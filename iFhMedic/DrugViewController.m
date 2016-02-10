//
//  DrugViewController.m
//  iRescueMedic
//
//  Created by Nathan on 7/5/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "DrugViewController.h"
#import "DDPopoverBackgroundView.h"
#import "NumericViewController.h"

@interface DrugViewController ()

@end

@implementation DrugViewController
@synthesize  delegate;
@synthesize bEdit;


@synthesize btnMg;
@synthesize btnPerDay;
@synthesize amountSelected;
@synthesize freqSelected;
@synthesize btnCC;
@synthesize btnGram;
@synthesize btnMcg;
@synthesize btnUnits;
@synthesize lblTitle;
@synthesize btnOther;
@synthesize btnPerMonth;
@synthesize btnPerWeek;
@synthesize btnAount;
@synthesize btnFreq;
@synthesize amountUnit;
@synthesize freqUnit;

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
    btnPerDay.selected = YES;
    btnMg.selected = YES;
    freqSelected = 1;
    amountSelected = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnMg:nil];
    [self setBtnPerDay:nil];
    [self setBtnUnits:nil];
    [self setBtnCC:nil];
    [self setBtnGram:nil];
    [self setBtnMcg:nil];
    [self setLblTitle:nil];
    [self setBtnPerWeek:nil];
    [self setBtnPerMonth:nil];
    [self setBtnOther:nil];
    [self setBtnAount:nil];
    [self setBtnFreq:nil];
    [super viewDidUnload];
}

- (void)setValueOfSelectedRow:(ClsMed *)med
{
    bEdit = YES;
    lblTitle.text = med.drugName;
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
}

-(void) doneNumericClick
{
    NumericViewController *p = (NumericViewController *)self.popoverController.contentViewController;
    if (numericClicked == 1)
    {
        [btnAount setTitle:p.displayStr forState:UIControlStateNormal];
    }
    if (numericClicked == 2)
    {
        [btnFreq setTitle:p.displayStr forState:UIControlStateNormal];
    }
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
}

- (IBAction)btnAmountClick:(UIButton *)sender
{
    numericClicked = 1;
    [sender resignFirstResponder];
    
    NumericViewController *popoverView =[[NumericViewController alloc] initWithNibName:@"NumericViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor blackColor];
    
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popoverController.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popoverController.popoverContentSize = CGSizeMake(430, 420);
    popoverView.delegate = self;
    [self.popoverController presentPopoverFromRect:CGRectMake(400, 75, 430 , 420) inView:self.view permittedArrowDirections:0 animated:YES];

}

- (IBAction)btnFrequencyClick:(UIButton *)sender
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

- (IBAction)btnMgClick:(id)sender {
    amountSelected = 1;
    btnMg.selected = YES;
    btnUnits.selected = NO;
    btnCC.selected = NO;
    btnGram.selected = NO;
    btnMcg.selected = NO;
}

- (IBAction)btnUnitsClick:(id)sender {
    amountSelected = 2;
    btnMg.selected = NO;
    btnUnits.selected = YES;
    btnCC.selected = NO;
    btnGram.selected = NO;
    btnMcg.selected = NO;
}

- (IBAction)btnCCClick:(id)sender {
    amountSelected = 3;
    btnMg.selected = NO;
    btnUnits.selected = NO;
    btnCC.selected = YES;
    btnGram.selected = NO;
    btnMcg.selected = NO;
}

- (IBAction)btnGramClick:(id)sender {
    amountSelected = 4;
    btnMg.selected = NO;
    btnUnits.selected = NO;
    btnCC.selected = NO;
    btnGram.selected = YES;
    btnMcg.selected = NO;
}

- (IBAction)btnMcgClick:(id)sender {
    amountSelected = 5;
    btnMg.selected = NO;
    btnUnits.selected = NO;
    btnCC.selected = NO;
    btnGram.selected = NO;
    btnMcg.selected = YES;
}

- (IBAction)btnContinueClick:(id)sender {
    switch (amountSelected) {
        case 1:
            amountUnit = @"mg";
            break;
        case 2:
            amountUnit = @"Units";
            break;
        case 3:
            amountUnit = @"cc";
            break;
        case 4:
            amountUnit = @"gram";
            break;
        case 5:
            amountUnit = @"mcg";
            break;
        default:
            break;
    }

    switch (freqSelected) {
        case 1:
            freqUnit = @"per Day";
            break;
        case 2:
            freqUnit = @"per Week";
            break;
        case 3:
            freqUnit = @"per Month";
            break;
        case 4:
            freqUnit = @"Other";
            break;
        default:
            break;
    }
    
   // [delegate continueClick];
    
    if(bEdit)
    {
        [delegate continueClick:YES];
    }
    else
    {
        [delegate continueClick:NO];
    }
}

- (IBAction)btnPerDayClick:(id)sender {
    freqSelected = 1;
    btnPerDay.selected = YES;
    btnPerWeek.selected = NO;
    btnPerMonth.selected = NO;
    btnOther.selected = NO;
}

- (IBAction)btnPerWeekClick:(id)sender {
    freqSelected = 2;
    btnPerDay.selected = NO;
    btnPerWeek.selected = YES;
    btnPerMonth.selected = NO;
    btnOther.selected = NO;
}

- (IBAction)btnPerMonthClick:(id)sender {
    freqSelected = 3;
    btnPerDay.selected = NO;
    btnPerWeek.selected = NO;
    btnPerMonth.selected = YES;
    btnOther.selected = NO;
}

- (IBAction)btnOtherClick:(id)sender {
    freqSelected = 4;
    btnPerDay.selected = NO;
    btnPerWeek.selected = NO;
    btnPerMonth.selected = NO;
    btnOther.selected = YES;
}
@end
