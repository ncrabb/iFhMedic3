//
//  SignatureTableViewCell.h
//  iRescueMedic
//
//  Created by admin on 12/28/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress1;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress2;
@property (strong, nonatomic) IBOutlet UILabel *lblPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblDob;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;


@end
