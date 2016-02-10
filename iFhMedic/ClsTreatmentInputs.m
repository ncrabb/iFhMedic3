//
//  ClsTreatmentInputs.m
//  iRescueMedic
//
//  Created by admin on 6/8/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "ClsTreatmentInputs.h"

@implementation ClsTreatmentInputs
@synthesize treatmentID;
@synthesize inputID;
@synthesize inputName;
@synthesize inputIndex;
@synthesize inputDataType;
@synthesize active;
@synthesize inputRequired;
@synthesize inputValue;

-(id)copyWithZone:(NSZone *)zone
{
    ClsTreatmentInputs *another = [[ClsTreatmentInputs alloc] init];
    another.treatmentID = treatmentID;
    another.inputID = inputID;
    another.inputName = [inputName copyWithZone: zone];
    another.inputIndex = inputIndex;
    another.inputDataType = inputDataType;
    another.active = active;
    another.inputRequired = inputRequired;
    another.inputValue = [inputValue copyWithZone:zone];
    return another;
}

@end
