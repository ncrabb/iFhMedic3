//
//  PopoverMultiPatientRefusalViewController.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 11/06/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissMultiRefusalDelegate <NSObject>

-(void) cancelMultiRefusal;
-(void) submitMultiRefusal;

@end


@interface PopoverMultiPatientRefusalViewController : UIViewController
{
    __weak id  <DismissMultiRefusalDelegate> delegate;

}

@property (weak) id delegate;

@property (nonatomic, strong) IBOutlet UILabel *lblErrorMsg;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl1;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl2;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl3;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl4;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segControl5;
@property (nonatomic, strong) IBOutlet UIView *container1;


- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)btnSeg1Click:(id)sender;
- (IBAction)btnSeg2Click:(id)sender;
- (IBAction)btnSeg3Click:(id)sender;
- (IBAction)btnSeg4Click:(id)sender;
- (IBAction)viewSignatureClick:(id)sender;


@end
