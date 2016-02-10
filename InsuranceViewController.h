//
//  InsuranceViewController.h
//  iRescueMedic
//
//  Created by Nathan on 7/18/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "OtherPayerViewController.h"
#import "ValidateViewController.h"
#import "ScribbleView.h"
#import "PopupIncidentViewController.h"
#import "QuickViewController.h"

@protocol DismissInsuranceDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end

@class InsuranceInfoCell;
@interface InsuranceViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, DismissOtherPayerInsDelegate, DismissValidateControl, DismissIncidentDelegate, DismissQuickbuttonDelegate, UITextFieldDelegate>
{
    UIPopoverController* popoverController;
    bool newMedia;
    NSString* payer;
    NSString* id;
    NSMutableArray* insuranceSelected;
    NSInteger insRowSelected;
    NSInteger payerSelected;
    bool editMode;
    BOOL newTicket;
    __weak id <DismissInsuranceDelegate> delegate;
    
    NSInteger functionSelected;
   // ScribbleView *signView;
    NSInteger currentView;
    NSInteger saveSig;
    bool saved;
}

@property (strong, nonatomic) ScribbleView *signView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;
@property (strong, nonatomic) UIPopoverController* popover;
@property (weak) id delegate;
@property(nonatomic) BOOL newTicket;
@property (nonatomic, strong) InsuranceInfoCell* insCell;
@property (nonatomic, strong) NSMutableArray* insuranceSelected;
@property (nonatomic, strong) NSString* payer;
@property (nonatomic, strong) NSString* id;

@property (nonatomic, strong) OtherPayerViewController* otherPayerController;
@property (nonatomic, strong) UIPopoverController* popoverController;
@property (nonatomic, assign) NSInteger abnSelectedObtion;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIView *containerView1;
@property (strong, nonatomic) IBOutlet UIView *containerView2;
@property (strong, nonatomic) IBOutlet UIView *containerView3;
@property (strong, nonatomic) IBOutlet UIView *containerView4;

@property (strong, nonatomic) IBOutlet UIButton *btnInsuranceName;


@property (strong, nonatomic) IBOutlet UIButton *btnInsuredSSN;


@property (strong, nonatomic) IBOutlet UITextField *txtInsuredName;
@property (strong, nonatomic) IBOutlet UISegmentedControl *SegCtrl;

@property (strong, nonatomic) IBOutlet UIButton *btnDOB;

@property (strong, nonatomic) IBOutlet UIView *ABNContainer;
@property (strong, nonatomic) IBOutlet UIView *PCSContainer;
@property (strong, nonatomic) IBOutlet UIView *page1Container;

@property (strong, nonatomic) NSMutableArray* medicareArray;
@property (strong, nonatomic) NSMutableArray* companyArray;
@property (strong, nonatomic) NSMutableArray* facultyArray;

@property (strong, nonatomic) IBOutlet UIView *ABNContainer1;
@property (strong, nonatomic) IBOutlet UIView *ABNContainer2;
@property (strong, nonatomic) IBOutlet UIView *ABNContainer3;
@property (strong, nonatomic) IBOutlet UIView *ABNContainer4;
@property (strong, nonatomic) IBOutlet UIView *ABNContainer5;

@property (strong, nonatomic) IBOutlet UIButton *btnABNObtion1;
@property (strong, nonatomic) IBOutlet UIButton *btnABNObtion2;
@property (strong, nonatomic) IBOutlet UIButton *btnABNObtion3;
@property (strong, nonatomic) IBOutlet UIButton *btnSSN;
@property (strong, nonatomic) IBOutlet UITextField *txtPatientName;
@property (strong, nonatomic) IBOutlet UITextField *txtReason;
@property (strong, nonatomic) IBOutlet UITextField *txtItemServices;
@property (strong, nonatomic) IBOutlet UITextField *txtReasonNotPay;
@property (strong, nonatomic) IBOutlet UITextField *txtEstimateCost;
@property (strong, nonatomic) IBOutlet UITextField *txtNotifier;
@property (strong, nonatomic) IBOutlet UIButton *btnFaculty;
@property (strong, nonatomic) IBOutlet UITextField *txtAdditionalInfo;

@property (strong, nonatomic) IBOutlet UIImageView *sigImageView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segEkg;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segVentilator;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segIV;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segChemRestraint;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segEMTALA;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSuction;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segOxygen;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segDanger;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segOrtho;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRiskFall;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSafety;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segFlightRisk;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segIsolation;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segPatientSize;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segSpecHandle;

@property (strong, nonatomic) IBOutlet UIButton *btnMedicarePlayer;
@property (strong, nonatomic) IBOutlet UITextField *txtMedicareID;

@property (strong, nonatomic) IBOutlet UITextField *txtMedicaidPayer;
@property (strong, nonatomic) IBOutlet UITextField *txtMedicaidID;

@property (strong, nonatomic) IBOutlet UITextField *txtSubscriberID;
@property (strong, nonatomic) IBOutlet UITextField *txtGroupNum;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentHospital;

@property (strong, nonatomic) IBOutlet UIButton *btnAddAnother;

@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@property (strong, nonatomic) NSMutableArray* privateInsArray;
@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) NSMutableArray* privateInsArrayAll;

@property (strong, nonatomic) IBOutlet UILabel *lblPrivateInsuranceName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrivateSubscriber;
@property (strong, nonatomic) IBOutlet UILabel *lblPrivateGroupNum;
@property (strong, nonatomic) IBOutlet UILabel *lblPrivateInsuredName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrivateInsuredSSN;
@property (strong, nonatomic) IBOutlet UILabel *lblPrivateInsuredDOB;
@property (strong, nonatomic) IBOutlet UIButton *btnOtherPayer;



- (IBAction)btnSelfPayClick:(UIButton *)sender;


- (IBAction)btnFacultyClick:(UIButton *)sender;



- (IBAction)btnMainMenuClick:(id)sender;

- (IBAction)btnTakePictureClick:(id)sender;

- (IBAction)btnPayerClick:(id)sender;
- (IBAction)btnReasonClick:(id)sender;
- (IBAction)btnEditClick:(id)sender;


- (IBAction)btnMedicarePlayerClicked:(id)sender;
- (IBAction)btnCompanyNameClick:(id)sender;
- (IBAction)btnDOBClick:(id)sender;
- (IBAction)copyInsuredNameClicked:(id)sender;
- (IBAction)copyInsuredDOBClicked:(id)sender;
- (IBAction)btnValidateClick:(UIButton *)sender;

- (IBAction)segmentValueChanged:(id)sender;
- (IBAction)btnClearSignature:(id)sender;

- (IBAction)abnObtionBtnClicked:(id)sender;
- (IBAction)pcsGetFacultySignatureClicked:(id)sender;
- (IBAction)pcsGetPatientSignatureClicked:(id)sender;
- (IBAction)btnQuickClick:(UIButton *)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;
- (IBAction)btnAddAnotherClick:(id)sender;
- (IBAction)btnClearSelection:(id)sender;

- (IBAction)btnIdNumClick:(id)sender;
- (IBAction)btnDeletePrivateInsClick:(id)sender;

- (IBAction)btnInsuredSSNClick:(id)sender;

@end;