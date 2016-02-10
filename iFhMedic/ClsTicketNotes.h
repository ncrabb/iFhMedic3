//
//  ClsTicketNotes.h
//  iRescueMedic
//
//  Created by admin on 11/2/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsTicketNotes : NSObject
{
    NSInteger ticketID;
    NSInteger noteUID;
    
    NSString* note;
    NSString* userID;
    NSString* noteTime;
    NSInteger noteRead;
    NSInteger forAdmin;
}

@property (nonatomic)NSInteger ticketID;
@property (nonatomic)NSInteger noteUID;

@property (nonatomic, strong)NSString* note;
@property (nonatomic, strong)NSString* userID;
@property (nonatomic, strong)NSString* noteTime;
@property (nonatomic)NSInteger noteRead;
@property (nonatomic)NSInteger forAdmin;

@end
