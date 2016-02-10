//
//  ClsInputs.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsInputs : NSObject
{
    NSInteger inputID;
    NSString* inputName;
    NSString* inputDefault;
    NSString* inputPage;
    NSString* inputGroup;
    NSInteger inputGroupIndex;
    NSString* inputForm;
    NSString* inputLongDesc;
    NSString* inputShortDesc;
    
    NSInteger inputDataType;
    NSString* inputAlternateLabel;
    NSString* inputAlternateDesc;
    NSInteger inputIndex;
    NSString* inputApplyRule;
    NSString* inputApplyRuleToInputs;
    NSInteger inputRequiredField;
    NSInteger inputDefaultable;
    NSInteger inputVisible;
}

@property (nonatomic) NSInteger inputID;
@property(nonatomic, strong) NSString* inputName;
@property(nonatomic, strong) NSString* inputDefault;
@property(nonatomic, strong) NSString* inputPage;
@property(nonatomic, strong) NSString* inputGroup;
@property (nonatomic) NSInteger inputGroupIndex;
@property(nonatomic, strong) NSString* inputForm;
@property(nonatomic, strong) NSString* inputLongDesc;
@property(nonatomic, strong) NSString* inputShortDesc;
@property (nonatomic) NSInteger inputDataType;
@property(nonatomic, strong) NSString* inputAlternateLabel;
@property(nonatomic, strong) NSString* inputAlternateDesc;
@property (nonatomic) NSInteger inputIndex;
@property(nonatomic, strong) NSString* inputApplyRule;
@property(nonatomic, strong) NSString* inputApplyRuleToInputs;
@property (nonatomic) NSInteger inputRequiredField;
@property (nonatomic) NSInteger inputDefaultable;
@property (nonatomic) NSInteger inputVisible;
@end
