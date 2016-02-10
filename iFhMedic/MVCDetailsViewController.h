//
//  MVCDetailsViewController.h
//  iRescueMedic
//
//  Created by admin on 3/30/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupMultIncidentViewController.h"
#import "PopupIncidentViewController.h"

@protocol DismissMvcDetailsDelegate <NSObject>

-(void)doneMvcDetailsClick;

@end


@interface MVCDetailsViewController : UIViewController
{
    UIImage* currentImage;
    UIPopoverController* popover;
    NSMutableArray* carArray;
    NSInteger functionSelected;
    NSInteger currentCarType;
    bool isDrawing;
    CGPoint location;
    NSMutableArray* equipmentArray;
    NSMutableArray* extricationArray;
    NSMutableArray* ejectedArray;
    NSMutableArray* deploymentArray;
    __weak id <DismissMvcDetailsDelegate> delegate;
    
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UIView *containView1;

@property (strong, nonatomic)  NSMutableArray* deploymentArray;
@property (strong, nonatomic)  NSMutableArray* indicatorArray;
@property (strong, nonatomic)  NSMutableArray* collisionArray;
@property (strong, nonatomic)  NSMutableArray* impactArray;

@property (strong, nonatomic) IBOutlet UILabel *lblMVCPosition;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *btnVehicle;
@property (strong, nonatomic) UIImage* currentImage;
@property (strong, nonatomic) UIImage* currentDrawImage;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) NSMutableArray* carArray;
@property (strong, nonatomic) IBOutlet UIButton *btnClearDraw;
@property (strong, nonatomic) IBOutlet UIButton *btnPosition;
@property (assign, nonatomic) CGPoint location;
@property (strong, nonatomic) NSMutableArray* mvcArray;
@property (strong, nonatomic) NSMutableArray* equipmentArray;
@property (strong, nonatomic) NSMutableArray* extricationArray;
@property (strong, nonatomic) NSMutableArray* ejectedArray;
@property (strong, nonatomic) IBOutlet UIButton *btnEquipment;
@property (strong, nonatomic) IBOutlet UIButton *btnExtrication;
@property (strong, nonatomic) IBOutlet UIButton *btnEject;
@property (strong, nonatomic) IBOutlet UIButton *btnDeploy;
@property (strong, nonatomic) IBOutlet UIButton *btnIndicators;
@property (strong, nonatomic) IBOutlet UIButton *btnCollision;
@property (strong, nonatomic) IBOutlet UIButton *btnImpact;


- (IBAction)btnImpactClick:(id)sender;

- (IBAction)btnCollisionClick:(id)sender;

- (IBAction)btnIndicatorClick:(id)sender;

- (IBAction)btnDeployClick:(id)sender;

- (IBAction)btnMVCClick:(id)sender;
- (IBAction)btnSafetyClick:(id)sender;
- (IBAction)btnExtricationClick:(id)sender;
- (IBAction)btnEjectClick:(id)sender;

- (IBAction)btnFreeDrawClick:(id)sender;
- (IBAction)btnClearDrawClick:(id)sender;
- (IBAction)btnVehicleClick:(id)sender;


- (IBAction)btnContinueClick:(id)sender;

@end
