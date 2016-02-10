//
//  PopoverMultiRefusalSignatureViewController.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 11/06/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PopoverMultiRefusalSignatureViewController.h"
#import "NumericViewController.h"
#import "DDPopoverBackgroundView.h"
#import "CalendarViewController.h"
#import "DAO.h"
#import "global.h"
#import "Base64.h"
#import "MultiPatientEditViewController.h"

@interface PopoverMultiRefusalSignatureViewController ()

@end

@implementation PopoverMultiRefusalSignatureViewController

@synthesize delegate;
@synthesize popover;

@synthesize container1;
@synthesize container2;
@synthesize container3;
@synthesize container4;
@synthesize btnDOB;
@synthesize btnPhone;
@synthesize btnZip;
@synthesize needToSave;
@synthesize image;
@synthesize txtName;
@synthesize txtAddress;
@synthesize txtCity;
@synthesize txtState;
@synthesize tvDisclaimer;
@synthesize lblPatientCount;

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
    sigSaved = 0;
    [self setViewUI];
    [self loadDisclaimer];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketSignatures where TicketID = %@ and signatureType = 999", ticketID];
    
    @synchronized(g_SYNCBLOBSDB)
    {
        countSig = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
    }
    countSig++;
    lblPatientCount.text = [NSString stringWithFormat:@"Patient# %d", countSig];
}



-(void) loadDisclaimer
{
    NSString* sql = [NSString stringWithFormat:@"Select DisclaimerText from SignatureTypes where SignatureType = %d", 999];
    @synchronized(g_SYNCLOOKUPDB)
    {
        tvDisclaimer.text = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UI controls adjustments
-(void) setViewUI
{
    
    [self.container1.layer setCornerRadius:10.0f];
    [self.container1.layer setMasksToBounds:YES];
    self.container1.layer.borderWidth = 1;
    self.container1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.container3.layer setCornerRadius:10.0f];
    [self.container3.layer setMasksToBounds:YES];
    self.container3.layer.borderWidth = 1;
    self.container3.layer.borderColor = [UIColor lightGrayColor].CGColor;

    
    [self.container2.layer setCornerRadius:10.0f];
    [self.container2.layer setMasksToBounds:YES];
    self.container2.layer.borderWidth = 1;
    self.container2.layer.borderColor = [UIColor lightGrayColor].CGColor;

    
    [self.container4.layer setCornerRadius:10.0f];
    [self.container4.layer setMasksToBounds:YES];
    self.container4.layer.borderWidth = 1;
    self.container4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,520, 125)];
    
    signView.backgroundColor = [UIColor whiteColor];
	[container4 addSubview:signView];

}



- (IBAction)btnNextPatient:(UIButton *)sender {
    countSig++;
    lblPatientCount.text = [NSString stringWithFormat:@"Patient# %d", countSig];
    txtName.text = @"";
    txtAddress.text = @"";
    txtCity.text = @"";
    txtState.text = @"";
    [btnZip setTitle:@"" forState:UIControlStateNormal];
    [btnPhone setTitle:@"" forState:UIControlStateNormal];
    [btnDOB setTitle:@"" forState:UIControlStateNormal];
    needToSave = true;
    [delegate cancelMultiSigRefusal];   
}

- (IBAction)cancelButtonPressed:(id)sender
{
    needToSave = false;
    [delegate cancelMultiSigRefusal];
}

- (IBAction)saveButtonPressed:(id)sender
{
    if (sigSaved == 0)
    {
        needToSave = false;
        self.image = [self signatureImage];
        NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketSignatures where TicketID = %@", ticketID];
        NSInteger signatureID = 0;
        @synchronized(g_SYNCBLOBSDB)
        {
            signatureID = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
        }
        signatureID++;
        
        NSData* data = UIImagePNGRepresentation(self.image);
        
        [Base64 initialize];
        NSString *sigEncoded = [Base64 encode:data];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [format stringFromDate:now];
        NSString* sigName = [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@-%@", txtName.text, txtAddress.text, txtCity.text, txtState.text, btnZip.titleLabel.text, btnPhone.titleLabel.text, btnDOB.titleLabel.text ];
        @synchronized(g_SYNCBLOBSDB)
        {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketSignatures(LocalTicketID, TicketID, SignatureID, SignatureType, SignatureText, SignatureString, SignatureTime) Values(0, %@, %d, %d, '%@', '%@', '%@')", ticketID, signatureID, 999, sigName, sigEncoded, dateString];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
        }
        sigSaved = 1;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Patient Signature Saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Patient Signature Already Saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
 //   [delegate cancelMultiSigRefusal];
}

- (UIImage *)signatureImage
{
    UIGraphicsBeginImageContext(container4.bounds.size);
    
    [container4.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
    
}

- (IBAction)clearButtonPressed:(id)sender
{
    [signView removeFromSuperview];
    signView = nil;
    
    signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 100)];
    
    signView.backgroundColor = [UIColor whiteColor];
	[container4 addSubview:signView];

}

-(void) doneNumericClick
{
    NumericViewController *p = (NumericViewController *)self.popover.contentViewController;
    
    if (functionSelected == 1)
    {
        [btnPhone setTitle:p.displayStr forState:UIControlStateNormal];
    }
    else if(functionSelected == 2)
    {
        [btnZip setTitle:p.displayStr forState:UIControlStateNormal];

    }
    [self.popover dismissPopoverAnimated:YES];
}


- (IBAction)phoneButtonPressed:(UIButton *)sender
{
    functionSelected = 1;
    [sender resignFirstResponder];
    
    NumericViewController *popoverView =[[NumericViewController alloc] initWithNibName:@"NumericViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor blackColor];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(430, 420);
    popoverView.delegate = self;
    [self.popover presentPopoverFromRect:CGRectMake(400, 75, 430 , 420) inView:self.view permittedArrowDirections:0 animated:YES];
}

- (IBAction)DOBPressed:(UIButton *)sender
{
    CalendarViewController *popoverView =[[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(400, 260);
    popoverView.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void) doneClick
{
    CalendarViewController *p = (CalendarViewController *)self.popover.contentViewController;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:p.dpDate.date];
    [dateFormatter setDateFormat:@"MMddYYYY"];

    
    [btnDOB  setTitle:strDate forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
}

- (IBAction)zipClicked:(UIButton *)sender
{
    functionSelected = 2;
    [sender resignFirstResponder];
    
    NumericViewController *popoverView =[[NumericViewController alloc] initWithNibName:@"NumericViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor blackColor];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(430, 420);
    popoverView.delegate = self;
    [self.popover presentPopoverFromRect:CGRectMake(400, 75, 430 , 420) inView:self.view permittedArrowDirections:0 animated:YES];

}

- (IBAction)btnViewList:(id)sender {
    MultiPatientEditViewController* multi = [[MultiPatientEditViewController alloc] initWithNibName:@"MultiPatientEditViewController" bundle:nil];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:multi];
    nav.navigationBar.barTintColor = [UIColor blackColor];
    [self presentViewController:nav animated:YES completion:nil];
}




@end
