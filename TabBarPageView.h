//
//  TabBarPageView.h
//  TestMem1
//
//  Created by Tony Nguyen on 01/04/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBarButton;

@interface TabBarPageView : UIView

@property (assign, nonatomic) BOOL leftArrowHidden; // dynamic
@property (assign, nonatomic) BOOL rightArrowHidden; // dynamic
@property (readonly, nonatomic) NSArray *buttons;

+ (instancetype) view;

/*!
 Add new button. After adding a button 'updateButtonsLayout' should be called.
 */
- (void) addButton:(TabBarButton*)button;

/*!
 Update buttons layout.
 */
- (void) updateButtonsLayout;


@end
