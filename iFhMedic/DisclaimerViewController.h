//
//  DisclaimerViewController.h
//  iRescueMedic
//
//  Created by admin on 9/9/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisclaimerViewController : UIViewController
@property (assign) NSInteger sigType;
@property (strong, nonatomic) IBOutlet UITextView *tvDisclaimer;



- (IBAction)btnDisclaimerClick:(id)sender;


@end
