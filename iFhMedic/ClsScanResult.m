//
//  ClsScanResult.m
//  iRescueMedic
//
//  Created by admin on 9/4/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "ClsScanResult.h"

@implementation ClsScanResult
@synthesize result;
@synthesize succeeded;

- (void)dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
	self.result = nil;
}

@end
