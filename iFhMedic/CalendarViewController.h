//
//  CalendarViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/19/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissCalendarDelegate <NSObject>

-(void) doneClick;

@end


@interface CalendarViewController : UIViewController
{
    __weak id <DismissCalendarDelegate> delegate;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UIDatePicker *dpDate;

- (IBAction)btnDoneClick:(id)sender;

@end
