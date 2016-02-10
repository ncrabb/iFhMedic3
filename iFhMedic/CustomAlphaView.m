//
//  CustomAlphaView.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 08/05/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "CustomAlphaView.h"
#import "MedsViewController.h"
#import "TreatmentsViewController.h"

@implementation CustomAlphaView

@synthesize parent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setDefaultText
{
    for(int i=1 ; i<=26; i++)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:i];
        btn.titleLabel.font= [UIFont boldSystemFontOfSize:12.0];
    }
}

- (IBAction)btnPressed:(id)sender
{
    [self setDefaultText];
    UIButton *btn = (UIButton *)sender;
    btn.titleLabel.font= [UIFont boldSystemFontOfSize:20.0];

    [parent searchAlphaOnScroll:btn.titleLabel.text];
}

- (IBAction)btnPressed1:(id)sender
{
    [self setDefaultText];

    UIButton *btn = (UIButton *)sender;
    btn.titleLabel.font= [UIFont boldSystemFontOfSize:20.0];

    [parent searchAlphaOnScroll:btn.titleLabel.text];
}
@end
