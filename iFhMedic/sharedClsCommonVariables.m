//
//  sharedClsCommonVariables.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 06/03/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "sharedClsCommonVariables.h"

sharedClsCommonVariables *sharedInstanceCommonVariables = nil;

@implementation sharedClsCommonVariables

@synthesize objClsUnit;
@synthesize objClsUsers;

+ (sharedClsCommonVariables *)sharedInstanceCommonVariables
{
	if(sharedInstanceCommonVariables == nil) {
		sharedInstanceCommonVariables = [[sharedClsCommonVariables alloc] init];
	}

	return sharedInstanceCommonVariables;
}


- (id)init
{
	if((self = [super init])) {
		objClsUnit  = [[ClsUnits alloc] init];
		objClsUsers = [[ClsUsers alloc] init];
	}

	return self;
}



@end


