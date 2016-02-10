//
//  CustomSignatureView.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 10/03/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "CustomSignatureView.h"
#import "SignatureViewController.h"

@implementation CustomSignatureView

@synthesize lblTitle;
@synthesize signImage;
@synthesize parent;
@synthesize btnSign;
@synthesize selected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        selected = false;
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


- (IBAction)ButtonClicked:(id)sender
{
    [(SignatureViewController *)parent signatureButtonPressed:self];
}

- (void)setImage:(UIImage*)image
{
    signImage.image = image;
    CGRect frame = lblTitle.frame;
    frame.origin.y = 96;
    lblTitle.frame = frame;
    selected = true;
   // btnSign.enabled = false;
}

- (void)clearImage
{
    signImage.image = nil;
    CGRect frame = lblTitle.frame;
    frame.origin.y = 51;
    lblTitle.frame = frame;
    selected = false;
    // btnSign.enabled = false;
}
@end
