//
//  PopoverPatientRefusalViewController.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 11/06/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissPatientRefusalDelegate <NSObject>

-(void) cancelPatientRefusal;
-(void) submitPatientRefusal;


@end


@interface PopoverPatientRefusalViewController : UIViewController
{
    __weak id <DismissPatientRefusalDelegate> delegate;

}

@property (weak) id delegate;

@property (nonatomic, strong) IBOutlet UILabel *lblErrorMsg;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl1;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl2;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl3;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl4;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl5;
@property (nonatomic, strong) IBOutlet UIView *container1;
@property (strong, nonatomic) IBOutlet UILabel *LblErrorMsg;


- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)submitButtonPressed:(id)sender;


@end
