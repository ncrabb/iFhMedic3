//
//  ClsCities.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsCities : NSObject
{
    NSInteger cityID;
    NSString* cityName;
    NSInteger countyID;
    NSInteger listIndex;
    NSInteger active;
    
}
@property (nonatomic) NSInteger cityID;
@property(nonatomic, strong) NSString* cityName;
@property (nonatomic) NSInteger countyID;
@property (nonatomic) NSInteger listIndex;
@property (nonatomic) NSInteger active;
@end
