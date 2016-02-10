//
//  ClsCustomFormInputs.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsCustomFormInputs : NSObject
{
    NSInteger formID;
    NSInteger inputID;
    NSString* inputName;
    NSString* inputDescription;
    NSInteger inputDataType;
    NSString* inputGroup;
    NSInteger inputRequired;
    NSInteger inputIndex;
    NSInteger active;
    
}
@property (nonatomic) NSInteger formID;
@property (nonatomic) NSInteger inputID;
@property(nonatomic, strong) NSString* inputName;
@property(nonatomic, strong) NSString* inputDescription;
@property (nonatomic) NSInteger inputDataType;
@property(nonatomic, strong) NSString* inputGroup;
@property (nonatomic) NSInteger inputRequired;
@property (nonatomic) NSInteger inputIndex;
@property (nonatomic) NSInteger active;
@end
