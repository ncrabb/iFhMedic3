//
//  TabBar.h
//  TestMem1
//
//  Created by Tony Nguyen on 08/04/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TabBar;
@class TabBarButton;

@protocol TabBarDelegate <NSObject>

- (void) tabBar:(TabBar*)tabBar didSelectButtonAtIndex:(NSInteger)index;

@end

@interface TabBar : UIView

@property (weak, nonatomic) id<TabBarDelegate> delegate;

/*!
 Array of buttons.
 */
@property (readonly, nonatomic) NSArray *buttons;

/*!
 Number of TabBarButton in one page. Doesn't effect if buttons already added.
 */
@property (assign, nonatomic) NSInteger buttonsOnPage;

/*!
 Add new buttons.
 */
- (void) addButtonsWithArray:(NSArray*)buttons;

/*!
 Select button with given index. Doesn't call delegate 'selection' method.
 */
- (void) setSelectedButtonAtIndex:(NSInteger)index;

/*!
 @result
 Return button with given index. Nil if there is no button with such index.
 */
- (TabBarButton*) buttonAtIndex:(NSInteger)index;

@end
