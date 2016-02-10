//
//  PopupInjuryTypeViewController.h
//  iRescueMedic
//
//  Created by Nathan on 8/27/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupIncidentViewController.h"

@protocol DismissInjuryTypeDelegate <NSObject>

-(void)doneSelected;

@end

@interface PopupInjuryTypeViewController : UIViewController <DismissIncidentDelegate>
{
    __weak id <DismissInjuryTypeDelegate> delegate;
}

@property (strong, nonatomic) UIPopoverController* popover;
@property (nonatomic, strong) NSMutableArray* array;
@property (weak) id delegate;
@property (nonatomic) NSInteger rowSelected;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic, strong) NSString* area;
@property (nonatomic, strong) NSMutableArray* burnType;
@property (nonatomic, assign) NSString* burnDegree;
@end
