//
//  TreatmentInfoCell.h
//  iRescueMedic
//
//  Created by admin on 3/29/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TreatmentInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTreatmentTime;
@property (strong, nonatomic) IBOutlet UILabel *lblTreatmentName;
@property (strong, nonatomic) IBOutlet UILabel *lblID;
@property (strong, nonatomic) IBOutlet UILabel *lblUnits;
@property (strong, nonatomic) IBOutlet UILabel *lblRoute;


@end
