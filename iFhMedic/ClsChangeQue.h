//
//  ClsChangeQue.h
//  iRescueMedic
//
//  Created by Nathan on 6/17/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsChangeQue : NSObject
{
    NSInteger changeID;
    NSString* tableName;
    NSInteger localTicketID;
    
    NSInteger ticketID;
    NSString* ticketGUID;
    NSInteger iDX1;
    NSInteger iDX2;
    NSInteger iDX3;
    
    NSString* fieldName;
    NSString* value;
    
    NSInteger inputInstance;
    NSInteger inputSubID;
    NSString* inputPage;
    NSString* del;
    NSString* dataModified;
}

@property (nonatomic) NSInteger changeID;
@property (nonatomic, strong ) NSString* tableName;
@property (nonatomic) NSInteger localTicketID;
@property (nonatomic) NSInteger ticketID;
@property (nonatomic, strong ) NSString* ticketGUID;
@property (nonatomic) NSInteger iDX1;
@property (nonatomic) NSInteger iDX2;
@property (nonatomic) NSInteger iDX3;
@property (nonatomic, strong ) NSString* fieldName;
@property (nonatomic, strong ) NSString* value;
@property (nonatomic) NSInteger inputInstance;
@property (nonatomic) NSInteger inputSubID;
@property (nonatomic, strong ) NSString* inputPage;
@property (nonatomic, strong ) NSString* del;
@property (nonatomic, strong ) NSString* dataModified;
@end
