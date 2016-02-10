//
//  ClsTreatmentInputs.h
//  iRescueMedic
//
//  Created by admin on 6/8/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsTreatmentInputs : NSObject <NSCopying>
{
    NSInteger treatmentID;
    NSInteger inputID;
    NSString* inputName;
    NSString* inputValue;

    NSInteger inputIndex;
    NSInteger inputDataType;
    NSInteger active;
    NSInteger inputRequired;
    
}
@property (nonatomic) NSInteger treatmentID;
@property (nonatomic) NSInteger inputID;
@property(nonatomic, strong) NSString* inputName;
@property(nonatomic, strong) NSString* inputValue;

@property (nonatomic) NSInteger inputIndex;
@property (nonatomic) NSInteger inputDataType;
@property (nonatomic) NSInteger active;
@property (nonatomic) NSInteger inputRequired;

-(id)copyWithZone:(NSZone *)zone;
@end
