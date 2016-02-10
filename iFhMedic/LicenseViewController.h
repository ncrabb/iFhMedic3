//
//  LicenseViewController.h
//  iRescueMedic
//
//  Created by admin on 6/21/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DoneRegisterDelegate <NSObject>

-(void) doneRegisterClick;

@end

@interface LicenseViewController : UIViewController
{
    __weak id <DoneRegisterDelegate> delegate;
    bool registerCLicked;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtOrganization;
@property (strong, nonatomic) IBOutlet UITextField *txtSerial;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomer;


- (IBAction)btnRegisterClick:(UIButton*)sender;
- (IBAction)btnCancelClick:(UIButton*)sender;


@end
