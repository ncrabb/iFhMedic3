//
//  ClsNarcotic.h
//  iRescueMedic
//
//  Created by Nathan on 7/8/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsNarcotic : NSObject
{
    NSInteger drugID;
    NSString* MedicationName;
    NSString* amountUsage;
    NSString* UsageUnit;
    NSString* amountWastage;
    NSString* WastageUnit;
    NSInteger witnessType;
    int witnessedUsage;
    int witnessWastage;
}

@property(nonatomic, strong) NSString* MedicationName;
@property(nonatomic, strong) NSString* amountUsage;
@property(nonatomic, strong) NSString* UsageUnit;
@property(nonatomic, strong) NSString* amountWastage;
@property(nonatomic, strong) NSString* WastageUnit;
@property(nonatomic, assign) NSInteger witnessType;
@property(nonatomic, assign) NSInteger drugID;
@property(nonatomic, assign) int witnessedUsage;
@property(nonatomic, assign) int witnessedWastage;
@end
