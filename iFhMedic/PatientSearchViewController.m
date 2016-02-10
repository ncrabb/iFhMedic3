//
//  PatientSearchViewController.m
//  iRescueMedic
//
//  Created by admin on 4/13/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PatientSearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DDPopoverBackgroundView.h"
#import "Reachability.h"
#import "global.h"
#import "DAO.h"
#import "ServiceSvc.h"
#import "ClsSearch.h"

@interface PatientSearchViewController ()

@end

@implementation PatientSearchViewController
@synthesize tvPatient;
@synthesize txtSearch;
@synthesize btnDob;
@synthesize btnName;
@synthesize btnSsn;
@synthesize rowSelected;
@synthesize delegate;
@synthesize array;
@synthesize lblDob;
@synthesize lblFname;
@synthesize lblLastName;
@synthesize lblSSN;
@synthesize txtFirstName;
@synthesize txtLastName;
@synthesize popoverController;
@synthesize popover;
@synthesize patientArray;
@synthesize patientSelected;

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
    searchOption = 1;
    tvPatient.layer.borderColor = [UIColor blackColor].CGColor;
    tvPatient.layer.borderWidth = 5.0f;
    [self hideName];
    patientArray = [[NSMutableArray alloc] init];
    rowSelected = -1;
}

-(void) hideName
{
    lblFname.hidden = true;
    lblDob.hidden = true;
    lblLastName.hidden = true;
    txtFirstName.hidden = true;
    txtLastName.hidden = true;
    btnDob.hidden = true;
    lblSSN.hidden = false;
    txtSearch.hidden = false;
}

-(void) showName
{
    lblFname.hidden = false;
    lblDob.hidden = false;
    lblLastName.hidden = false;
    txtFirstName.hidden = false;
    txtLastName.hidden = false;
    btnDob.hidden = false;
    [btnDob setBackgroundImage:[UIImage imageNamed:@"btn_background.png"] forState:UIControlStateNormal];
    lblSSN.hidden = true;
    txtSearch.hidden = true;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDobClick:(UIButton*)sender {
    CalendarViewController *popoverView =[[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(400, 260);
    popoverView.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnSsnClick:(id)sender {
    searchOption = 1;
    [btnSsn setBackgroundImage:[UIImage imageNamed:@"check_box"] forState:UIControlStateNormal];
    [btnName setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [btnDob setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [self hideName];
}

- (IBAction)btnNameClick:(id)sender {
    searchOption = 2;
    [btnSsn setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [btnName setBackgroundImage:[UIImage imageNamed:@"check_box"] forState:UIControlStateNormal];
    [btnDob setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [self showName];
}



- (IBAction)btnSearchClick:(id)sender {
    [txtSearch resignFirstResponder];
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [patientArray removeAllObjects];
    [tvPatient reloadData];
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try
        {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            if (searchOption == 1)
            {
                if (txtSearch.text.length > 1)
                {
                    ServiceSvc_SearchForPatientBySSN *req = [[ServiceSvc_SearchForPatientBySSN alloc] init];
                    req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
                    req.MachineID = nil;
                    req.SSN = txtSearch.text;

                    ServiceSoapBindingResponse* resp = [binding SearchForPatientBySSNUsingParameters:req];
                    for (id mine in resp.bodyParts)
                    {
                        if ([mine isKindOfClass:[ServiceSvc_SearchForPatientBySSNResponse class]])
                        {
                            ServiceSvc_ArrayOfClsSearchName* resultArray = [mine SearchForPatientBySSNResult];
                            NSMutableArray* sarray = [resultArray ClsSearchName];
                            
                            for (int i = 0; i < [sarray count]; i++)
                            {
                                ServiceSvc_ClsSearchName* record = [sarray objectAtIndex:i];
                                ClsSearch* patient = [[ClsSearch alloc] init];
                                patient.ticketID = [[record valueForKey:@"TicketID"] integerValue];
                                
                                patient.firstName = [record valueForKey:@"FirstName"];
                                patient.lastName = [record valueForKey:@"LastName"];
                                patient.mi = [record valueForKey:@"Mi"];
                                patient.dob = [record valueForKey:@"Dob"];
                                patient.race = [record valueForKey:@"Race"];
                                patient.sex = [record valueForKey:@"Sex"];
                                patient.phone = [record valueForKey:@"Phone"];
                                patient.height = [record valueForKey:@"Height"];
                                patient.weight = [record valueForKey:@"Weight"];
                                patient.dlNumber = [record valueForKey:@"DlNumber"];
                                patient.ssn = [record valueForKey:@"Ssn"];
                                patient.address1 = [record valueForKey:@"Address1"];
                                patient.address2 = [record valueForKey:@"Address2"];
                                patient.city = [record valueForKey:@"City"];
                                patient.state = [record valueForKey:@"State"];
                                patient.zip = [record valueForKey:@"Zip"];
                                patient.county = [record valueForKey:@"County"];
                                patient.meds = [record valueForKey:@"Meds"];
                                patient.dos = [record valueForKey:@"Dos"];
                                patient.allenv = [record valueForKey:@"Allenv"];
                                patient.allfood = [record valueForKey:@"Allfood"];
                                patient.allinsects = [record valueForKey:@"Allinsects"];
                                patient.allmeds = [record valueForKey:@"Allmeds"];
                                patient.allalerts = [record valueForKey:@"Allalerts"];
                                patient.histCardio = [record valueForKey:@"HistCardio"];
                                patient.histCancer = [record valueForKey:@"HistCancer"];
                                patient.histNeuro = [record valueForKey:@"HistNeuro"];
                                patient.histGastro = [record valueForKey:@"HistGastro"];
                                patient.histGenit = [record valueForKey:@"HistGenit"];
                                patient.histInfect = [record valueForKey:@"HistInfect"];
                                patient.histEndo = [record valueForKey:@"HistEndo"];
                                patient.histResp = [record valueForKey:@"HistResp"];
                                patient.histPsych = [record valueForKey:@"HistPsych"];
                                patient.histWomen = [record valueForKey:@"HistWomen"];
                                patient.histMusc = [record valueForKey:@"HistMusc"];
                                patient.insMedid = [record valueForKey:@"InsMedid"];
                                patient.insMaid = [record valueForKey:@"InsMaid"];
                                patient.insConame = [record valueForKey:@"InsConame"];
                                patient.insId = [record valueForKey:@"InsId"];
                                patient.insGroup = [record valueForKey:@"InsGroup"];
                                patient.insName = [record valueForKey:@"InsName"];
                                patient.insDob = [record valueForKey:@"InsDob"];
                                patient.insSSN = [record valueForKey:@"InsSSN"];
                                //patient = [record valueForKey:@"City"];
                                
                                [patientArray addObject:patient];
                            }
                            result = 1;
                            if (patientArray.count > 0)
                            {
                                [tvPatient reloadData];
                            }
                        }
                    }
                    
                }  // end of txtSearch.length > 1
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FHMedic for iPad" message:@"Please enter a SSN to search." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
            }  // end if search option == 1
            else
            {
                if (txtFirstName.text.length > 1 && txtLastName.text.length > 0 && btnDob.titleLabel.text.length > 0)
                {
                    ServiceSvc_SearchForPatientByName *req = [[ServiceSvc_SearchForPatientByName alloc] init];
                    req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
                    req.MachineID = nil;
                    req.FirstName = txtFirstName.text;
                    req.LastName = txtLastName.text;
                    NSRange range11 = NSMakeRange(5,2);
                    NSString* year = [btnDob.titleLabel.text substringToIndex:4];
                    NSString* month = [btnDob.titleLabel.text substringWithRange:range11];
                    range11 = NSMakeRange(8,2);
                    NSString* day = [btnDob.titleLabel.text substringWithRange:range11];
                    req.DOB = [NSString stringWithFormat:@"%@/%@/%@",month,day,year];
                    
                    ServiceSoapBindingResponse* resp = [binding SearchForPatientByNameUsingParameters:req];
                    for (id mine in resp.bodyParts)
                    {
                        if ([mine isKindOfClass:[ServiceSvc_SearchForPatientByNameResponse class]])
                        {
                            ServiceSvc_ArrayOfClsSearchName* resultArray = [mine SearchForPatientByNameResult];
                            NSMutableArray* sarray = [resultArray ClsSearchName];
                            
                            for (int i = 0; i < [sarray count]; i++)
                            {
                                ServiceSvc_ClsSearchName* record = [sarray objectAtIndex:i];
                                ClsSearch* patient = [[ClsSearch alloc] init];
                                patient.ticketID = [[record valueForKey:@"TicketID"] integerValue];
                                
                                patient.firstName = [record valueForKey:@"FirstName"];
                                patient.lastName = [record valueForKey:@"LastName"];
                                patient.mi = [record valueForKey:@"Mi"];
                                patient.dob = [record valueForKey:@"Dob"];
                                patient.race = [record valueForKey:@"Race"];
                                patient.sex = [record valueForKey:@"Sex"];
                                patient.phone = [record valueForKey:@"Phone"];
                                patient.height = [record valueForKey:@"Height"];
                                patient.weight = [record valueForKey:@"Weight"];
                                patient.dlNumber = [record valueForKey:@"DlNumber"];
                                patient.ssn = [record valueForKey:@"Ssn"];
                                patient.address1 = [record valueForKey:@"Address1"];
                                patient.address2 = [record valueForKey:@"Address2"];
                                patient.city = [record valueForKey:@"City"];
                                patient.state = [record valueForKey:@"State"];
                                patient.zip = [record valueForKey:@"Zip"];
                                patient.county = [record valueForKey:@"County"];
                                patient.meds = [record valueForKey:@"Meds"];
                                patient.dos = [record valueForKey:@"Dos"];
                                patient.allenv = [record valueForKey:@"Allenv"];
                                patient.allfood = [record valueForKey:@"Allfood"];
                                patient.allinsects = [record valueForKey:@"Allinsects"];
                                patient.allmeds = [record valueForKey:@"Allmeds"];
                                patient.allalerts = [record valueForKey:@"Allalerts"];
                                patient.histCardio = [record valueForKey:@"HistCardio"];
                                patient.histCancer = [record valueForKey:@"HistCancer"];
                                patient.histNeuro = [record valueForKey:@"HistNeuro"];
                                patient.histGastro = [record valueForKey:@"HistGastro"];
                                patient.histGenit = [record valueForKey:@"HistGenit"];
                                patient.histInfect = [record valueForKey:@"HistInfect"];
                                patient.histEndo = [record valueForKey:@"HistEndo"];
                                patient.histResp = [record valueForKey:@"HistResp"];
                                patient.histPsych = [record valueForKey:@"HistPsych"];
                                patient.histWomen = [record valueForKey:@"HistWomen"];
                                patient.histMusc = [record valueForKey:@"HistMusc"];
                                patient.insMedid = [record valueForKey:@"InsMedid"];
                                patient.insMaid = [record valueForKey:@"InsMaid"];
                                patient.insConame = [record valueForKey:@"InsConame"];
                                patient.insId = [record valueForKey:@"InsId"];
                                patient.insGroup = [record valueForKey:@"InsGroup"];
                                patient.insName = [record valueForKey:@"InsName"];
                                patient.insDob = [record valueForKey:@"InsDob"];
                                patient.insSSN = [record valueForKey:@"InsSSN"];
                                //patient = [record valueForKey:@"City"];
                                
                                [patientArray addObject:patient];
                            }
                            result = 1;
                            if (patientArray.count > 0)
                            {
                                [tvPatient reloadData];
                            }
                        }
                    }
                    
                    
                } // end of check length
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FHMedic for iPad" message:@"Please enter a patient first name, last name, and DOB to search." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                
            } // end of if search option == 2
            
            
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            
        }
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


- (void) saveHistoryData
{
    if (self.patientSelected == nil)
    {return;}
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1601", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    if (count > 0)
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1601", patientSelected.histCardio, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1602", patientSelected.histCancer, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1603", patientSelected.histNeuro, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1604", patientSelected.histGastro, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1605", patientSelected.histGenit, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1606", patientSelected.histInfect, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1607", patientSelected.histEndo, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1608", patientSelected.histResp, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1609", patientSelected.histPsych, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1610", patientSelected.histWomen, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1611", patientSelected.histMusc, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];

        }
        
    }
    else
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1601, 0, 1, @"", @"", patientSelected.histCardio];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1602, 0, 1, @"", @"", patientSelected.histCancer];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1603, 0, 1, @"", @"", patientSelected.histNeuro];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1604, 0, 1, @"", @"", patientSelected.histGastro];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1605, 0, 1, @"", @"", patientSelected.histGenit];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1606, 0, 1, @"", @"", patientSelected.histInfect];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1607, 0, 1, @"", @"", patientSelected.histEndo];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1608, 0, 1, @"", @"", patientSelected.histResp];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1609, 0, 1, @"", @"", patientSelected.histPsych];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1610, 0, 1, @"", @"", patientSelected.histWomen];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1611, 0, 1, @"", @"", patientSelected.histMusc];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1613, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1614, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 21211, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 21219, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
}


- (void) saveMedData
{
    if (self.patientSelected == nil)
    {return;}
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1433", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    if (count > 0)
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1433", patientSelected.meds, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    else
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1433, 0, 1, @"", @"", patientSelected.meds];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
}

- (void) saveAllergyData
{
    if (self.patientSelected == nil)
    {return;}
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1433", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    if (count > 0)
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1224", patientSelected.allenv, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1225", patientSelected.allfood, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1226", patientSelected.allinsects, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1227", patientSelected.allmeds, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
        }
    }
    else
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1224, 0, 1, @"", @"", patientSelected.allenv];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1225, 0, 1, @"", @"", patientSelected.allfood];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1226, 0, 1, @"", @"", patientSelected.allinsects];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1227, 0, 1, @"", @"", patientSelected.allmeds];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
}

- (void) saveInsuranceData
{
    if (self.patientSelected == nil)
    {return;}
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1120", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    if (count > 0)
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1120", patientSelected.insMedid, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1121", patientSelected.insMaid, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1122", patientSelected.insConame, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
 
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1123", patientSelected.insId, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1124", patientSelected.insGroup, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
 
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1125", patientSelected.insName, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1126", patientSelected.insDob, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1127", patientSelected.insSSN, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    else
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1120, 0, 1, @"", @"", patientSelected.insMedid];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1121, 0, 1, @"", @"", patientSelected.insMaid];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1122, 0, 1, @"", @"", patientSelected.insConame];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1123, 0, 1, @"", @"", patientSelected.insId];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1124, 0, 1, @"", @"", patientSelected.insGroup];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
 
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1125, 0, 1, @"", @"", patientSelected.insName];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1126, 0, 1, @"", @"", patientSelected.insDob];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1127, 0, 1, @"", @"", patientSelected.insSSN];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
}



- (void) saveOutcomeData
{
    if (self.patientSelected == nil)
    {return;}
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString*  sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1402", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    if (count > 0)
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1228", patientSelected.allalerts, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    else
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1402, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1403, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1420, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1421, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1422, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1423, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1424, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1425, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1426, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1427, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1428, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1434, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 22011, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 22012, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 22013, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 22014, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1228, 0, 1, @"", @"", patientSelected.allalerts];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1029, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1031, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1429, 0, 1, @"", @"", @" "];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
}

- (IBAction)btnSelectClick:(id)sender {
    if (rowSelected > -1)
    {
        patientSelected = [patientArray objectAtIndex:rowSelected];
        [self saveMedData];
        [self saveAllergyData];
        [self saveHistoryData];
        [self saveOutcomeData];
        [self saveInsuranceData];
        [delegate doneSelectPatient];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FHMedic for iPad" message:@"Please select a patient from the list." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
    }
}

- (IBAction)btnBackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == txtSearch)
    {
        if ([string isEqualToString:@""])
        {
            NSLog(@"backspace button pressed");
        }
        else
            
        {
            if([textField.text length]>10)
                return NO;
            
            else
            {
                if(([textField.text length] == 3) || ([textField.text length] == 6))
                {
                    textField.text = [NSString stringWithFormat:@"%@-", textField.text];
                }
                return YES;
            }
        }
        return YES;
    }
    
    else
        return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return patientArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if ([patientArray count] > indexPath.row)
    {
        ClsSearch* patient = [patientArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ - DOB:%@   %@, %@, %@ %@ - DOS:%@", patient.firstName, patient.lastName, patient.dob, patient.address1, patient.city, patient.state, patient.zip, patient.dos];

    }
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    rowSelected = indexPath.row;
   // [delegate doneSelectPatient];
}

-(void) doneClick
{
    CalendarViewController *p = (CalendarViewController *)self.popover.contentViewController;
    if (p.dpDate.date.description.length >= 10)
    {
        [btnDob  setTitle:[p.dpDate.date.description substringToIndex:10] forState:UIControlStateNormal];
    }
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;

}

@end
