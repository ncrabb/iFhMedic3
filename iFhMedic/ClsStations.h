//
//  ClsStations.h
//  iRescueMedic
//
//  Created by admin on 6/8/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsStations : NSObject
{
    NSInteger stationID;
    NSString* stationDescription;
    NSString* stationAddress;
    NSString* stationCity;
    NSString* stationState;
    NSString* stationZip;
    NSString* stationPhone;
    NSString* stationCode;
    
    
}
@property (nonatomic) NSInteger stationID;
@property(nonatomic, strong) NSString* stationDescription;
@property(nonatomic, strong) NSString* stationAddress;
@property(nonatomic, strong) NSString* stationCity;
@property(nonatomic, strong) NSString* stationState;
@property(nonatomic, strong) NSString* stationZip;
@property(nonatomic, strong) NSString* stationPhone;
@property(nonatomic, strong) NSString* stationCode;

@end
