//
//  ClsAssesment.h
//  iRescueMedic
//
//  Created by Nathan on 7/1/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClsAssesment : NSObject

@property (nonatomic, strong ) NSString* time;
@property (nonatomic, strong) NSString* skin;
@property (nonatomic, strong) NSString* head;
@property (nonatomic, strong) NSString* neck;
@property (nonatomic, strong ) NSString* chest;
@property (nonatomic, strong) NSString* heart;
@property (nonatomic, strong) NSString* abdomen;
@property (nonatomic, strong) NSString* pelvis;
@property (nonatomic, strong) NSString* back;
@property (nonatomic, strong) NSString* extremity;
@property (nonatomic, strong) NSString* eye;
@property (nonatomic, strong) NSString *luAbd;
@property (nonatomic, strong) NSString* llAbd;
@property (nonatomic, strong) NSString* rrAbd;
@property (nonatomic, strong) NSString* ruAbd;
@property (nonatomic, strong ) NSString* gu;
@property (nonatomic, strong ) NSString* cervical;
@property (nonatomic, strong) NSString* thoracic;
@property (nonatomic, strong) NSString* lumbar;
@property (nonatomic, strong) NSString* ruExt;
@property (nonatomic, strong) NSString* rrExt;
@property (nonatomic, strong) NSString* llExt;
@property (nonatomic, strong) NSString* luExt;
@property (nonatomic, strong) NSString* leftEye;
@property (nonatomic, strong) NSString* rightEye;
@property (nonatomic, strong) NSString* mentalStatus;
@property (nonatomic, strong) NSString* neurological;
@property (nonatomic, strong) NSString* face;
@property (nonatomic, strong) NSString* abdomenLoc;
@property (nonatomic, strong) NSString* backLoc;
@property (nonatomic, strong) NSString* extremityLoc;
@property (nonatomic, strong) NSString* eyeLoc;

@property (nonatomic, strong) NSString *avpu;
@property (nonatomic, strong) NSString *motor;
@property (nonatomic, strong) NSString * sensory;
@property (nonatomic, strong) NSString *speech;
@property (nonatomic, strong) NSString *airway;
@property (nonatomic, strong) NSString *breathing;
@property (nonatomic, strong) NSString* general;
@property (nonatomic, strong) NSString *CRT;
@property (nonatomic, strong) NSString *deleted;
@end
