//
//  ClsSignatureTypes.h
//  iRescueMedic
//
//  Created by admin on 6/7/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsSignatureTypes : NSObject
{
    NSInteger signatureType;
    NSString* signatureTypeDesc;
    NSString* discalimerText;
    NSString* signatureGroup;
    
    
}
@property (nonatomic) NSInteger signatureType;
@property(nonatomic, strong) NSString* signatureTypeDesc;
@property(nonatomic, strong) NSString* disclaimerText;
@property(nonatomic, strong) NSString* signatureGroup;

@end
