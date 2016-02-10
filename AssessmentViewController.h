//
//  AssessmentViewController.h
//  iFhMedic
//
//  Created by admin on 10/11/15.
//  Copyright © 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAMessageViewController.h"
#import "InputViewFull.h"
#import "ValidateViewController.h"
#import "QuickViewController.h"

@protocol DismissAssessmentDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end


@interface AssessmentViewController : UIViewController<DismissValidateControl, DismissQuickbuttonDelegate>
{
    __weak id  <DismissAssessmentDelegate> delegate;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UIView *inputContainer;
@property(nonatomic) BOOL newTicket;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSMutableArray*  incidentInput;
@property (strong, nonatomic) NSMutableDictionary* ticketInputData;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) IBOutlet UITableView *tvAssessment;


- (IBAction)btnNewAssessment:(id)sender;
- (IBAction)btnEditCllick:(id)sender;
- (IBAction)btnDeleteClick:(id)sender;
- (IBAction)btnClearClick:(id)sender;
- (IBAction)btnNormalClick:(id)sender;


- (IBAction)btnMainMenuCick:(id)sender;
- (IBAction)btnValidateClick:(UIButton *)sender;
- (IBAction)btnQuickClick:(UIButton *)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;

- (IBAction)btnPageControlClick:(id)sender;
- (IBAction)btnLeftClick:(id)sender;
- (IBAction)btnRightClick:(id)sender;



@end
