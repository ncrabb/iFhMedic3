//
//  CustomCrewViewController.m
//  iRescueMedic
//
//  Created by admin on 6/24/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "CustomCrewViewController.h"

@interface CustomCrewViewController ()

@end

@implementation CustomCrewViewController
@synthesize delegate;
@synthesize save;
@synthesize txtId;
@synthesize txtName;
@synthesize txtLastName;
@synthesize containerView;
@synthesize buttonSelect;
@synthesize btnFirefighterSelect;
@synthesize btnPoliceSelect;
@synthesize btnPreceptSelect;
@synthesize btnRideAlongSelect;
@synthesize btnStudentSelect;
@synthesize cert;

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
    save = false;
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

- (IBAction)btnCancel:(id)sender {
    save = false;
    [delegate doneCustomCrew];
}

- (IBAction)btnSave:(id)sender {
    int pass = true;
    if ([txtName.text length] < 1)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Name Field Empty" message:@"Please enter a crew first name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        pass = false;
        return;
    }
    if ([txtLastName.text length] < 1)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Name Field Empty" message:@"Please enter a crew last name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        pass = false;
        return;
    }
    if ([txtId.text length] < 1)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ID Field Empty" message:@"Please enter a crew ID." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        pass = false;
        return;
    }

    if (buttonSelect < 1)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Select Crew Title" message:@"Please select a title for the crew." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        pass = false;
        return;
    }
    int crewID;
    @try {
        crewID = [txtId.text intValue];
    }
    @catch (NSException *exception) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic for iPad" message:@"Crew ID must be an integer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        pass = false;
        return;
    }

    if (pass)
    {
        save = true;
        if (buttonSelect == 1)
        {
            self.cert = @"Student / Intern";
        }
        else if (buttonSelect == 2)
        {
            self.cert = @"Ride Along";
        }
        else if (buttonSelect == 3)
        {
            self.cert = @"Police Officer";
        }
        else if (buttonSelect == 4)
        {
            self.cert = @"Firefighter";
        }
        else if (buttonSelect == 5)
        {
            self.cert = @"Precept";
        }
        
        [delegate doneCustomCrew];
    }
}

- (IBAction)btnStudent:(id)sender {
    btnStudentSelect.selected = true;
    btnPoliceSelect.selected = false;
    btnFirefighterSelect.selected = false;
    btnPreceptSelect.selected = false;
    btnRideAlongSelect.selected = false;
    buttonSelect = 1;
    
}

- (IBAction)btnRideAlong:(id)sender {
    btnStudentSelect.selected = false;
    btnRideAlongSelect.selected = true;
    btnPoliceSelect.selected = false;
    btnFirefighterSelect.selected = false;
    btnPreceptSelect.selected = false;
    buttonSelect = 2;
}

- (IBAction)btnPolice:(id)sender {
    btnStudentSelect.selected = false;
    btnRideAlongSelect.selected = false;
    btnPoliceSelect.selected = true;
    btnFirefighterSelect.selected = false;
    btnPreceptSelect.selected = false;
    buttonSelect = 3;
}

- (IBAction)btnFireFighter:(id)sender {
    btnStudentSelect.selected = false;
    btnRideAlongSelect.selected = false;
    btnPoliceSelect.selected = false;
    btnFirefighterSelect.selected = true;
    btnPreceptSelect.selected = false;
    buttonSelect = 4;
}

- (IBAction)btnPrecept:(id)sender {
    btnStudentSelect.selected = false;
    btnRideAlongSelect.selected = false;
    btnPoliceSelect.selected = false;
    btnFirefighterSelect.selected = false;
    btnPreceptSelect.selected = true;
    buttonSelect = 5;
}
@end
