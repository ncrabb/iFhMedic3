//
//  LicenseViewController.m
//  iRescueMedic
//
//  Created by admin on 6/21/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "LicenseViewController.h"
#import "DAO.h"
#import "global.h"
#import "Reachability.h"
#import "ServiceSvc.h"

@interface LicenseViewController ()

@end

@implementation LicenseViewController
@synthesize containerView;
@synthesize delegate;
@synthesize txtCustomer;
@synthesize txtSerial;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    registerCLicked = NO;
    [self.containerView.layer setCornerRadius:10.0f];
    [self.containerView.layer setMasksToBounds:YES];
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnRegisterClick:(UIButton*)sender {
    if (!registerCLicked)
    {
        if ([txtSerial.text isEqualToString:@"DEMO"] && [txtCustomer.text isEqualToString:@"DEMO123"] )
        {
            [g_SETTINGS setObject:@"LOCAL" forKey:@"MachineID"];
            [g_SETTINGS setObject:@"1" forKey:@"CustomerID"];
            [self.delegate doneRegisterClick];
        }
        else
        {
            registerCLicked = YES;
            int result = [self getDeviceSettings];
            // result = 1;
            if (result == 1)
            {
                [self.delegate doneRegisterClick];
            }
            else
            {
                registerCLicked = NO;
            }
        }
    }
}


- (NSInteger)getDeviceSettings
{
    NSInteger result = 0;

    NSString* machineID = txtSerial.text;
    NSInteger customerNumber;
    @try {
        customerNumber = [txtCustomer.text intValue];
    }
    @catch (NSException *exception) {
        customerNumber = 0;
    }
    if (customerNumber <= 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Invalid Customer Number" message:@"Please reenter your customer number or contact customer support." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        alert.tag = 1;
    }
    
    else
    {
        Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
        
        BOOL connectionRequired= [hostReach connectionRequired];
        if(connectionRequired)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please establish a network connection before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert.tag = 0;
        }
        else
        {
            NSInteger customerNo = 0;
            @try {
                ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
                binding.logXMLInOut = NO;
                ServiceSvc_GetCustomerID *req = [[ServiceSvc_GetCustomerID alloc] init];
                req.MachineID = machineID;
                ServiceSoapBindingResponse* resp = [binding GetCustomerIDUsingParameters:req];
                for (id mine in resp.bodyParts)
                {
                    if ([mine isKindOfClass:[ServiceSvc_GetCustomerIDResponse class]])
                    {
                        NSString* customerNumberStr = [mine GetCustomerIDResult];
                        customerNo = [customerNumberStr intValue];
                        if (customerNo == customerNumber)
                        {
                            [g_SETTINGS setObject:machineID forKey:@"MachineID"];
                            [g_SETTINGS setObject:customerNumberStr forKey:@"CustomerID"];
                            result = 1;
                        }
                    }
                }
            }
            @catch (NSException *exception) {
                result = -1;
            }
            @finally {
                
            }
            
            if (customerNo <= 0)
            {
    
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unregistered" message:@"Your application has not been properly registered yet. Please make sure you have registered this application and a network connection is available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert.tag = 1;
            }
        }
    }
    return result;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0)
    {
        if (buttonIndex == 0)
        {
            exit(0);
        }
        else if (buttonIndex == 1)
        {
            return;
        }
            
    }
}

- (IBAction)btnCancelClick:(UIButton*)sender {
    exit(0);
}

@end
