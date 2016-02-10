//
//  PopupDataViewController.h
//  iRescueMedic
//
//  Created by admin on 9/5/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissDataViewDelegate <NSObject>

-(void)doneDataViewClick;

@end


@interface PopupDataViewController : UIViewController
{
    __weak id <DismissDataViewDelegate> delegate;
}
@property (nonatomic, strong) NSMutableArray* array;
@property (strong, nonatomic) IBOutlet UITextField *txtDisplay;
@property (weak) id delegate;
- (IBAction)btnContinueClick:(id)sender;


@end
