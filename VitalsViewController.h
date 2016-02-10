//
//  VitalsViewController.h
//  iFhMedic
//
//  Created by admin on 10/31/15.
//  Copyright © 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidateViewController.h"

@protocol DismissVitalsDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end


@interface VitalsViewController : UIViewController <DismissValidateControl>
{
    __weak id <DismissVitalsDelegate> delegate;
    NSInteger rowSelected;
}

@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;

@property (weak) id delegate;
@property(nonatomic) BOOL newTicket;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) UIPopoverController* popover;

@property (strong, nonatomic) IBOutlet UIView *inputContainer;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) IBOutlet UITableView *tvTreatment;


@property (strong, nonatomic) NSMutableArray*  incidentInput;

- (IBAction)btnPageControlClick:(UIPageControl *)sender;

- (IBAction)btnMainMenuClick:(id)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;

- (IBAction)btnDeleteClick:(id)sender;
- (IBAction)btnReplicateClick:(id)sender;
- (IBAction)btnEditClick:(id)sender;
- (IBAction)btnNewVitalsClick:(id)sender;
- (IBAction)btnValidateClick:(UIButton *)sender;
- (IBAction)btnRightClick:(id)sender;
- (IBAction)btnLeftClick:(id)sender;


@end
