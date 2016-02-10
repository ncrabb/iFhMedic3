//
//  ClsVitals.h
//  iRescueMedic
//
//  Created by admin on 6/8/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsVitals : NSObject
{
    NSInteger inputID;
    NSString* inputDesc;
    NSString* vitalName;
    NSInteger vitalRequired;
    NSInteger vitalVisible;
    NSInteger vitalDataType;
    NSInteger detailsID;
    NSString* detailsName;
    NSString* detailsButtons;
    NSInteger vitalsIndex;
    NSString* vitalsGroup;
    
}
@property (nonatomic) NSInteger inputID;
@property(nonatomic, strong) NSString* inputDesc;
@property(nonatomic, strong) NSString* vitalName;
@property (nonatomic) NSInteger vitalRequired;
@property (nonatomic) NSInteger vitalVisible;
@property (nonatomic) NSInteger vitalDataType;
@property (nonatomic) NSInteger detailsID;
@property(nonatomic, strong) NSString* detailsName;
@property(nonatomic, strong) NSString* detailsButtons;
@property (nonatomic) NSInteger vitalsIndex;
@property(nonatomic, strong) NSString* vitalsGroup;
@end
