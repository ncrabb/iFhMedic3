//
//  Keypad.m
//  iRescueMedic
//
//  Created by admin on 1/28/16.
//  Copyright © 2016 Emergidata. All rights reserved.
//

#import "Keypad.h"

@implementation Keypad
@synthesize delegate;
@synthesize target;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"Keypad" owner:self options:nil];
        self.bounds = self.view.bounds;
        
        [self addSubview:self.view];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"Keypad" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}


- (IBAction)btnKey_click:(UIButton*)sender {
    
    if (delegate != nil)
    {
        [delegate doneButtonTapped:[sender tag] withTarget: target];
    }
}
@end
