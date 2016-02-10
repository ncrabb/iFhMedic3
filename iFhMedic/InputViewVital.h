//
//  InputViewFull.h
//  iFhMedic
//
//  Created by admin on 9/21/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimeViewController.h"
#import "NumericViewController.h"
#import "PerformedByViewController.h"

@protocol DismissInputViewVitallDelegate <NSObject>

-(void) doneInputViewVital:(NSInteger) tag;

@end

@interface InputViewVital : UIView <DismissDateTimeDelegate, DismissPerformedByDelegate, DismissNumericDelegate>
{
    bool bNormal;
    bool keybaordDown;
    __weak id <DismissInputViewVitallDelegate> delegate;
}


@property (assign, nonatomic) NSInteger tabPage;
@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (assign, nonatomic) NSInteger position;
@property (assign, nonatomic) NSInteger inputID;
@property (assign, nonatomic) NSInteger inputType;
@property (strong, nonatomic) IBOutlet UILabel *lblInput;
@property (strong, nonatomic) IBOutlet UILabel *lblDetail;


@property (strong, nonatomic) IBOutlet UIButton *btnInput;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) NSMutableArray* array;



- (IBAction)btnInputClick:(UIButton *)sender;

-(void) setLabelText: (NSString*) labelText dataType:(NSInteger) type inputRequired:(NSInteger) required;
-(void) setBtnText: (NSString*) btnText;
@end
