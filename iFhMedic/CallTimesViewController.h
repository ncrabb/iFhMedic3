//
//  CallTimesViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeViewController.h"
#import "PopupIncidentViewController.h"
#import "NumericViewController.h"

#import "ValidateViewController.h"
#import "InputVIewCalltime.h"
#import "InputViewFull.h"

@protocol DismissCallTimesDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end

@interface CallTimesViewController : UIViewController < DismissValidateControl>
{
    UIPopoverController* popover;
    BOOL newTicket;
    __weak id <DismissCallTimesDelegate> delegate;

}

@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;
@property (strong, nonatomic) NSMutableDictionary* ticketInputData;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;

@property (weak) id delegate;
@property(nonatomic) BOOL newTicket;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) UIPopoverController* popover;


@property (strong, nonatomic) IBOutlet UIView *inputContainer;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSMutableArray*  incidentInput;



- (IBAction)btnMainMenuClick:(id)sender;


- (IBAction)btnValidateClick:(UIButton *)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;

- (IBAction)btnPageControlClick:(id)sender;

- (IBAction)btnRightClick:(id)sender;
- (IBAction)btnLeftClick:(id)sender;

@end
