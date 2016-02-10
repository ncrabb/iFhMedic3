//
//  PopoverMultiRefusalSignatureViewController.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 11/06/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScribbleView.h"

@protocol DismissMultiSignatureDelegate <NSObject>

-(void) cancelMultiSigRefusal;


@end


@interface PopoverMultiRefusalSignatureViewController : UIViewController
{
    __weak id  <DismissMultiSignatureDelegate> delegate;
    ScribbleView *signView;
    NSInteger functionSelected;
    NSInteger sigSaved;
    NSInteger countSig;
}

@property (weak) id delegate;
@property (strong, nonatomic) UIPopoverController* popover;

@property (nonatomic, strong) IBOutlet UIView *container1;
@property (nonatomic, strong) IBOutlet UIView *container2;
@property (nonatomic, strong) IBOutlet UIView *container3;
@property (nonatomic, strong) IBOutlet UIView *container4;
@property (nonatomic, strong) IBOutlet UIButton *btnPhone;
@property (nonatomic, strong) IBOutlet UIButton *btnZip;
@property (nonatomic, strong) IBOutlet UIButton *btnDOB;
@property (assign, nonatomic) bool needToSave;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextView *tvDisclaimer;
@property (strong, nonatomic) IBOutlet UILabel *lblPatientCount;



- (IBAction)btnNextPatient:(UIButton *)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)phoneButtonPressed:(id)sender;
- (IBAction)DOBPressed:(id)sender;
- (IBAction)zipClicked:(id)sender;
- (IBAction)btnViewList:(id)sender;


@end
