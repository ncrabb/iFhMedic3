//
//  TabBarPageView.m
//  TestMem1
//
//  Created by Tony Nguyen on 01/04/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import "TabBarPageView.h"
#import "TabBarButton.h"

@interface TabBarPageView()

@property (weak, nonatomic) IBOutlet UIImageView *leftArrowView;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowView;

@end

@implementation TabBarPageView
{
    NSMutableArray *_buttons;
}

+ (instancetype) view
{
    return [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil][0];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if ( self )
    {
        _buttons = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) addButton:(TabBarButton *)button
{
    [_buttons addObject:button];
    [self addSubview:button];
}


- (void) updateButtonsLayout
{
    if ( _buttons.count )
    {
        CGRect buttonFrame = CGRectMake(0.0f, 0.0f, self.bounds.size.width / _buttons.count, self.bounds.size.height);
        for ( TabBarButton *button in _buttons )
        {
            button.frame = buttonFrame;
            [button setNeedsLayout];
            buttonFrame.origin.x += buttonFrame.size.width;
        }
    }
}


#pragma mark - get/set

- (void) setFrame:(CGRect)frame
{
    const BOOL needsUpdateLayout = !CGSizeEqualToSize(self.frame.size, frame.size);
    
    [super setFrame:frame];
    
    if ( needsUpdateLayout )
    {
        [self updateButtonsLayout];
    }
}

- (void) setLeftArrowHidden:(BOOL)leftArrowHidden
{
    _leftArrowHidden = leftArrowHidden;
    _leftArrowView.hidden = leftArrowHidden;
}

- (void) setRightArrowHidden:(BOOL)rightArrowHidden
{
    _rightArrowHidden = rightArrowHidden;
    _rightArrowView.hidden = rightArrowHidden;
}

@end
