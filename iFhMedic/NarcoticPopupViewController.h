//
// NarcoticPopupViewController.h
//  iRescueMedic
//
//  Created by Nathan on 7/5/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClsNarcotic.h"

@protocol DismissNarcoticControllerDelegate <NSObject>

-(void) continueClick:(BOOL)edit;

@end

@interface NarcoticPopupViewController : UIViewController
{
    __weak id  <DismissNarcoticControllerDelegate> delegate;
    NSInteger witessTypeSelected;
    
    UIPopoverController* popoverController;
    NSInteger numericClicked;
    
    NSMutableArray *medications;
    NSMutableArray *units;

}

@property (weak) id delegate;
@property (nonatomic, assign) BOOL bEdit;
@property (nonatomic, assign) NSInteger witessTypeSelected;
@property (nonatomic, strong) NSMutableArray *medications;
@property (nonatomic, strong) NSMutableArray *units;
@property (nonatomic, strong) ClsNarcotic *narcotic;

@property (nonatomic, strong) IBOutlet UIButton *btnMedication;
@property (nonatomic, strong)IBOutlet UIButton *btnUsageAmt;
@property (nonatomic, strong)IBOutlet UIButton *btnUsageUnit;
@property (nonatomic, strong)IBOutlet UIButton *btnWastageAmt;
@property (nonatomic, strong)IBOutlet UIButton *btnWastageUnit;
@property (nonatomic, strong)IBOutlet UIButton *btnUsageWitness;
@property (nonatomic, strong)IBOutlet UIButton *btnWastageWitness;
@property (nonatomic, strong) IBOutlet UIView *container1;




@property (strong, nonatomic) UIPopoverController* popoverController;


-(IBAction)btnMedicationPressed:(id)sender;
- (IBAction)btnUsageAmountPressed:(id)sender;
- (IBAction)btnUsageUnitPressed:(id)sender;
- (IBAction)btnWastageAmountPressed:(id)sender;
- (IBAction)btnWastageUnitPressed:(id)sender;

- (IBAction)witnessTypeUsageClicked:(id)sender;
- (IBAction)witnessTypeWastageClicked:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
