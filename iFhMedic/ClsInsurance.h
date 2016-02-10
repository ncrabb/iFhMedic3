//
//  ClsInsurance.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsInsurance : NSObject
{
    NSInteger insuranceID;
    NSString* insuranceName;
    NSString* insuranceAddress;
    NSString* InsurancePhone;
    NSString* insuranceCode;
    NSString* insuranceType;
    
}
@property (nonatomic) NSInteger insuranceID;
@property(nonatomic, strong) NSString* insuranceName;
@property(nonatomic, strong) NSString* insuranceAddress;
@property(nonatomic, strong) NSString* insurancePhone;
@property(nonatomic, strong) NSString* insuranceCode;
@property(nonatomic, strong) NSString* insuranceType;
@end
