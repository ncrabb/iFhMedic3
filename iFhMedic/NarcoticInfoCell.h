//
//  NarcoticInfoCell.h
//  iRescueMedic
//
//  Created by admin on 3/29/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverViewController.h"
#import "NumericViewController.h"

@interface NarcoticInfoCell : UITableViewCell <DismissNumericDelegate, DismissDelegate>
{
    NSInteger witnessUsage;
    NSInteger witnessWastage;
}

@property (strong, nonatomic) NumericViewController* numView;
@property (strong, nonatomic) PopoverViewController* popView;
@property (strong, nonatomic) IBOutlet UILabel *lblMedication;
@property (strong, nonatomic) IBOutlet UILabel *lblAmtUsage;
@property (strong, nonatomic) IBOutlet UILabel *lblUnitUsage;
@property (strong, nonatomic) IBOutlet UIButton *btnUsage;
@property (strong, nonatomic) IBOutlet UIButton *btnWaste;

@property (strong, nonatomic) IBOutlet UIButton *btnUnitWasted;
@property (strong, nonatomic) IBOutlet UIButton *btnAmtWasted;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) NSMutableArray *unitArray;
@property (strong, nonatomic) IBOutlet UIButton *btnWitnessUsage;
@property (strong, nonatomic) IBOutlet UIButton *btnWitnessWastage;



- (IBAction)btnUnitWastedClick:(id)sender;
- (IBAction)btnAmtWastedClick:(id)sender;
- (IBAction)btnWitnessUsageClick:(id)sender;
- (IBAction)btnWitnessWastageClick:(id)sender;




@end
