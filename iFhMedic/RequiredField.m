//
//  RequiredField.m
//  iRescueMedic
//
//  Created by admin on 5/17/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "RequiredField.h"

@implementation RequiredField
@synthesize lblField;
@synthesize lblPage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
