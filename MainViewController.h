//
//  MainViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PopoverViewController.h"
#import <MessageUI/MessageUI.h>
#import "TransferViewController.h"
//#import "TabViewController.h"

NSObject* g_SYNCDATADB;
NSObject* g_SYNCLOOKUPDB;
NSObject* g_SYNCBLOBSDB;
Boolean g_NEWTICKET;
NSMutableArray* g_CREWARRAY;


@class TicketDataInfoCell;

@interface MainViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, DismissTransferViewDelegate>
{
    NSTimer* g_CLEANUP;
    NSTimer* mapTimer;

    NSTimer* g_QUEUESTATUSTIMER;
    NSObject* syncQueueDB;
    Boolean newTicket;
    NSMutableArray* ticketData;
    Boolean reloadData;
    NSInteger ticketRowSelected;
    TicketDataInfoCell* selectedCell;
    
    BOOL showPractice;
    UIPopoverController* popover;
    NSInteger functionSelected;
    BOOL transfer;
}

@property (strong, nonatomic) UIButton* _sender;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar1;
@property (strong, nonatomic) IBOutlet MKMapView *mapview;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray* ticketData;
@property (strong, nonatomic) IBOutlet UIButton *btnShowPractice;
@property (strong, nonatomic) IBOutlet UISegmentedControl *btnSegmentedControl;
@property (strong, nonatomic) IBOutlet UIButton *btnReview;
@property (strong, nonatomic) IBOutlet UIButton *btnIncomplete;
@property (strong, nonatomic) IBOutlet UIButton *btnComplete;
@property (strong, nonatomic) IBOutlet UIButton *btnAll;
@property (strong, nonatomic) UIPopoverController* popover;

- (IBAction)btnCopyNew:(UIButton *)sender;

- (IBAction)btnCrewClick:(id)sender;
- (IBAction)btnSegmentedControlClick:(id)sender;


- (IBAction)btnNewTicketClick:(id)sender;
- (IBAction)btnEditTicketClick:(id)sender;
- (IBAction)btnViewPCRClick:(id)sender;
- (IBAction)btnHelpClick:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

- (IBAction)showPracticeClicked:(id)sender;

- (IBAction)incompleteButtonPressed:(id)sender;
- (IBAction)completeButtonPressed:(id)sender;
- (IBAction)AllButtonPressed:(id)sender;
- (IBAction)reviewButtonPressed:(id)sender;

- (IBAction)btnTransferClick:(id)sender;

- (IBAction)btnTransferTicketClick:(UIButton *)sender;


@end
