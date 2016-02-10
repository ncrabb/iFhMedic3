//
//  TicketDataInfoCell.h
//  iRescueMedic
//
//  Created by Nathan on 6/21/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketDataInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *incidentNumber;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *unit;
@property (strong, nonatomic) IBOutlet UILabel *incidentDate;

@end
