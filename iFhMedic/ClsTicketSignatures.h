//
//  ClsTicketSignatures.h
//  iRescueMedic
//
//  Created by Nathan on 6/25/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsTicketSignatures : NSObject
{
    NSInteger localTicketID;
    NSInteger ticketID;
    NSInteger signatureID;
    NSInteger signatureType;
    NSString* signatureString;
    NSString* signatureTime;
    NSString* signatureText;
    NSInteger deleted;
}
@property (nonatomic) NSInteger localTicketID;
@property (nonatomic) NSInteger ticketID;
@property (nonatomic) NSInteger signatureID;
@property (nonatomic) NSInteger signatureType;
@property (nonatomic, strong ) NSString* signatureString;
@property (nonatomic, strong ) NSString* signatureTime;
@property (nonatomic, strong ) NSString* signatureText;
@property (nonatomic) NSInteger deleted;

@end
