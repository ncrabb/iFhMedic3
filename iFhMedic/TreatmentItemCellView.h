//
//  TreatmentItemCellView.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 01/07/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClsTreatmentInputs.h"

@interface TreatmentItemCellView : UIView <UITextViewDelegate>

@property (nonatomic, assign)id parent;
@property (nonatomic, strong) ClsTreatmentInputs *treatmentInputInfo;

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UIButton *btnText;

@property (strong, nonatomic) IBOutlet UITextView *tvNotes;


@property (nonatomic, assign) NSInteger index;

- (IBAction)buttonPressed:(id)sender;
- (void)setButtonText:(NSString *)str;
- (void) setLabelColor:(UIColor*) color;
- (void) setTextFieldFirstRespond;
- (void) setTextFieldResignRespond;
@end
