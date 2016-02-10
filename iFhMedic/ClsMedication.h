//
//  ClsMedication.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsMedication : NSObject
{
    NSInteger medicationID;
    NSString* medicationName;
    NSInteger medicationType;
    
}
@property (nonatomic) NSInteger medicationID;
@property(nonatomic, strong) NSString* medicationName;
@property (nonatomic) NSInteger medicationType;
@end
