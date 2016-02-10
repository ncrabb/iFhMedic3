//
//  ClsTicketFormsInputs.h
//  iRescueMedic
//
//  Created by admin on 8/19/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsTicketFormsInputs : NSObject
{
    NSInteger localTicketID;
    NSInteger ticketID;
    NSInteger formID;
    NSInteger formInputID;
    NSString* formInputValue;
    NSInteger deleted;
    NSInteger modified;
}

@property (nonatomic) NSInteger localTicketID;
@property (nonatomic) NSInteger ticketID;
@property (nonatomic) NSInteger formID;
@property (nonatomic) NSInteger formInputID;
@property (nonatomic, strong) NSString* formInputValue;
@property (nonatomic) NSInteger deleted;
@property (nonatomic) NSInteger modified;
@end
