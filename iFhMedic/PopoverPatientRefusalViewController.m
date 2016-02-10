//
//  PopoverPatientRefusalViewController.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 11/06/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PopoverPatientRefusalViewController.h"

@interface PopoverPatientRefusalViewController ()

@end

@implementation PopoverPatientRefusalViewController

@synthesize delegate;

@synthesize lblErrorMsg;
@synthesize segControl1;
@synthesize segControl2;
@synthesize segControl3;
@synthesize segControl4;
@synthesize segControl5;
@synthesize container1;
@synthesize LblErrorMsg;

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
    lblErrorMsg.hidden = YES;
    LblErrorMsg.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [delegate cancelPatientRefusal];
}
- (IBAction)submitButtonPressed:(id)sender
{
    if(segControl1.selectedSegmentIndex == 1 || segControl2.selectedSegmentIndex == 1 ||segControl3.selectedSegmentIndex == 1 || segControl4.selectedSegmentIndex == 1 || segControl5.selectedSegmentIndex == 1 )
    {
        lblErrorMsg.hidden = NO;
    }
    else
    {
        [delegate submitPatientRefusal];
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


@end
