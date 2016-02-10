//
//  ClsControlFilters.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsControlFilters : NSObject
{
    NSInteger ccid;
    NSInteger controlID;
    NSString* controlType;
    NSInteger requiredField;
    
}
@property (nonatomic) NSInteger ccid;
@property (nonatomic) NSInteger controlID;
@property(nonatomic, strong) NSString* controlType;
@property (nonatomic) NSInteger requiredField;
@end
