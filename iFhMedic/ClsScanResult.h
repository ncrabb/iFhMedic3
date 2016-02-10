//
//  ClsScanResult.h
//  iRescueMedic
//
//  Created by admin on 9/4/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsScanResult : NSObject
{
	BOOL succeeded;
	NSString *result;
}

@property (nonatomic, assign) BOOL succeeded;
@property (nonatomic, retain) NSString *result;
@end
