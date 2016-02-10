//
//  SummaryInfoCell.m
//  iRescueMedic
//
//  Created by admin on 3/29/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "SummaryInfoCell.h"

@implementation SummaryInfoCell
@synthesize lblTime;
@synthesize lblType;
@synthesize lblDesc;


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
