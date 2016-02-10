//
//  PopoverPasswordControllerViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/11/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "PopoverPasswordControllerViewController.h"

@interface PopoverPasswordControllerViewController ()

@end

@implementation PopoverPasswordControllerViewController
@synthesize delegate;

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

- (IBAction)OkClick:(id)sender {
     [delegate didClickOK];
}
@end
