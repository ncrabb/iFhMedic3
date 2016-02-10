//
//  ClsInsuranceTypes.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsInsuranceTypes : NSObject
{
    NSInteger insID;
    NSString* insDescription;
    NSString* insAltDescription;
    
}
@property (nonatomic) NSInteger insID;
@property(nonatomic, strong) NSString* insDescription;
@property(nonatomic, strong) NSString* insAltDescription;
@end
