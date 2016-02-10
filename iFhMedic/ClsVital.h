//
//  ClsVital.h
//  iRescueMedic
//
//  Created by Nathan on 7/1/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsVital : NSObject
{
    NSInteger vitalID;
    NSString* timeTaken;
    NSString* bpSys;
    NSString* bpDia;
    NSString* hr;
    NSString* rr;
    NSString* spo2;
    NSString* spco;
    NSString* etco2;
    NSString* glucose;
    NSString* temperature;
    NSString* gsc;
    NSString* position;
    NSString* ekg;
    NSString* performedBy;
    NSInteger gsc1;
    NSInteger gsc2;
    NSInteger gsc3;
    NSInteger gsc4;
    NSInteger gscTotal;
    
    NSString *cbg;
    NSString *rts;
    NSString *painScale;
    NSString *spmet;
    NSString *bpMeasure;
    NSString *emr;
    NSString *pulse;
    NSString *respEffort;
    NSString *GCSQualifier;
    NSString *level;
    NSString * stroke;
    NSString *lblSystolic;
    NSString *lblDiastolic;
    NSString *lblhr;
    NSString *lblRr;
    NSString *lblSpo2;
    NSString *lblEtc02;
    NSString *lblTemp;
    NSString* deleted;
}

@property (nonatomic) NSInteger vitalID;
@property (nonatomic, strong ) NSString* timeTaken;
@property (nonatomic, strong) NSString* bpSys;
@property (nonatomic, strong) NSString* bpDia;
@property (nonatomic, strong) NSString* hr;
@property (nonatomic, strong ) NSString* rr;
@property (nonatomic, strong) NSString* spo2;
@property (nonatomic, strong) NSString* spco;
@property (nonatomic, strong) NSString* etco2;
@property (nonatomic, strong) NSString* glucose;
@property (nonatomic, strong ) NSString* temperature;
@property (nonatomic, strong ) NSString* gsc;
@property (nonatomic, strong) NSString* position;
@property (nonatomic, strong) NSString* ekg;
@property (nonatomic, strong) NSString* performedBy;
@property (nonatomic, assign) NSInteger gsc1;
@property (nonatomic, assign) NSInteger gsc2;
@property (nonatomic, assign) NSInteger gsc3;
@property (nonatomic, assign) NSInteger gsc4;
@property (nonatomic, assign) NSInteger gscTotal;

@property (nonatomic, strong) NSString* lblSystolic;
@property (nonatomic, strong) NSString* lblDiastolic;
@property (nonatomic, strong) NSString* lblhr;
@property (nonatomic, strong) NSString* lblRr;
@property (nonatomic, strong) NSString* lblSpo2;
@property (nonatomic, strong) NSString* lblEtc02;
@property (nonatomic, strong) NSString* lblTemp;
@property (nonatomic, strong) NSString* lblGlucose;
@property (nonatomic, strong) NSString *cbg;
@property (nonatomic, strong) NSString *rts;
@property (nonatomic, strong) NSString *painScale;
@property (nonatomic, strong) NSString *spmet;
@property (nonatomic, strong) NSString *bpMeasure;
@property (nonatomic, strong) NSString *emr;
@property (nonatomic, strong) NSString *pulse;
@property (nonatomic, strong) NSString *respEffort;
@property (nonatomic, strong) NSString *GCSQualifier;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString * stroke;
@property (nonatomic, strong) NSString* deleted;
@end
