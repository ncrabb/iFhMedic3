//
//  DrugViewController.h
//  iRescueMedic
//
//  Created by Nathan on 7/5/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClsMed.h"

@protocol DismissDrugControllerDelegate <NSObject>

-(void) continueClick:(BOOL)edit;

@end

@interface DrugViewController : UIViewController
{
    __weak id <DismissDrugControllerDelegate> delegate;
    NSInteger amountSelected;
    NSInteger freqSelected;
    NSString* amountUnit;
    NSString* freqUnit;
    
    UIPopoverController* popoverController;
    NSInteger numericClicked;

}

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) NSString* amountUnit;
@property (strong, nonatomic) NSString* freqUnit;
@property (nonatomic) NSInteger amountSelected;
@property (nonatomic) NSInteger freqSelected;
@property (weak) id delegate;
@property (nonatomic, assign) BOOL bEdit;

@property (strong, nonatomic) IBOutlet UIButton *btnMg;
@property (strong, nonatomic) IBOutlet UIButton *btnPerDay;
@property (strong, nonatomic) IBOutlet UIButton *btnUnits;
@property (strong, nonatomic) IBOutlet UIButton *btnCC;
@property (strong, nonatomic) IBOutlet UIButton *btnGram;
@property (strong, nonatomic) IBOutlet UIButton *btnMcg;
@property (strong, nonatomic) IBOutlet UIButton *btnPerWeek;
@property (strong, nonatomic) IBOutlet UIButton *btnPerMonth;
@property (strong, nonatomic) IBOutlet UIButton *btnOther;
@property (strong, nonatomic) IBOutlet UIButton *btnAount;
@property (strong, nonatomic) IBOutlet UIButton *btnFreq;

@property (strong, nonatomic) UIPopoverController* popoverController;

- (IBAction)btnMgClick:(id)sender;
- (IBAction)btnUnitsClick:(id)sender;
- (IBAction)btnCCClick:(id)sender;
- (IBAction)btnGramClick:(id)sender;
- (IBAction)btnMcgClick:(id)sender;
- (IBAction)btnContinueClick:(id)sender;
- (IBAction)btnPerDayClick:(id)sender;
- (IBAction)btnPerWeekClick:(id)sender;
- (IBAction)btnPerMonthClick:(id)sender;
- (IBAction)btnOtherClick:(id)sender;

- (IBAction)btnAmountClick:(id)sender;
- (IBAction)btnFrequencyClick:(id)sender;

- (void)setValueOfSelectedRow:(ClsMed *)med;

@end
