//
//  CustomCrewViewController.h
//  iRescueMedic
//
//  Created by admin on 6/24/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DismissCustomCrewDelegate <NSObject>

-(void)doneCustomCrew;

@end

@interface CustomCrewViewController : UIViewController
{
    __weak id <DismissCustomCrewDelegate> delegate;
    int buttonSelect;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;


@property (strong, nonatomic) IBOutlet UITextField *txtId;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (assign) bool save;
@property (assign) int buttonSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnStudentSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnRideAlongSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnPoliceSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnFirefighterSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnPreceptSelect;
@property (strong, nonatomic) NSString* cert;

- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSave:(id)sender;
- (IBAction)btnStudent:(id)sender;
- (IBAction)btnRideAlong:(id)sender;
- (IBAction)btnPolice:(id)sender;
- (IBAction)btnFireFighter:(id)sender;
- (IBAction)btnPrecept:(id)sender;




@end
