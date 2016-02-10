//
//  SceneViewController.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 03/03/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//  Scene

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ValidateViewController.h"
#import "InputView.h"

@protocol DismissSceneDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
-(void)setTabsRequired:(NSMutableArray*) tabArray;

@end

@interface SceneViewController : UIViewController<UITextFieldDelegate, DismissValidateControl, DismissInputViewDelegate>

{
    __weak id <DismissSceneDelegate> delegate;
    NSInteger functionSelected;
    BOOL isCurrentLocation;
    bool manualPress;
}


@property (assign, nonatomic) CLLocationCoordinate2D currentLocation;
@property (strong, nonatomic) NSMutableArray*  incidentInput;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;

@property (weak) id delegate;


@property (strong, nonatomic) UIPopoverController* popover;


@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;


@property (strong, nonatomic) IBOutlet MKMapView *mapView;


@property (strong, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (strong, nonatomic) IBOutlet UIView *page2Container;
@property (strong, nonatomic) IBOutlet UISegmentedControl *SegmentControl;
@property (strong, nonatomic) IBOutlet UIView *page2Container1;
@property (strong, nonatomic) IBOutlet UIView *page2Container2;

@property (strong, nonatomic)  NSMutableDictionary* ticketInputData;
@property (strong, nonatomic) IBOutlet UIButton *btnDOS;


@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;

@property (strong, nonatomic) IBOutlet UIView *inputContainer;


@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;


- (IBAction)btnMainMenuClick:(id)sender;


- (IBAction)btnCurrentLocationPressed:(id)sender;

- (IBAction)btnValidateClick:(id)sender;

- (IBAction)btnQAMessageClick:(UIButton *)sender;

- (IBAction)btnPageControlClick:(id)sender;
-(void)viewWillDisappear:(BOOL)animated;
- (IBAction)btnRightClick:(id)sender;

- (IBAction)btnLeftClick:(id)sender;


@end
