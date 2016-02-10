//
//  LoginViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//
//make sure this is on github

#import "NSData+Base64.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "DAO.h"
#import "global.h"
#import "Reachability.h"
#import "ServiceSvc.h"
#import "ClsUnits.h"
#import "ClsUsers.h"
#import "PopoverPasswordControllerViewController.h"
#import "ClsCrewInfo.h"
#import "DDPopoverBackgroundView.h"  // Mani
#import "ClsInputs.h"
#import "ClsInputLookup.h"
#import "MBProgressHUD.h"
#import "ClsTableKey.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize webData;
@synthesize unitsArray;
@synthesize usersArray;
@synthesize btnUnit;
@synthesize btnUser;
@synthesize popOver;
@synthesize txtPassword;
@synthesize iVTopBar;
@synthesize lblVersion;
@synthesize btnLogin;
@synthesize btnShift;
@synthesize shiftArray;

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
    txtPassword.delegate = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ipad_login_bkg.jpg"]];
    lblVersion.text = [NSString stringWithFormat:@"Version: %@",
                       [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
    
    g_SETTINGS = [[NSMutableDictionary alloc] init];
    [self copyDB];
    
    registered = false;
    NSInteger customerNumber = [DAO getCustomerNumber:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue]];
    if (customerNumber <= 0)
    {
        license = [[LicenseViewController alloc] init];
        [self.view addSubview:license.view];
        license.delegate = self;
    }
    else if (customerNumber == 1)
    {
        [g_SETTINGS setObject:@"LOCAL" forKey:@"MachineID"];
        userSelected = 69;
        unitSelected = 0;
        [g_SETTINGS setObject:@"1" forKey:@"Shift"];
        [g_SETTINGS setObject:@"1" forKey:@"ShiftID"];
        NSString* sql = [NSString stringWithFormat:@"Select u.UserID, u.UserFirstname, u.UserLastName, u.UserAddress, u.UserCity, u.UserState, u.UserZip, u.UserAge, u.UserUnit, u.UserActive, u.UserCertification, u.UserCertStart, u.UserCertEnd, u.UserCertNum, u.UserPassword, u.UserGroup, c.CertName as UserIDNumber from users u left join certification c on u.UserCertification = c.CertUID where UserActive = %d", 1]; //unitSelected
        self.usersArray = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
        
    }
    else
    {
        txtPassword.text = @"";
        [btnShift setTitle:@"Shift" forState:UIControlStateNormal];
        [btnUnit setTitle:@"Click to select Unit" forState:UIControlStateNormal];
        [btnShift setTitle:@"Shift" forState:UIControlStateNormal];
        [btnUser setTitle:@"Enter Username" forState:(UIControlStateNormal)];
        [g_SETTINGS setObject:[NSString stringWithFormat:@"%d",customerNumber ] forKey:@"CustomerID"];
        registered = true;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (registered)
    {
        [self setViewUI];
        
        unitSelected = -1;
        userSelected = -1;
        functionSelected = -1;
        
        txtPassword.borderStyle = UITextBorderStyleRoundedRect;
        
        unitSelected = -1;
        userSelected = -1;
        functionSelected = -1;
        [btnUnit setTitle:@"Click to select Unit" forState:UIControlStateNormal];
        [btnShift setTitle:@"Shift" forState:UIControlStateNormal];
        [btnUser setTitle:@"Enter Username" forState:UIControlStateNormal];
        txtPassword.text = @"";
        NSString* machineCheck = [g_SETTINGS objectForKey:@"MachineID"];
        if (![machineCheck isEqualToString:@"LOCAL"])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.labelText = @"Downloading data";
            hud.detailsLabelText = @"Please wait...";
            hud.mode = MBProgressHUDAnimationFade;
            [self.view addSubview:hud];
            [hud showWhileExecuting:@selector(setupDB) onTarget:self withObject:Nil animated:YES];
        }
        else
        {
            [self loadSettings];
        }
    }
    else
    {
        [self loadSettings];
    }
}

- (void) loadSettings
{
    NSString* sql = @"Select SettingDesc, SettingValue from Settings";
    [DAO executeLoadSettings:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    
}

- (void) copyDB
{
    dataDB = [DAO openDB:g_DATADB db:dataDB];
    if (dataDB == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic for iPad" message:@"Unable to copy data DB from bundle, please shut down and restart the app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [g_SETTINGS setObject:[NSValue valueWithPointer:dataDB] forKey:@"dataDB"];
    
    blobsDB = [DAO openDB:g_BLOBSDB db:blobsDB];
    if (blobsDB == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic for iPad" message:@"Unable to copy blobs DB from bundle, please shut down and restart the app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [g_SETTINGS setObject:[NSValue valueWithPointer:blobsDB] forKey:@"blobsDB"];
    
    //   queueDB = [DAO openDB:g_QUEUEDB db:queueDB];
    //   if (queueDB == nil)
    //   {
    //       UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Database copy failed" message:@"Unable to copy queue DB from bundle" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //       [alert show];
    //   }
    //   [g_SETTINGS setObject:[NSValue valueWithPointer:queueDB] forKey:@"queueDB"];
    
    lookupDB = [DAO openDB:g_LOOKUPDB db:lookupDB];
    if (lookupDB == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic for iPad" message:@"Unable to copy queue DB from bundle, please shut down and restart the app." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [g_SETTINGS setObject:[NSValue valueWithPointer:lookupDB] forKey:@"lookupDB"];
    
}

- (void) setupDB
{
    @autoreleasepool {
        NSInteger result = 1;
        //    NSInteger result = [self getDeviceSettings];
        //    if (result > -1)
        {
            Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
            BOOL connectionRequired= [hostReach connectionRequired];
            if (!connectionRequired)
            {
                @try
                {
                    NSMutableDictionary* xInputDict = [DAO ReadXInputTables:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Filter:@""];
                    ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
                    binding.logXMLInOut = NO;
                    ServiceSvc_GetxInputTables *req = [[ServiceSvc_GetxInputTables alloc] init];
                    req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
                    ServiceSoapBindingResponse* resp = [binding GetxInputTablesUsingParameters:req];
                    for (id mine in resp.bodyParts)
                    {
                        if ([mine isKindOfClass:[ServiceSvc_GetxInputTablesResponse class]])
                        {
                            ServiceSvc_ArrayOfClsXInputTables* resultArray = [mine GetxInputTablesResult];
                            NSMutableArray* array = [resultArray ClsXInputTables];
                            int protocolGroupSet = 0;
                            for (int i = 0; i < [array count]; i++)
                            {
                                ServiceSvc_ClsXInputTables* record = [array objectAtIndex:i];
                                NSString* tableName = [record valueForKey:@"IT_TableName"];
                                NSString* hashCode = [record valueForKey:@"IT_HashCode"];
                                NSString* localValue = [xInputDict objectForKey:tableName];
                                if (![hashCode isEqualToString:localValue])
                                {
                                    if ([tableName isEqualToString:@"ProtocolGroups"])
                                    {
                                        protocolGroupSet = 1;
                                    }
                                    result = 0;
                                    if ([tableName isEqualToString:@"Inputs"])
                                    {
                                        result = [self downloadInputs];
                                        
                                    }
                                    else if ([tableName isEqualToString:@"InputLookup"])
                                    {
                                        result = [self downloadInputLookup];
                                    }
                                    else if ([tableName isEqualToString:@"Certification"])
                                    {
                                        result = [self downloadCert];
                                    }
                                    else if ([tableName isEqualToString:@"ChiefComplaints"])
                                    {
                                        result = [self downloadCC];
                                    }
                                    else if ([tableName isEqualToString:@"Cities"])
                                    {
                                        result = [self downloadCities];
                                    }
                                    else if ([tableName isEqualToString:@"Counties"])
                                    {
                                        result = [self downloadCounties];
                                    }
                                    else if ([tableName isEqualToString:@"ControlFilters"])
                                    {
                                        result = [self downloadControlFilters];
                                    }
                                    else if ([tableName isEqualToString:@"CustomerContent"])
                                    {
                                        result = [self downloadCustomerContent];
                                    }
                                    else if ([tableName isEqualToString:@"CustomForms"])
                                    {
                                        //   result = [self downloadCustomForms];
                                    }
                                    else if ([tableName isEqualToString:@"CustomFormInputs"])
                                    {
                                        // result = [self downloadCustomFormInputs];
                                    }
                                    else if ([tableName isEqualToString:@"Drugs"])
                                    {
                                        result = [self downloadDrugs];
                                    }
                                    else if ([tableName isEqualToString:@"DrugDosages"])
                                    {
                                        result = [self downloadDrugDosages];
                                    }
                                    else if ([tableName isEqualToString:@"Forms"])
                                    {
                                        result = [self downloadForms];
                                    }
                                    else if ([tableName isEqualToString:@"Groups"])
                                    {
                                        result = [self downloadGroups];
                                    }
                                    else if ([tableName isEqualToString:@"InjuryTypes"])
                                    {
                                        result = [self downloadInjuryTypes];
                                    }
                                    else if ([tableName isEqualToString:@"Insurance"])
                                    {
                                        result = [self downloadInsurance];
                                    }
                                    else if ([tableName isEqualToString:@"InsuranceInputs"])
                                    {
                                        result = [self downloadInsuranceInputs];
                                    }
                                    else if ([tableName isEqualToString:@"InsuranceInputLookup"])
                                    {
                                        result = [self downloadInsuranceInputLookup];
                                    }
                                    else if ([tableName isEqualToString:@"InsuranceTypes"])
                                    {
                                        result = [self downloadInsuranceTypes];
                                    }
                                    else if ([tableName isEqualToString:@"Locations"])
                                    {
                                        result = [self downloadLocations];
                                    }
                                    else if ([tableName isEqualToString:@"Medications"])
                                    {
                                        result = [self downloadMedications];
                                    }
                                    else if ([tableName isEqualToString:@"Outcomes"])
                                    {
                                        result = [self downloadOutomes];
                                    }
                                    else if ([tableName isEqualToString:@"OutcomeTypes"])
                                    {
                                        result = [self downloadOutcomeTypes];
                                    }
                                    else if ([tableName isEqualToString:@"OutcomeRequiredItems"])
                                    {
                                        result = [self downloadOutcomeRequiredItems];
                                    }
                                    else if ([tableName isEqualToString:@"OutcomeRequiredSignatures"])
                                    {
                                        result = [self downloadOutcomeRequiredSignatures];
                                    }
                                    else if ([tableName isEqualToString:@"Pages"])
                                    {
                                        result = [self downloadPages];
                                    }
                                    else if ([tableName isEqualToString:@"ProtocolFiles"])
                                    {
                                        result = [self downloadProtocolFiles];
                                    }
                                    else if ([tableName isEqualToString:@"ProtocolGroups"])
                                    {
                                        result = [self downloadProtocolGroups];
                                    }
                                    else if ([tableName isEqualToString:@"QuickButtons"])
                                    {
                                        result = [self downloadQuickButtons];
                                    }
                                    else if ([tableName isEqualToString:@"Settings"])
                                    {
                                        result = [self downloadSettings];
                                    }
                                    else if ([tableName isEqualToString:@"Shifts"])
                                    {
                                        result = [self downloadShifts];
                                    }
                                    else if ([tableName isEqualToString:@"SignatureTypes"])
                                    {
                                        result = [self downloadSignatureTypes];
                                    }
                                    else if ([tableName isEqualToString:@"States"])
                                    {
                                        result = [self downloadStates];
                                    }
                                    else if ([tableName isEqualToString:@"Stations"])
                                    {
                                        result = [self downloadStations];
                                    }
                                    else if ([tableName isEqualToString:@"Status"])
                                    {
                                        result = [self downloadStatus];
                                    }
                                    else if ([tableName isEqualToString:@"Treatments"])
                                    {
                                        result = [self downloadTreatments];
                                    }
                                    else if ([tableName isEqualToString:@"TreatmentInputs"])
                                    {
                                        result = [self downloadTreatmentInputs];
                                    }
                                    else if ([tableName isEqualToString:@"TreatmentInputLookup"])
                                    {
                                        result = [self downloadTreatmentInputLookup];
                                    }
                                    else if ([tableName isEqualToString:@"Units"])
                                    {
                                        result = [self downloadUnits];
                                    }
                                    else if ([tableName isEqualToString:@"Users"])
                                    {
                                        result = [self downloadUsers];
                                    }
                                    else if ([tableName isEqualToString:@"Vitals"])
                                    {
                                        result = [self downloadVitals];
                                    }
                                    else if ([tableName isEqualToString:@"VitalInputLookup"])
                                    {
                                        result = [self downloadVitalInputLookup];
                                    }
                                    else if ([tableName isEqualToString:@"Zips"])
                                    {
                                        result = [self downloadZips];
                                    }
                                    if (result == 1)
                                    {
                                        NSString* sqlUpdate = [NSString stringWithFormat:@"Update xInputTables Set IT_HashCode = %@ where IT_TableName = '%@'", hashCode, tableName];
                                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlUpdate];
                                    }
                                    
                                }
                            }
                            if (protocolGroupSet == 0)
                            {
                                [self downloadProtocolGroups];
                            }
                            
                        }
                    }
                    
                }
                @catch (NSException *exception) {
                    result = -1;
                }
                @finally {
                    //  [self loadSettings];
                }
                
            }
        }
        [self loadSettings];
    }
}

- (NSString*) removeNull:(NSString*)str
{
    if ([str length] > 0 && ([str rangeOfString:@"(null)"].location == NSNotFound))
    {
        return str;
    }
    else
    {
        return @"";
    }
}


- (int) downloadZips
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetZips *req = [[ServiceSvc_GetZips alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetZipsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetZipsResponse class]])
                {
                    ServiceSvc_ArrayOfClsZips * resultArray = [mine GetZipsResult];
                    NSMutableArray* array = [resultArray ClsZips];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Zips;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsZips* record = [array objectAtIndex:i];
                        NSString* ZipText = [self removeNull:[record valueForKey:@"ZipText"]];
                        NSString* CityID = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"CityID"]]];
                        NSString* ListIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"ListIndex"]]];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into Zips(ZipText, CityID, ListIndex, Active) Values('%@', %@, %@,%@)", ZipText, CityID, ListIndex, Active];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadVitalInputLookup
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetVitalInputLookupTable *req = [[ServiceSvc_GetVitalInputLookupTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetVitalInputLookupTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetVitalInputLookupTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsVitalInputLookup * resultArray = [mine GetVitalInputLookupTableResult];
                    NSMutableArray* array = [resultArray ClsVitalInputLookup];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from VitalInputLookup;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsVitalInputLookup* record = [array objectAtIndex:i];
                        NSString* VitalInputID = [record valueForKey:@"VitalInputID"];
                        NSString* VitalInputIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"VitalInputIndex"]]];
                        NSString* VitalInputDesc = [self removeNull:[record valueForKey:@"VitalInputDesc"]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into VitalInputLookup(VitalInputID, VitalInputIndex, VitalInputDesc) Values(%@, %@, '%@')", VitalInputID, VitalInputIndex, VitalInputDesc];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}



- (int) downloadVitals
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetVitalsTable *req = [[ServiceSvc_GetVitalsTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetVitalsTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetVitalsTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsVitals * resultArray = [mine GetVitalsTableResult];
                    NSMutableArray* array = [resultArray ClsVitals];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Vitals;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsVitals* record = [array objectAtIndex:i];
                        NSString* InputID = [record valueForKey:@"InputID"];
                        NSString* InputDesc = [self removeNull:[record valueForKey:@"InputDesc"]];
                        NSString* VitalName = [self removeNull:[record valueForKey:@"VitalName"]];
                        NSString* VitalRequired = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"VitalRequired"]]];
                        NSString* VitalVisible = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"VitalVisible"]]];
                        NSString* VitalDataType   = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"VitalDataType"]]];
                        NSString* DetailsID = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"DetailsID"]]];
                        NSString* DetailsName = [self removeNull:[record valueForKey:@"DetailsName"]];
                        NSString* DetailsButtons = [self removeNull:[record valueForKey:@"DetailsButtons"]];
                        NSString* VitalsIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"VitalsIndex"]]];
                        NSString* VitalsGroup = [self removeNull:[record valueForKey:@"VitalsGroup"]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into Vitals(InputID, InputDesc, VitalName, VitalRequired, VitalVisible, VitalDataType, DetailsID, DetailsName, DetailsButtons, VitalsIndex, VitalsGroup) Values(%@, '%@', '%@', %@, %@, %@, %@,'%@','%@', %@,'%@' )", InputID, InputDesc, VitalName, VitalRequired, VitalVisible, VitalDataType, DetailsID, DetailsName, DetailsButtons, VitalsIndex, VitalsGroup];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadUsers
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetUsers *req = [[ServiceSvc_GetUsers alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetUsersUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetUsersResponse class]])
                {
                    ServiceSvc_ArrayOfClsUsers * resultArray = [mine GetUsersResult];
                    NSMutableArray* array = [resultArray ClsUsers];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Users;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsUsers* record = [array objectAtIndex:i];
                        NSString* UserID = [record valueForKey:@"UserID"];
                        NSString* UserFirstName = [self removeNull:[record valueForKey:@"UserFirstName"]];
                        NSString* UserLastName = [self removeNull:[record valueForKey:@"UserLastName"]];
                        NSString* UserAddress = [self removeNull:[record valueForKey:@"UserAddress"]];
                        NSString* UserCity = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"UserCity"]]];
                        NSString* UserState = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"UserState"]]];
                        NSString* UserZip = [self removeNull:[record valueForKey:@"UserZip"]];
                        NSString* UserAge = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"UserAge"]]];
                        NSString* UserUnit = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"UserUnit"]]];
                        NSString* UserActive = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"UserActive"]]];
                        NSString* UserCertification = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"UserCertification"]]];
                        NSString* UserCertStart = [self removeNull:[record valueForKey:@"UserCertStart"]];
                        NSString* UserCertEnd = [self removeNull:[record valueForKey:@"UserCertEnd"]];
                        NSString* UserCertNum = [self removeNull:[record valueForKey:@"UserCertNum"]];
                        NSString* UserPassword = [self removeNull:[record valueForKey:@"UserPassword"]];
                        NSString* UserGroup = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"UserGroup"]]];
                        NSString* UserIDNumber = [self removeNull:[record valueForKey:@"UserIDNumber"]];
                        NSString* City = [self removeNull:[record valueForKey:@"City"]];
                        NSString* State = [self removeNull:[record valueForKey:@"State"]];
                        NSString* UserEmailAddress = [self removeNull:[record valueForKey:@"UserEmailAddress"]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into Users(UserID, UserFirstName, UserLastName, UserAddress, UserCity, UserState, UserZip, UserAge, UserUnit, UserActive, UserCertification, UserCertStart, UserCertEnd, UserCertNum, UserPassword, UserGroup, UserIDNumber, City, State, UserEmailAddress) Values(%@, '%@', '%@','%@', %@, %@, '%@', %@, %@, %@, %@, '%@', '%@', '%@', '%@', %@, '%@', '%@', '%@', '%@')", UserID, UserFirstName, UserLastName, UserAddress, UserCity, UserState, UserZip, UserAge, UserUnit, UserActive, UserCertification, UserCertStart, UserCertEnd, UserCertNum, UserPassword, UserGroup, UserIDNumber, City, State, UserEmailAddress];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadUnits
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetUnits *req = [[ServiceSvc_GetUnits alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetUnitsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetUnitsResponse class]])
                {
                    ServiceSvc_ArrayOfClsUnits * resultArray = [mine GetUnitsResult];
                    NSMutableArray* array = [resultArray ClsUnits];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Units;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsUnits* record = [array objectAtIndex:i];
                        NSString* UnitID = [record valueForKey:@"UnitID"];
                        
                        NSString* UnitDescription = [self removeNull:[record valueForKey:@"UnitDescription"]];
                        
                        NSString* StationID = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"StationID"]]];
                        NSString* RegionID = [self removeNull:[record valueForKey:@"RegionID"]];
                        NSString* UnitType = [self removeNull:[record valueForKey:@"UnitType"]];
                        NSString* VehicleType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"VehicleType"]]];
                        NSString* CADDispatchable = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"CADDispatchable"]]];
                        NSString* CADUnitDescription = [self removeNull:[record valueForKey:@"CADUnitDescription"]];
                        NSString* InterAgency = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InterAgency"]]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into Units(UnitID, UnitDescription, StationID, RegionID, UnitType, VehicleType, CADDispatchable, CADUnitDescription, InterAgency) Values(%@, '%@', %@,'%@', '%@', %@, %@, '%@', %@)", UnitID, UnitDescription, StationID, RegionID, UnitType, VehicleType, CADDispatchable, CADUnitDescription, InterAgency];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadTreatmentInputLookup
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetTreatmentInputLookupTable *req = [[ServiceSvc_GetTreatmentInputLookupTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetTreatmentInputLookupTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetTreatmentInputLookupTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsTreatmentInputLookup * resultArray = [mine GetTreatmentInputLookupTableResult];
                    NSMutableArray* array = [resultArray ClsTreatmentInputLookup];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from TreatmentInputLookup;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTreatmentInputLookup* record = [array objectAtIndex:i];
                        NSString* TreatmentID = [record valueForKey:@"TreatmentID"];
                        NSString* InputID = [record valueForKey:@"InputID"];
                        NSString* InputLookupID = [record valueForKey:@"InputLookupID"];
                        NSString* LookupName = [self removeNull:[record valueForKey:@"LookupName"]];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]]];
                        NSString* Code = [self removeNull:[record valueForKey:@"Code"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into TreatmentInputLookup(TreatmentID, InputID, InputLookupID, LookupName, Active, Code) Values(%@, %@, %@,'%@', %@, '%@')", TreatmentID, InputID, InputLookupID, LookupName, Active, Code];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}



- (int) downloadTreatmentInputs
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetTreatmentInputsTable *req = [[ServiceSvc_GetTreatmentInputsTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetTreatmentInputsTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetTreatmentInputsTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsTreatmentInputs * resultArray = [mine GetTreatmentInputsTableResult];
                    NSMutableArray* array = [resultArray ClsTreatmentInputs];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from TreatmentInputs;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTreatmentInputs* record = [array objectAtIndex:i];
                        NSString* TreatmentID = [record valueForKey:@"TreatmentID"];
                        NSString* InputID = [record valueForKey:@"InputID"];
                        NSString* InputName = [self removeNull:[record valueForKey:@"InputName"]];
                        NSString* InputIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputIndex"]]];
                        NSString* InputDataType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputDataType"]]];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]]];
                        NSString* InputRequired = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputRequired"]]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into TreatmentInputs(TreatmentID, InputID, InputName, InputIndex, InputDataType, Active, InputRequired) Values(%@, %@,'%@', %@, %@, %@,  %@)", TreatmentID, InputID, InputName, InputIndex, InputDataType, Active, InputRequired];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadTreatments
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetTreatmentsTable *req = [[ServiceSvc_GetTreatmentsTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetTreatmentsTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetTreatmentsTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsTreatments * resultArray = [mine GetTreatmentsTableResult];
                    NSMutableArray* array = [resultArray ClsTreatments];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Treatments;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTreatments* record = [array objectAtIndex:i];
                        NSString* TreatmentID = [record valueForKey:@"TreatmentID"];
                        NSString* TreatmentDesc = [self removeNull:[record valueForKey:@"TreatmentDesc"]];
                        NSString* TreatmentFilter = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TreatmentFilter"]]];
                        
                        NSString* SortIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SortIndex"]]];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into Treatments(TreatmentID, TreatmentDesc, TreatmentFilter, Active, SortIndex) Values(%@, '%@', %@, %@, %@)", TreatmentID, TreatmentDesc, TreatmentFilter, Active, SortIndex];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadStatus
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetStatus *req = [[ServiceSvc_GetStatus alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetStatusUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetStatusResponse class]])
                {
                    ServiceSvc_ArrayOfClsStatus * resultArray = [mine GetStatusResult];
                    NSMutableArray* array = [resultArray ClsStatus];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Status;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsStates* record = [array objectAtIndex:i];
                        NSString* StatusID = [record valueForKey:@"StatusID"];
                        NSString* StatusDescription = [self removeNull:[record valueForKey:@"StatusDescription"]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into Status(StatusID, StatusDescription) Values(%@, '%@')", StatusID, StatusDescription];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadStations
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetStations *req = [[ServiceSvc_GetStations alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetStationsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetStationsResponse class]])
                {
                    ServiceSvc_ArrayOfClsStations * resultArray = [mine GetStationsResult];
                    NSMutableArray* array = [resultArray ClsStations];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Stations;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsStations* record = [array objectAtIndex:i];
                        NSString* StationID = [record valueForKey:@"StationID"];
                        NSString* StationDescription = [self removeNull:[record valueForKey:@"StationDescription"]];
                        NSString* StationAddress = [self removeNull:[record valueForKey:@"StationAddress"]];
                        NSString* StationCity = [self removeNull:[record valueForKey:@"StationCity"]];
                        NSString* StationState = [self removeNull:[record valueForKey:@"StationState"]];
                        NSString* StationZip = [self removeNull:[record valueForKey:@"StationZip"]];
                        NSString* StationPhone = [self removeNull:[record valueForKey:@"StationPhone"]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into Stations(StationID, StationDescription, StationAddress, StationCity, StationState, StationZip, StationPhone) Values(%@, '%@', '%@', '%@', '%@', '%@', '%@')", StationID, StationDescription, StationAddress, StationCity, StationState, StationZip, StationPhone];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadStates
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetStates *req = [[ServiceSvc_GetStates alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetStatesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetStatesResponse class]])
                {
                    ServiceSvc_ArrayOfClsStates * resultArray = [mine GetStatesResult];
                    NSMutableArray* array = [resultArray ClsStates];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from States;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsStates* record = [array objectAtIndex:i];
                        NSString* StateID = [record valueForKey:@"StateID"];
                        NSString* StateName = [self removeNull:[record valueForKey:@"StateName"]];
                        NSString* ListIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"ListIndex"]]];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into States(StateID, StateName, ListIndex, Active) Values(%@, '%@', %@, %@)", StateID, StateName, ListIndex, Active];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}

- (int) downloadSignatureTypes
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetSignatureTypes *req = [[ServiceSvc_GetSignatureTypes alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetSignatureTypesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetSignatureTypesResponse class]])
                {
                    ServiceSvc_ArrayOfClsSignatureTypes * resultArray = [mine GetSignatureTypesResult];
                    NSMutableArray* array = [resultArray ClsSignatureTypes];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from SignatureTypes;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsSignatureTypes* record = [array objectAtIndex:i];
                        NSString* SignatureType = [record valueForKey:@"SignatureType"];
                        NSString* SignatureTypeDesc = [self removeNull:[record valueForKey:@"SignatureTypeDesc"]];
                        NSString* DisclaimerText1 = [self removeNull:[record valueForKey:@"DisclaimerText"]];
                        NSString* DisclaimerText = [DisclaimerText1 stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                        
                        NSString* SignatureGroup = [self removeNull:[record valueForKey:@"SignatureGroup"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into SignatureTypes(SignatureType, SignatureTypeDesc, DisclaimerText, SignatureGroup) Values(%@, '%@', '%@', '%@')", SignatureType, SignatureTypeDesc, DisclaimerText, SignatureGroup];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}



- (int) downloadShifts
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetShifts *req = [[ServiceSvc_GetShifts alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetShiftsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetShiftsResponse class]])
                {
                    ServiceSvc_ArrayOfClsShifts * resultArray = [mine GetShiftsResult];
                    NSMutableArray* array = [resultArray ClsShifts];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Shifts;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsShifts* record = [array objectAtIndex:i];
                        NSString* ShiftID = [record valueForKey:@"ShiftID"];
                        NSString* ShiftName = [self removeNull:[record valueForKey:@"ShiftName"]];
                        NSString* ShiftHours = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"ShiftHours"]]];
                        NSString* ShiftStart = [self removeNull:[record valueForKey:@"ShiftStart"]];
                        NSString* ShiftRefDate = [self removeNull:[record valueForKey:@"ShiftRefDate"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into Shifts(ShiftID, ShiftName, ShiftHours, ShiftStart, ShiftRefDate) Values(%@, '%@', %@, '%@', '%@')", ShiftID, ShiftName, ShiftHours, ShiftStart, ShiftRefDate];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadSettings
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetSettings *req = [[ServiceSvc_GetSettings alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetSettingsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetSettingsResponse class]])
                {
                    ServiceSvc_ArrayOfClsSettings * resultArray = [mine GetSettingsResult];
                    NSMutableArray* array = [resultArray ClsSettings];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Settings;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsSettings* record = [array objectAtIndex:i];
                        NSString* SettingID = [record valueForKey:@"SettingID"];
                        NSString* SettingDesc = [self removeNull:[record valueForKey:@"SettingDesc"]];
                        NSString* SettingValue = [self removeNull:[record valueForKey:@"SettingValue"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into Settings(SettingID, SettingDesc, SettingValue) Values(%@, '%@', '%@')", SettingID, SettingDesc, SettingValue];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadQuickButtons
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetQuickButtons *req = [[ServiceSvc_GetQuickButtons alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetQuickButtonsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetQuickButtonsResponse class]])
                {
                    ServiceSvc_ArrayOfClsQuickButtons * resultArray = [mine GetQuickButtonsResult];
                    NSMutableArray* array = [resultArray ClsQuickButtons];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from QuickButtons;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsQuickButtons* record = [array objectAtIndex:i];
                        NSString* CCID = [record valueForKey:@"CCID"];
                        NSString* InputType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputType"]]];
                        NSString* InputID = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputID"]] ];
                        NSString* Type = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Type"]]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into QuickButtons(CCID, InputType, InputID, Type) Values(%@, %@, %@,%@)", CCID, InputType, InputID, Type];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadProtocolFiles
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetProtocolFiles *req = [[ServiceSvc_GetProtocolFiles alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetProtocolFilesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetProtocolFilesResponse class]])
                {
                    ServiceSvc_ArrayOfClsProtocolFiles * resultArray = [mine GetProtocolFilesResult];
                    NSMutableArray* array = [resultArray ClsProtocolFiles];
                    //  if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from ProtocolFiles;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsProtocolFiles* record = [array objectAtIndex:i];
                        NSString* ProtocolID = [record valueForKey:@"ProtocolID"];
                        NSString* ProtocolButtonText = [record valueForKey:@"ProtocolButtonText"];
                        NSString* ProtocolFileString = [self removeNull:[record valueForKey:@"ProtocolFileString"]];
                        NSString* ProtocolFileVersion = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"ProtocolFileVersion"]]];
                        NSString* ProtocolFileName = [self removeNull:[record valueForKey:@"ProtocolFileName"]];
                        NSString* ProtocolGroup = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"ProtocolGroup"]] ];
                        NSString* SortIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SortIndex"]]];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into ProtocolFiles(ProtocolID, ProtocolButtonText, ProtocolFileString, ProtocolFileVersion, ProtocolFileName, ProtocolGroup, SortIndex, Active) Values(%@,'%@','%@',%@, '%@',%@,%@,%@)", ProtocolID, ProtocolButtonText, ProtocolFileString, ProtocolFileVersion, ProtocolFileName, ProtocolGroup, SortIndex, Active];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadProtocolGroups
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetProtocolGroups *req = [[ServiceSvc_GetProtocolGroups alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetProtocolGroupsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetProtocolGroupsResponse class]])
                {
                    ServiceSvc_ArrayOfClsProtocolGroups * resultArray = [mine GetProtocolGroupsResult];
                    NSMutableArray* array = [resultArray ClsProtocolGroups];
                    //  if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from ProtocolGroups;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsProtocolGroups* record = [array objectAtIndex:i];
                        NSString* ProtocolGroupID = [record valueForKey:@"ProtocolGroupID"];
                        NSString* ProtocolGroupDesc = [record valueForKey:@"ProtocolGroupDesc"];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into ProtocolGroups(ProtocolGroupID, ProtocolGroupDesc) Values(%@,'%@')", ProtocolGroupID, ProtocolGroupDesc];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadPages
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetPages *req = [[ServiceSvc_GetPages alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetPagesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetPagesResponse class]])
                {
                    ServiceSvc_ArrayOfClsPages * resultArray = [mine GetPagesResult];
                    NSMutableArray* array = [resultArray ClsPages];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Pages;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsPages* record = [array objectAtIndex:i];
                        NSString* TabID = [record valueForKey:@"TabID"];
                        NSString* FormID = [record valueForKey:@"FormID"];
                        NSString* TabDescription = [self removeNull:[record valueForKey:@"TabDescription"]];
                        NSString* TabName = [self removeNull:[record valueForKey:@"TabName"]];
                        NSString* InitialTab = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InitialTab"]] ];
                        NSString* Visible = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Visible"]] ];
                        NSString* SortIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SortIndex"]]];
                        NSString* AltDescription = [self removeNull:[record valueForKey:@"AltDescription"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into Pages(TabID, FormID, TabDescription, TabName, InitialTab, Visible, SortIndex, AltDescription) Values(%@,%@,'%@','%@', %@,%@,%@,'%@')", TabID, FormID, TabDescription, TabName, InitialTab, Visible, SortIndex, AltDescription];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}

- (int) downloadMedications
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetMedications *req = [[ServiceSvc_GetMedications alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetMedicationsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetMedicationsResponse class]])
                {
                    ServiceSvc_ArrayOfClsMedications * resultArray = [mine GetMedicationsResult];
                    NSMutableArray* array = [resultArray ClsMedications];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Medications;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsMedications* record = [array objectAtIndex:i];
                        NSString* MedicationID = [record valueForKey:@"MedicationID"];
                        NSString* MedicationName = [self removeNull:[record valueForKey:@"MedicationName"]];
                        NSString* MedicationType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"MedicationType"]] ];
                        NSString* sql = [NSString stringWithFormat:@"Insert into Medications(MedicationID, MedicationName, MedicationType) Values(%@,'%@',%@)", MedicationID, MedicationName, MedicationType];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadLocations
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetLocations *req = [[ServiceSvc_GetLocations alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetLocationsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetLocationsResponse class]])
                {
                    ServiceSvc_ArrayOfClsLocations * resultArray = [mine GetLocationsResult];
                    NSMutableArray* array = [resultArray ClsLocations];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Locations;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsLocations* record = [array objectAtIndex:i];
                        NSString* LocationID = [record valueForKey:@"LocationID"];
                        NSString* LocationName = [self removeNull:[record valueForKey:@"LocationName"]];
                        NSString* LocationAddress1 = [self removeNull:[record valueForKey:@"LocationAddress1"]];
                        NSString* LocationAddress2 = [self removeNull:[record valueForKey:@"LocationAddress2"]];
                        NSString* LocationCity = [self removeNull:[record valueForKey:@"LocationCity"]];
                        NSString* LocationZip = [self removeNull:[record valueForKey:@"LocationZip"]];
                        NSString* LocationPhone = [self removeNull:[record valueForKey:@"LocationPhone"]];
                        NSString* LocationPhone2 = [self removeNull:[record valueForKey:@"LocationPhone2"]];
                        NSString* LocationFax = [self removeNull:[record valueForKey:@"LocationFax"]];
                        NSString* LocationFax2 = [self removeNull:[record valueForKey:@"LocationFax2"]];
                        NSString* LocationState = [self removeNull:[record valueForKey:@"LocationState"]];
                        NSString* SortIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SortIndex"]] ];
                        NSString* LocationCode = [self removeNull:[record valueForKey:@"LocationCode"]];
                        NSString* LocationType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"LocationType"]] ];
                        NSString* SystemNumber = [self removeNull:[record valueForKey:@"SystemNumber"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into Locations(LocationID, LocationName, LocationAddress1, LocationAddress2, LocationCity, LocationZip, LocationPhone, LocationPhone2, LocationFax, LocationFax2, LocationState, SortIndex, LocationCode, LocationType, SystemNumber) Values(%@,'%@','%@', '%@','%@', '%@','%@','%@','%@', '%@','%@', %@, '%@', %@, '%@')", LocationID, LocationName, LocationAddress1, LocationAddress2, LocationCity, LocationZip, LocationPhone, LocationPhone2, LocationFax, LocationFax2, LocationState, SortIndex, LocationCode, LocationType, SystemNumber];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadInsuranceTypes
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetInsuranceTypes *req = [[ServiceSvc_GetInsuranceTypes alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetInsuranceTypesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetInsuranceTypesResponse class]])
                {
                    ServiceSvc_ArrayOfClsInsuranceTypes * resultArray = [mine GetInsuranceTypesResult];
                    NSMutableArray* array = [resultArray ClsInsuranceTypes];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from InsuranceTypes;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsInsuranceTypes* record = [array objectAtIndex:i];
                        NSString* InsID = [record valueForKey:@"InsID"];
                        NSString* InsDescription = [self removeNull:[record valueForKey:@"InsDescription"]];
                        NSString* InsAltDescription = [self removeNull:[record valueForKey:@"InsAltDescription"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into InsuranceTypes(InsID, InsDescription, InsAltDescription) Values(%@,'%@','%@')", InsID, InsDescription, InsAltDescription];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}



- (int) downloadInsuranceInputLookup
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetInsuranceInputLookup *req = [[ServiceSvc_GetInsuranceInputLookup alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetInsuranceInputLookupUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetInsuranceInputLookupResponse class]])
                {
                    ServiceSvc_ArrayOfClsInsuranceInputLookup * resultArray = [mine GetInsuranceInputLookupResult];
                    NSMutableArray* array = [resultArray ClsInsuranceInputLookup];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from InsuranceInputLookup;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsInsuranceInputLookup* record = [array objectAtIndex:i];
                        NSString* InsID = [record valueForKey:@"InsID"];
                        NSString* InputID = [record valueForKey:@"InputID"];
                        NSString* InputLookupID = [record valueForKey:@"InputLookupID"];
                        NSString* LookupName = [self removeNull:[record valueForKey:@"LookupName"]];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]] ];
                        NSString* Code = [self removeNull:[record valueForKey:@"Code"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into InsuranceInputLookup(InsID, InputID, InputLookupID, LookupName ,Active, Code) Values(%@, %@, %@, '%@', %@, '%@')", InsID, InputID, InputLookupID, LookupName, Active, Code];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadInsuranceInputs
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetInsuranceInputs *req = [[ServiceSvc_GetInsuranceInputs alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetInsuranceInputsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetInsuranceInputsResponse class]])
                {
                    ServiceSvc_ArrayOfClsInsuranceInputs * resultArray = [mine GetInsuranceInputsResult];
                    NSMutableArray* array = [resultArray ClsInsuranceInputs];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from InsuranceInputs;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsInsuranceInputs* record = [array objectAtIndex:i];
                        NSString* InsID = [record valueForKey:@"InsID"];
                        NSString* InputID = [record valueForKey:@"InputID"];
                        NSString* InputName = [self removeNull:[record valueForKey:@"InputName"]];
                        NSString* InputAltName = [self removeNull:[record valueForKey:@"InputAltName"]];
                        NSString* InputIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputIndex"]] ];
                        NSString* InputDataType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputDataType"]] ];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]] ];
                        NSString* sql = [NSString stringWithFormat:@"Insert into InsuranceInputs(InsID, InputID, InputName, InputAltName, InputIndex, InputDataType, Active) Values(%@, %@,'%@', '%@', %@, %@, %@)", InsID, InputID, InputName, InputAltName, InputIndex, InputDataType, Active];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadInsurance
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetInsurance *req = [[ServiceSvc_GetInsurance alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetInsuranceUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetInsuranceResponse class]])
                {
                    ServiceSvc_ArrayOfClsInsurance * resultArray = [mine GetInsuranceResult];
                    NSMutableArray* array = [resultArray ClsInsurance];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Insurance;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsInsurance* record = [array objectAtIndex:i];
                        NSString* InsuranceID = [record valueForKey:@"InsuranceID"];
                        NSString* InsuranceName = [self removeNull:[record valueForKey:@"InsuranceName"]];
                        NSString* InsuranceAddress = [self removeNull:[record valueForKey:@"InsuranceAddress"]];
                        NSString* InsurancePhone = [self removeNull:[record valueForKey:@"InsurancePhone"]];
                        NSString* InsuranceCode = [self removeNull:[record valueForKey:@"InsuranceCode"]];
                        NSString* InsuranceType = [self removeNull:[record valueForKey:@"InsuranceType"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into Insurance(InsuranceID, InsuranceName, InsuranceAddress, InsurancePhone, InsuranceCode, InsuranceType) Values(%@, '%@', '%@', '%@', '%@', '%@')", InsuranceID, InsuranceName, InsuranceAddress, InsurancePhone, InsuranceCode, InsuranceType];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}

- (int) downloadInjuryTypes
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetInjuryTypes *req = [[ServiceSvc_GetInjuryTypes alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetInjuryTypesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetInjuryTypesResponse class]])
                {
                    ServiceSvc_ArrayOfClsInjuryTypes * resultArray = [mine GetInjuryTypesResult];
                    NSMutableArray* array = [resultArray ClsInjuryTypes];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from InjuryTypes;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsInjuryTypes* record = [array objectAtIndex:i];
                        NSString* InjuryTypeID = [record valueForKey:@"InjuryTypeID"];
                        NSString* InjuryTypeName = [self removeNull:[record valueForKey:@"InjuryTypeName"]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into InjuryTypes(InjuryTypeID, InjuryTypeName) Values(%@, '%@')", InjuryTypeID, InjuryTypeName];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadGroups
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetGroups *req = [[ServiceSvc_GetGroups alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetGroupsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetGroupsResponse class]])
                {
                    ServiceSvc_ArrayOfClsGroups * resultArray = [mine GetGroupsResult];
                    NSMutableArray* array = [resultArray ClsGroups];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Groups;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsGroups* record = [array objectAtIndex:i];
                        NSString* GroupID = [record valueForKey:@"GroupID"];
                        NSString* GroupDescription = [self removeNull:[record valueForKey:@"GroupDescription"]];
                        NSString* GroupAccessLevel = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"GroupAccessLevel"]] ];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into Groups(GroupID, GroupDescription, GroupAccessLevel) Values(%@, '%@', %@)", GroupID, GroupDescription, GroupAccessLevel];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadDrugs
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetDrugs *req = [[ServiceSvc_GetDrugs alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetDrugsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetDrugsResponse class]])
                {
                    ServiceSvc_ArrayOfClsDrugs * resultArray = [mine GetDrugsResult];
                    NSMutableArray* array = [resultArray ClsDrugs];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Drugs;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsDrugs* record = [array objectAtIndex:i];
                        NSString* drugID = [record valueForKey:@"DrugID"];
                        NSString* drugName = [self removeNull:[record valueForKey:@"DrugName"]];
                        NSString* narcotic = [record valueForKey:@"Narcotic"];
                        NSString* defaultDosage = [record valueForKey:@"DefaultDosage"];
                        NSString* sortIndex = [record valueForKey:@"SortIndex"];
                        NSString* sql = [NSString stringWithFormat:@"Insert into Drugs(DrugID, DrugName, Narcotic, DefaultDosage, SortIndex) Values(%@, '%@', %@, %@, %@)", drugID, drugName, narcotic, defaultDosage, sortIndex];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}

- (int) downloadDrugDosages
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetDrugDosages *req = [[ServiceSvc_GetDrugDosages alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetDrugDosagesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetDrugDosagesResponse class]])
                {
                    ServiceSvc_ArrayOfClsDrugDosages * resultArray = [mine GetDrugDosagesResult];
                    NSMutableArray* array = [resultArray ClsDrugDosages];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from DrugDosages;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsDrugDosages* record = [array objectAtIndex:i];
                        NSString* drugID = [record valueForKey:@"DrugID"];
                        NSString* dosageID = [record valueForKey:@"DosageID"];
                        NSString* units = [record valueForKey:@"Units"];
                        NSString* dosage = [self removeNull:[record valueForKey:@"Dosage"]];
                        NSString* route = [self removeNull:[record valueForKey:@"Route"]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into DrugDosages(DrugID, dosageID, units, dosage, route) Values(%@, %@, %@, '%@', '%@')", drugID, dosageID, units, dosage, route];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}



- (int) downloadForms
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetForms *req = [[ServiceSvc_GetForms alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetFormsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetFormsResponse class]])
                {
                    ServiceSvc_ArrayOfClsForms * resultArray = [mine GetFormsResult];
                    NSMutableArray* array = [resultArray ClsForms];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Forms;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsForms* record = [array objectAtIndex:i];
                        NSString* FormID = [record valueForKey:@"FormID"];
                        NSString* FormDescription = [self removeNull:[record valueForKey:@"FormDescription"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into CustomForms(FormID, FormDescription) Values(%@, '%@')", FormID, FormDescription];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadCustomForms
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetCustomForms *req = [[ServiceSvc_GetCustomForms alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetCustomFormsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetCustomFormsResponse class]])
                {
                    ServiceSvc_ArrayOfClsCustomForms * resultArray = [mine GetCustomFormsResult];
                    NSMutableArray* array = [resultArray ClsCustomForms];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from CustomForms;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsCustomForms* record = [array objectAtIndex:i];
                        NSString* FormID = [record valueForKey:@"FormID"];
                        NSString* FormDescription = [self removeNull:[record valueForKey:@"FormDescription"]];
                        NSString* DateAdded = [self removeNull:[record valueForKey:@"DateAdded"]];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]] ];
                        NSString* TriggerAndOr = [self removeNull:[record valueForKey:@"TriggerAndOr"]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into CustomForms(FormID, FormDescription, DateAdded, Active, TriggerAndOr) Values(%@, '%@', '%@', %@, '%@')", FormID, FormDescription, DateAdded, Active, TriggerAndOr];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}



- (int) downloadCustomFormInputs
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetCustomFormInputs *req = [[ServiceSvc_GetCustomFormInputs alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetCustomFormInputsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetCustomFormInputsResponse class]])
                {
                    ServiceSvc_ArrayOfClsCustomFormInputs * resultArray = [mine GetCustomFormInputsResult];
                    NSMutableArray* array = [resultArray ClsCustomFormInputs];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from CustomFormInputs;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsCustomFormInputs* record = [array objectAtIndex:i];
                        NSString* FormID = [record valueForKey:@"FormID"];
                        NSString* InputID = [record valueForKey:@"InputID"];
                        NSString* InputName = [self removeNull:[record valueForKey:@"InputName"]];
                        NSString* InputDescription = [self removeNull:[record valueForKey:@"InputDescription"]];
                        NSString* InputDataType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputDataType"]] ];
                        NSString* InputGroup = [self removeNull:[record valueForKey:@"InputGroup"]];
                        NSString* InputRequired = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputRequired"]] ];
                        NSString* InputIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputIndex"]] ];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]] ];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into CustomFormInputs(FormID, InputID, InputName, InputDescription, InputDataType, InputGroup, InputRequired, InputIndex, Active) Values(%@, %@, '%@', '%@', %@, '%@', %@, %@, %@)", FormID, InputID, InputName, InputDescription, InputDataType, InputGroup, InputRequired, InputIndex, Active];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadCC
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetChiefComplaintsTable *req = [[ServiceSvc_GetChiefComplaintsTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetChiefComplaintsTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetChiefComplaintsTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsChiefComplaints * resultArray = [mine GetChiefComplaintsTableResult];
                    NSMutableArray* array = [resultArray ClsChiefComplaints];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from ChiefComplaints;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsChiefComplaints* record = [array objectAtIndex:i];
                        NSString* CCID = [record valueForKey:@"CCID"];
                        NSString* CCDescription = [self removeNull:[record valueForKey:@"CCDescription"]];
                        NSString* CCType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"CCType"]] ];
                        NSString* CCUserDefined = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"CCUserDefined"]] ];
                        NSString* CCActive = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"CCActive"]] ];
                        NSString* CCClarify = [self removeNull:[record valueForKey:@"CCClarify"]];
                        NSString* CCFilter = [self removeNull:[record valueForKey:@"CCFilter"]];
                        NSString* CustomCode = [self removeNull:[record valueForKey:@"CustomCode"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into ChiefComplaints(CCID, CCDescription, CCType, CCUserDefined, CCActive, CCClarify, CCFilter, CustomCode) Values(%@, '%@', %@, %@, %@, '%@', '%@', '%@')", CCID, CCDescription, CCType, CCUserDefined, CCActive, CCClarify, CCFilter, CustomCode];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadCert
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetCertificationTable *req = [[ServiceSvc_GetCertificationTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetCertificationTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetCertificationTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsCertification * resultArray = [mine GetCertificationTableResult];
                    NSMutableArray* array = [resultArray ClsCertification];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Certification;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsCertification* record = [array objectAtIndex:i];
                        NSString* certName = [record valueForKey:@"CertName"];
                        NSString* certUID = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"CertUID"]] ];
                        NSString* sql = [NSString stringWithFormat:@"Insert into Certification(CertName, CertUID) Values('%@', %@)", certName, certUID];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadInputs
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetInputsTable *req = [[ServiceSvc_GetInputsTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetInputsTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetInputsTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsInputs * resultArray = [mine GetInputsTableResult];
                    NSMutableArray* array = [resultArray ClsInputs];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Inputs;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsInputs* record = [array objectAtIndex:i];
                        NSString* inputID = [record valueForKey:@"InputID"];
                        NSString* inputName = [record valueForKey:@"InputName"];
                        NSString* inputDefault = [self removeNull:[record valueForKey:@"InputDefault"]];
                        NSString* inputPage = [self removeNull:[record valueForKey:@"InputPage"]];
                        NSString* inputGroup = [self removeNull:[record valueForKey:@"InputGroup"]];
                        NSString* inputGroupIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputGroupIndex"]] ];
                        NSString* inputForm = [self removeNull:[record valueForKey:@"InputForm"]];
                        NSString* inputLongDesc = [self removeNull:[record valueForKey:@"InputLongDesc"]];
                        NSString* inputShortDesc = [self removeNull:[record valueForKey:@"InputShortDesc"]];
                        NSString* inputDataType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputDataType"]]];
                        NSString* inputAlternateLabel = [self removeNull:[record valueForKey:@"InputAlternateLabel"]];
                        NSString* inputAlternateDesc = [self removeNull:[record valueForKey:@"InputAlternateDesc"]];
                        NSString* inputIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputIndex"]]];
                        NSString* inputApplyRule = [self removeNull:[record valueForKey:@"InputApplyRule"]];
                        NSString* inputApplyRuleToInputs = [self removeNull:[record valueForKey:@"InputApplyRuleToInputs"]];
                        NSString* inputRequiredField = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputRequiredField"]]];
                        NSString* inputDefaultable = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputDefaultable"]]];
                        NSString* inputVisible = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputVisible"]]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into Inputs(InputID, InputName, InputDefault, InputPage, InputGroup, InputGroupIndex, InputForm, InputLongDesc, InputShortDesc, InputDataType, InputAlternateLabel, InputAlternateDesc, InputIndex, InputApplyRule, InputApplyRuleToInputs, InputRequiredField, InputDefaultable, InputVisible) Values(%@, '%@', '%@', '%@', '%@', %@, '%@', '%@', '%@', %@, '%@', '%@', %@, '%@', '%@', %@, %@, %@)", inputID, inputName, inputDefault, inputPage, inputGroup, inputGroupIndex, inputForm, inputLongDesc, inputShortDesc, inputDataType, inputAlternateLabel, inputAlternateDesc, inputIndex, inputApplyRule, inputApplyRuleToInputs, inputRequiredField, inputDefaultable, inputVisible];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
    
}

- (int) downloadInputLookup
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetInputLookupTable *req = [[ServiceSvc_GetInputLookupTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetInputLookupTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetInputLookupTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsInputLookup * resultArray = [mine GetInputLookupTableResult];
                    NSMutableArray* array = [resultArray ClsInputLookup];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from InputLookup;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsInputLookup* record = [array objectAtIndex:i];
                        NSString* inputID = [record valueForKey:@"InputID"];
                        NSString* valueID = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"ValueID"]]];
                        NSString* valueName = [self removeNull:[record valueForKey:@"ValueName"]];
                        NSString* page = [self removeNull:[record valueForKey:@"Page"]];
                        NSString* excludedCCIDs = [self removeNull:[record valueForKey:@"ExcludedCCIDs"]];
                        NSString* excludeAllCC = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"ExcludeAllCC"]]];
                        NSString* sortIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SortIndex"]]];
                        NSString* code = [self removeNull:[record valueForKey:@"Code"]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into InputLookup(InputID, ValueID, ValueName, Page, ExcludedCCIDs, ExcludeAllCC, SortIndex, Code) Values(%@, %@, '%@', '%@', '%@', %@, %@, '%@')", inputID, valueID, valueName, page, excludedCCIDs, excludeAllCC, sortIndex, code];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}

- (int) downloadCities
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetCitiesTable *req = [[ServiceSvc_GetCitiesTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetCitiesTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetCitiesTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsCities * resultArray = [mine GetCitiesTableResult];
                    NSMutableArray* array = [resultArray ClsCities];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Cities;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsCities* record = [array objectAtIndex:i];
                        NSString* CityID = [record valueForKey:@"CityID"];
                        NSString* CityName = [record valueForKey:@"CityName"];
                        NSString* CountyID = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"CountyID"]] ];
                        NSString* ListIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"ListIndex"]]];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into Cities(CityID, CityName, CountyID, ListIndex, Active) Values(%@, '%@', %@, %@, %@)", CityID, CityName, CountyID, ListIndex, Active];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}

- (int) downloadCounties
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetCountiesTable *req = [[ServiceSvc_GetCountiesTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetCountiesTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetCountiesTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsCounties * resultArray = [mine GetCountiesTableResult];
                    NSMutableArray* array = [resultArray ClsCounties];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Counties;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsCounties* record = [array objectAtIndex:i];
                        NSString* CountyID = [record valueForKey:@"CountyID"];
                        NSString* CountyName = [record valueForKey:@"CountyName"];
                        NSString* StateID = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"StateID"]] ];
                        NSString* ListIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"ListIndex"]]];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into Counties(CountyID, CountyName, StateID, ListIndex, Active) Values(%@, '%@', %@, %@, %@)", CountyID, CountyName, StateID, ListIndex, Active];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}

- (int) downloadControlFilters
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetControlFiltersTable *req = [[ServiceSvc_GetControlFiltersTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetControlFiltersTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetControlFiltersTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsControlFilters * resultArray = [mine GetControlFiltersTableResult];
                    NSMutableArray* array = [resultArray ClsControlFilters];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from ControlFilters;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsControlFilters* record = [array objectAtIndex:i];
                        NSString* CCID = [record valueForKey:@"CCID"];
                        NSString* ControlID = [record valueForKey:@"ControlID"];
                        NSString* ControlType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"ControlType"]]];
                        NSString* RequiredField = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"RequiredField"]]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into ControlFilters(CCID, ControlID, ControlType, RequiredField) Values(%@, %@, '%@', %@)", CCID, ControlID, ControlType, RequiredField];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}

- (int) downloadCustomerContent
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetCustomerContentTable *req = [[ServiceSvc_GetCustomerContentTable alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetCustomerContentTableUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetCustomerContentTableResponse class]])
                {
                    ServiceSvc_ArrayOfClsCustomerContent * resultArray = [mine GetCustomerContentTableResult];
                    NSMutableArray* array = [resultArray ClsCustomerContent];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from CustomerContent;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsCustomerContent* record = [array objectAtIndex:i];
                        NSString* FileType = [record valueForKey:@"FileType"];
                        NSString* FileName = [self removeNull:[record valueForKey:@"FileName"]];
                        NSString* FileString = [self removeNull:[record valueForKey:@"FileString"]];
                        NSString* FileSize = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"FileSize"]]];
                        NSString* FileID = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"FileID"]]];
                        NSString* sql = [NSString stringWithFormat:@"Insert into CustomerContent(FileType, FileName, FileString, FileSize, FileID) Values('%@', '%@', '%@', %@, %@)", FileType, FileName, FileString, FileSize, FileID];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (NSInteger)getDeviceSettings
{
    NSInteger result = 0;
    @autoreleasepool {
        NSUUID* uuid = [[UIDevice currentDevice] identifierForVendor];
        NSString* machineID = [uuid UUIDString];
        //NSString* udid = [SecureUDID UDIDForDomain:DOMAIN usingkey:key];
        machineID = @"AFE9F9BF000006D9";
        [g_SETTINGS setObject:machineID forKey:@"MachineID"];
        NSInteger customerNumber = [DAO getCustomerNumber:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue]];
        if (customerNumber <= 0)
        {
            Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
            
            BOOL connectionRequired= [hostReach connectionRequired];
            if(connectionRequired)
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please establish a network connection before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                alert.tag = 0;
                return result;
            }
            else
            {
                @try {
                    ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
                    binding.logXMLInOut = NO;
                    ServiceSvc_GetCustomerID *req = [[ServiceSvc_GetCustomerID alloc] init];
                    req.MachineID = [g_SETTINGS objectForKey:@"MachineID"];
                    ServiceSoapBindingResponse* resp = [binding GetCustomerIDUsingParameters:req];
                    for (id mine in resp.bodyParts)
                    {
                        if ([mine isKindOfClass:[ServiceSvc_GetCustomerIDResponse class]])
                        {
                            NSString* customerNumberStr = [mine GetCustomerIDResult];
                            if ([customerNumberStr intValue] > 0)
                            {
                                [g_SETTINGS setObject:customerNumberStr forKey:@"CustomerID"];
                                customerNumber = [customerNumberStr intValue];
                                [DAO insertValue:@"Customer" column:@"CustomerNumber" value:customerNumberStr DB:lookupDB];
                            }
                        }
                    }
                }
                @catch (NSException *exception) {
                    result = -1;
                }
                @finally {
                    
                }
                
                if (customerNumber <= 0)
                {
                    NSString* title = [NSString stringWithFormat:@"Unregistered MachineID - %@", machineID ];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:@"Your application has not been properly registered yet. Please make sure you have registered this application and a network connection is available before rerunning this application." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    alert.tag = 0;
                }
            }
        }
        else
        {
            [g_SETTINGS setObject:[NSString stringWithFormat:@"%i",customerNumber] forKey:@"CustomerID"];
        }
    }
    return result;
}


- (int) downloadOutomes
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetOutcomes *req = [[ServiceSvc_GetOutcomes alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetOutcomesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetOutcomesResponse class]])
                {
                    ServiceSvc_ArrayOfClsOutcomes * resultArray = [mine GetOutcomesResult];
                    NSMutableArray* array = [resultArray ClsOutcomes];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from Outcomes;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsOutcomes* record = [array objectAtIndex:i];
                        NSString* OutcomeID = [record valueForKey:@"OutcomeID"];
                        NSString* TransportType = [record valueForKey:@"TransportType"];
                        
                        NSString* Description = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Description"]]];
                        NSString* SortIndex = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SortIndex"]]];
                        NSString* Active = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Active"]]];
                        NSString* AltDescription = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"AltDescription"]]];
                        NSString* TriggerID = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TriggerID"]]];
                        NSString* CustomFlag = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"CustomFlag"]]];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into Outcomes(OutcomeID, TransportType, Description, SortIndex, Active, AltDescription, TriggerID, CustomFlag) Values(%@, %@, '%@', %@, %@, '%@', %@, %@)", OutcomeID, TransportType, Description, SortIndex, Active, AltDescription, TriggerID, CustomFlag];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}

- (int) downloadOutcomeTypes
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetOutcomeTypes *req = [[ServiceSvc_GetOutcomeTypes alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetOutcomeTypesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetOutcomeTypesResponse class]])
                {
                    ServiceSvc_ArrayOfClsOutcomeTypes * resultArray = [mine GetOutcomeTypesResult];
                    NSMutableArray* array = [resultArray ClsOutcomeTypes];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from OutcomeTypes;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsOutcomeTypes* record = [array objectAtIndex:i];
                        NSString* OutcomeTypeID = [record valueForKey:@"OutcomeTypeID"];
                        NSString* OutcomeTypeDesc = [record valueForKey:@"OutcomeTypeDesc"];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into OutcomeTypes(OutcomeTypeID, OutcomeTypeDesc) Values(%@, '%@')", OutcomeTypeID, OutcomeTypeDesc];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}

- (int) downloadOutcomeRequiredSignatures
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetOutcomeRequiredSignatures *req = [[ServiceSvc_GetOutcomeRequiredSignatures alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetOutcomeRequiredSignaturesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetOutcomeRequiredSignaturesResponse class]])
                {
                    ServiceSvc_ArrayOfClsOutcomeRequiredSignatures * resultArray = [mine GetOutcomeRequiredSignaturesResult];
                    NSMutableArray* array = [resultArray ClsOutcomeRequiredSignatures];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from OutcomeRequiredSignatures;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsOutcomeRequiredSignatures* record = [array objectAtIndex:i];
                        NSString* OutcomeID = [record valueForKey:@"OutcomeID"];
                        NSString* SignatureGroupID = [record valueForKey:@"SignatureGroupID"];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into OutcomeRequiredSignatures(OutcomeID, SignatureGroupID) Values(%@, '%@')", OutcomeID, SignatureGroupID];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


- (int) downloadOutcomeRequiredItems
{
    int result = 0;
    @autoreleasepool {
        @try
        {
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetOutcomeRequiredItems *req = [[ServiceSvc_GetOutcomeRequiredItems alloc] init];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            ServiceSoapBindingResponse* resp = [binding GetOutcomeRequiredItemsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetOutcomeRequiredItemsResponse class]])
                {
                    ServiceSvc_ArrayOfClsOutcomeRequiredItems * resultArray = [mine GetOutcomeRequiredItemsResult];
                    NSMutableArray* array = [resultArray ClsOutcomeRequiredItems];
                    if ([array count] > 0)
                    {
                        NSString* sql = @"Delete from OutcomeRequiredItems;";
                        [DAO executeDelete:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsOutcomeRequiredSignatures* record = [array objectAtIndex:i];
                        NSString* OutcomeID = [record valueForKey:@"OutcomeID"];
                        NSString* OutcomeReqID = [record valueForKey:@"OutcomeReqID"];
                        NSString* InputID = [record valueForKey:@"InputID"];
                        NSString* OutcomeReqDescription = [record valueForKey:@"OutcomeReqDescription"];
                        
                        NSString* sql = [NSString stringWithFormat:@"Insert into OutcomeRequiredItems(OutcomeID, OutcomeReqID, InputID, OutcomeReqDescription) Values(%@, %@, %@, '%@')", OutcomeID, OutcomeReqID, InputID, OutcomeReqDescription];
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                    }
                    result = 1;
                }
            }
            
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    return result;
}


//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 0)
//    {
//        if (buttonIndex == 0)
//        {
//            exit(0);
//        }
//    }
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSelectUnitClick:(UIButton *)sender {
    functionSelected = 0;
    PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    popoverView.arrayUnits = [DAO loadUnits:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Filter:@""];
    popoverView.functionSelected = 0;
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popOver.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popOver.popoverContentSize = CGSizeMake(280, 305);
    popoverView.delegate = self;
    
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}

- (IBAction)UserClick:(UIButton *)sender {
    if (unitSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unit Not Selected" message:@"Please select a unit first." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    functionSelected = 1;
    PopOverWithSearchViewController *popoverView =[[PopOverWithSearchViewController alloc] initWithNibName:@"PopOverWithSearchViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    NSString* sql = [NSString stringWithFormat:@"Select u.UserID, u.UserFirstname, u.UserLastName, u.UserAddress, u.UserCity, u.UserState, u.UserZip, u.UserAge, u.UserUnit, u.UserActive, u.UserCertification, u.UserCertStart, u.UserCertEnd, u.UserCertNum, u.UserPassword, u.UserGroup, UserIDNumber from users u left join certification c on u.UserCertification = c.CertUID where UserActive = %d", 1]; //unitSelected
    self.usersArray = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    popoverView.arrayUsers = self.usersArray;
    popoverView.functionSelected = 1;
    popoverView.unitSelectedID = unitSelected;
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popOver.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popOver.popoverContentSize = CGSizeMake(280, 305);
    popoverView.delegate = self;
    
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}

- (IBAction)btnShiftClick:(UIButton*)sender {
    functionSelected = 3;
    
    PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
    
    NSString* sql = @"Select shiftID, 'Shifts', ShiftName from Shifts";
    @synchronized(g_SYNCLOOKUPDB)
    {
        self.shiftArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    
    popoverView.arrays = self.shiftArray;
    popoverView.functionSelected = 4;
    
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popOver.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popOver.popoverContentSize = CGSizeMake(250, 260);
    popoverView.delegate = self;
    
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}


-(void)didTap
{
    PopoverViewController *p = (PopoverViewController *)popOver.contentViewController;
    if (functionSelected == 0)
    {
        ClsUnits* unit =  [p.arrayUnits objectAtIndex:p.rowSelected];
        [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUnit = unit;
        //     NSLog(@".objClsUnit.unitID; : %d", [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUnit.unitID);
        [btnUnit setTitle:unit.unitDescription forState:UIControlStateNormal];
        unitSelected = unit.unitID;
        btnUnit.tag =  unitSelected;
        btnUnit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    else if (functionSelected == 1)
    {
        ClsUsers* user =  [p.arrayUsers objectAtIndex:p.rowSelected];
        [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers = user;
        NSLog(@".objClsUsers.userFirstName : %@", [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers.userFirstName);
        NSLog(@".objClsUsers.userLastName : %@", [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers.userLastName);
        [btnUser  setTitle:[NSString stringWithFormat:@"%@, %@", user.userLastName, user.userFirstName] forState:UIControlStateNormal];
        userSelected = user.userID;
        btnUser.tag =  p.rowSelected;
        btnUser.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    else if (functionSelected == 3)
    {
        
        NSString* shift = ((ClsTableKey *)[shiftArray objectAtIndex:p.rowSelected]).desc;
        NSString* shiftID = [NSString stringWithFormat:@"%d", ((ClsTableKey *)[shiftArray objectAtIndex:p.rowSelected]).key];
        [btnShift setTitle:shift forState:UIControlStateNormal];
        [g_SETTINGS setObject:shift forKey:@"Shift"];
        [g_SETTINGS setObject:shiftID forKey:@"ShiftID"];
        
        btnShift.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    [self.popOver dismissPopoverAnimated:YES];
    self.popOver = nil;
}


- (IBAction)LoginClick:(id)sender {
    if ((unitSelected < 0) || (userSelected < 0))
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unit/User Not Selected" message:@"Please select a unit and user before continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else if ([btnShift.titleLabel.text isEqualToString:@"Shift"])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Shift Not Selected" message:@"Please select a shift before continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    NSString* machineID = [g_SETTINGS objectForKey:@"MachineID"];
    ClsUsers* user;
    if ([machineID isEqualToString:@"LOCAL"])
    {
        user = [self.usersArray objectAtIndex:1];
        unitSelected = 1;
        [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers = user;
    }
    else
    {
        user = [self.usersArray objectAtIndex:btnUser.tag];
    }
    NSString* encryptedPass = user.userPassword;
    
    // Sharma testing
    NSString* enteredPass = [self hmacsha1:txtPassword.text];
    if ([enteredPass isEqualToString:encryptedPass])
    {
        [g_SETTINGS setObject:[NSString stringWithFormat:@"%d",user.userID] forKey:@"UserID"];
        g_CREWARRAY = [[NSMutableArray alloc] init];
        ClsCrewInfo* crew = [[ClsCrewInfo alloc] init];
        crew.role = @"Primary";
        crew.Id = [NSString stringWithFormat:@"%d", user.userID ];
        crew.name = [NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName ];
        [g_SETTINGS setObject:crew.name forKey:@"UserName"];
        crew.certification = [NSString stringWithFormat:@"%@", user.userIDNumber];
        [g_CREWARRAY addObject:crew];
        if (unitSelected >= 0)
        {
            [g_SETTINGS setObject:[NSString stringWithFormat:@"%@",btnUnit.titleLabel.text] forKey:@"UnitName"];
            [g_SETTINGS setObject:[NSString stringWithFormat:@"%d",unitSelected] forKey:@"Unit"];
        }
        else
        {
            [g_SETTINGS setObject:[NSString stringWithFormat:@"%d",user.userUnit] forKey:@"Unit"];
            [g_SETTINGS setObject:[NSString stringWithFormat:@"%@",btnUnit.titleLabel.text] forKey:@"UnitName"];
        }
        [self performSegueWithIdentifier:@"LoginToMainSegue" sender:sender];
    }
    else
    {
        txtPassword.text = @"";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Wrong Username/Password" message:@"Your username/password did not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
}

- (void) processLogin
{
    
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

-(void) doneRegisterClick
{
    registered = true;
    NSString* customerStr = [g_SETTINGS objectForKey:@"CustomerID"];
    NSString* machineID = [g_SETTINGS objectForKey:@"MachineID"];
    NSString* sql = [NSString stringWithFormat:@"Insert into Customer(CustomerNumber, MachineID) Values(%@, '%@');", customerStr, machineID];
    [DAO insertCustomer:sql DB:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue]];
    
    for (UIView* subview in self.view.subviews)
    {
        if (subview.tag == 12345)
        {
            [subview removeFromSuperview];
        }
    }
    
    if (![machineID isEqualToString:@"LOCAL"])
    {
        txtPassword.text = @"";
        [btnUnit setTitle:@"Click to select Unit" forState:UIControlStateNormal];
        [btnShift setTitle:@"Shift" forState:UIControlStateNormal];
        [btnUser setTitle:@"Enter username" forState:(UIControlStateNormal)];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"Downloading data";
        hud.detailsLabelText = @"Please wait...";
        hud.mode = MBProgressHUDAnimationFade;
        [self.view addSubview:hud];
        [hud showWhileExecuting:@selector(setupDB) onTarget:self withObject:Nil animated:YES];
    }
    else
    {
        userSelected = 69;
        unitSelected = 0;
        [g_SETTINGS setObject:@"1" forKey:@"Shift"];
        [g_SETTINGS setObject:@"1" forKey:@"ShiftID"];
        NSString* sql = [NSString stringWithFormat:@"Select u.UserID, u.UserFirstname, u.UserLastName, u.UserAddress, u.UserCity, u.UserState, u.UserZip, u.UserAge, u.UserUnit, u.UserActive, u.UserCertification, u.UserCertStart, u.UserCertEnd, u.UserCertNum, u.UserPassword, u.UserGroup, c.CertName as UserIDNumber from users u left join certification c on u.UserCertification = c.CertUID where UserActive = %d", 1]; //unitSelected
        self.usersArray = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
}


#pragma mark- UI controls adjustments
-(void) setViewUI
{
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    NSLog(@"System Version is %f",ver_float);
    
    if (ver_float >= 7.0) {
        CGRect rectIvTopBar = self.iVTopBar.frame;
        rectIvTopBar = CGRectMake(rectIvTopBar.origin.x, rectIvTopBar.origin.y + 20, rectIvTopBar.size.width, rectIvTopBar.size.height - 20);
        self.iVTopBar.frame = rectIvTopBar;
    }
    
    
}

- (IBAction)btnExitClick:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Exit FH Medic" message:@"Are you sure you want to exit the application?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 0;
    [alert show];
    //self.parentViewController;
    
    //exit(0);
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            exit(0);
            //abort();
            //assert(<#e#>);
        } else
        {
            
        }
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtPassword)
    {
        [self LoginClick:btnLogin];
    }
    return YES;
}

- (void) doneSearchUserTap
{
    PopoverViewController *p = (PopoverViewController *)popOver.contentViewController;
    if (functionSelected == 1)
    {
        self.usersArray = p.arrayUsers;
        ClsUsers* user =  [p.arrayUsers objectAtIndex:p.rowSelected];
        [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers = user;
        NSLog(@".objClsUsers.userFirstName : %@", [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers.userFirstName);
        NSLog(@".objClsUsers.userLastName : %@", [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers.userLastName);
        [btnUser  setTitle:[NSString stringWithFormat:@"%@, %@", user.userLastName, user.userFirstName] forState:UIControlStateNormal];
        userSelected = user.userID;
        btnUser.tag =  p.rowSelected;
        btnUser.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    [self.popOver dismissPopoverAnimated:YES];
    self.popOver = nil;
}

@end
