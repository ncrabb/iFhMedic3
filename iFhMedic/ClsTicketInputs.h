//
//  ClsTicketInputs.h
//  iRescueMedic
//
//  Created by Nathan on 6/21/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsTicketInputs : NSObject
{
    NSInteger localTicketId;
    NSInteger ticketId;
    NSInteger inputId;
    NSInteger inputSubId;
    
    NSInteger inputInstance;
    NSString* inputPage;
    NSString* inputName;
    NSString* inputValue;
    NSInteger deleted;
    NSInteger modified;
}

@property (nonatomic) NSInteger localTicketId;
@property (nonatomic) NSInteger ticketId;
@property (nonatomic) NSInteger inputId;
@property (nonatomic) NSInteger inputSubId;
@property (nonatomic) NSInteger inputInstance;
@property (nonatomic, strong ) NSString* inputPage;
@property (nonatomic, strong ) NSString* inputName;
@property (nonatomic, strong ) NSString* inputValue;
@property (nonatomic) NSInteger deleted;
@property (nonatomic) NSInteger modified;
@end
