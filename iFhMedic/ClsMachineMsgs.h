//
//  ClsMachineMsgs.h
//  iRescueMedic
//
//  Created by admin on 1/21/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsMachineMsgs : NSObject
{
    NSInteger machineMsgsID;
    
    NSString* machineID;
    NSString* sentTo;
    NSString* sentBy;
    NSString* timeStamp;
    NSString* msg;
    NSInteger refID;
}

@property (nonatomic)NSInteger machineMsgsID;
@property (nonatomic, strong)NSString* machineID;
@property (nonatomic, strong)NSString* sentTo;
@property (nonatomic, strong)NSString* sentBy;
@property (nonatomic)NSString* timeStamp;
@property (nonatomic)NSString* msg;
@property (nonatomic)NSInteger refID;
@end
