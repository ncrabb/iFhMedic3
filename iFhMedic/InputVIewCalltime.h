//
//  InputVIewCalltime.h
//  iFhMedic
//
//  Created by admin on 2/2/16.
//  Copyright © 2016 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupIncidentViewController.h"

#import "NumericViewController.h"
#import "Keypad.h"


@protocol DismissInputViewCalltimeDelegate <NSObject>

-(void) doneInputViewCalltime:(NSInteger) tag;

@end

@interface InputVIewCalltime : UIView < DismissNumericDelegate, DismissPadDelegate, UITextFieldDelegate>
{
    __weak id <DismissInputViewCalltimeDelegate> delegate;
    Keypad* keypad;
    NSMutableString *displayStr;
}

@property (assign, nonatomic) NSInteger tabPage;
@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (assign, nonatomic) NSInteger position;
@property (assign, nonatomic) NSInteger inputID;
@property (assign, nonatomic) NSInteger inputType;
@property (strong, nonatomic) IBOutlet UITextField *txtInput;
@property (strong, nonatomic) IBOutlet UIButton *btnInput;



@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) NSMutableArray* array;



- (IBAction)btnInputClick:(UIButton *)sender;

-(void) setLabelText: (NSString*) labelText dataType:(NSInteger) type inputRequired:(NSInteger) required;
-(void) setBtnText: (NSString*) btnText;
@end
