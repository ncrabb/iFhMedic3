//
//  NarcoticSigViewController.h
//  iRescueMedic
//
//  Created by admin on 6/14/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScribbleView.h"

@protocol DoneNarcoticSignatureDelegate <NSObject>

-(void) doneNarcoticSigningClick;

@end


@interface NarcoticSigViewController : UIViewController
{
    __weak id <DoneNarcoticSignatureDelegate> delegate;
    ScribbleView *signView;
    UIView *containerView;
    NSInteger sigType;
    UIImageView* imageview;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (assign, nonatomic) bool needToSave;
@property (strong, nonatomic) UIImage* image;
@property (nonatomic, retain) IBOutlet ScribbleView *signView;
@property (strong, nonatomic) IBOutlet UITextView *tvDisclaimer;
@property (assign) NSInteger sigType;
@property (assign) NSInteger formInputID;
@property (assign) NSInteger formID;
@property (strong, nonatomic) IBOutlet UIButton *btnsave;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;



- (IBAction)btnCancel:(id)sender;
- (IBAction)btnClear:(id)sender;
- (IBAction)btnSave:(id)sender;

@end
