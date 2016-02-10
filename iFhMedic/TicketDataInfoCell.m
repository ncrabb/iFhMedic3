//
//  TicketDataInfoCell.m
//  iRescueMedic
//
//  Created by Nathan on 6/21/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "TicketDataInfoCell.h"

@implementation TicketDataInfoCell
@synthesize image;
@synthesize incidentNumber;
@synthesize address;
@synthesize unit;
@synthesize incidentDate;


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
