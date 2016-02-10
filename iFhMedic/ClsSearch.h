//
//  ClsSearch.h
//  iRescueMedic
//
//  Created by admin on 12/16/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsSearch : NSObject
{
    NSInteger ticketID;
    NSString* firstName;
    NSString* lastName;
    NSString* mi;
    NSString* dob;
    NSString* race;
    NSString* sex;
    NSString* phone;
    NSString* height;
    NSString* weight;
    NSString* dlNumber;
    NSString* ssn;
    NSString* address1;
    NSString* address2;
    NSString* zip;
    NSString* city;
    NSString* state;
    NSString* county;
    NSString* meds;
    NSString* dos;
    NSString* allenv;
    NSString* allfood;
    NSString* allinsects;
    NSString* allmeds;
    NSString* allalerts;
    NSString* histCardio;
    NSString* histCancer;
    NSString* histNeuro;
    NSString* histGastro;
    NSString* histGenit;
    NSString* histInfect;
    NSString* histEndo;
    NSString* histResp;
    NSString* histPsych;
    NSString* histWomen;
    NSString* histMusc;
    NSString* insMedid;
    NSString* insMaid;
    NSString* insConame;
    NSString* insId;
    NSString* insGroup;
    NSString* insName;
    NSString* insDob;
    NSString* insSSN;
    NSString* resident;
    NSString* ethnicity;
}

@property(nonatomic) NSInteger ticketID;
@property(nonatomic, strong) NSString* firstName;
@property(nonatomic, strong) NSString* lastName;
@property(nonatomic, strong) NSString* mi;
@property(nonatomic, strong) NSString* dob;
@property(nonatomic, strong) NSString* race;
@property(nonatomic, strong) NSString* sex;
@property(nonatomic, strong) NSString* phone;
@property(nonatomic, strong) NSString* height;
@property(nonatomic, strong) NSString* weight;
@property(nonatomic, strong) NSString* dlNumber;
@property(nonatomic, strong) NSString* ssn;
@property(nonatomic, strong) NSString* address1;
@property(nonatomic, strong) NSString* address2;
@property(nonatomic, strong) NSString* zip;
@property(nonatomic, strong) NSString* city;
@property(nonatomic, strong) NSString* state;
@property(nonatomic, strong) NSString* county;
@property(nonatomic, strong) NSString* meds;
@property(nonatomic, strong) NSString* dos;
@property(nonatomic, strong) NSString* allenv;
@property(nonatomic, strong) NSString* allfood;
@property(nonatomic, strong) NSString* allinsects;
@property(nonatomic, strong) NSString* allmeds;
@property(nonatomic, strong) NSString* allalerts;
@property(nonatomic, strong) NSString* histCardio;
@property(nonatomic, strong) NSString* histCancer;
@property(nonatomic, strong) NSString* histNeuro;
@property(nonatomic, strong) NSString* histGastro;
@property(nonatomic, strong) NSString* histGenit;
@property(nonatomic, strong) NSString* histInfect;
@property(nonatomic, strong) NSString* histEndo;
@property(nonatomic, strong) NSString* histResp;
@property(nonatomic, strong) NSString* histPsych;
@property(nonatomic, strong) NSString* histWomen;
@property(nonatomic, strong) NSString* histMusc;
@property(nonatomic, strong) NSString* insMedid;
@property(nonatomic, strong) NSString* insMaid;
@property(nonatomic, strong) NSString* insConame;
@property(nonatomic, strong) NSString* insId;
@property(nonatomic, strong) NSString* insGroup;
@property(nonatomic, strong) NSString* insName;
@property(nonatomic, strong) NSString* insDob;
@property(nonatomic, strong) NSString* insSSN;
@property(nonatomic, strong) NSString* resident;
@property(nonatomic, strong) NSString* ethnicity;
@end
