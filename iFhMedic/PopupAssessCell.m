//
//  PopupAssessCell.m
//  iFhMedic
//
//  Created by admin on 1/9/16.
//  Copyright © 2016 com.emergidata. All rights reserved.
//

#import "PopupAssessCell.h"

@implementation PopupAssessCell
@synthesize lblLabel;
@synthesize imageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
