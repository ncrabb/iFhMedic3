//
//  ClsXInputTables.h
//  iRescueMedic
//
//  Created by Nathan on 6/13/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsXInputTables : NSObject
{
    NSString* it_TableName;
    NSString* it_HashCode;
}

@property (nonatomic, strong ) NSString* it_TableName;
@property (nonatomic, strong ) NSString* it_HashCode;

@end
