//
//  ClsSignatureImages.h
//  iRescueMedic
//
//  Created by Nathan on 8/22/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsSignatureImages : NSObject
{
    
}

@property(nonatomic, strong) UIImage* image;
@property(nonatomic, strong) NSString* imageStr;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* id;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, assign) NSInteger signatureID;
@end
