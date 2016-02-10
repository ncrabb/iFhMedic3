//
//  CrewViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/26/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//
#define ALL_USERS_FROM_CURRENT_UNIT     0
#define ALL_ACTIVE_USERS_FROM_ALL_UNITS 1

#import <UIKit/UIKit.h>
#import "PopoverViewController.h"
#import "sharedClsCommonVariables.h"
#import "CustomCrewViewController.h"
#import "PasswordViewController.h"


@interface CrewViewController : UIViewController <UITextFieldDelegate, DismissDelegate, UITableViewDelegate, UITableViewDataSource, DismissCustomCrewDelegate, DismissPasswordDelegate, UISearchBarDelegate>
{
    NSInteger functionSelected;
    NSInteger userSelected;
    NSInteger cellSelected;
    NSInteger typeSelected;
    NSString* primaryUser;
    NSString* primaryUserId;
    NSString* _unitName;
    BOOL showUsers;
    bool unitSelected;
    NSInteger crewRowSelected;
    NSInteger userRowSelected;
}

@property (nonatomic, strong) NSMutableArray* shiftArray;
@property (strong, nonatomic) IBOutlet UIView *viewLabel;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblID;
@property (strong, nonatomic) IBOutlet UILabel *lblCertification;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UITableView *tvCrew;

@property (nonatomic, strong) NSString* primaryUser;
@property (nonatomic, strong) NSString* primaryUserId;
@property (nonatomic, strong) NSMutableArray* usersArray;
@property (nonatomic, strong) NSMutableArray* arrayActiveUsers;
@property (nonatomic, strong) NSMutableArray* arrayUnitUsers;
@property (nonatomic, strong) NSMutableArray* ticketCrewArray;
@property (nonatomic, strong) NSMutableArray* typeArray;
@property (nonatomic, strong) UIPopoverController *popOver;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtID;
@property (strong, nonatomic) IBOutlet UIButton *btnCrewType;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectCrew;
@property (strong, nonatomic) IBOutlet UIButton *btnPrimaryUser;
@property (strong, nonatomic) IBOutlet UIButton *btnAllUnits;
@property (strong, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) IBOutlet UILabel *lblType;

@property (strong, nonatomic) IBOutlet UIView *containerView3;
@property (strong, nonatomic) IBOutlet UIButton *btnSelectShift;
@property (nonatomic) NSInteger affectCurrentTicket;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;



- (IBAction)btnSegmentControlClick:(id)sender;


- (IBAction)btnAllUnits:(id)sender;
- (IBAction)btnDoneClick:(id)sender;
- (IBAction)selectCrewClick:(id)sender;
- (IBAction)selectCrewTypeClick:(id)sender;
- (IBAction)btnAddClick:(id)sender;
- (IBAction)btnLogoutClick:(id)sender;
- (IBAction)btnAddCrew:(id)sender;
- (IBAction)btnAddMember:(id)sender;
- (IBAction)btnDeleteClick:(id)sender;
- (IBAction)btnSelectShiftClick:(UIButton *)sender;
- (IBAction)btnPrimaryClick:(id)sender;


@end
