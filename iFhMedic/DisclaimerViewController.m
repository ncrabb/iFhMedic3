//
//  DisclaimerViewController.m
//  iRescueMedic
//
//  Created by admin on 9/9/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "DisclaimerViewController.h"
#import "global.h"
#import "DAO.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController
@synthesize sigType;
@synthesize tvDisclaimer;

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString* sql = [NSString stringWithFormat:@"Select DisclaimerText from SignatureTypes where SignatureType = %d", sigType];
    @synchronized(g_LOOKUPDB)
    {
        tvDisclaimer.text = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDisclaimerClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
