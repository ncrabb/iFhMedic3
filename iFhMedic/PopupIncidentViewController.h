//
//  PopupIncidentViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/19/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissIncidentDelegate <NSObject>

-(void)didTap;

@end

@interface PopupIncidentViewController : UIViewController 
{
     __weak id <DismissIncidentDelegate> delegate;
}


@property (nonatomic, strong) NSMutableArray* array;
@property (weak) id delegate;
@property (nonatomic) NSInteger rowSelected;
@property (nonatomic, strong) NSMutableArray *arrRowSelected;

- (IBAction)btnClearClick:(UIButton *)sender;
@end
