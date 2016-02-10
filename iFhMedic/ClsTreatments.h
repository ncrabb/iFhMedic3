//
//  ClsTreatments.h
//  iRescueMedic
//
//  Created by Nathan on 8/15/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsTreatments : NSObject

@property (nonatomic) NSInteger treatmentID;
@property (nonatomic, strong ) NSString* treatmentDesc;
@property (nonatomic) NSInteger treatmentFilter;
@property (nonatomic) NSInteger Active;
@property (nonatomic) NSInteger SortIndex;
@property (nonatomic) bool existing;
@property (nonatomic, strong) NSString *treatmentTime;
@property (nonatomic, strong) NSString *drugName;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *dose;
@property (nonatomic, strong) NSString *route;

@property (nonatomic, strong) NSString *performedBy;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *attempts;
@property (nonatomic, strong) NSString *successful;
@property (nonatomic, strong) NSString *complications;
@property (nonatomic, strong) NSString *response;
@property (nonatomic, strong) NSString *arrival;
@property (nonatomic, strong) NSMutableArray *arrayTreatmentInputValues;
@property (nonatomic) NSInteger instance;
@end
