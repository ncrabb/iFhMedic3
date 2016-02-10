//
//  ClsCounties.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsCounties : NSObject
{
    NSInteger countyID;
    NSString* countyName;
    NSInteger stateID;
    NSInteger listIndex;
    NSInteger active;
    
}
@property (nonatomic) NSInteger countyID;
@property(nonatomic, strong) NSString* countyName;
@property (nonatomic) NSInteger stateID;
@property (nonatomic) NSInteger listIndex;
@property (nonatomic) NSInteger active;

@end
