//
//  ClsPages.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsPages : NSObject
{
    NSInteger tabID;
    NSInteger formID;
    NSString* tabDescription;
    NSString* tabName;
    NSInteger intitalTab;
    NSInteger visible;
    NSInteger sortIndex;
    NSString* altDescription;
    
}
@property (nonatomic) NSInteger tabID;
@property (nonatomic) NSInteger formID;
@property(nonatomic, strong) NSString* tabDescription;
@property(nonatomic, strong) NSString* tabName;
@property (nonatomic) NSInteger intialTab;
@property (nonatomic) NSInteger visible;
@property (nonatomic) NSInteger sortIndex;
@property(nonatomic, strong) NSString* altDescription;
@end
