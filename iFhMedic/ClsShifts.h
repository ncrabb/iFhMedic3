//
//  ClsShifts.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsShifts : NSObject
{
    NSInteger shiftID;
    NSString* shiftName;
    NSInteger shiftHours;
    NSString* shiftStart;
    NSString* shiftRefDate;


    
    
}
@property (nonatomic) NSInteger shiftID;
@property(nonatomic, strong) NSString* shiftName;
@property (nonatomic) NSInteger shiftHours;
@property(nonatomic, strong) NSString* shiftStart;
@property(nonatomic, strong) NSString* shiftRefDate;
@end
