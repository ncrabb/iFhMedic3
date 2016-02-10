//
//  ClsInjuryType.h
//  iRescueMedic
//
//  Created by Nathan on 8/27/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsInjuryType : NSObject
@property(nonatomic, strong) NSString* area;
@property(nonatomic, strong) NSString* type;
@property(nonatomic, assign) CGPoint location;
@property(nonatomic, assign) NSInteger front;
@end
