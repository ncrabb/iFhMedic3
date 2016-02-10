//
//  ClsGroups.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsGroups : NSObject
{
    NSInteger groupID;
    NSString* groupDescription;
    NSInteger groupAccessLevel;
    
}
@property (nonatomic) NSInteger groupID;
@property(nonatomic, strong) NSString* grouoDescription;
@property (nonatomic) NSInteger groupAccessLevel;
@end
