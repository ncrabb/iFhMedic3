//
//  SignaturePageViewController.h
//  iRescueMedic
//
//  Created by Nathan on 8/21/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScribbleView.h"

@protocol DoneSignatureDelegate <NSObject>

-(void) doneSigningClick;

@end

@interface SignaturePageViewController : UIViewController <UITextFieldDelegate>
{
     __weak id <DoneSignatureDelegate> delegate;
    ScribbleView *signView;
 UIView *containerView;
}


@property (weak) id delegate;

@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (assign, nonatomic) bool needToSave;
@property (strong, nonatomic) UIImage* image;
@property (nonatomic, retain) IBOutlet ScribbleView *signView;
@property (assign) NSInteger sigType;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) NSString* labelTitle;
@property (strong, nonatomic) NSString* name;

- (IBAction)btnCancel:(id)sender;
- (IBAction)btnClear:(id)sender;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnViewDisclaimer:(id)sender;


@end
