//
//  PatientSigUnableViewController.h
//  iRescueMedic
//
//  Created by admin on 6/15/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScribbleView.h"
#import "PopupIncidentViewController.h"
#import "PerformedByViewController.h"

@protocol DonePatientUnableSignatureDelegate <NSObject>

-(void) donePatientUnableSigningClick;

@end

@interface PatientSigUnableViewController : UIViewController
{
    __weak id <DonePatientUnableSignatureDelegate> delegate;
    ScribbleView *signView;
    UIView *containerView;
    NSInteger sigType;
    UIPopoverController* popover;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtCrew;


@property (assign, nonatomic) bool needToSave;
@property (strong, nonatomic) UIImage* image;
@property (nonatomic, retain) IBOutlet ScribbleView *signView;
@property (strong, nonatomic) IBOutlet UITextView *tvDisclaimer;
@property (assign) NSInteger sigType;
@property (strong, nonatomic) NSMutableArray * reasons;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) NSString* titleStr;


- (IBAction)btnCancel:(id)sender;
- (IBAction)btnClear:(id)sender;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnChooseReasonClick:(id)sender;
- (IBAction)btnCrewNamesClick:(UIButton *)sender;


@end
