//
//  ClsCallTimes.h
//  iRescueMedic
//
//  Created by Nathan on 7/1/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsCallTimes : NSObject
{
    NSString* dispatched;
    NSString* enRoute;
    NSString* atScene;
    NSString* atPatient;
    NSString* departScene;
    NSString* arriveDest;
    NSString* transferCare;
    NSString* unitCare;
    NSString* incidentType;
    NSString* alarmType;
    NSString* aid;
    NSString* propertyUse;
    NSString* actionTaken;
    NSString* milBeg;
    NSString* milAtScene;
    NSString* milAtDest;
    NSString* milEnd;
    NSString* milLoaded;
    NSString* TotalMil;


}

@property (nonatomic, strong ) NSString* dispatched;
@property (nonatomic, strong) NSString* enRoute;
@property (nonatomic, strong) NSString* atScene;
@property (nonatomic, strong) NSString* atPatient;
@property (nonatomic, strong ) NSString* departScene;
@property (nonatomic, strong) NSString* arriveDest;
@property (nonatomic, strong) NSString *transferCare;
@property (nonatomic, strong) NSString* unitCare;
@property (nonatomic, strong) NSString* incidentType;
@property (nonatomic, strong) NSString* alarmType;
@property (nonatomic, strong ) NSString* aid;
@property (nonatomic, strong ) NSString* propertyUse;
@property (nonatomic, strong) NSString* actionTaken;
@property (nonatomic, strong) NSString* milBeg;
@property (nonatomic, strong) NSString* milAtScene;
@property (nonatomic, strong) NSString* milAtDest;
@property (nonatomic, strong) NSString* milEnd;
@property (nonatomic, strong) NSString* milLoaded;
@property (nonatomic, strong) NSString* TotalMil;


@end
