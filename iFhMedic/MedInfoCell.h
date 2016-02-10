//
//  MedInfoCell.h
//  iRescueMedic
//
//  Created by Nathan on 7/8/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblDrugName;

@property (strong, nonatomic) IBOutlet UILabel *lblDosage;
@property (strong, nonatomic) IBOutlet UILabel *lblFreq;

@end
