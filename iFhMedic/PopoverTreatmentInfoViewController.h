//
// PopoverTreatmentInfoViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/11/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClsTreatments.h"
#import "NumericViewController.h"
#import "TimeViewController.h"
#import "DateTimeViewController.h"
#import "PerformedByViewController.h"
#import "PopoverViewController.h"
#import "DAO.h"
#import "global.h"
#import "ClsTreatmentInputs.h"
#import "PopupDataViewController.h"


@protocol DismissTreatmentDelegate <NSObject>

-(void)didClickOK;

@end

@interface PopoverTreatmentInfoViewController : UIViewController<DismissDateTimeDelegate, UITextFieldDelegate, DismissDataViewDelegate, UITextViewDelegate>
{
    __weak id <DismissTreatmentDelegate> delegate;
    
    UIPopoverController* popover;
    NSInteger functionSelected;
    NSInteger buttonClicked;
    BOOL bEdit;

    NSMutableArray* routesArray;

    NSInteger currentInstance;


}

@property (weak) id delegate;
@property (strong, nonatomic)ClsTreatments *treatment;
@property (strong, nonatomic) UIPopoverController* popover;
@property (assign, nonatomic) NSInteger selectedTreatmentCell;
@property(nonatomic, assign) BOOL bEdit;
@property (nonatomic, assign) NSInteger functionSelected;

@property (strong, nonatomic) NSMutableArray* drugs;

@property (strong, nonatomic) NSMutableArray* routesArray;


@property (strong, nonatomic) IBOutlet UIButton *btnCopyTreatment;

@property (strong, nonatomic) IBOutlet UILabel *lblTreatmentHeader;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString* noteStr;

- (void) loadEntryFields;


- (void)inputButtonPressed:(ClsTreatmentInputs *)inputData tag:(NSInteger)tag;

- (IBAction)btnSaveTreatmentClick:(id)sender;

-(void)didTap;

@end
