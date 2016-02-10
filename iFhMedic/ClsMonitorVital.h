//
//  ClsMonitorVital.h
//  iRescueMedic
//
//  Created by admin on 6/22/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsMonitorVital : NSObject
{
    NSInteger monitorVitalsID;
    NSString* patientID;
    NSString* deviceTime;
    NSString* co2;
    NSString* diagtolic;
    NSString* pulseRate;
    NSString* systolic;
    NSString* respRate;
    NSString* spo2Sat;
    
    
}
@property(nonatomic, assign) NSInteger monitorVitalsID;
@property(nonatomic, strong) NSString* patientID;
@property(nonatomic, strong) NSString* deviceTime;
@property(nonatomic, strong) NSString* co2;

@property(nonatomic, strong) NSString* diagtolic;
@property(nonatomic, strong) NSString* pulseRate;
@property(nonatomic, strong) NSString* systolic;
@property(nonatomic, strong) NSString* respRate;
@property(nonatomic, strong) NSString* spo2Sat;

@end
