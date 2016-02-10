//
//  ClsUnit.h
//  iRescueMedic
//
//  Created by Nathan on 6/10/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsUnits : NSObject
{
    NSInteger unitID;
    NSString* unitDescription;
    NSInteger stationID;
    NSString* regionID;
    NSString* unitType;
    NSInteger vehicleType;
    NSInteger cadDispatchable;
    NSString* cadUnitDescription;
    NSInteger interAgency;
    NSString* vehicleNumber;
    NSInteger active;
    
}

@property (nonatomic) NSInteger unitID;
@property (nonatomic, strong ) NSString* unitDescription;
@property (nonatomic) NSInteger stationID;
@property (nonatomic, strong ) NSString* regionID;
@property (nonatomic, strong ) NSString* unitType;
@property (nonatomic) NSInteger vehicleType;
@property (nonatomic) NSInteger cadDispatchable;
@property (nonatomic, strong ) NSString* cadUnitDescription;
@property (nonatomic) NSInteger interAgency;
@property (nonatomic, strong ) NSString* vehicleNumber;
@property (nonatomic) NSInteger active;

@end  

