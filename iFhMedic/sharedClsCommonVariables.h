//
//  sharedClsCommonVariables.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 06/03/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClsUnits.h"
#import "ClsUsers.h"

@interface sharedClsCommonVariables : NSObject {
    
    ClsUnits *_objClsUnit;
    ClsUsers *_objClsUsers;
    
}

@property (retain) ClsUnits *objClsUnit;
@property (retain) ClsUsers *objClsUsers;

+ (sharedClsCommonVariables *)sharedInstanceCommonVariables;

@end







