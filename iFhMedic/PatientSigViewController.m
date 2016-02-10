//
//  PatientSigViewController.m
//  iRescueMedic
//
//  Created by admin on 6/14/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PatientSigViewController.h"
#import "global.h"
#import "DAO.h"

@interface PatientSigViewController ()

@end

@implementation PatientSigViewController
@synthesize delegate;
@synthesize needToSave;
@synthesize image;
@synthesize txtName;
@synthesize signView;
@synthesize tvDisclaimer;
@synthesize sigType;

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
    needToSave = FALSE;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(37, 79, 485, 100)];
	containerView.backgroundColor = [UIColor whiteColor];
	
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.borderWidth = 2;
    containerView.layer.cornerRadius = 8;
    containerView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 100)];
    
    signView.backgroundColor = [UIColor whiteColor];
	[containerView addSubview:signView];
	[self.view addSubview:containerView];
    [self loadDisclaimer];
}

-(void) loadDisclaimer
{
    NSString* sql = [NSString stringWithFormat:@"Select DisclaimerText from SignatureTypes where SignatureType = %d", sigType];
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
- (UIImage *)signatureImage
{
    UIGraphicsBeginImageContext(containerView.bounds.size);
    
    [containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
    
}


- (void)viewDidUnload {
    [self setTxtName:nil];
    [super viewDidUnload];
}
- (IBAction)btnCancel:(id)sender {
    [self.delegate donePatientSigningClick];
    needToSave = FALSE;
}

- (IBAction)btnClear:(id)sender {
    //  [signView clearSignature:CGRectMake(0, 0, signView.frame.size.width, signView.frame.size.height)];
    
    [signView removeFromSuperview];
    signView = nil;
    
    signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 100)];
    
    signView.backgroundColor = [UIColor whiteColor];
	[containerView addSubview:signView];
    
}

- (IBAction)btnSave:(id)sender {
    needToSave = TRUE;
    //self.image = [signature glToUIImage];
    self.image = [self signatureImage];
    NSLog(@"Exit image");
    [self.delegate donePatientSigningClick];
}

@end
