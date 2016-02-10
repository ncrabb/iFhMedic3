//
//  InjuryViewController.h
//  iFhMedic
//
//  Created by admin on 11/1/15.
//  Copyright © 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidateViewController.h"

@protocol DismissInjuryDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end

@interface InjuryViewController : UIViewController <DismissValidateControl>
{
    __weak id <DismissInjuryDelegate> delegate;
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

- (IBAction)btnPageControlClick:(UIPageControl *)sender;
- (IBAction)btnMainMenuClick:(id)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;
- (IBAction)btnValidateClick:(UIButton *)sender;

- (IBAction)btnLeftClick:(id)sender;
- (IBAction)btnRightClick:(id)sender;


@end
