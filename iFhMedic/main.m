//
//  main.m
//  iFhMedic
//
//  Created by admin on 8/16/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

NSMutableDictionary* g_SETTINGS;
NSObject* g_SYNCDATADB;
NSObject* g_SYNCLOOKUPDB;
NSObject* g_SYNCBLOBSDB;
Boolean g_NEWTICKET;
NSMutableArray* g_CREWARRAY;

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
