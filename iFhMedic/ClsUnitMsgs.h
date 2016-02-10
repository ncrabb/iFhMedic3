//
//  ClsUnitMsgs.h
//  iRescueMedic
//
//  Created by admin on 1/21/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsUnitMsgs : NSObject
{
    NSInteger unitMsgID;
    
    NSString* unitID;
    NSString* sentTo;
    NSString* sentBy;
    NSString* timeStamp;
    NSString* msg;
    NSInteger refID;
}

@property (nonatomic)NSInteger unitMsgID;
@property (nonatomic, strong)NSString* unitID;
@property (nonatomic, strong)NSString* sentTo;
@property (nonatomic, strong)NSString* sentBy;
@property (nonatomic)NSString* timeStamp;
@property (nonatomic, strong)NSString* msg;
@property (nonatomic)NSInteger refID;

@end
