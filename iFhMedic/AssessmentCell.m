//
//  AssessmentCell.m
//  iFhMedic
//
//  Created by admin on 1/5/16.
//  Copyright © 2016 com.emergidata. All rights reserved.
//

#import "AssessmentCell.h"

@implementation AssessmentCell
@synthesize lblChest;
@synthesize lblhead;
@synthesize lblLeft;
@synthesize lblNeck;
@synthesize lblRight;
@synthesize lblSkin;
@synthesize lblTime;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
