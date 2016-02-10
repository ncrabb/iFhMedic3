//
//  InputCell.m
//  iFhMedic
//
//  Created by admin on 9/7/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import "InputCell.h"

@implementation InputCell
@synthesize lblLabel;
@synthesize txtInput;
@synthesize btnInput;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
