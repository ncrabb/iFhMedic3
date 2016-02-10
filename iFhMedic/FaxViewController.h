//
//  FaxViewController.h
//  iRescueMedic
//
//  Created by admin on 12/18/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaxViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UITextField *txtFaxNum;
@property (strong, nonatomic) NSMutableArray* array;
@property (strong, nonatomic) NSString* form;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


- (IBAction)btnSendClick:(id)sender;

- (IBAction)btnCancelClick:(id)sender;

@end
