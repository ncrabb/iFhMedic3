//
//  OrangeButton.m
//  iRescueMedic
//
//  Created by Nathan on 6/27/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 
#import "OrangeButton.h"

@implementation OrangeButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self runSetup];

    }
    return self;
}


- (id)initWithCoder:(NSCoder*)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self runSetup];
    }
    return self;
}

// Balraj for changing color of orange buttons

//-(void)runSetup
//{
//    [[self titleLabel] setFont:[UIFont fontWithName:@"ZegoeUI" size:18]];
//    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    if(self.state == UIControlStateHighlighted) {
//        [self setBackgroundColor:[UIColor greenColor]];
//    }
//    else {
//        [self setBackgroundColor:[UIColor orangeColor]];
//    }
//    self.layer.borderColor = [UIColor blackColor].CGColor;
//    self.layer.borderWidth = 0.5f;
//    self.layer.cornerRadius = 10.0f;
//    [self.layer setCornerRadius:10.0f];
//}

-(void)runSetup
{
    
    [[self titleLabel] setFont:[UIFont fontWithName:@"ZegoeUI" size:18]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if(self.state == UIControlStateHighlighted) {
        [self setBackgroundColor:[UIColor greenColor]];
    }
    else {
        CGRect frame = self.frame;
        if(frame.size.height>=70) {
            [self setBackgroundImage:[UIImage imageNamed:@"btn_background_Big.png"] forState:UIControlStateNormal];
        }
        else {
            [self setBackgroundImage:[UIImage imageNamed:@"btn_background_Big.png"] forState:UIControlStateNormal]; // btn_background.png
        }
        
    }
    // NSLog(@"%@", NSStringFromCGRect(self.frame));
    CGRect frame = self.frame;
    if(frame.size.width>=160)
    {
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = 10.0f;
        [self.layer setCornerRadius:10.0f];}
    else
    {
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = 5.0f;
        [self.layer setCornerRadius:5.0f];
    }
}
// Balraj for changing color of orange buttons


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// Balraj for changing color of orange buttons

//-(void) setHighlighted:(BOOL)highlighted {
//    
//
//    self.backgroundColor = [UIColor orangeColor];
//
//    [super setHighlighted:highlighted];
//}
//
//-(void) setSelected:(BOOL)selected {
//    
//    self.backgroundColor = [UIColor greenColor];
//    [super setSelected:selected];
//}

-(void) setHighlighted:(BOOL)highlighted {
    
    
    //self.backgroundColor = [UIColor orangeColor];
    [self setBackgroundImage:[UIImage imageNamed:@"btn_background_Big.png"] forState:UIControlStateNormal]; // btn_background.png
    
    [super setHighlighted:highlighted];
}

-(void) setSelected:(BOOL)selected {
    
    self.backgroundColor = [UIColor greenColor];
    [super setSelected:selected];
}

// Balraj for changing color of orange buttons

@end
