//
//  ClsMedicare.h
//  iRescueMedic
//
//  Created by Nathan on 8/16/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsMedicare : NSObject
{
    NSString* payer;
    NSString* id;
}

@property(nonatomic, strong) NSString* payer;
@property(nonatomic, strong) NSString* id;

@end
