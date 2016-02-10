//
//  AppDelegate.m
//  iFhMedic
//
//  Created by admin on 8/16/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import "AppDelegate.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize dblCurrentLatitude;
@synthesize dblCurrentLongitude;
@synthesize locationManager;
@synthesize arrInputLookup;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self checkDB];
    [application setStatusBarHidden:NO];
     [self startUpdatingLoaction];
    m_contentOfCurrentProperty = nil;
    
    //[[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"ec53c1be80c37adad95e8b2e8ff972c7"];
  //  [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"3b0757863f6a9dd1576d1ab3a7be502a"];
  //  [[BITHockeyManager sharedHockeyManager] startManager];
  //  [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica Neue" size:15.0f], NSFontAttributeName, [UIColor colorWithRed:(90/255.5) green:(200/255.5) blue:(225.0/255) alpha:1], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)setLocationCoordinate:(CLLocationCoordinate2D)coordinate
{
    
    dblCurrentLatitude = coordinate.latitude;
    dblCurrentLongitude = coordinate.longitude;
}

- (void) checkDB
{
    /*   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSString *bundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
     if ([userDefaults objectForKey:kVERSION]) {
     NSString *version = [userDefaults objectForKey:kVERSION];
     if (![version isEqualToString:bundleVersion]) {
     [self replaceDatabase];
     [userDefaults setObject:bundleVersion forKey:kVERSION];
     }
     } else {
     [self replaceDatabase];
     [userDefaults setObject:bundleVersion forKey:kVERSION];
     } */
    [self replaceDatabase];
}

- (void)replaceDatabase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // remove old sqlite database from documents directory
    NSURL *dblookupDocumentsURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"rm_lookup.sqlite"];
    NSString *dbDocumentsPath = [dblookupDocumentsURL path];
    if (![fileManager fileExistsAtPath:dbDocumentsPath]) {
        // move new sqlite database from bundle to documents directory
        NSString *dbBundlePath = [[NSBundle mainBundle] pathForResource:@"rm_lookup" ofType:@"sqlite"];
        if (dbBundlePath) {
            NSError *error = nil;
            [fileManager copyItemAtPath:dbBundlePath toPath:dbDocumentsPath error:&error];
            if (error) {
                NSLog(@"Error copying lookup sqlite database: %@", [error localizedDescription]);
            }
        }
    }
    NSURL *dbdataDocumentsURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"rm_data.sqlite"];
    NSString *dbdataDocumentsPath = [dbdataDocumentsURL path];
    if (![fileManager fileExistsAtPath:dbdataDocumentsPath]) {
        // move new sqlite database from bundle to documents directory
        NSString *dbBundlePath = [[NSBundle mainBundle] pathForResource:@"rm_data" ofType:@"sqlite"];
        if (dbBundlePath) {
            NSError *error = nil;
            [fileManager copyItemAtPath:dbBundlePath toPath:dbdataDocumentsPath error:&error];
            if (error) {
                NSLog(@"Error copying data sqlite database: %@", [error localizedDescription]);
            }
        }
    }
    NSURL *dbblobDocumentsURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"rm_blobs.sqlite"];
    NSString *dbblobDocumentsPath = [dbblobDocumentsURL path];
    if (![fileManager fileExistsAtPath:dbblobDocumentsPath]) {
        // move new sqlite database from bundle to documents directory
        NSString *dbBundlePath = [[NSBundle mainBundle] pathForResource:@"rm_blobs" ofType:@"sqlite"];
        if (dbBundlePath) {
            NSError *error = nil;
            [fileManager copyItemAtPath:dbBundlePath toPath:dbblobDocumentsPath error:&error];
            if (error) {
                NSLog(@"Error copying blob sqlite database: %@", [error localizedDescription]);
            }
        }
    }
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



#pragma mark -
#pragma mark <CLLocationManagerDelegate> Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    
    // NSLog(@"my latitude :%f",currentLocation.coordinate.latitude);
    
    //NSLog(@"my longitude :%f",currentLocation.coordinate.longitude);
    [self setLocationCoordinate:currentLocation.coordinate];
    
    
    //  NSLog(@"Detected Location : %f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         //   NSLog(@"Monday");
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
         
     }];
}


// Called when the location is updated
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // Horizontal coordinates
    if (signbit(newLocation.horizontalAccuracy))
    {
        // Negative accuracy means an invalid or unavailable measurement
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iRescueMedic" message:@"Latitude / Longitude unavailable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];*/
    }
    else
    {
        //dblCurrentLatitude = newLocation.coordinate.latitude;
        //dblCurrentLongitude = newLocation.coordinate.longitude;
        [self setLocationCoordinate:newLocation.coordinate];
        //[NSThread detachNewThreadSelector:@selector(loadHomeView) toTarget:self withObject:Nil];
    }
}

// Called when there is an error getting the location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *sErrorString = @"";
    
    if ([error domain] == kCLErrorDomain)
    {
        // We handle CoreLocation-related errors here
        switch ([error code])
        {
            case kCLErrorDenied:
                sErrorString = [NSString stringWithFormat:@"Access to use your location was denied."];
                break;
                
            case kCLErrorLocationUnknown:
                sErrorString = [NSString stringWithFormat:@"Your location could not be determined."];
                break;
                
            default:
                sErrorString = [NSString stringWithFormat:@"Unknown location."];
                break;
        }
    }
    else
    {
        // We handle all non-CoreLocation errors here
        sErrorString = [NSString stringWithFormat:@"Error domain: \"%@\"  Error code: %d\n", [error domain], [error code]];
        sErrorString = [NSString stringWithFormat:@"Description: \"%@\"\n", [error localizedDescription]];
    }
    
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iRescueMedic" message:sErrorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];*/
}



- (void)startUpdatingLoaction
{
    if(locationManager)
    {
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
    }
    
    // Start searching for current location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if(IS_OS_8_OR_LATER) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    [self.locationManager startUpdatingLocation];
}


@end
