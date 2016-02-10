//
//  ClsStates.h
//  iRescueMedic
//
//  Created by admin on 6/8/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsStates : NSObject
{
    NSInteger stateID;
    NSString* stateName;
    NSInteger listIndex;
    NSInteger active;
    
}
@property (nonatomic) NSInteger stateID;
@property(nonatomic, strong) NSString* stateName;
@property (nonatomic) NSInteger listIndex;
@property (nonatomic) NSInteger active;
@end
