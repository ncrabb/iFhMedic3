//
//  TimeViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/27/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissTimeDelegate <NSObject>

-(void) doneTimeClick;

@end

@interface TimeViewController : UIViewController
{
    __weak id <DismissTimeDelegate> delegate;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UIDatePicker *dpTime;

- (IBAction)btnDoneClick:(id)sender;

@end


