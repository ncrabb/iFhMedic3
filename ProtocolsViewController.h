//
//  ProtocolsViewController.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 12/03/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PopupIncidentViewController.h"
//#import "PopoverPDFViewController.h"
#import "ValidateViewController.h"
#import "QuickViewController.h"
#import <QuickLook/QuickLook.h>

@protocol DismissProtocolDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end

@interface ProtocolsViewController : UIViewController<DismissValidateControl, DismissQuickbuttonDelegate, UISearchBarDelegate, QLPreviewControllerDataSource,QLPreviewControllerDelegate>
{
    __weak id <DismissProtocolDelegate> delegate;
    NSMutableArray *arrProtocols;
    BOOL isSearching;
    NSString* ticketID;
    UIPopoverController* popover;


}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIScrollView *protocolScrollView;
@property (strong, nonatomic) NSMutableArray *arrProtocols;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) NSMutableArray *arrProtocolGroups;
@property (strong, nonatomic) IBOutlet UIScrollView *groupScrollView;
@property (strong, nonatomic) NSURL *fileURL;
@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;

@property (strong, nonatomic) IBOutlet UIScrollView *groupScrollView2;

- (IBAction)btnMainMenuClick:(id)sender;
- (IBAction)btnValidateClick:(UIButton *)sender;
- (IBAction)btnQuickClick:(id)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;

@end
