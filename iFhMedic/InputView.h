//
//  InputView.h
//  iFhMedic
//
//  Created by admin on 9/7/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupIncidentViewController.h"
#import "CalendarViewController.h"
#import "TextViewController.h"
#import "DateTimeViewController.h"
#import "SSNNumericViewController.h"


@protocol DismissInputViewDelegate <NSObject>

-(void) doneInputView:(NSInteger) tag;

@end

@interface InputView : UIView <DismissIncidentDelegate, DismissTextDelegate, DismissCalendarDelegate, DismissSSNDelegate>
{
    bool keybaordDown;
    __weak id <DismissInputViewDelegate> delegate;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (assign, nonatomic) NSInteger position;
@property (assign, nonatomic) NSInteger inputID;
@property (assign, nonatomic) NSInteger inputType;
@property (strong, nonatomic) IBOutlet UILabel *lblInput;

@property (strong, nonatomic) IBOutlet UIButton *btnInput;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) NSMutableArray* array;
- (IBAction)btnInputClick:(UIButton *)sender;
-(void) setLabelText: (NSString*) labelText dataType:(NSInteger) type inputRequired:(NSInteger) required;
-(void) setBtnText: (NSString*) btnText;
@end
