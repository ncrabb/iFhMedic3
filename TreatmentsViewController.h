//
//  TreatmentsViewController.h
//  iFhMedic
//
//  Created by admin on 10/31/15.
//  Copyright © 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverTreatmentInfoViewController.h"
#import "ValidateViewController.h"

@protocol DismissTreatmentsDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end

@interface TreatmentsViewController : UIViewController <DismissValidateControl>
{
        __weak id <DismissTreatmentsDelegate> delegate;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UILabel *lblSelectTreatment;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) IBOutlet UITableView *tblTreatment;
@property (strong, nonatomic) IBOutlet UIScrollView *treatmentScrollView;
@property (strong, nonatomic) NSMutableArray* treatmentArray;
@property (strong, nonatomic) NSMutableArray* treatmentInputs;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;

- (IBAction)btnDeleteClick:(id)sender;
- (IBAction)btnCopyClick:(id)sender;
- (IBAction)btnEditClick:(id)sender;

- (IBAction)btnMainMenuClick:(id)sender;
- (IBAction)btnValidateClick:(UIButton *)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;

@end
