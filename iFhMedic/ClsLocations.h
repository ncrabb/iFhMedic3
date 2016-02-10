//
//  ClsLocations.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsLocations : NSObject
{
    NSInteger locationID;
    NSString* locationName;
    NSString* locationAddress1;
    NSString* locationAddress2;
    NSString* locationCity;
    NSString* locationZip;
    NSString* locationPhone;
    NSString* locationPhone2;
    NSString* locationFax;
    NSString* locationFax2;
    NSString* locationState;
    NSInteger sortIndex;
    NSString* locationCode;
    NSInteger locationType;
    NSString* systemNumber;
    
}
@property (nonatomic) NSInteger locationID;
@property(nonatomic, strong) NSString* locationName;
@property(nonatomic, strong) NSString* locationAddress1;
@property(nonatomic, strong) NSString* locationAddress2;
@property(nonatomic, strong) NSString* locationCity;
@property(nonatomic, strong) NSString* locationZip;
@property(nonatomic, strong) NSString* locationPhone;
@property(nonatomic, strong) NSString* locationPhone2;
@property(nonatomic, strong) NSString* locationFax;
@property(nonatomic, strong) NSString* locatiohFax2;
@property(nonatomic, strong) NSString* locationState;
@property (nonatomic) NSInteger sortIndex;
@property(nonatomic, strong) NSString* locationCode;
@property (nonatomic) NSInteger locationType;
@property(nonatomic, strong) NSString* systemNumber;
@end
