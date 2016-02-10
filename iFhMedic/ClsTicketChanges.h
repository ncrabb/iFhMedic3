//
//  ClsTicketChanges.h
//  iRescueMedic
//
//  Created by admin on 11/6/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsTicketChanges : NSObject
{
    NSInteger ticketID;
    NSInteger changeID;
    
    NSString* changeMade;
    NSString* changeTime;
    NSInteger modifiedBy;
    NSInteger changeInputID;
    NSString* originalValue;
}

@property (nonatomic)NSInteger ticketID;
@property (nonatomic)NSInteger changeID;
@property (nonatomic, strong)NSString* changeMade;
@property (nonatomic, strong)NSString* changeTime;
@property (nonatomic)NSInteger modifiedBy;
@property (nonatomic)NSInteger changeInputID;
@property (nonatomic, strong)NSString* originalValue;

@end
