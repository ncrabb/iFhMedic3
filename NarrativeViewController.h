//
//  NarrativeViewController.h
//  iRescueMedic
//
//  Created by Nathan on 8/26/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidateViewController.h"
#import "QuickViewController.h"
#import "ClsTreatments.h"
#import "ScratchpadViewController.h"

@protocol DismissNarrativeDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end

@interface NarrativeViewController : UIViewController <DismissValidateControl, DismissQuickbuttonDelegate, DismissScratchpadDelegate, UITextViewDelegate>
{
    __weak id <DismissNarrativeDelegate> delegate;
}
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UITextView *svNarrative;
@property(nonatomic) BOOL newTicket;
@property (strong, nonatomic) NSString* ticketID;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *scNarrative;
@property (assign, nonatomic) NSInteger currentIndex;
@property (nonatomic, assign) BOOL bCopy;
@property (strong, nonatomic) IBOutlet UIButton *btnCopyNarrative;
@property (strong, nonatomic) NSMutableDictionary* ticketInputsData;
@property (strong, nonatomic) ClsTreatments* loadTreatment;
@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;


- (IBAction)btnQueueClick:(id)sender;
- (IBAction)btnMainMenuCick:(id)sender;
- (IBAction)btnSegmentControlClick:(id)sender;
- (IBAction)btnValidateClick:(UIButton *)sender;
- (IBAction)btnCopyAutoClick:(UIButton *)sender;
- (IBAction)btnQuickClick:(UIButton *)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;
- (IBAction)btnScratchpadClick:(id)sender;
@end
