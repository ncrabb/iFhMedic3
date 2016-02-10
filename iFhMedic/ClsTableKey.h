//
//  ClsTableKey.h
//  iRescueMedic
//
//  Created by Nathan on 6/19/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsTableKey : NSObject
{
    NSInteger key;
    NSString* tableName;
    NSString* desc;
    NSMutableArray* additionalInfo;
    NSInteger tableID;
}

@property (nonatomic) NSInteger key;
@property (nonatomic) NSInteger tableID;
@property (nonatomic, strong ) NSString* tableName;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSMutableArray* additionalInfo;

@end
