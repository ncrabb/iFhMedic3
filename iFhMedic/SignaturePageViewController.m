//
//  SignaturePageViewController.m
//  iRescueMedic
//
//  Created by Nathan on 8/21/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 
#import "SignaturePageViewController.h"
#import "DisclaimerViewController.h"

@interface SignaturePageViewController ()

@end

@implementation SignaturePageViewController
@synthesize delegate;
@synthesize needToSave;
@synthesize image;
@synthesize txtName;
@synthesize signView;
@synthesize sigType;
@synthesize lblTitle;
@synthesize labelTitle;
@synthesize name;


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
    txtName.delegate = self;
   // [self.signature setBrushColorWithRed:0.0f green:0.0f blue:0.0f];
   // signature.backgroundColor = [UIColor whiteColor];
  //  signature.layer.borderWidth = 2;
  //  signature.layer.cornerRadius = 8;
 //   signature.layer.borderColor = [[UIColor grayColor] CGColor];
    needToSave = FALSE;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(40, 95.0, 485, 250)];
	containerView.backgroundColor = [UIColor whiteColor];
	
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.borderWidth = 2;
    containerView.layer.cornerRadius = 8;
    containerView.layer.borderColor = [[UIColor grayColor] CGColor];

    self.signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 250)];
    
    self.signView.backgroundColor = [UIColor whiteColor];
	[containerView addSubview:self.signView];
	[self.view addSubview:containerView];

    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    lblTitle.text = labelTitle;
    if (name.length > 0)
    {
        txtName.text = name;
    }
}

- (UIImage *)signatureImage
{
    UIGraphicsBeginImageContext(containerView.bounds.size);
    
    [containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtName:nil];
    [super viewDidUnload];
}
- (IBAction)btnCancel:(id)sender {
    [self.delegate doneSigningClick];
    needToSave = FALSE;
}

- (IBAction)btnClear:(id)sender {
  //  [signView clearSignature:CGRectMake(0, 0, signView.frame.size.width, signView.frame.size.height)];
    
    [signView removeFromSuperview];
    self.signView = nil;
    
    self.signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 250)];
    
    self.signView.backgroundColor = [UIColor whiteColor];
	[containerView addSubview:self.signView];
    
}

- (IBAction)btnSave:(id)sender {
    needToSave = TRUE;
   //self.image = [signature glToUIImage];
    self.image = [self signatureImage];
    NSLog(@"Exit image");
    [self.delegate doneSigningClick];
}

- (IBAction)btnViewDisclaimer:(id)sender {
    DisclaimerViewController* disclaimer = [[DisclaimerViewController alloc] initWithNibName:@"DisclaimerViewController" bundle:nil];
    disclaimer.sigType = sigType;
    [self presentViewController:disclaimer animated:NO completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //[textField resignFirstResponder];
    
}
@end
