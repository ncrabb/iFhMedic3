//
//  SSNNumericViewController.h
//  iRescueMedic
//
//  Created by Nathan on 7/1/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissSSNDelegate <NSObject>

-(void) doneSSNClick;

@end


@interface SSNNumericViewController : UIViewController
{
    __weak id <DismissSSNDelegate> delegate;
    NSMutableString* displayStr;
    bool utoEnabled;
}
@property (assign) NSInteger phoneFormat;
@property (weak) id delegate;
@property (strong, nonatomic) NSMutableString* displayStr;
@property (strong, nonatomic) IBOutlet UITextField *txtDisplay;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnUTO;
@property (assign, nonatomic) bool utoEnabled;

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
- (IBAction)btnEnterClick:(id)sender;
- (IBAction)btnUTOClick:(id)sender;

@end
