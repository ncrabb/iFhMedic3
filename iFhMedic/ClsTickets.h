//
//  ClsTickets.h
//  iRescueMedic
//
//  Created by Nathan on 6/17/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsTickets : NSObject
{
    NSInteger localTicketId;
    NSInteger ticketID;
    NSString* TicketGUID;
    
    NSString* ticketIncidentNumber;
    
    NSString* ticketDesc;
    NSString* ticketDOS;
    NSInteger ticketStatus;
    NSInteger ticketOwner;
    
    NSInteger ticketCreator;
    NSInteger ticketUnitNumber;
    
    NSInteger ticketFinalized;
    NSString* ticketDateFinalized;
    NSString* ticketCrew;
    NSInteger ticketPractice;
    NSString* ticketCreatedTime;
 
    NSInteger TicketShift;
    NSInteger ticketLocked;
    NSInteger ticketReviewed;
    NSInteger ticketAccount;
    NSString* ticketAdminNotes;
    NSString *ticketType;
    
}


@property (nonatomic) NSInteger localTicketId;
@property (nonatomic) NSInteger ticketID;
@property (nonatomic, strong ) NSString* TicketGUID;
@property (nonatomic, strong) NSString* ticketIncidentNumber;
@property (nonatomic, strong) NSString* ticketDesc;
@property (nonatomic, strong) NSString* ticketDOS;
@property (nonatomic) NSInteger ticketStatus;
@property (nonatomic) NSInteger ticketOwner;
@property (nonatomic) NSInteger ticketCreator;
@property (nonatomic) NSInteger ticketUnitNumber;
@property (nonatomic) NSInteger ticketFinalized;
@property (nonatomic, strong ) NSString* ticketDateFinalized;
@property (nonatomic, strong ) NSString* ticketCrew;
@property (nonatomic) NSInteger ticketPractice;
@property (nonatomic, strong ) NSString* ticketCreatedTime;
@property (nonatomic) NSInteger TicketShift;
@property (nonatomic) NSInteger ticketLocked;
@property (nonatomic) NSInteger ticketReviewed;
@property (nonatomic) NSInteger ticketAccount;
@property (nonatomic, strong ) NSString* ticketAdminNotes;
@property (nonatomic, strong) NSString *ticketType;

@end
