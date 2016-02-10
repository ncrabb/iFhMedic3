//
//  PatientSearchViewController.h
//  iRescueMedic
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"
#import "ClsSearch.h"

@protocol DismissPatientSearchDelegate <NSObject>

-(void) doneSelectPatient;

@end


@interface PatientSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DismissCalendarDelegate>
{
    int searchOption;
    NSInteger rowSelected;
    __weak id <DismissPatientSearchDelegate> delegate;
    UIPopoverController* popover;
}
@property (strong, nonatomic) UIPopoverController* popoverController;
@property (strong, nonatomic) NSMutableArray* array;
@property (weak) id <DismissPatientSearchDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
@property (strong, nonatomic) IBOutlet UIButton *btnSsn;
@property (strong, nonatomic) IBOutlet UIButton *btnName;
@property (strong, nonatomic) IBOutlet UIButton *btnDob;
@property (strong, nonatomic) IBOutlet UITableView *tvPatient;
@property (assign, nonatomic) NSInteger rowSelected;
@property (strong, nonatomic) IBOutlet UILabel *lblSSN;
@property (strong, nonatomic) IBOutlet UILabel *lblDob;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UILabel *lblLastName;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) NSMutableArray* patientArray;
@property (strong, nonatomic) IBOutlet UILabel *lblFname;
@property (strong, nonatomic) ClsSearch *patientSelected;
- (IBAction)btnDobClick:(id)sender;

- (IBAction)btnSsnClick:(id)sender;
- (IBAction)btnNameClick:(id)sender;


- (IBAction)btnSearchClick:(id)sender;
- (IBAction)btnSelectClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;

@end
