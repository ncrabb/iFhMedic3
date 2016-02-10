//
//  YelloButton.m
//  iRescueMedic
//
//  Created by Nathan on 6/27/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 
#import "YelloButton.h"

@implementation YelloButton

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

-(void)runSetup
{
    [[self titleLabel] setFont:[UIFont fontWithName:@"ZegoeUI" size:18]];
    self.titleLabel.adjustsFontSizeToFitWidth =YES ;

    
    if(self.state == UIControlStateHighlighted) {
      //  [self setBackgroundColor:[UIColor colorWithRed:(251.0/255.0) green:(254.0/255.0) blue:(195.0/255.0) alpha:1]];
    }
    else {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 10.0f;
    [self.layer setCornerRadius:10.0f];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void) setHighlighted:(BOOL)highlighted {
    
    
   // self.backgroundColor = [UIColor colorWithRed:(251.0/255.0) green:(254.0/255.0) blue:(195.0/255.0) alpha:1];
    
    [super setHighlighted:highlighted];
}

-(void) setSelected:(BOOL)selected {
    if (selected) {
    //  self.backgroundColor = [UIColor colorWithRed:(251.0/255.0) green:(254.0/255.0) blue:(195.0/255.0) alpha:1];
    }
    else {
      self.backgroundColor = [UIColor whiteColor];
    }
    
    [super setSelected:selected];
}


@end
