//
//  ClsForms.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsForms : NSObject
{
    NSInteger formID;
    NSString* formDescription;
    
    
}
@property (nonatomic) NSInteger formID;
@property(nonatomic, strong) NSString* formDescription;
@end
