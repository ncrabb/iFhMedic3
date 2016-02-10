//
//  ClsCustomForms.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsCustomForms : NSObject
{
    NSInteger formID;
    NSString* formDescription;
    NSString* dateAdded;
    NSInteger active;
    NSString* triggerAndOr;
    
}
@property (nonatomic) NSInteger formID;
@property(nonatomic, strong) NSString* formDescription;
@property(nonatomic, strong) NSString* dateAdded;
@property (nonatomic) NSInteger active;
@property(nonatomic, strong) NSString* triggerAndOr;
@end
