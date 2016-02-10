//
//  ClsSettings.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsSettings : NSObject
{
    NSInteger settingID;
    NSString* settingDesc;
    NSString* settingValue;
    
}
@property (nonatomic) NSInteger settingID;
@property(nonatomic, strong) NSString* settingDesc;
@property(nonatomic, strong) NSString* settingValue;
@end
