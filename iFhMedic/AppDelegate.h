//
//  AppDelegate.h
//  iFhMedic
//
//  Created by admin on 8/16/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ClsInputLookup.h"
#import <sqlite3.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>
{
    UIPopoverController *m_popOverController;
    
    CLLocationManager *locationManager;
    ClsInputLookup *inputLookup;
    NSMutableString *m_contentOfCurrentProperty;
    
    NSMutableArray* g_ARRAY;
    sqlite3 *dataDB;
    sqlite3 *blobsDB;
    sqlite3 *queueDB;
    sqlite3 *lookupDB;
    
    
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, assign) double dblCurrentLatitude;
@property (nonatomic, assign) double dblCurrentLongitude;
@property (nonatomic, strong) NSMutableArray *arrInputLookup;
@property (nonatomic, strong) NSMutableArray *arrLocalInputLookup;

- (void)startUpdatingLoaction;
@end

