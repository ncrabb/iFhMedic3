//
//  ClsTicketAttachments.h
//  iRescueMedic
//
//  Created by admin on 6/4/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsTicketAttachments : NSObject
{
    NSInteger localTicketID;
    NSInteger ticketID;
    NSInteger attachmentID;
    NSString* fileType;
    NSString* fileStr;
    NSString* fileName;
    NSString* timeAdded;
    NSInteger deleted;
}

@property (nonatomic) NSInteger localTicketID;
@property (nonatomic) NSInteger ticketID;
@property (nonatomic) NSInteger attachmentID;
@property (nonatomic, strong) NSString* fileType;
@property (nonatomic, strong) NSString* fileStr;
@property (nonatomic, strong) NSString* fileName;
@property (nonatomic, strong) NSString* timeAdded;
@property (nonatomic) NSInteger deleted;

@end
