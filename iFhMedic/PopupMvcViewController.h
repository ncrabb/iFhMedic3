//
//  PopupMvcViewController.h
//  iRescueMedic
//
//  Created by admin on 10/16/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVCDetailsViewController.h"
#import "PopupSecondViewController.h"

@protocol DismissMvcDelegate <NSObject>

-(void)doneMvcClick;

@end

@interface PopupMvcViewController : UIViewController <DismissMvcDetailsDelegate, DismissPopupSecondDelegate>
{
    __weak id <DismissMvcDelegate> delegate;

    NSMutableArray *arrSelectedData;

}
@property (nonatomic, strong) NSMutableArray* array;
@property (weak) id delegate;
@property (nonatomic) NSInteger rowSelected;
@property (nonatomic, strong) NSMutableArray* burnType;
@property (strong, nonatomic) UIPopoverController* popover;
@property (nonatomic, strong) NSString* burnDegree;
@property (nonatomic, strong) NSMutableArray *arrRowSelected;
@property (nonatomic, strong) NSString *strSelectedData;

-(void)setDefaultData;
- (IBAction)btnDoneClick:(id)sender;


@end
