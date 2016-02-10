//
//  PopoverPasswordControllerViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/11/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissPasswordDelegate <NSObject>

-(void)didClickOK;

@end

@interface PopoverPasswordControllerViewController : UIViewController
{
   __weak id <DismissPasswordDelegate> delegate;
}

@property (weak) id delegate;

- (IBAction)OkClick:(id)sender;

@end
