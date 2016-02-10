//
//  ClsInsuranceInputLookup.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsInsuranceInputLookup : NSObject
{
    NSInteger insID;
    NSInteger inputID;
    NSInteger inputLookupID;
    NSString* lookupName;
    NSInteger active;
    NSString* code;
    
}
@property (nonatomic) NSInteger insID;
@property (nonatomic) NSInteger inputID;
@property (nonatomic) NSInteger inputLookupID;
@property(nonatomic, strong) NSString* lookupName;
@property (nonatomic) NSInteger active;
@property(nonatomic, strong) NSString* code;

@end
