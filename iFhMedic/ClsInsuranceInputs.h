//
//  ClsInsuranceInputs.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsInsuranceInputs : NSObject
{
    NSInteger insID;
    NSInteger inputID;
    NSString* inputName;
    NSString* inputAltName;
    NSInteger inputIndex;
    NSInteger inputDataType;
    NSInteger active;
    
}
@property (nonatomic) NSInteger insID;
@property (nonatomic) NSInteger inputID;
@property(nonatomic, strong) NSString* inputName;
@property(nonatomic, strong) NSString* inputAltName;
@property (nonatomic) NSInteger inputIndex;
@property (nonatomic) NSInteger inputDataType;
@property (nonatomic) NSInteger active;

@end
