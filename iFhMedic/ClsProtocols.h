//
//  ClsProtocols.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsProtocols : NSObject
{
    NSInteger protocolID;
    NSString* protocolName;
    NSString* protocolFileName;
    NSString* protocolNemsisValue;
    
}
@property (nonatomic) NSInteger protocolID;
@property(nonatomic, strong) NSString* protocolName;
@property(nonatomic, strong) NSString* protocolFileName;
@property(nonatomic, strong) NSString* protocolNemsisValueName;
@end
