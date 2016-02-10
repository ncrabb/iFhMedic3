//
//  PasswordViewController.m
//  iRescueMedic
//
//  Created by admin on 8/13/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PasswordViewController.h"
#import "global.h"
#import "DAO.h"
#import "ClsUsers.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@interface PasswordViewController ()

@end

@implementation PasswordViewController
@synthesize userId;
@synthesize txtPassword;
@synthesize lblMessage;
@synthesize delegate;
@synthesize pass;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    pass = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnNextClick:(id)sender {
    if ([txtPassword.text length] < 1)
    {
        lblMessage.text = @"Please enter the new Primary User password.";
        return;
    }
    
    NSString* sql = [NSString stringWithFormat:@"Select u.UserID, u.UserFirstname, u.UserLastName, u.UserAddress, u.UserCity, u.UserState, u.UserZip, u.UserAge, u.UserUnit, u.UserActive, u.UserCertification, u.UserCertStart, u.UserCertEnd, u.UserCertNum, u.UserPassword, u.UserGroup, c.CertName as UserIDNumber from users u left join certification c on u.UserCertification = c.CertUID where UserActive = %d and u.UserID = %d", 1, userId]; //unitSelected
    NSArray* userArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        userArray = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    ClsUsers* user = [userArray objectAtIndex:0];
    NSString* encryptedPass = user.userPassword;
    
    // Sharma testing
    NSString* enteredPass = [self hmacsha1:txtPassword.text];
    if ([enteredPass isEqualToString:encryptedPass])
    {
        pass = true;
        [delegate donePasswordClick];
    }
    else
    {
        lblMessage.text = @"Password entered is not correct.";
        return;
    }
    
}

- (NSString *)hmacsha1:(NSString *)data {
    
    NSString* key = @"Hudson";
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [[data uppercaseString]cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64Encoding];
    return hash;
}

- (IBAction)btnCancelClick:(id)sender {
    pass = false;
    [delegate donePasswordClick];    
}
@end
