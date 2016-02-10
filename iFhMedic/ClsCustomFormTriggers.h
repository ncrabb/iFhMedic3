//
//  ClsCustomFormTriggers.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsCustomFormTriggers : NSObject
{
    NSInteger formID;
    NSInteger triggerID;
    NSInteger inputID;
    NSString* inputValue;
    
}
@property (nonatomic) NSInteger formID;
@property (nonatomic) NSInteger triggerID;
@property (nonatomic) NSInteger inputID;
@property(nonatomic, strong) NSString* inputValue;
@end
