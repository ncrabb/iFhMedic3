//
//  ClsOutcomeRequiredItems.h
//  iRescueMedic
//
//  Created by admin on 8/21/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsOutcomeRequiredItems : NSObject

@property (nonatomic)NSInteger outcomeID;
@property (nonatomic)NSInteger outcomeReqID;
@property (nonatomic)NSInteger inputID;
@property (nonatomic, strong)NSString* outcomeReqDescription;

@end
