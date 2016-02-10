//
//  PatientSigUnableViewController.m
//  iRescueMedic
//
//  Created by admin on 6/15/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PatientSigUnableViewController.h"
#import "ClsTableKey.h"
#import "DDPopoverBackgroundView.h"
#import "global.h"

@interface PatientSigUnableViewController ()

@end

@implementation PatientSigUnableViewController
@synthesize delegate;
@synthesize needToSave;
@synthesize image;
@synthesize txtName;
@synthesize signView;
@synthesize tvDisclaimer;
@synthesize sigType;
@synthesize reasons;
@synthesize popover;
@synthesize txtCrew;
@synthesize titleStr;
@synthesize lblTitle;

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
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(36, 146, 485, 100)];
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    lblTitle.text = titleStr;
}

-(void) loadDisclaimer
{
/*    NSString* sql = [NSString stringWithFormat:@"Select DisclaimerText from SignatureTypes where SignatureType = %d", sigType];
    @synchronized(g_SYNCLOOKUPDB)
    {
        tvDisclaimer.text = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    } */
    
    tvDisclaimer.text = @"My signature below indicates that, at the time of service, the patient was physically or mentally incapable of signing, and that no responsible parties were available or willing to sign on the patient's behalf.";
    
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
    [self.delegate donePatientUnableSigningClick];
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
    [self.delegate donePatientUnableSigningClick];
}

- (IBAction)btnChooseReasonClick:(UIButton*)sender {
   
    if (self.reasons == nil)
    {
        NSString* enforceCMS = [g_SETTINGS objectForKey:@"EnforceCMS"];
        if ([enforceCMS isEqualToString:@"1"])
        {
            self.reasons = [[NSMutableArray alloc] init];
            ClsTableKey *reason1 = [[ClsTableKey alloc] init];
            reason1.key = 1;
            reason1.tableName = @"Reasons";
            reason1.desc = @"Patient Physically unable to Sign";
            [self.reasons addObject:reason1];
            
            ClsTableKey *reason2 = [[ClsTableKey alloc] init];
            reason2.key = 2;
            reason2.tableName = @"Reasons";
            reason2.desc = @"Patient Mentally unable to Sign";
            [self.reasons addObject:reason2];
            
            ClsTableKey *reason3 = [[ClsTableKey alloc] init];
            reason3.key = 3;
            reason3.tableName = @"Reasons";
            reason3.desc = @"Patient Unwilling to Sign";
            [self.reasons addObject:reason3];
            
            ClsTableKey *reason4 = [[ClsTableKey alloc] init];
            reason4.key = 4;
            reason4.tableName = @"Reasons";
            reason4.desc = @"Patient Medically unable to Sign";
            [self.reasons addObject:reason4];
        }
        else
        {
            self.reasons = [[NSMutableArray alloc] init];
            ClsTableKey *reason1 = [[ClsTableKey alloc] init];
            reason1.key = 1;
            reason1.tableName = @"Reasons";
            reason1.desc = @"Patient Physically unable to Sign";
            [self.reasons addObject:reason1];
            
            ClsTableKey *reason2 = [[ClsTableKey alloc] init];
            reason2.key = 2;
            reason2.tableName = @"Reasons";
            reason2.desc = @"Patient Mentally unable to Sign";
            [self.reasons addObject:reason2];
            
            ClsTableKey *reason3 = [[ClsTableKey alloc] init];
            reason3.key = 3;
            reason3.tableName = @"Reasons";
            reason3.desc = @"Patient Unwilling to Sign";
            [self.reasons addObject:reason3];
            
            ClsTableKey *reason4 = [[ClsTableKey alloc] init];
            reason4.key = 4;
            reason4.tableName = @"Reasons";
            reason4.desc = @"Patient With Doctor";
            [self.reasons addObject:reason4];
            
            ClsTableKey *reason5 = [[ClsTableKey alloc] init];
            reason5.key = 5;
            reason5.tableName = @"Reasons";
            reason5.desc = @"Patient Restrained";
            [self.reasons addObject:reason5];
            
            
            ClsTableKey *reason6 = [[ClsTableKey alloc] init];
            reason6.key = 6;
            reason6.tableName = @"Reasons";
            reason6.desc = @"Patient Deceased";
            [self.reasons addObject:reason6];
            
            ClsTableKey *reason7 = [[ClsTableKey alloc] init];
            reason7.key = 7;
            reason7.tableName = @"Reasons";
            reason7.desc = @"Patient Care Transferred";
            [self.reasons addObject:reason7];
            
            ClsTableKey *reason8 = [[ClsTableKey alloc] init];
            reason8.key = 8;
            reason8.tableName = @"Reasons";
            reason8.desc = @"Patient Refused";
            [self.reasons addObject:reason8];
            
            ClsTableKey *reason9 = [[ClsTableKey alloc] init];
            reason9.key = 9;
            reason9.tableName = @"Reasons";
            reason9.desc = @"See Narrative for Other";
            [self.reasons addObject:reason9];
            
            ClsTableKey *reason10 = [[ClsTableKey alloc] init];
            reason10.key = 10;
            reason10.tableName = @"Reasons";
            reason10.desc = @"In Custody";
            [self.reasons addObject:reason10];
            
            ClsTableKey *reason11 = [[ClsTableKey alloc] init];
            reason11.key = 11;
            reason11.tableName = @"Reasons";
            reason11.desc = @"Language Barrier";
            [self.reasons addObject:reason11];
            
            
            ClsTableKey *reason12 = [[ClsTableKey alloc] init];
            reason12.key = 12;
            reason12.tableName = @"Reasons";
            reason12.desc = @"Minor / Child";
            [self.reasons addObject:reason12];
            
            ClsTableKey *reason13 = [[ClsTableKey alloc] init];
            reason13.key = 13;
            reason13.tableName = @"Reasons";
            reason13.desc = @"Physical Disimpairment of Extremities";
            [self.reasons addObject:reason13];
            
            ClsTableKey *reason14 = [[ClsTableKey alloc] init];
            reason14.key = 14;
            reason14.tableName = @"Reasons";
            reason14.desc = @"Unconscious";
            [self.reasons addObject:reason14];
            
            ClsTableKey *reason15 = [[ClsTableKey alloc] init];
            reason15.key = 15;
            reason15.tableName = @"Reasons";
            reason15.desc = @"Visually Impaired";
            [self.reasons addObject:reason15];
        }
            

    }
    PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
    
    popoverView.array = self.reasons;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    
    self.popover.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}

- (IBAction)btnCrewNamesClick:(UIButton *)sender {
    PerformedByViewController *popoverView =[[PerformedByViewController alloc] initWithNibName:@"PerformedByViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(515, 360);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}

-(void) donePerformedByClick
{
    PerformedByViewController *p = (PerformedByViewController *)self.popover.contentViewController;
    txtCrew.text = p.txtName.text;

    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}


-(void) didTap
{
    PopupIncidentViewController *p = (PopupIncidentViewController *)self.popover.contentViewController;
    
        ClsTableKey * tableKey =  [p.array objectAtIndex:p.rowSelected];
        txtName.text = tableKey.desc;
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}


@end
