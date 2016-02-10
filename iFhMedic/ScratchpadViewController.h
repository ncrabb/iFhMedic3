//
//  ScratchpadViewController.h
//  iRescueMedic
//
//  Created by admin on 5/2/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScribbleView.h"

@protocol DismissScratchpadDelegate <NSObject>

-(void)doneScratchpad;
-(void)caenelScratchpad;

@end

@interface ScratchpadViewController : UIViewController
{
    BOOL     needToSave;
    __weak id <DismissScratchpadDelegate> delegate;
    UIView* containerView;
}
@property (nonatomic, retain) IBOutlet ScribbleView *signView;
@property (weak) id delegate;

- (IBAction)btnSave:(id)sender;
- (IBAction)btnCancel:(id)sender;


@end
