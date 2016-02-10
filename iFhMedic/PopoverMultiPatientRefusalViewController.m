//
//  PopoverMultiPatientRefusalViewController.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 11/06/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PopoverMultiPatientRefusalViewController.h"
#import "MultiPatientEditViewController.h"


@interface PopoverMultiPatientRefusalViewController ()

@end

@implementation PopoverMultiPatientRefusalViewController

@synthesize delegate;

@synthesize lblErrorMsg;
@synthesize segControl1;
@synthesize segControl2;
@synthesize segControl3;
@synthesize segControl4;
@synthesize segControl5;
@synthesize container1;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [delegate cancelMultiRefusal];
}

- (IBAction)submitButtonPressed:(id)sender
{
    if(segControl1.selectedSegmentIndex == 1 || segControl2.selectedSegmentIndex == 0 ||segControl3.selectedSegmentIndex == 0 || segControl4.selectedSegmentIndex == 0 )
    {
        lblErrorMsg.hidden = NO;
    }
    else
    {
        [delegate submitMultiRefusal];
    }
}

#pragma mark- UI controls adjustments
-(void) setViewUI
{
    
    [self.container1.layer setCornerRadius:10.0f];
    [self.container1.layer setMasksToBounds:YES];
    self.container1.layer.borderWidth = 1;
    self.container1.layer.borderColor = [UIColor lightGrayColor].CGColor;
}



- (IBAction)btnSeg1Click:(id)sender {
    if(segControl1.selectedSegmentIndex == 0 && segControl2.selectedSegmentIndex == 1 && segControl3.selectedSegmentIndex == 1 && segControl4.selectedSegmentIndex == 1 )
    {
        lblErrorMsg.hidden = YES;
    }
    else
    {
        lblErrorMsg.hidden = NO;
    }
}

- (IBAction)btnSeg2Click:(id)sender {
    if(segControl1.selectedSegmentIndex == 0 && segControl2.selectedSegmentIndex == 1 && segControl3.selectedSegmentIndex == 1 && segControl4.selectedSegmentIndex == 1 )
    {
        lblErrorMsg.hidden = YES;
    }
    else
    {
        lblErrorMsg.hidden = NO;
    }
}

- (IBAction)btnSeg3Click:(id)sender {
    if(segControl1.selectedSegmentIndex == 0 && segControl2.selectedSegmentIndex == 1 && segControl3.selectedSegmentIndex == 1 && segControl4.selectedSegmentIndex == 1 )
    {
        lblErrorMsg.hidden = YES;
    }
    else
    {
        lblErrorMsg.hidden = NO;
    }
}

- (IBAction)btnSeg4Click:(id)sender {
    if(segControl1.selectedSegmentIndex == 0 && segControl2.selectedSegmentIndex == 1 && segControl3.selectedSegmentIndex == 1 && segControl4.selectedSegmentIndex == 1 )
    {
         lblErrorMsg.hidden = YES;
    }
    else
    {
        lblErrorMsg.hidden = NO;
    }
}

- (IBAction)viewSignatureClick:(id)sender
{
    MultiPatientEditViewController* multi = [[MultiPatientEditViewController alloc] initWithNibName:@"MultiPatientEditViewController" bundle:nil];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:multi];
    nav.navigationBar.barTintColor = [UIColor blackColor];
    [self presentViewController:nav animated:YES completion:nil];
}
@end
