//
//  CrewInfoCell.m
//  iRescueMedic
//
//  Created by Nathan on 8/28/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "CrewInfoCell.h"

@implementation CrewInfoCell
@synthesize lblName;
@synthesize lblID;
@synthesize lblCertification;
@synthesize lblPrimary;

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
