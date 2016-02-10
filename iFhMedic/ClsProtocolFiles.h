//
//  ClsProtocolFiles.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsProtocolFiles : NSObject
{
    NSInteger protocolID;
    NSString* protocolButtonText;
    NSString* protocolFileString;
    NSInteger protocolFileVersion;
    NSString* protocolFileName;
    NSInteger protocolGroup;
    NSInteger sortIndex;
    NSInteger active;
    
}
@property (nonatomic) NSInteger protocolID;
@property(nonatomic, strong) NSString* protocolButtonText;
@property(nonatomic, strong) NSString* protocolFileString;
@property (nonatomic) NSInteger protocolFileVersion;
@property(nonatomic, strong) NSString* protocolFileName;
@property (nonatomic) NSInteger protocolGroup;
@property (nonatomic) NSInteger sortIndex;
@property (nonatomic) NSInteger active;
@end
