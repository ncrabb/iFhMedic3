//
//  ClsCustomerContent.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsCustomerContent : NSObject
{
    NSString* fileType;
    NSString* fileName;
    NSString* fileString;
    NSInteger fileSize;
    NSInteger fileID;
    
}
@property(nonatomic, strong) NSString* fileType;
@property(nonatomic, strong) NSString* fileName;
@property(nonatomic, strong) NSString* fileString;
@property (nonatomic) NSInteger fileSize;
@property (nonatomic) NSInteger fileID;


@end
