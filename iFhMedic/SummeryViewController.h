//
//  SummeryViewController.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 10/04/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissSummaryDelegate <NSObject>

-(void) doneSummaryView:(NSInteger)tag;

@end


@interface SummeryViewController : UIViewController
{
    __weak id <DismissSummaryDelegate> delegate;
     NSString* ticketID;
    BOOL newTicket;

    NSMutableArray *arrSummary;
    NSMutableArray *arrAll;

}
@property (weak) id delegate;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UITableView *tblSummary;
@property (nonatomic) BOOL newTicket;
@property(nonatomic, strong) NSMutableArray *arrSummary;
@property (nonatomic, assign ) NSInteger rowSelected;
@property (nonatomic, strong) NSString *selectedType;
@property(nonatomic, strong) NSMutableArray *arrAssessment;
- (IBAction)doneButtonClicked:(id)sender;

- (IBAction)btnAllPressed:(id)sender;
- (IBAction)btnVitalPressed:(id)sender;
-  (IBAction)btnTreatmentPressed:(id)sender;
- (IBAction)btnCalltimesPressed:(id)sender;

- (IBAction)btnEditClick:(id)sender;
- (IBAction)btnAssessmentClick:(id)sender;


@end
