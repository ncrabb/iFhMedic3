//
//  ClsChiefComplaints.h
//  iRescueMedic
//
//  Created by Nathan on 6/26/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsChiefComplaints : NSObject
{
    NSInteger ccID;
    NSString* ccDescription;
    NSInteger ccType;
    NSInteger ccUserDefined;
    NSInteger ccActive;
    NSString* ccClarify;
    NSString* ccFilter;
    NSString* customCode;
}

@property (nonatomic) NSInteger ccID;
@property (nonatomic, strong ) NSString* ccDescription;
@property (nonatomic) NSInteger ccType;
@property (nonatomic) NSInteger ccUserDefined;
@property (nonatomic) NSInteger ccActive;
@property (nonatomic, strong ) NSString* ccClarify;
@property (nonatomic, strong ) NSString* ccFilter;
@property (nonatomic, strong ) NSString* customCode;
@end
