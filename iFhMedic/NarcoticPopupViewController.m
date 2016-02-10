//
//  NarcoticPopupViewController.m
//  iRescueMedic
//
//  Created by Nathan on 7/5/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "NarcoticPopupViewController.h"
#import "DDPopoverBackgroundView.h"
#import "NumericViewController.h"
#import "global.h"
#import "DAO.h"
#import "PopoverViewController.h"
#import "ClsTableKey.h"

@interface NarcoticPopupViewController ()

@end

@implementation NarcoticPopupViewController
@synthesize  delegate;
@synthesize bEdit;


@synthesize btnMedication;
@synthesize btnUsageAmt;
@synthesize btnUsageUnit;
@synthesize btnWastageAmt;
@synthesize btnWastageUnit;
@synthesize btnUsageWitness;
@synthesize btnWastageWitness;
@synthesize container1;

@synthesize witessTypeSelected;
@synthesize medications;
@synthesize units;
@synthesize narcotic;

@synthesize popoverController;


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
    bEdit = NO;
    narcotic = [[ClsNarcotic alloc] init];
    [self.container1.layer setCornerRadius:10.0f];
    [self.container1.layer setMasksToBounds:YES];
    self.container1.layer.borderWidth = 1;
    self.container1.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnMedication:nil];
    [self setBtnUsageAmt:nil];
    [self setBtnUsageUnit:nil];
    [self setBtnWastageAmt:nil];
    [self setBtnWastageUnit:nil];
    [super viewDidUnload];
}

/*- (void)setValueOfSelectedRow:(ClsMed *)med
{
    bEdit = YES;
    [btnAount setTitle:med.amount forState:UIControlStateNormal];
    [btnFreq setTitle:med.freq forState:UIControlStateNormal];
    btnPerDay.selected = YES;
    btnMg.selected = YES;
    
    if([med.amountUnit isEqualToString:@"mg"])
    {
        [self btnMgClick:Nil];
    }
    else if([med.amountUnit isEqualToString:@"Units"])
    {
        [self btnUnitsClick:Nil];
    }
    else if([med.amountUnit isEqualToString:@"cc"])
    {
        [self btnCCClick:Nil];
    }
    else if([med.amountUnit isEqualToString:@"gram"])
    {
        [self btnGramClick:Nil];
    }
    else if([med.amountUnit isEqualToString:@"mcg"])
    {
        [self btnMcgClick:Nil];
    }

    if([med.freqUnit isEqualToString:@"per Day"])
    {
        [self btnPerDayClick:Nil];
    }
    else if([med.freqUnit isEqualToString:@"per Week"])
    {
        [self btnPerWeekClick:Nil];
    }
    else if([med.freqUnit isEqualToString:@"per Month"])
    {
        [self btnPerMonthClick:Nil];
    }
    else if([med.freqUnit isEqualToString:@"Other"])
    {
        [self btnOtherClick:Nil];
    }
}*/

-(void) doneNumericClick
{
    NumericViewController *p = (NumericViewController *)self.popoverController.contentViewController;
    if (numericClicked == 2)
    {
        [btnUsageAmt setTitle:p.displayStr forState:UIControlStateNormal];
    }
    if (numericClicked == 3)
    {
        [btnWastageAmt setTitle:p.displayStr forState:UIControlStateNormal];
    }
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
}

-(void) didTap
{
    PopoverViewController *p = (PopoverViewController *)self.popoverController.contentViewController;
    if(numericClicked == 1)
    {
        ClsTableKey * tableKey =  [medications objectAtIndex:p.rowSelected];
        [self.btnMedication setTitle:tableKey.desc forState:UIControlStateNormal];
        btnUsageUnit.tag =  p.rowSelected;

    }
    if(numericClicked == 4)
    {
        ClsTableKey * tableKey =  [units objectAtIndex:p.rowSelected];
        [self.btnUsageUnit setTitle:tableKey.desc forState:UIControlStateNormal];
        btnUsageUnit.tag =  p.rowSelected;
    }
    if(numericClicked == 5)
    {
        ClsTableKey * tableKey =  [units objectAtIndex:p.rowSelected];
        [self.btnWastageUnit setTitle:tableKey.desc forState:UIControlStateNormal];
        btnWastageUnit.tag =  p.rowSelected;
    }
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
}

-(IBAction)btnMedicationPressed:(UIButton *)sender
{
        NSString* sql = @"Select DrugID, 'Medications', DrugName from Drugs where Narcotic = 1";
        @synchronized(g_LOOKUPDB)
        {
            self.medications = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
        }
    
    numericClicked = 1;
    PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    popoverView.arrays = self.medications;
    popoverView.functionSelected = 4;
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popoverController.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popoverController.popoverContentSize = CGSizeMake(250, 260);
    popoverView.delegate = self;
    
    [self.popoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)btnUsageAmountPressed:(UIButton *)sender
{
    numericClicked = 2;
    [sender resignFirstResponder];
    
    NumericViewController *popoverView =[[NumericViewController alloc] initWithNibName:@"NumericViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor blackColor];
    
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popoverController.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popoverController.popoverContentSize = CGSizeMake(430, 420);
    popoverView.delegate = self;
    [self.popoverController presentPopoverFromRect:CGRectMake(400, 75, 430 , 420) inView:self.view permittedArrowDirections:0 animated:YES];

}

- (IBAction)btnUsageUnitPressed:(UIButton *)sender
{
    numericClicked = 4;
    [sender resignFirstResponder];
    PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    if ([units count] < 1)
    {
        NSString* querySql = @"select IL.InputlookupID, 'Inputs', IL.LookupName from TreatmentInputs Inputs inner join TreatmentInputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 4 and IL.treatmentID = 2011 and Inputs.treatmentID = 2011 and IL.active =1";
        
        @synchronized(g_LOOKUPDB)
        {
            self.units = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
        
    }
    popoverView.arrays = self.units;
    popoverView.functionSelected = 4;
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popoverController.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popoverController.popoverContentSize = CGSizeMake(200, 300);
    popoverView.delegate = self;
    [self.popoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)btnWastageAmountPressed:(UIButton *)sender
{
    numericClicked = 3;
    [sender resignFirstResponder];
    
    NumericViewController *popoverView =[[NumericViewController alloc] initWithNibName:@"NumericViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor blackColor];
    
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popoverController.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popoverController.popoverContentSize = CGSizeMake(430, 420);
    popoverView.delegate = self;
    [self.popoverController presentPopoverFromRect:CGRectMake(400, 75, 430 , 420) inView:self.view permittedArrowDirections:0 animated:YES];
}

- (IBAction)btnWastageUnitPressed:(UIButton *)sender
{
    numericClicked = 5;
    [sender resignFirstResponder];
    PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    if ([units count] < 1)
    {
        NSString* querySql = @"select IL.InputlookupID, 'Inputs', IL.LookupName from TreatmentInputs Inputs inner join TreatmentInputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 4 and IL.treatmentID = 2011 and Inputs.treatmentID = 2011 and IL.active =1";
        
        @synchronized(g_LOOKUPDB)
        {
            self.units = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
        
    }
    popoverView.arrays = self.units;
    popoverView.functionSelected = 4;
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popoverController.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popoverController.popoverContentSize = CGSizeMake(200, 300);
    popoverView.delegate = self;
    [self.popoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)witnessTypeUsageClicked:(id)sender
{
    witessTypeSelected = 1;
    btnUsageWitness.selected = YES;
    btnWastageWitness.selected = NO;
}

- (IBAction)witnessTypeWastageClicked:(id)sender
{
    witessTypeSelected = 2;
    btnUsageWitness.selected = NO;
    btnWastageWitness.selected = YES;
}

- (IBAction)saveButtonPressed:(id)sender
{
    narcotic.MedicationName = btnMedication.titleLabel.text;
    narcotic.amountUsage = btnUsageAmt.titleLabel.text;
    narcotic.UsageUnit = btnUsageUnit.titleLabel.text;
    narcotic.WastageUnit = btnWastageUnit.titleLabel.text;
    narcotic.amountWastage = btnWastageAmt.titleLabel.text;
    narcotic.witnessType = witessTypeSelected;
    
    if(bEdit)
    {
        [delegate continueClick:YES];
    }
    else
    {
        [delegate continueClick:NO];
    }
}

- (IBAction)btnContinueClick:(id)sender {
    narcotic.MedicationName = btnMedication.titleLabel.text;
    narcotic.amountUsage = btnUsageAmt.titleLabel.text;
    narcotic.UsageUnit = btnUsageUnit.titleLabel.text;
    narcotic.WastageUnit = btnWastageUnit.titleLabel.text;
    narcotic.amountWastage = btnWastageAmt.titleLabel.text;
    narcotic.witnessType = witessTypeSelected;
    
    if(bEdit)
    {
        [delegate continueClick:YES];
    }
    else
    {
        [delegate continueClick:NO];
    }
}



@end
