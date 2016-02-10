//
//  AssessmentCell.h
//  iFhMedic
//
//  Created by admin on 1/5/16.
//  Copyright © 2016 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssessmentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblSkin;
@property (strong, nonatomic) IBOutlet UILabel *lblhead;
@property (strong, nonatomic) IBOutlet UILabel *lblNeck;
@property (strong, nonatomic) IBOutlet UILabel *lblChest;
@property (strong, nonatomic) IBOutlet UILabel *lblLeft;
@property (strong, nonatomic) IBOutlet UILabel *lblRight;

@end
