//
//  ChiefComplaintViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/20/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GridView.h"
//#import "YelloButton.h"
#import "ValidateViewController.h"

@protocol DismissComplaintsDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end

@interface ChiefComplaintViewController : UIViewController <DismissValidateControl>
{
    NSString* primaryComplaint;
    NSString* secondaryComplaint;
    NSMutableArray* medical;
    NSMutableArray* trauma;
    BOOL newTicket;
    __weak id  <DismissComplaintsDelegate> delegate;
    Boolean g_NEWTICKET; // Balraj For Edit mode.
    bool primarySelected;

}


@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;
@property (strong, nonatomic) UIPopoverController* popover;
@property (weak) id delegate;
@property(nonatomic) BOOL newTicket;
@property (strong, nonatomic) NSMutableArray* medical;
@property (strong, nonatomic) NSMutableArray* trauma;
@property (strong, nonatomic) NSString* primaryComplaint;
@property (strong, nonatomic) NSString* secondaryComplaint;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIButton *btnQueue;

@property (strong, nonatomic) IBOutlet UIButton *btnPrimaryImpression;
@property (strong, nonatomic) IBOutlet UIButton *btnSecondaryImpression;
@property (nonatomic, retain) IBOutlet UITextField *txtComplaint;

@property (strong, nonatomic) IBOutlet UILabel *lblChiefComplaint;

@property (strong, nonatomic) IBOutlet UIImageView *iv1;
@property (strong, nonatomic) IBOutlet UIImageView *iv2;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionview;
@property (nonatomic, retain) NSMutableArray *arrDataSourse;
@property (nonatomic, retain) NSMutableDictionary* ticketInputsData;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;

- (IBAction)btnSegControlClick:(id)sender;



- (void)setButtonText:(NSString *)text onButton:(NSInteger)tag;

- (IBAction)btnPrimarySecondaryClick:(id)sender;
// Balraj


- (IBAction)btnMainMenuClick:(id)sender;
- (IBAction)btnValidateClick:(UIButton *)sender;

- (IBAction)btnQAMessageClick:(UIButton *)sender;

- (IBAction)btnCopyImpressionClick:(id)sender;


@end
