//
//  ClsDrugs.h
//  iRescueMedic
//
//  Created by admin on 3/22/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsDrugs : NSObject
{
    NSInteger drugID;
    NSString* drugName;
    NSInteger narcotic;
}

@property (nonatomic) NSInteger drugID;
@property(nonatomic, strong) NSString* drugName;
@property (nonatomic) NSInteger narcotic;
@property (nonatomic) NSInteger defaultDosage;
@property (nonatomic) NSInteger sortIndex;
@end
