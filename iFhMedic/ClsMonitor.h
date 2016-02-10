//
//  ClsMonitor.h
//  iRescueMedic
//
//  Created by admin on 6/21/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsMonitor : NSObject
{
    NSString* monitorID;
    NSString* patientID;
    NSString* incidentID;
    NSString* deviceTime;
    NSString* vendor;
}

@property(nonatomic, strong) NSString* monitorID;
@property(nonatomic, strong) NSString* patientID;
@property(nonatomic, strong) NSString* incidentID;
@property(nonatomic, strong) NSString* deviceTime;
@property(nonatomic, strong) NSString* vendor;
@end
