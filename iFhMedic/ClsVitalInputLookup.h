//
//  ClsVitalInputLookup.h
//  iRescueMedic
//
//  Created by admin on 6/8/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsVitalInputLookup : NSObject
{
    NSInteger vitalInputID;
    NSInteger vitalInputIndex;
    NSString* vitalInputDesc;
    
    
}
@property (nonatomic) NSInteger vitalInputID;
@property (nonatomic) NSInteger vitalInputIndex;
@property(nonatomic, strong) NSString* vitalInputDesc;
@end
