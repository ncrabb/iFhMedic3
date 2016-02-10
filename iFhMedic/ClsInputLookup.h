//
//  ClsInputLookup.h
//  iRescueMedic
//
//  Created by Nathan on 6/21/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsInputLookup : NSObject
{
    NSInteger inputId;
    NSInteger valueId;
    
    NSString* valueName;
    NSString* page;
    NSString* excludeCCId;
    NSInteger excludeAllCC;
    NSInteger sortIndex;
    NSString* code;




}

@property (nonatomic)NSInteger inputId;
@property (nonatomic)NSInteger valueId;

@property (nonatomic, strong)NSString* valueName;
@property (nonatomic, strong)NSString* page;
@property (nonatomic, strong)NSString* excludeCCId;
@property (nonatomic)NSInteger excludeAllCC;
@property (nonatomic)NSInteger sortIndex;
@property (nonatomic, strong)NSString* code;


@end
