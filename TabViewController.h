//
//  TabViewController.h
//  iMobileMedic
//
//  Created by Admin on 8/29/13.
//  Copyright (c) 2013 MobieSoftwareSystem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneViewController.h"
#import "CallTimesViewController.h"
#import "PatientViewController.h"
#import "ChiefComplaintViewController.h"
#import "AssessmentViewController.h"
#import "VitalsViewController.h"
#import "TreatmentsViewController.h"
#import "HistoryViewController.h"
#import "MedsViewController.h"
#import "AllergyViewController.h"
#import "SymptomViewController.h"
#import "OpqrstViewController.h"
#import "InjuryViewController.h"
#import "DiagramViewController.h"
#import "NarrativeViewController.h"
#import "OutcomeViewController.h"
#import "InsuranceViewController.h"
#import "SignatureViewController.h"
#import "ProtocolsViewController.h"
#import "CPRViewController.h"
#import "NarcoticViewController.h"
#import "SummeryViewController.h"

@interface TabViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, DismissSceneDelegate, DismissHistoryDelegate, DismissSymptomDelegate, DismissOutcomeDelegate >
{
    NSInteger prevTab;
}

@property (nonatomic) Boolean newTicket;
@property (nonatomic, strong) SceneViewController* sceneView;
@property (nonatomic, strong) CallTimesViewController* calltimesView;
@property (nonatomic, strong) PatientViewController* patientView;
@property (nonatomic, strong) ChiefComplaintViewController* chiefComplaintView;
@property (nonatomic, strong) AssessmentViewController* assessmentView;
@property (nonatomic, strong) VitalsViewController* vitalsView;
@property (nonatomic, strong) TreatmentsViewController* treatmentsView;
@property (nonatomic, strong) HistoryViewController* historyView;
@property (nonatomic, strong) MedsViewController* medView;
@property (nonatomic, strong) AllergyViewController* allergyView;
@property (nonatomic, strong) SymptomViewController* symptomView;
@property (nonatomic, strong) OpqrstViewController* opqrstView;
@property (nonatomic, strong) InjuryViewController* injuryView;
@property (nonatomic, strong) DiagramViewController* diagramView;
@property (nonatomic, strong) NarrativeViewController* narrativeView;
@property (nonatomic, strong) OutcomeViewController* outcomeView;
@property (nonatomic, strong) InsuranceViewController* insuranceView;
@property (nonatomic, strong) SignatureViewController* signatureView;
@property (nonatomic, strong) ProtocolsViewController* protocolView;
@property (nonatomic, strong) CPRViewController* cprView;
@property (nonatomic, strong) NarcoticViewController* narcoticView;
@property (nonatomic, strong) SummeryViewController* summary;
@property (strong, nonatomic) UIPopoverController* popover;

@property (nonatomic) float viewHeight;
@property (nonatomic, strong) NSString *selectedType;
- (IBAction)btnQuickClick:(UIButton*)sender;
- (IBAction) btnCrewPressed:(UIButton *)sender;
- (IBAction)btnSummaryPressed:(UIButton *)sender;
- (IBAction)btnPrintPressed:(UIButton *)sender;
@end
