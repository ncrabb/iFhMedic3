//
//  Keypad.h
//  iRescueMedic
//
//  Created by admin on 1/28/16.
//  Copyright © 2016 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissPadDelegate
- (void) doneButtonTapped: (NSInteger) ASCIICode withTarget: target;
@end

@interface Keypad : UIView
{
    __weak id<DismissPadDelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UIView *view;
@property(nonatomic, assign) UITextField* target;
@property (nonatomic, weak) id<DismissPadDelegate> delegate;

- (IBAction)btnKey_click:(UIButton*)sender;

@end


