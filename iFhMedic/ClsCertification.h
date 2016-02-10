//
//  ClsCertification.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsCertification : NSObject
{
    NSString* certName;
    NSInteger certUID;

}
@property(nonatomic, strong) NSString* certName;
@property (nonatomic) NSInteger certUID;
@end
