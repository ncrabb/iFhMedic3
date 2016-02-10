//
//  QAMessageViewController.h
//  iRescueMedic
//
//  Created by admin on 10/30/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAMessageViewController : UIViewController

@property (strong, nonatomic) NSString* adminNotes;

- (IBAction)btnDoneClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *tvNote;
@property (strong, nonatomic) IBOutlet UITextField *txtMessage;
@property (assign, nonatomic) NSInteger ticketID;

- (IBAction)btnSendClick:(id)sender;



@end
