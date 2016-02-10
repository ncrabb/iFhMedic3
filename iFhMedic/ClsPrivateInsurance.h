//
//  ClsPrivateInsurance.h
//  iRescueMedic
//
//  Created by admin on 3/15/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsPrivateInsurance : NSObject
{
    NSInteger insuranceID;
    NSString* insuranceName;
    NSString* subscribberID;
    NSString* groupNum;
    NSString* insuredName;
    NSString* insuredSSN;
    NSString* insuredDOB;
    NSString* Deleted;
    
}
@property (nonatomic) NSInteger insuranceID;
@property(nonatomic, strong) NSString* insuranceName;
@property(nonatomic, strong) NSString* subscribberID;
@property(nonatomic, strong) NSString* groupNum;
@property(nonatomic, strong) NSString* insuredName;
@property(nonatomic, strong) NSString* insuredSSN;
@property(nonatomic, strong) NSString* insuredDOB;
@property(nonatomic, assign) NSString* deleted;
@end
