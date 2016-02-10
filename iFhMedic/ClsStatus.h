//
//  ClsStatus.h
//  iRescueMedic
//
//  Created by admin on 6/8/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsStatus : NSObject
{
    NSInteger statusID;
    NSString* statusDescription;
    
}
@property (nonatomic) NSInteger statusID;
@property(nonatomic, strong) NSString* statusDescription;
@end
