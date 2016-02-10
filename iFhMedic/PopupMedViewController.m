//
//  PopupMedViewController.m
//  iRescueMedic
//
//  Created by admin on 9/5/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PopupMedViewController.h"

@interface PopupMedViewController ()

@end

@implementation PopupMedViewController
@synthesize delegate;
@synthesize txtDrugName;
@synthesize buttonClicked;

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

- (IBAction)btnCancel:(id)sender {
    buttonClicked = 0;
    [delegate doneMedClick];
    
}

- (IBAction)btnContinue:(UIButton *)sender {
    buttonClicked = 1;
    [delegate doneMedClick];
}
@end
