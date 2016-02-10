//
//  PasswordViewController.h
//  iRescueMedic
//
//  Created by admin on 8/13/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissPasswordDelegate <NSObject>

-(void) donePasswordClick;

@end

@interface PasswordViewController : UIViewController
{
    __weak id <DismissPasswordDelegate> delegate;
}

@property (weak) id delegate;

@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (assign) NSInteger userId;
@property (assign) bool pass;

- (IBAction)btnNextClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;


@end
