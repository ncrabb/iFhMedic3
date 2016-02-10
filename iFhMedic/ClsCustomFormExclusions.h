//
//  ClsCustomFormExclusions.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsCustomFormExclusions : NSObject
{
    NSInteger formID;
    NSInteger exclusionID;
    NSInteger inputID;
    NSString* inputValue;
    
    
}
@property (nonatomic) NSInteger formID;
@property (nonatomic) NSInteger exclusionID;
@property (nonatomic) NSInteger inputID;
@property(nonatomic, strong) NSString* inputValue;
@end
