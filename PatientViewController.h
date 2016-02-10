//
//  PatientViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupIncidentViewController.h"
#import "CalendarViewController.h"
#import "PatientSearchViewController.h"
#import "NumericViewController.h"
#import "ValidateViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import "ClsScanResult.h"
#import "PopupDataViewController.h"
#import "QuickViewController.h"
#import "SSNNumericViewController.h"
#import "InputViewFull.h"

@interface DecoderResult : NSObject {
	BOOL succeeded;
	NSString *result;
}

@property (nonatomic, assign) BOOL succeeded;
@property (nonatomic, retain) NSString *result;

+(DecoderResult *)createSuccess:(NSString *)result;
+(DecoderResult *)createFailure;

@end



typedef enum eMainScreenState {
	NORMAL,
	LAUNCHING_CAMERA,
	CAMERA,
	CAMERA_DECODING,
	DECODE_DISPLAY,
	CANCELLING
} MainScreenState;

@protocol DismissPatientControlDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end


@interface PatientViewController : UIViewController <UITextFieldDelegate, DismissIncidentDelegate, DismissCalendarDelegate, DismissNumericDelegate, DismissValidateControl, AVCaptureVideoDataOutputSampleBufferDelegate, DismissDataViewDelegate, DismissQuickbuttonDelegate, DismissPatientSearchDelegate, DismissSSNDelegate>
{
    UIPopoverController* popover;
    NSInteger functionSelected;
    __weak id <DismissPatientControlDelegate> delegate;
    BOOL newMedia;
    UIPopoverController* popoverController;
    bool copyIncident;
    NSInteger numericClicked;
    bool cameraOn;
}

@property (strong, nonatomic) IBOutlet UIView *inputContainer;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray*  incidentInput;
@property (strong, nonatomic)  NSMutableDictionary* ticketInputData;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIView *page2Container;


@property (strong, nonatomic) UIPopoverController* popoverController;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;

@property (weak) id delegate;
@property (strong, nonatomic) UIPopoverController* popover;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (nonatomic, retain) IBOutlet UIView *containerView1;
@property (nonatomic, retain) IBOutlet UIView *containerView2;
@property (nonatomic, retain) IBOutlet UIView *containerView3;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (nonatomic, assign) id currentResponder;

@property (strong, nonatomic) IBOutlet UIButton *btnCopyIncident;

//@property (strong, nonatomic) MWScannerViewController* scanView;
//@property (nonatomic, assign) MainScreenState state;

@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *prevLayer;
@property (nonatomic, retain) AVCaptureDevice *device;
@property (nonatomic, retain) NSTimer *focusTimer;
@property (nonatomic, retain) ClsScanResult* result;
@property (strong, nonatomic) IBOutlet UIButton *btnInbox;
@property (strong, nonatomic) IBOutlet UIButton *btnScanDl;
@property (strong, nonatomic) IBOutlet UILabel *lblLastName;
@property (strong, nonatomic) IBOutlet UILabel *lblFirstName;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblCity;
@property (strong, nonatomic) IBOutlet UILabel *lblState;
@property (strong, nonatomic) IBOutlet UILabel *lblZip;
@property (strong, nonatomic) IBOutlet UILabel *lblCounty;
@property (strong, nonatomic) IBOutlet UILabel *lblSSNum;
@property (strong, nonatomic) IBOutlet UILabel *lblGender;
@property (strong, nonatomic) IBOutlet UILabel *lblDob;
@property (strong, nonatomic) IBOutlet UILabel *lblRace;
@property (strong, nonatomic) IBOutlet UILabel *lblAge;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblResident;
@property (strong, nonatomic) IBOutlet UILabel *lblAgeUnit;


@property (strong, nonatomic) IBOutlet UIButton *btnLookupPat;
@property (strong, nonatomic) PatientSearchViewController* search;
@property (strong, nonatomic) ClsSearch* selectedPatient;

@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;
@property (strong, nonatomic) IBOutlet UILabel *lblWeight;



- (IBAction)btnPageControlClick:(UIPageControl *)sender;


- (IBAction)btnPhoneClick:(UIButton *)sender;

- (void)decodeResultNotification: (NSNotification *)notification;
- (void)initCapture;
- (void) startScanning;
- (void) stopScanning;
- (void) toggleTorch;

- (IBAction)btnSSNClicked:(id)sender;



- (IBAction)btnCopyIncidentClick:(id)sender;
- (IBAction)btnCopySettingPressed:(id)sender;

- (IBAction)btnLoopUpClick:(id)sender;


- (IBAction)btnTakePictureClick:(id)sender;


- (IBAction)btnMainMenuClick:(id)sender;

- (NSString*) removeNull:(NSString*)str;

- (IBAction)btnValidateClick:(UIButton *)sender;

- (IBAction)btnQuickClick:(UIButton *)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;

- (IBAction)btnRightClick:(id)sender;
- (IBAction)btnLeftClick:(id)sender;


@end
