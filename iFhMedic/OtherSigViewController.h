//
//  OtherSigViewController.h
//  iRescueMedic
//
//  Created by admin on 12/26/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScribbleView.h"
#import "PopupDataViewController.h"

@protocol DoneOherSigDelegate <NSObject>

-(void) doneOtherSigningClick;

@end


@interface OtherSigViewController : UIViewController <UITextFieldDelegate, DismissDataViewDelegate>
{
    __weak id <DoneOherSigDelegate> delegate;
    ScribbleView *signView;
    UIView *containerView;
    NSInteger functionSelected;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UIButton *btnSignature;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) NSString* labelTitle;
@property (assign) NSInteger sigType;
@property (nonatomic, retain) IBOutlet ScribbleView *signView;
@property (assign, nonatomic) bool needToSave;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSMutableArray* array;
@property (strong, nonatomic) UIPopoverController* popover;

- (IBAction)btnSignatureTypeClick:(id)sender;

- (IBAction)btnCancel:(id)sender;

- (IBAction)btnClear:(id)sender;

- (IBAction)btnSave:(id)sender;

@end
