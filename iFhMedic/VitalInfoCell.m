//
//  VitalInfoCell.m
//  iRescueMedic
//
//  Created by Nathan on 7/1/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "VitalInfoCell.h"

@implementation VitalInfoCell
@synthesize lblBPDia;
@synthesize lblBPSys;
@synthesize lblETCO2;
@synthesize lblGlucose;
@synthesize lblHR;
@synthesize lblPosition;
@synthesize lblRR;
@synthesize lblSPO2;
@synthesize lblTemperature;
@synthesize lblTimeTaken;
@synthesize lblGsc1;
@synthesize lblGsc2;
@synthesize lblGsc3;
@synthesize lblGsc4;
@synthesize lblGscTotal;
@synthesize lblSpco;


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
