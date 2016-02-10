//
//  NarcoticInfoCell.m
//  iRescueMedic
//
//  Created by admin on 3/29/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "NarcoticInfoCell.h"
#import "global.h"
#import "DAO.h"
#import "DDPopoverBackgroundView.h"
#import "ClsTableKey.h"

@implementation NarcoticInfoCell
@synthesize lblMedication;
@synthesize lblAmtUsage;
@synthesize lblUnitUsage;
@synthesize btnAmtWasted;
@synthesize btnUnitWasted;
@synthesize btnUsage;
@synthesize btnWaste;
@synthesize unitArray;
@synthesize popover;
@synthesize btnWitnessUsage;
@synthesize btnWitnessWastage;
@synthesize numView;
@synthesize popView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        witnessUsage = 0;
        witnessWastage = 0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnUnitWastedClick:(UIButton*)sender {
    [sender resignFirstResponder];
     self.popView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    popView.view.backgroundColor = [UIColor whiteColor];
    if ([unitArray count] < 1)
    {
        NSString* querySql = @"select IL.InputlookupID, 'Inputs', IL.LookupName from TreatmentInputs Inputs inner join TreatmentInputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 4 and IL.treatmentID = 2011 and Inputs.treatmentID = 2011 and IL.active =1";
        
        @synchronized(g_LOOKUPDB)
        {
            self.unitArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
        
    }
    popView.arrays = self.unitArray;
    popView.functionSelected = 4;
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(350, 400);
    popView.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.contentView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)btnAmtWastedClick:(UIButton*)sender {
    self.numView =[[NumericViewController alloc] initWithNibName:@"NumericViewController" bundle:nil];
    numView.view.backgroundColor = [UIColor blackColor];
    numView.view.tag = sender.tag;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:numView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(430, 420);
    numView.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.contentView permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)btnWitnessUsageClick:(id)sender {
    if (witnessUsage == 0)
    {
        witnessUsage = 1;
        btnWitnessUsage.selected = true;
    }
    else
    {
        witnessUsage = 0;
        btnWitnessUsage.selected = false;
    }
}

- (IBAction)btnWitnessWastageClick:(id)sender {
    if (witnessWastage == 0)
    {
        witnessWastage = 1;
        btnWitnessWastage.selected = true;
    }
    else
    {
        witnessWastage = 0;
        btnWitnessWastage.selected = false;
    }
}

- (void) didTap
{
    ClsTableKey* key = [unitArray objectAtIndex:popView.rowSelected];
    [btnUnitWasted setTitle:key.desc forState:UIControlStateNormal];
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}


- (void) doneNumericClick
{

        if ([numView.displayStr floatValue] > [lblAmtUsage.text floatValue])
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Input Error" message:@"Amount wasted cannot be greater than amount used." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            [btnAmtWasted setTitle:numView.displayStr forState:UIControlStateNormal];
        }



    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

@end
