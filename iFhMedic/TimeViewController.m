//
//  TimeViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/27/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "TimeViewController.h"

@interface TimeViewController ()

@end

@implementation TimeViewController
@synthesize delegate;
@synthesize dpTime;

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

- (void)viewDidUnload {
    [self setDpTime:nil];
    [super viewDidUnload];
}
- (IBAction)btnDoneClick:(id)sender {
    [delegate doneTimeClick];
}
@end
