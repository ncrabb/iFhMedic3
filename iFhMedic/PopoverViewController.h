//
//  PopoverViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/11/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissDelegate <NSObject>

-(void)didTap;

@end

@interface PopoverViewController : UIViewController
{
   __weak id <DismissDelegate> delegate;
}

@property (nonatomic) NSInteger functionSelected;
@property (nonatomic, strong) NSMutableArray* arrayUnits;
@property (nonatomic, strong) NSMutableArray* arrayUsers;
@property (nonatomic, strong) NSMutableArray *arrDrugs;
@property (nonatomic, strong) NSMutableArray *drugs;
@property (nonatomic, strong) NSMutableArray *arrays;
@property (weak) id delegate;
@property (nonatomic) NSInteger rowSelected;

- (IBAction)btnClearClick:(UIButton *)sender;

@end
