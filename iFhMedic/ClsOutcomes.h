//
//  ClsOutcomes.h
//  iRescueMedic
//
//  Created by admin on 8/21/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsOutcomes : NSObject
{
    NSInteger outcomeID;
    NSInteger transportType;
    
    NSString* description;
    NSInteger sortIndex;
    NSInteger active;
    NSString* altDescription;
    NSInteger triggerID;
    NSInteger customFlag;
    
    
}

@property (nonatomic)NSInteger outcomeID;
@property (nonatomic)NSInteger transportType;

@property (nonatomic, strong)NSString* description;
@property (nonatomic) NSInteger sortIndex;
@property (nonatomic) NSInteger active;

@property (nonatomic, strong)NSString* altDescription;
@property (nonatomic)NSInteger triggerID;
@property (nonatomic)NSInteger customFlag;

@end
