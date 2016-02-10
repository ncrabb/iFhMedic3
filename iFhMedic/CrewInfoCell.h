//
//  CrewInfoCell.h
//  iRescueMedic
//
//  Created by Nathan on 8/28/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrewInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblID;
@property (strong, nonatomic) IBOutlet UILabel *lblCertification;
@property (strong, nonatomic) IBOutlet UILabel *lblPrimary;


@end
