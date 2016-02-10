//
//  ClsInjuryTypes.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsInjuryTypes : NSObject
{
    NSInteger injuryTypeID;
    NSString* injuryTypeName;
    
    
}
@property (nonatomic) NSInteger injuryTypeID;
@property(nonatomic, strong) NSString* injuryTypeName;
@end
