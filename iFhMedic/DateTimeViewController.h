//
//  DateTimeViewController.h
//  iRescueMedic
//
//  Created by Tony Nguyen on 3/22/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissDateTimeDelegate <NSObject>

-(void) doneDateTimeClick;

@end


@interface DateTimeViewController : UIViewController
{
    NSMutableString* displayStr;
    NSInteger charCount;
    __weak id <DismissDateTimeDelegate> delegate;
    
    NSString *previousDate;
}

@property (weak) id delegate;
@property (strong, nonatomic) NSMutableString* displayStr;
@property (strong, nonatomic) IBOutlet UITextField *txtDisplay;
@property (strong, nonatomic) IBOutlet UILabel *lblTtle;
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
- (IBAction)btnNowClick:(id)sender;
- (IBAction)btn5Ago:(id)sender;
- (IBAction)btn1Fwd:(id)sender;
- (IBAction)btn1Ago:(id)sender;
- (IBAction)btn1DayFwd:(id)sender;
- (IBAction)btn1DayAgo:(id)sender;
- (void)setDate:(NSString *)dateString;




@end
