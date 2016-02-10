//
//  ClsQuickButtons.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsQuickButtons : NSObject
{
    NSInteger ccID;
    NSInteger inputType;
    NSInteger inputID;
    NSInteger type;
    
}
@property (nonatomic) NSInteger ccID;
@property (nonatomic) NSInteger inputType;
@property (nonatomic) NSInteger inputID;
@property (nonatomic) NSInteger type;

@end
