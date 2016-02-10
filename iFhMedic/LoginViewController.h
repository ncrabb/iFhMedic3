//
//  LoginViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "PopoverViewController.h"
#import "sharedClsCommonVariables.h"
#import "LicenseViewController.h"
#import "PopOverWithSearchViewController.h"

//NSMutableDictionary* g_SETTINGS;


@interface LoginViewController : UIViewController <UITextFieldDelegate, DismissDelegate, DoneRegisterDelegate, DismissSearchUserDelegate>
{
    NSMutableData* webData;
    NSMutableString* soapResult;
    NSURLConnection* conn;	

    NSMutableArray* g_ARRAY;
    sqlite3 *dataDB;
    sqlite3 *blobsDB;
    sqlite3 *queueDB;
    sqlite3 *lookupDB;
    NSMutableArray* unitArray;
    NSInteger unitSelected;
    NSInteger userSelected;
    NSInteger functionSelected;
    bool registered;
    LicenseViewController* license;

}

@property (strong, nonatomic) IBOutlet UIButton *btnUnit;
@property (strong, nonatomic) IBOutlet UIButton *btnUser;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIImageView *iVTopBar; // Balraj

@property (nonatomic, strong) NSMutableData* webData;
@property (nonatomic, strong) NSMutableArray* unitsArray;
@property (nonatomic, strong) NSMutableArray* usersArray;
@property (nonatomic,strong) UIPopoverController *popOver;
@property (strong, nonatomic) IBOutlet UILabel *lblVersion;

@property (strong, nonatomic) IBOutlet UIButton *btnShift;
@property (nonatomic, strong) NSMutableArray* shiftArray;

@property (strong, nonatomic) IBOutlet UIButton *btnLogin;


- (IBAction)btnSelectUnitClick:(id)sender;
- (IBAction)UserClick:(id)sender;


- (IBAction)btnShiftClick:(id)sender;


- (IBAction)LoginClick:(id)sender;
- (IBAction)btnExitClick:(id)sender;



@end
