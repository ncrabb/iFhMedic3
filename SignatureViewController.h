//
//  SignatureViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/20/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignaturePageViewController.h"
#import "OrangeButton.h"
#import "ValidateViewController.h"
#import "PopoverPatientRefusalViewController.h"
#import  "PopoverMultiPatientRefusalViewController.h"
#import "PopoverMultiRefusalSignatureViewController.h"
#import "PatientSigUnableViewController.h"
#import "QuickViewController.h"
#import "OtherSigViewController.h"

@protocol DismissSignatureDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end

@interface SignatureViewController : UIViewController <DoneSignatureDelegate, DismissValidateControl, DismissPatientRefusalDelegate, DismissMultiRefusalDelegate, DismissMultiSignatureDelegate, DonePatientUnableSignatureDelegate, DismissPerformedByDelegate, DismissQuickbuttonDelegate, DoneOherSigDelegate>
{
    NSInteger signatureSeleted;
    NSInteger signatureCount;
    NSInteger btnSelected;
    NSString* ticketID;
    BOOL newTicket;
    __weak id <DismissSignatureDelegate> delegate;
    int tabSaved;
    int refusalTag;
    CGRect senderFrame;
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;

@property (weak) id delegate;
@property (strong, nonatomic) NSString* ticketID;
@property (strong, nonatomic) NSMutableArray* imageArray;
@property (strong, nonatomic) SignaturePageViewController* witness;
@property (strong, nonatomic) SignaturePageViewController* patient;
@property (strong, nonatomic) SignaturePageViewController* party;
@property (strong, nonatomic) SignaturePageViewController* refusalTrasport;
@property (strong, nonatomic) SignaturePageViewController* refusalTreatment;
@property (strong, nonatomic) SignaturePageViewController* patientRefusal;
@property (strong, nonatomic) SignaturePageViewController* medic;
@property (strong, nonatomic) SignaturePageViewController* medic2;
@property (strong, nonatomic) PatientSigUnableViewController* unable;
@property (strong, nonatomic) OtherSigViewController* nurse;
@property (strong, nonatomic) SignaturePageViewController* physician;
@property (strong, nonatomic) SignaturePageViewController* guardian;
@property (strong, nonatomic) SignaturePageViewController* guardianRefusal;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) SignaturePageViewController* sigPageControl;

@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) IBOutlet UIScrollView *signContainerView;

@property (strong, nonatomic) NSMutableArray* signatureTypesArray;
@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;

- (void)signatureButtonPressed:(id)sender;
- (IBAction)btnMainMenuClick:(id)sender;


- (IBAction)btnValidateClick:(UIButton *)sender;

- (IBAction)btnClearSelectedClick:(id)sender;
- (IBAction)btnClearAllClick:(id)sender;

- (IBAction)btnQuickClick:(UIButton *)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;
@end
