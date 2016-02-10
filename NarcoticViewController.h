//
//  NarcoticViewController.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 04/06/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ValidateViewController.h"
#import "NarcoticSigViewController.h"
#import "QuickViewController.h"

@protocol DismissNarcoticDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end



@interface NarcoticViewController : UIViewController<DismissValidateControl, DoneNarcoticSignatureDelegate, DismissQuickbuttonDelegate>
{
    __weak id <DismissNarcoticDelegate> delegate;
    NSString* ticketID;
    BOOL newTicket;
    NSInteger orderSelected;
    bool lock;
    NSInteger currentButonClicked;
    NSString* paramedicName;
    NSString* paramedicSig;
    NSString* witnessName;
    NSString* witnessSig;
    NSString* wastageName;
    NSString* wastageSig;
    NSString* sigtime;
}

@property (weak) id delegate;
@property(nonatomic) BOOL newTicket;
@property (strong, nonatomic) NSString* ticketID;
@property (nonatomic, strong) UIPopoverController* popover;
@property (nonatomic, strong) NSMutableArray *arrNarcotic;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIView *container1;
@property (strong, nonatomic) IBOutlet UIView *container2;
@property (strong, nonatomic) IBOutlet UIView *container3;
@property (strong, nonatomic) IBOutlet UIView *container4;
@property (strong, nonatomic) IBOutlet UIView *container5;
@property (strong, nonatomic) IBOutlet UIView *container6;
@property (strong, nonatomic) IBOutlet UIView *container7;

@property (strong, nonatomic) IBOutlet UITableView *tblNarcotic;
@property (strong, nonatomic) IBOutlet UIButton *btnOrderStanding;
@property (strong, nonatomic) IBOutlet UIButton *btnOrderPhysician;
@property (strong, nonatomic) IBOutlet UITextField *txtBoxNumber;
@property (strong, nonatomic) NarcoticSigViewController* signatureView;
@property (strong, nonatomic) IBOutlet UITextField *txtPhysician;
@property (strong, nonatomic) IBOutlet UITextField *txtParamedicCert;
@property (strong, nonatomic) IBOutlet UITextField *txtWitnessCert;
@property (strong, nonatomic) IBOutlet UITextField *txtWastageCert;
@property (strong, nonatomic) IBOutlet UIButton *btnParamedicSig;
@property (strong, nonatomic) IBOutlet UIButton *btnWitnessSig;
@property (strong, nonatomic) IBOutlet UIButton *btnWastageSig;

@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) UIButton *bsender;

@property (strong, nonatomic) IBOutlet UILabel *lblControledSub;
@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;

- (IBAction)btnValidateClick:(id)sender;
- (IBAction)btnMainMenuClick:(id)sender;

- (IBAction)addButtonPressed:(id)sender;
- (IBAction)btnOrderOptionPressed:(id)sender;
- (IBAction)witnessSignPressed:(id)sender;
- (IBAction)administerningSignPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *WatsageWitnessClick;
- (IBAction)btnWastageWitnessClick:(id)sender;
- (IBAction)btnQuickClick:(UIButton *)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;

@end
