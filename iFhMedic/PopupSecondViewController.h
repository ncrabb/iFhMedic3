//
//  PopupSecondViewController.h
//  iRescueMedic
//
//  Created by admin on 4/21/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverViewController.h"

@protocol DismissPopupSecondDelegate <NSObject>

-(void) doneSecondDelegate;

@end


@interface PopupSecondViewController : UIViewController
{
    __weak id <DismissPopupSecondDelegate> delegate;
}

@property (nonatomic) NSInteger functionSelected;
@property (strong, nonatomic) UIPopoverController* popover;
@property (nonatomic, strong) NSMutableArray *arrays;
@property (weak) id delegate;
@property (nonatomic) NSInteger rowSelected;
@property (nonatomic, strong) NSMutableArray *burnType;
@property (nonatomic, strong) NSString *selectedValue;
@end
