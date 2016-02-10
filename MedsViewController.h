//
//  MedsViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/20/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrugViewController.h"
#import "CustomAlphaView.h"
#import "ValidateViewController.h"
#import "PopupMedViewController.h"
#import "QuickViewController.h"

@protocol DismissMedsDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end

@interface MedsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DismissDrugControllerDelegate, UISearchBarDelegate, DismissValidateControl, DismissMedViewDelegate, DismissQuickbuttonDelegate>
{
    NSMutableArray* drugs;
    NSMutableArray* drugSelected;
    UIPopoverController* popover;
    NSInteger drugRowSelected;
    NSInteger drugButtonSelected;
    BOOL newTicket;
    __weak id <DismissMedsDelegate> delegate;
    BOOL isSearching;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;

@property (weak) id delegate;
@property(nonatomic) BOOL newTicket;
@property (strong, nonatomic) NSMutableArray* drugs;
@property (strong, nonatomic) NSMutableArray* drugSelected;
@property (strong, nonatomic) UIPopoverController* popover;

@property (strong, nonatomic) IBOutlet UITableView *tvDrugSelected;
@property (strong, nonatomic) IBOutlet UITableView *tvDrugs;
@property (strong, nonatomic) IBOutlet UITextField *txtDrug;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIScrollView *drugScrollView;

@property (strong, nonatomic) IBOutlet CustomAlphaView *customAlphaView;
@property (strong, nonatomic) IBOutlet UILabel *lblSelectMed;
@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;


- (IBAction)btnMainMenuClick:(id)sender;

- (IBAction)btnAddClick:(id)sender;
- (IBAction)btnDeleteClick:(id)sender;
- (IBAction)editButtonPressed:(id)sender;

- (void)searchAlphaOnScroll:(NSString *)alpha;
- (IBAction)btnValidateClick:(id)sender;
- (IBAction)btnQuickClick:(UIButton *)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;

@end
