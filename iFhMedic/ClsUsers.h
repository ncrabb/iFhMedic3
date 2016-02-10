//
//  ClsUsers.h
//  iRescueMedic
//
//  Created by Nathan on 6/11/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsUsers : NSObject
{
    NSInteger userID;
    NSString* userFirstName;
    NSString* userLastName;
    NSString* userAddress;
    NSInteger userCity;
    NSInteger userState;
    NSString* userZip;
    NSInteger userAge;
    NSInteger userUnit;
    NSInteger userActive;
    NSInteger userCertification;
    NSInteger userCertStart;
    NSInteger userCertEnd;
    NSString* userCertNum;
    NSString* userPassword;
    NSInteger userGroup;
    NSString* userIDNumber;
    NSString* city;
    NSString* state;
    NSString* userEmailAddress;
}

@property (nonatomic) NSInteger userID;
@property (nonatomic, strong ) NSString* userFirstName;
@property (nonatomic, strong ) NSString* userLastName;
@property (nonatomic, strong ) NSString* userAddress;
@property (nonatomic) NSInteger userCity;
@property (nonatomic) NSInteger userState;
@property (nonatomic, strong ) NSString* userZip;
@property (nonatomic) NSInteger userAge;
@property (nonatomic) NSInteger userUnit;
@property (nonatomic) NSInteger userActive;
@property (nonatomic) NSInteger userCertification;
@property (nonatomic) NSInteger userCertStart;
@property (nonatomic) NSInteger userCertEnd;
@property (nonatomic, strong ) NSString* userCertNum;
@property (nonatomic, strong ) NSString* userPassword;
@property (nonatomic) NSInteger userGroup;
@property (nonatomic, strong ) NSString* userIDNumber;
@property (nonatomic, strong ) NSString* city;
@property (nonatomic, strong ) NSString* state;
@property (nonatomic, strong ) NSString* userEmailAddress;

@end
