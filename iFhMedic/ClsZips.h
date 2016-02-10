//
//  ClsZips.h
//  iRescueMedic
//
//  Created by admin on 6/8/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsZips : NSObject
{
    NSString* zipText;
    NSInteger cityID;
    NSInteger listIndex;
    NSInteger active;
    
}
@property(nonatomic, strong) NSString* zipText;
@property (nonatomic) NSInteger cityID;
@property (nonatomic) NSInteger listIndex;
@property (nonatomic) NSInteger active;

@end
