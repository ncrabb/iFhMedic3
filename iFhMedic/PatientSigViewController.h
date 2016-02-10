//
//  PatientSigViewController.h
//  iRescueMedic
//
//  Created by admin on 6/14/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScribbleView.h"

@protocol DonePatientSignatureDelegate <NSObject>

-(void) donePatientSigningClick;

@end


@interface PatientSigViewController : UIViewController
{
    __weak id <DonePatientSignatureDelegate> delegate;
    ScribbleView *signView;
    UIView *containerView;
    NSInteger sigType;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (assign, nonatomic) bool needToSave;
@property (strong, nonatomic) UIImage* image;
@property (nonatomic, retain) IBOutlet ScribbleView *signView;
@property (strong, nonatomic) IBOutlet UITextView *tvDisclaimer;
@property (assign) NSInteger sigType;

- (IBAction)btnCancel:(id)sender;
- (IBAction)btnClear:(id)sender;
- (IBAction)btnSave:(id)sender;

@end
