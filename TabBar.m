//
//  TabBar.m
//  TestMem1
//
//  Created by Tony Nguyen on 08/04/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import "TabBar.h"
#import "TabBarPageView.h"
#import "TabBarButton.h"

@interface ScrollView : UIScrollView
{
    NSMutableArray *_pages;
}

@end

@implementation ScrollView

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if ( self )
    {
        _pages = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) addSubview:(UIView *)view
{
    [super addSubview:view];
    if ( [view isKindOfClass:[TabBarPageView class]] )
    {
        [_pages addObject:view];
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    CGRect pageFrame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
    for ( TabBarPageView *page in _pages )
    {
        page.frame = pageFrame;
        pageFrame.origin.x += pageFrame.size.width;
    }
    
    [self updateContentSize];
}

- (void) updateContentSize
{
    [self setContentSize:CGSizeMake(self.bounds.size.width * _pages.count, self.bounds.size.height)];
}

@end

@interface TabBar()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet ScrollView *scrollView;

@end

@implementation TabBar
{
    UIView *_contentView;
    
    NSMutableArray *_buttons;
    NSMutableArray *_pages;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if ( self )
    {

        _contentView = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil][0];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_contentView];
        
        _buttons = [[NSMutableArray alloc] init];
        _pages = [[NSMutableArray alloc] init];
        
        
        NSDictionary *view = @{@"contentView" : _contentView};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[contentView]-0-|" options:0 metrics:nil views:view]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[contentView]-0-|" options:0 metrics:nil views:view]];
        
    }
    
    return self;
}


- (void) rightarrowPressed
{
    CGPoint pont = _scrollView.contentOffset;
    pont.x+= 1024;
    _scrollView.contentOffset = pont;
}

- (void) leftarrowPressed
{
    CGPoint pont = _scrollView.contentOffset;
    pont.x-= 1024;
    _scrollView.contentOffset = pont;
}

- (void) addButtonsWithArray:(NSArray*)buttons
{
    NSMutableArray *buttonsArray = [NSMutableArray arrayWithArray:buttons];
    for ( TabBarPageView *pageView in _pages )
    {
        while ( pageView.buttons.count < _buttonsOnPage && buttonsArray.count )
        {
            TabBarButton *button = [buttonsArray objectAtIndex:0U];
            [button addTarget:self action:@selector(_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [buttonsArray removeObjectAtIndex:0U];
            [pageView addButton:button];
            [_buttons addObject:button];
        }
        
        [pageView updateButtonsLayout];
    }
    
    TabBarPageView *newPage = nil;
    while ( buttonsArray.count )
    {
        if ( !newPage )
        {
            newPage = [TabBarPageView view];
            newPage.frame = CGRectMake(_pages.count * _scrollView.bounds.size.width, 0.0f, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
            [_pages addObject:newPage];
            [_scrollView addSubview:newPage];
        }
        
        TabBarButton *button = [buttonsArray objectAtIndex:0U];
        [button addTarget:self action:@selector(_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsArray removeObjectAtIndex:0U];
        [newPage addButton:button];
        [_buttons addObject:button];
        
        if ( newPage.buttons.count >= _buttonsOnPage )
        {
            [newPage updateButtonsLayout];
            newPage = nil;
        }
    }
    
    for ( TabBarPageView *page in _pages )
    {
        page.leftArrowHidden = page == _pages.firstObject;
        page.rightArrowHidden = page == _pages.lastObject;
    }
    
    [newPage updateButtonsLayout];
    [_scrollView updateContentSize];
    
    UIButton *rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setImage:[UIImage imageNamed:@"bottom_right_arrow.png"] forState:UIControlStateNormal];
    rightButton1.frame = CGRectMake(1004, 0, 20, self.frame.size.height);
    rightButton1.tag = 2;
    [rightButton1 addTarget:self action:@selector(rightarrowPressed) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:rightButton1];
    rightButton1 = nil;
    
    UIButton *leftButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton1 setImage:[UIImage imageNamed:@"bottom_left_arrow.png"] forState:UIControlStateNormal];
    leftButton1.frame = CGRectMake(1024, 0, 20, self.frame.size.height);
    leftButton1.tag = 1;
    [leftButton1 addTarget:self action:@selector(leftarrowPressed) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:leftButton1];
    leftButton1 = nil;
}

- (void) setSelectedButtonAtIndex:(NSInteger)index
{
    NSInteger buttonIndex = 0;
    for ( TabBarButton *button in _buttons )
    {
        [button setSelected:buttonIndex++ == index];
    }
}

- (TabBarButton*) buttonAtIndex:(NSInteger)index
{
    TabBarButton *button = nil;
    
    if ( index >= 0 && index < _buttons.count )
    {
        button = [_buttons objectAtIndex:index];
    }
    
    return button;
}

#pragma mark - get/set

#pragma mark - private(actions)

- (void) _buttonAction:(TabBarButton*)sender
{
    NSInteger buttonIndex = [_buttons indexOfObject:sender];
    
    [_delegate tabBar:self didSelectButtonAtIndex:buttonIndex];
    [self setSelectedButtonAtIndex:buttonIndex];
}

@end
