//
//  NumericViewController.h
//  iRescueMedic
//
//  Created by Nathan on 7/1/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupDetailsViewController.h"

@protocol DismissNumericDelegate <NSObject>

-(void) doneNumericClick;
@optional
-(void) doneDetailClick;
@end


@interface NumericViewController : UIViewController <DismissDetailsDelegate>
{
    __weak id <DismissNumericDelegate> delegate;
    NSMutableString* displayStr;
    bool utoEnabled;
}

@property (weak) id delegate;
@property (strong, nonatomic) NSMutableString* displayStr;
@property (strong, nonatomic) IBOutlet UITextField *txtDisplay;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnUTO;
@property (strong, nonatomic) IBOutlet UIButton *btnWeight;
@property (strong, nonatomic) IBOutlet UILabel *lblWeight;
@property (strong, nonatomic) IBOutlet UIButton *btnDetails;
@property (assign, nonatomic) int unhide;
@property (strong, nonatomic) UIPopoverController* popover;
@property (assign, nonatomic) bool utoEnabled;
@property (assign, nonatomic) NSInteger vitalSelected;
@property (strong, nonatomic) NSString* detailsText;
@property (strong, nonatomic) NSMutableArray* detailsArray;
@property (assign, nonatomic) bool detailsSet;

- (IBAction)btn1Click:(id)sender;
- (IBAction)btn2Click:(id)sender;
- (IBAction)btn3Click:(id)sender;
- (IBAction)btn4Click:(id)sender;
- (IBAction)btn5Click:(id)sender;
- (IBAction)btn6Click:(id)sender;
- (IBAction)btn7Click:(id)sender;
- (IBAction)btn8Click:(id)sender;
- (IBAction)btn9Click:(id)sender;
- (IBAction)btn0Click:(id)sender;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnClearClick:(id)sender;
- (IBAction)btnUTOClick:(id)sender;
- (IBAction)btnEnterClick:(id)sender;
- (IBAction)btnDecimalClick:(id)sender;

- (IBAction)lbsToKgPressed:(id)sender;
- (IBAction)btnDetails:(id)sender;


@end
