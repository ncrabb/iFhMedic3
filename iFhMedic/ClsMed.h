//
//  ClsMed.h
//  iRescueMedic
//
//  Created by Nathan on 7/8/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsMed : NSObject
{
    NSString* drugName;
    NSString* amount;
    NSString* amountUnit;
    NSString* freq;
    NSString* freqUnit;
}

@property(nonatomic, strong) NSString* drugName;
@property(nonatomic, strong) NSString* amount;
@property(nonatomic, strong) NSString* amountUnit;
@property(nonatomic, strong) NSString* freq;
@property(nonatomic, strong) NSString* freqUnit;
@end
