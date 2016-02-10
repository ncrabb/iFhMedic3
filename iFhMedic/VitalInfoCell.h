//
//  VitalInfoCell.h
//  iRescueMedic
//
//  Created by Nathan on 7/1/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VitalInfoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTimeTaken;
@property (strong, nonatomic) IBOutlet UILabel *lblBPSys;
@property (strong, nonatomic) IBOutlet UILabel *lblBPDia;
@property (strong, nonatomic) IBOutlet UILabel *lblHR;
@property (strong, nonatomic) IBOutlet UILabel *lblRR;
@property (strong, nonatomic) IBOutlet UILabel *lblSPO2;
@property (strong, nonatomic) IBOutlet UILabel *lblETCO2;
@property (strong, nonatomic) IBOutlet UILabel *lblGlucose;
@property (strong, nonatomic) IBOutlet UILabel *lblTemperature;
@property (strong, nonatomic) IBOutlet UILabel *lblPosition;
@property (strong, nonatomic) IBOutlet UILabel *lblSpco;
@property (strong, nonatomic) IBOutlet UILabel *lblGsc1;
@property (strong, nonatomic) IBOutlet UILabel *lblGsc2;
@property (strong, nonatomic) IBOutlet UILabel *lblGsc3;
@property (strong, nonatomic) IBOutlet UILabel *lblGsc4;
@property (strong, nonatomic) IBOutlet UILabel *lblGscTotal;



@end
