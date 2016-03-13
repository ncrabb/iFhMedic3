//
//  NarrativeViewController.m
//  iRescueMedic
//
//  Created by Nathan on 8/26/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NarrativeViewController.h"
#import "global.h"
#import "DAO.h"
#import "ClsTicketInputs.h"
#import "DDPopoverBackgroundView.h"
#import "QAMessageViewController.h"
#import "ClsTreatmentInputs.h"
#import "ClsTableKey.h"
#import "ClsUsers.h"
#import "ClsUnits.h"
#import "ClsSignatureImages.h"
#import "ClsSignatureTypes.h"
#import "ClsTicketChanges.h"
#import <WebKit/WebKit.h>

#import <libxml/xmlmemory.h>
#import <libxml/debugXML.h>
#import <libxml/HTMLtree.h>
#import <libxml/xmlIO.h>
#import <libxml/xinclude.h>
#import <libxml/catalog.h>
#import "xslt.h"
#import "xsltInternals.h"
#import "transform.h"
#import "xsltutils.h"

@interface NarrativeViewController ()
{
    WKWebView* webView1;
}

@end

@implementation NarrativeViewController
@synthesize svNarrative;
@synthesize newTicket;
@synthesize ticketID;
@synthesize delegate;
@synthesize btnNameLabel;
@synthesize scNarrative;
@synthesize popover;
@synthesize currentIndex;
@synthesize btnCopyNarrative;
@synthesize ticketInputsData;
@synthesize loadTreatment;
@synthesize btnQAMessage;

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
    [self.navigationController setNavigationBarHidden:TRUE];
    self.svNarrative.delegate = self;
    svNarrative.layer.borderColor = [UIColor blackColor].CGColor;
    svNarrative.layer.borderWidth = 5.0f;
    [self setViewUI];
    currentIndex = 0;
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }
    CGRect rect = CGRectMake(0, 112, 1024, 481);
    webView1 = [[WKWebView alloc] initWithFrame:rect];
    [self.view addSubview:webView1];
    webView1.hidden = true;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString* patientName;
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    btnNameLabel.title = patientName;
    [btnNameLabel setTintColor:[UIColor whiteColor]];
    
    [self loadData];
    [self setControl];
}



- (void) loadData
{
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1430 and InputName = 'Medic'", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    if (count > 0)
    {
        self.newTicket = NO;
    }
    else
    {
        self.newTicket = YES;
    }
    if (!self.newTicket)
    {
        NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and inputID = 1430 and  InputName = 'Medic'", ticketID ];
        @synchronized(g_SYNCDATADB)
        {
            self.ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        if ([[ticketInputsData objectForKey:@"1430:0:1"] length] > 0 && ([[ticketInputsData objectForKey:@"1430:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            int asciiCode1 = 13;
            NSString *string1 = [NSString stringWithFormat:@"%c", asciiCode1];
            NSString* temp = [ticketInputsData objectForKey:@"1430:0:1"];
            NSString* text = [temp stringByReplacingOccurrencesOfString:string1 withString:@""];
            self.svNarrative.text = text;
        }
        else
        {
            self.svNarrative.text = @" ";
        }
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSvNarrative:nil];
    [super viewDidUnload];
}

-(void) viewWillDisappear:(BOOL)animated
{
    // [[NSNotificationCenter defaultCenter] removeObserver:self];
    //  [self saveTab];
    [self saveNarretiveData];
    btnCopyNarrative.hidden = NO;
    svNarrative.userInteractionEnabled = YES;
    scNarrative.selectedSegmentIndex = 0;
    [super viewWillDisappear:animated];
}

- (void) saveTab
{
    NSString* sqlStr;
    int asciiCode1 = 13;
    NSString *string1 = [NSString stringWithFormat:@"\n%c", asciiCode1];
    NSString* text = [svNarrative.text stringByReplacingOccurrencesOfString:@"\n" withString:string1];
    
    @synchronized(g_SYNCDATADB)
    {
        if (self.newTicket)
        {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1430, 0, 1, @"", @"", text];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            
        }
        else
        {
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1430", svNarrative.text, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
        }
    }
}


- (IBAction)btnQueueClick:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Quit" message:@"Are you sure you want to exit the application?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 0;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            exit(0);
        } else
        {
            
        }
    }
}

- (void)saveNarretiveData
{
    NSString* sqlStr;
    NSInteger count;
    NSString* status = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ( [status isEqualToString:@"3"] || [status isEqualToString:@"5"])
    {
        NSString* userID = [g_SETTINGS objectForKey:@"UserID"];
        sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketChanges where TicketID = %@", ticketID ];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        NSDate* sourceDate = [NSDate date];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd-yyyy hh:mm:ss"];
        NSString* timeAdded = [dateFormat stringFromDate:sourceDate];
        
        if ((svNarrative.text != nil) &&  ![svNarrative.text isEqualToString:[ticketInputsData objectForKey:@"1430:0:1"]])
        {
            count++;
            sqlStr = [NSString stringWithFormat:@"Insert into TicketChanges(LocalTicketID, TicketID, ChangeID, ChangeMade, ChangeTime, ModifiedBy, ChangeInputID, OriginalValue) Values(0, %@, %d, 'Input changed from %@ to %@', '%@', %@, 1430, '%@')", ticketID, count , [ticketInputsData objectForKey:@"1430:0:1"] ,[self removeNull:svNarrative.text], timeAdded, userID, [ticketInputsData objectForKey:@"1430:0:1"]];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }
        
    }
    int asciiCode1 = 13;
    NSString *string1 = [NSString stringWithFormat:@"\n%c", asciiCode1];
    NSString* text = [svNarrative.text stringByReplacingOccurrencesOfString:@"\n" withString:string1];
    if(self.currentIndex == 0)
    {
        
        sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1430 and InputSubID = 0", ticketID ];
        NSInteger count;
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (count > 0)
        {
            self.newTicket = NO;
        }
        else
        {
            self.newTicket = YES;
        }
        
        if (self.newTicket)
        {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1430, 0, 1, @"", @"Medic", [self removeNull:text]];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }
        
        else
        {
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1430 and InputSubID = 0", [self removeNull:text], ticketID];

            @synchronized(g_SYNCDATADB)
            {
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        
    }
    else if(self.currentIndex == 1)
    {
        
        sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1430 and InputSubID = 1", ticketID ];
        NSInteger count;
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (count > 0)
        {
            self.newTicket = NO;
        }
        else
        {
            self.newTicket = YES;
        }
        
        @synchronized(g_SYNCDATADB)
        {
            if (self.newTicket)
            {
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1430, 1, 1, @"", @"Auto", [self removeNull:text]];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                
            }
            else
            {
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1430 and InputSubID = 1", [self removeNull:text], ticketID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
            }
        }
        
    }
    else if(self.currentIndex == 2)
    {
        
        sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1430 and InputSubID = 2", ticketID ];
        NSInteger count;
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (count > 0)
        {
            self.newTicket = NO;
        }
        else
        {
            self.newTicket = YES;
        }
        
        @synchronized(g_SYNCDATADB)
        {
            if (self.newTicket)
            {
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', 'Incident', '%@')", ticketID, 1430, 2, 1, @"", [self removeNull:text]];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                
            }
            else
            {
                sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1430 and InputSubID = 2", [self removeNull:text], ticketID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
            }
        }
        
    }
    
    
}

- (IBAction)btnMainMenuCick:(id)sender {
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [delegate dismissViewControl];
}

- (NSString *)getAutoNarrativeData
{
    bool primaryComplaint = false;
    NSString* chiefComplaint = @"";
    
    //        NSString* vitalCount = @"";
    
    NSString* sqlStr = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketUnitNumber, TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and (deleted is null or deleted = 0)", ticketID ];
    
    NSMutableDictionary* inputsData;
    
    @synchronized(g_SYNCDATADB)
    {
        inputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    NSString* crewIds = [[inputsData objectForKey:@"TicketCrew"] stringByReplacingOccurrencesOfString:@"|" withString:@","];
    NSString* crewIDStr;
    if (crewIds.length >= 1)
    {
        if ([[crewIds substringFromIndex:(crewIds.length - 1)] isEqualToString:@","])
        {
            crewIDStr = [crewIds substringToIndex:[crewIds length] - 1];
        }
        else
        {
            crewIDStr = crewIds;
        }
    }
    
    NSMutableArray* crewData;
    NSMutableArray* unitData;
    sqlStr = [NSString stringWithFormat:@"Select * from users where userID in (%@)", crewIDStr ];
    @synchronized(g_SYNCLOOKUPDB)
    {
        crewData = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"UnitID = %@", [inputsData objectForKey:@"TicketID"] ];
    @synchronized(g_SYNCLOOKUPDB)
    {
        unitData = [DAO loadUnits:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Filter:sqlStr];
    }
    
    NSMutableString* crewList = [[NSMutableString alloc] init];
    for (int i =0; i< [crewData count]; i++)
    {
        ClsUsers* user = [crewData objectAtIndex:i];
        if (i == [crewData count] - 1)
        {
            [crewList appendString:[NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName]];
        }
        else
        {
            [crewList appendString:[NSString stringWithFormat:@"%@ %@ | ", user.userFirstName, user.userLastName]];
        }
        
    }
    
    NSMutableString* unitList = [[NSMutableString alloc] init];
    for (int i =0; i< [unitData count]; i++)
    {
        ClsUnits* unit = [unitData objectAtIndex:i];
        if (i == [crewData count] - 1)
        {
            [unitList appendString:[NSString stringWithFormat:@"%@", unit.unitDescription]];
        }
        else
        {
            [unitList appendString:[NSString stringWithFormat:@"%@ | ", unit.unitDescription]];
        }
        
    }
    
    
    NSMutableString* narrativeText = [[NSMutableString alloc] init];
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@", ticketID ];
    NSMutableDictionary* ticketInputData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if ([[ticketInputData objectForKey:@"1008:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1008:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        chiefComplaint = [ticketInputData objectForKey:@"1008:0:1"];
        primaryComplaint = true;
    }
    
    if ([[ticketInputData objectForKey:@"1010:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1010:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        if (primaryComplaint)
        {
            chiefComplaint = [NSString stringWithFormat:@"%@ and %@", [ticketInputData objectForKey:@"1008:0:1"],[ticketInputData objectForKey:@"1010:0:1"] ];
        }
        else
        {
            chiefComplaint = [ticketInputData objectForKey:@"1010:0:1"];
        }
    }
    
    if ([[ticketInputData objectForKey:@"1002:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1002:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* DOSStr = [NSString stringWithFormat:@"On %@ ", [ticketInputData objectForKey:@"1002:0:1"]];
        
        
        [narrativeText appendString:DOSStr];
    }
    [narrativeText appendString:[NSString stringWithFormat:@"EMS Unit %@ responded to a call with a chief complaint of %@. ",unitList,  chiefComplaint]];
    
    NSInteger age = 0;
    if ([[ticketInputData objectForKey:@"1119:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1119:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* ageStr = [NSString stringWithFormat:@"Patient was a %@ year old", [ticketInputData objectForKey:@"1119:0:1"]];
        [narrativeText appendString:ageStr];
        age = 1;
    }
    
    if ([[ticketInputData objectForKey:@"1105:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1105:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        if (age ==1)
        {
            NSString* sexStr = [NSString stringWithFormat:@" %@. ", [ticketInputData objectForKey:@"1105:0:1"] ];
            [narrativeText appendString:sexStr];
        }
        
    }
    else
    {
        if (age == 1)
        {
            [narrativeText appendString:@". "];
        }
    }
    
    NSString* noallergies = @" Patient has no known drug allergies. ";
    if ([[ticketInputData objectForKey:@"1227:0:1"] length] > 1 && ([[ticketInputData objectForKey:@"1227:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        NSString* drugAllergy = [ticketInputData objectForKey:@"1227:0:1"];
        if ([drugAllergy containsString:@"NKDA"])
        {
            [narrativeText appendString:@" Patient has no known drug allergies (NKDA). "];
        }
        else
        {
            NSString* allergyStr = [NSString stringWithFormat:@" Allergies to the following medications were noted: %@. ", [ticketInputData objectForKey:@"1227:0:1"]];
            [narrativeText appendString:allergyStr];
        }
    }
    else
    {
        [narrativeText appendString:noallergies];
    }
    
    if ([[ticketInputData objectForKey:@"1224:0:1"] length] > 1 && ([[ticketInputData objectForKey:@"1224:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* allergyStr = [NSString stringWithFormat:@"Environmental allergies included: %@. ", [ticketInputData objectForKey:@"1224:0:1"]];
        [narrativeText appendString:allergyStr];
    }
    
    if ([[ticketInputData objectForKey:@"1225:0:1"] length] > 1 && ([[ticketInputData objectForKey:@"1225:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* allergyStr = [NSString stringWithFormat:@"Food allergies included: %@. ", [ticketInputData objectForKey:@"1225:0:1"]];
        [narrativeText appendString:allergyStr];
    }
    
    if ([[ticketInputData objectForKey:@"1226:0:1"] length] > 1 && ([[ticketInputData objectForKey:@"1226:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* allergyStr = [NSString stringWithFormat:@"Insect allergies included: %@. ", [ticketInputData objectForKey:@"1226:0:1"]];
        [narrativeText appendString:allergyStr];
    }
    if ([[ticketInputData objectForKey:@"1228:0:1"] length] > 1 && ([[ticketInputData objectForKey:@"1228:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* allergyStr = [NSString stringWithFormat:@"\n\nEMS exposure: %@.", [ticketInputData objectForKey:@"1228:0:1"]];
        [narrativeText appendString:allergyStr];
    }
    [narrativeText appendString:@"\n\n"];
    
    
    NSString* histStr = [NSString stringWithFormat:@"Select count(*) from ticketInputs where ticketID = %@ and inputID in (1433, 1601, 1602, 1603, 1604, 1605, 1606, 1607, 1608, 1609, 1610) and (inputValue is not null or inputValue != '(null)')", ticketID];
    NSInteger histCount;
    @synchronized(g_SYNCDATADB)
    {
        histCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:histStr];
    }
    if (histCount > 0)
    {
        NSString* histHeader = @"Patient gave the following medical history to EMT personel. ";
        [narrativeText appendString:histHeader];
        if ([[ticketInputData objectForKey:@"1433:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1433:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* medStr = [NSString stringWithFormat:@"Current medications being taken include: %@. ", [ticketInputData objectForKey:@"1433:0:1"]];
            [narrativeText appendString:medStr];
        }
        
        if ([[ticketInputData objectForKey:@"1601:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1601:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"Cardiovascular history included: %@. ", [ticketInputData objectForKey:@"1601:0:1"]];
            [narrativeText appendString:histStr];
        }
        if ([[ticketInputData objectForKey:@"1602:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1602:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"Patient has a history of cancer, including %@. ", [ticketInputData objectForKey:@"1602:0:1"]];
            [narrativeText appendString:histStr];
        }
        if ([[ticketInputData objectForKey:@"1603:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1603:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"Neurological history includes %@. ", [ticketInputData objectForKey:@"1603:0:1"]];
            [narrativeText appendString:histStr];
        }
        if ([[ticketInputData objectForKey:@"1604:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1604:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"Patient reports a gastrointestinal history of %@. ", [ticketInputData objectForKey:@"1604:0:1"]];
            [narrativeText appendString:histStr];
        }
        
        if ([[ticketInputData objectForKey:@"1605:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1605:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"Genitourinary history includes %@. ", [ticketInputData objectForKey:@"1605:0:1"]];
            [narrativeText appendString:histStr];
        }
        
        if ([[ticketInputData objectForKey:@"1606:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1606:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"Patient reports an infectious history of %@. ", [ticketInputData objectForKey:@"1606:0:1"]];
            [narrativeText appendString:histStr];
        }
        
        if ([[ticketInputData objectForKey:@"1607:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1607:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"Metabolic - endocrine history includes %@. ", [ticketInputData objectForKey:@"1607:0:1"]];
            [narrativeText appendString:histStr];
        }
        
        if ([[ticketInputData objectForKey:@"1608:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1608:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"Patient reports a respiratory history of %@. ", [ticketInputData objectForKey:@"1608:0:1"]];
            [narrativeText appendString:histStr];
        }
        
        if ([[ticketInputData objectForKey:@"1609:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1609:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"Psychological history includes %@. ", [ticketInputData objectForKey:@"1609:0:1"]];
            [narrativeText appendString:histStr];
        }
        if ([[ticketInputData objectForKey:@"1610:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1610:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"Patient reports the following women's health issues: %@. ", [ticketInputData objectForKey:@"1610:0:1"]];
            [narrativeText appendString:histStr];
        }
        [narrativeText appendString:@"\n\n"];
    }
    
    NSString* assessHeader = @"Patient was assessed with the following responses noted.\n\n";
    [narrativeText appendString:assessHeader];
    
    
    if ([[ticketInputData objectForKey:@"1235:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1235:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nMotor Response was: %@. ", [ticketInputData objectForKey:@"1235:0:1"]];
        [narrativeText appendString:str];
    }
    NSInteger verbal = 0;
    if ([[ticketInputData objectForKey:@"1236:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1236:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nVerbal Response was rated at a: %@ ", [ticketInputData objectForKey:@"1236:0:1"]];
        [narrativeText appendString:str];
        verbal = 1;
    }
    
    if ([[ticketInputData objectForKey:@"1237:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1237:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        if (verbal == 1)
        {
            NSString* str = [NSString stringWithFormat:@", and Eye Response was rated at a: %@. ", [ticketInputData objectForKey:@"1237:0:1"]];
            [narrativeText appendString:str];
        }
        else
        {
            NSString* str = [NSString stringWithFormat:@"\nEye Response was rated at a: %@. ", [ticketInputData objectForKey:@"1237:0:1"]];
            [narrativeText appendString:str];
        }
    }
    else
    {
        if (verbal == 1)
        {
            [narrativeText appendString:@". "];
        }
    }
    
    
    
    NSInteger airway = 0;
    if ([[ticketInputData objectForKey:@"1239:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1239:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nAirway was : %@ ", [ticketInputData objectForKey:@"1239:0:1"]];
        [narrativeText appendString:str];
        airway = 1;
    }
    
    if ([[ticketInputData objectForKey:@"1240:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1240:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        if (airway == 1)
        {
            NSString* str = [NSString stringWithFormat:@", and breathing was : %@. ", [ticketInputData objectForKey:@"1240:0:1"]];
            [narrativeText appendString:str];
        }
        else
        {
            NSString* str = [NSString stringWithFormat:@"\nBreathing was: %@. ", [ticketInputData objectForKey:@"1237:0:1"]];
            [narrativeText appendString:str];
        }
    }
    else
    {
        if (airway == 1)
        {
            [narrativeText appendString:@". "];
        }
    }
    
    NSInteger crt = 0;
    if ([[ticketInputData objectForKey:@"1242:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1242:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nCRT (Capillary Refill Time) was %@", [ticketInputData objectForKey:@"1242:0:1"]];
        [narrativeText appendString:str];
        crt = 1;
    }
    
    if ([[ticketInputData objectForKey:@"1243:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1243:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        if (crt == 1)
        {
            NSString* str = [NSString stringWithFormat:@", and skin was: %@. ", [ticketInputData objectForKey:@"1243:0:1"]];
            [narrativeText appendString:str];
        }
        else
        {
            NSString* str = [NSString stringWithFormat:@"\nSkin was: %@. ", [ticketInputData objectForKey:@"1237:0:1"]];
            [narrativeText appendString:str];
        }
    }
    else
    {
        if (crt == 1)
        {
            [narrativeText appendString:@". "];
        }
    }
    
    if ([[ticketInputData objectForKey:@"1244:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1244:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nAVPU was %@. ", [ticketInputData objectForKey:@"1244:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1272:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1272:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nOrientation was %@. ", [ticketInputData objectForKey:@"1272:0:1"]];
        [narrativeText appendString:str];
    }
    
    
    if ([[ticketInputData objectForKey:@"1283:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1283:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nHead/Face was %@. ", [ticketInputData objectForKey:@"1283:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1284:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1284:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nNeck was %@. ", [ticketInputData objectForKey:@"1284:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1285:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1285:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nLungs were %@. ", [ticketInputData objectForKey:@"1285:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1286:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1286:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nChest was %@. ", [ticketInputData objectForKey:@"1286:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1287:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1287:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nABD was %@. ", [ticketInputData objectForKey:@"1287:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1288:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1288:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nPelvis was %@. ", [ticketInputData objectForKey:@"1288:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1270:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1270:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nExt was %@. ", [ticketInputData objectForKey:@"1270:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1271:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1271:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nBack was %@. ", [ticketInputData objectForKey:@"1271:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1273:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1273:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nPsychosocial was %@. ", [ticketInputData objectForKey:@"1273:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1280:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1280:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nStress level was %@. ", [ticketInputData objectForKey:@"1280:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1281:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1281:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nAnxiety level was %@. ", [ticketInputData objectForKey:@"1281:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1282:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1282:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nCooperativeness level was %@. ", [ticketInputData objectForKey:@"1282:0:1"]];
        [narrativeText appendString:str];
    }
    
    
    NSInteger motor = 0;
    if ([[ticketInputData objectForKey:@"1245:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1245:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nMotor rated at %@", [ticketInputData objectForKey:@"1245:0:1"]];
        [narrativeText appendString:str];
        motor = 1;
    }
    
    if ([[ticketInputData objectForKey:@"1246:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1246:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        if (motor == 1)
        {
            NSString* str = [NSString stringWithFormat:@", and sensory was: %@. ", [ticketInputData objectForKey:@"1246:0:1"]];
            [narrativeText appendString:str];
        }
        else
        {
            NSString* str = [NSString stringWithFormat:@"\nSensory was: %@. ", [ticketInputData objectForKey:@"1246:0:1"]];
            [narrativeText appendString:str];
        }
    }
    else
    {
        if (motor == 1)
        {
            [narrativeText appendString:@". "];
        }
    }
    
    
    NSInteger speech = 0;
    if ([[ticketInputData objectForKey:@"1247:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1247:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nSpeech was %@", [ticketInputData objectForKey:@"1247:0:1"]];
        [narrativeText appendString:str];
        speech = 1;
    }
    
    if ([[ticketInputData objectForKey:@"1249:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1249:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        if (speech == 1)
        {
            NSString* str = [NSString stringWithFormat:@", and eyes were: %@. ", [ticketInputData objectForKey:@"1249:0:1"]];
            [narrativeText appendString:str];
        }
        else
        {
            NSString* str = [NSString stringWithFormat:@"\nEyes were: %@. ", [ticketInputData objectForKey:@"1249:0:1"]];
            [narrativeText appendString:str];
        }
    }
    else
    {
        if (speech == 1)
        {
            [narrativeText appendString:@". "];
        }
    }
    
    if ([[ticketInputData objectForKey:@"1240:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1240:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"\nOverall, general assessment: %@.\n", [ticketInputData objectForKey:@"1240:0:1"]];
        [narrativeText appendString:str];
        speech = 1;
    }
    
    
    
    
    
    sql = [NSString stringWithFormat:@"Select count(distinct inputInstance) from TicketInputs where TicketID = %@ and InputID in (3001) and (deleted is null or deleted = 0)", ticketID];
    
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSInteger NumOfVitals = count;
    if (NumOfVitals > 0)
    {
        NSString* vitalDesc = [NSString stringWithFormat:@"%d set of vitals were taken for this incident. ",
                               NumOfVitals ];
        // svNarrative.text = [narrativeText stringByAppendingString:vitalDesc];
        [narrativeText appendString:vitalDesc];
        for (int i = 1; i<= NumOfVitals; i++)
        {
            if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3001:0:%d", i]]] length] > 0 )
            {
                [self appendVital:ticketInputData text:narrativeText searchFor:[NSString stringWithFormat:@"%d", i]];
            }
        }
        
        [narrativeText appendString:@"\n"];
        
    }
    
    sql = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID > 2000 and InputID < 2099 and inputsubid = 1", ticketID];
    NSInteger NumOftreatments =0;
    @synchronized(g_SYNCDATADB)
    {
        NumOftreatments = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (NumOftreatments > 0)
    {
        NSString* treatmentDesc = [NSString stringWithFormat:@"\nThe following %d treatments were performed on the patients. ", NumOftreatments ];
        [narrativeText appendString:treatmentDesc];
        
        NSString* sql = [NSString stringWithFormat:@"Select * from TicketInputs where TicketID = %@ and InputID > 2000 and InputID < 2099 order by InputID, inputInstance, inputSubID", ticketID ];
        NSMutableArray* treatmentsData;
        NSMutableArray* treatmentArray = [[NSMutableArray alloc] init];;
        @synchronized(g_SYNCDATADB)
        {
            treatmentsData = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
        NSInteger inputID = 0;
        NSInteger prevInputID = 0;
        NSInteger prevInputInstance = 0;
        
        for (int i = 0; i< [treatmentsData count]; i++)
        {
            ClsTicketInputs* ticketInput = (ClsTicketInputs*) [treatmentsData objectAtIndex:i];
            inputID = ticketInput.inputId;
            if ((inputID != prevInputID) || ( ticketInput.inputInstance != prevInputInstance) )
            {
                if (prevInputID != 0)
                {
                    [treatmentArray addObject:loadTreatment];
                }
                self.loadTreatment = [[ClsTreatments alloc] init];
                loadTreatment.treatmentID = ticketInput.inputId;
                loadTreatment.treatmentDesc = ticketInput.inputPage;
                prevInputID = inputID;
                prevInputInstance = ticketInput.inputInstance;
                self.loadTreatment.arrayTreatmentInputValues = [[NSMutableArray alloc] init];
                ClsTreatmentInputs *input = [[ClsTreatmentInputs alloc ] init];
                input.inputID = ticketInput.inputSubId;
                input.inputName = ticketInput.inputName;
                input.inputValue = ticketInput.inputValue;
                [self.loadTreatment.arrayTreatmentInputValues addObject:input];
            }
            else
            {
                ClsTreatmentInputs *input = [[ClsTreatmentInputs alloc ] init];
                input.inputID = ticketInput.inputSubId;
                input.inputName = ticketInput.inputName;
                input.inputValue = ticketInput.inputValue;
                [self.loadTreatment.arrayTreatmentInputValues addObject:input];
            }
            
            
        }
        
        [treatmentArray addObject:loadTreatment];
        
        
        for (int i=0; i<[treatmentArray count]; i++ )
        {
            
            ClsTreatments* treatment = [treatmentArray objectAtIndex:i];
            
            ClsTreatmentInputs *input = [treatment.arrayTreatmentInputValues objectAtIndex:0];
            
            
            NSString* treatmentDetail;
            
            if (treatment.treatmentID != 2011)
            {
                treatmentDetail= [NSString stringWithFormat:@"%@ was started at %@. ", treatment.treatmentDesc, input.inputValue];
            }
            else
            {
                treatmentDetail= [NSString stringWithFormat:@"%@ was administered at %@. ", treatment.treatmentDesc, input.inputValue];
            }
            [narrativeText appendString:treatmentDetail];
            
            NSString* temp = @"The following details were noted for this treatment: ";
            [narrativeText appendString:temp];
            for(int i=1;i<[treatment.arrayTreatmentInputValues count];i++)
            {
                ClsTreatmentInputs *inputs = [treatment.arrayTreatmentInputValues objectAtIndex:i];
                // if ([self removeNull:inputs.inputValue].length > 0)
                {
                    NSString* temp1 = [NSString stringWithFormat:@"%@: %@ ", inputs.inputName, [self removeNull:inputs.inputValue]];
                    [narrativeText appendString:temp1];
                    if (i != [treatment.arrayTreatmentInputValues count] -1)
                    {
                        // [narrativeText appendString:@", "];
                    }
                }
                
            }
            [narrativeText appendString:@". "];
            
        }
    }
    [narrativeText appendString:@"\n\n"];
    if ([self removeNull:[ticketInputData objectForKey:@"1401:0:1"]].length > 0)
    {
        NSString* outcomeHeader = [NSString stringWithFormat:@"Outcome for this incident: %@. ", [self removeNull:[ticketInputData objectForKey:@"1401:0:1"]]];
        [narrativeText appendString:outcomeHeader];
    }
    else
    {
        NSString* outcomeHeader = [NSString stringWithFormat:@"Outcome for this incident: . "];
        [narrativeText appendString:outcomeHeader];
    }
    NSInteger transported = 0;
    if ([[ticketInputData objectForKey:@"1402:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1042:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* histStr = [NSString stringWithFormat:@"Patient was transported to %@ ", [ticketInputData objectForKey:@"1402:0:1"]];
        [narrativeText appendString:histStr];
        transported = 1;
    }
    if ([[ticketInputData objectForKey:@"1403:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1403:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        NSString* personalChoice = [NSString stringWithFormat:@"(%@)", [ticketInputData objectForKey:@"1403:0:1"]];
        [narrativeText appendString:personalChoice];
        if (transported == 1)
        {
            NSString* str = [NSString stringWithFormat:@", escorted by %@. ", [ticketInputData objectForKey:@"1422:0:1"]];
            [narrativeText appendString:str];
        }
        else
        {
            NSString* str = [NSString stringWithFormat:@" Escorted by %@. ", [ticketInputData objectForKey:@"1422:0:1"]];
            [narrativeText appendString:str];
        }
    }
    else
    {
        if (transported == 1)
        {
            [narrativeText appendString:@". "];
        }
    }
    
    NSInteger personal = 0;
    if ([[ticketInputData objectForKey:@"1420:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1420:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* histStr = [NSString stringWithFormat:@"Patient personal items included %@ ", [ticketInputData objectForKey:@"1420:0:1"]];
        [narrativeText appendString:histStr];
        personal = 1;
    }
    if ([[ticketInputData objectForKey:@"1421:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1421:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        if (personal == 1)
        {
            NSString* str = [NSString stringWithFormat:@", which were given to: %@. ", [ticketInputData objectForKey:@"1421:0:1"]];
            [narrativeText appendString:str];
        }
        
    }
    else
    {
        if (personal == 1)
        {
            [narrativeText appendString:@". "];
        }
    }
    
    
    if ([[ticketInputData objectForKey:@"1023:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1023:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* histStr = [NSString stringWithFormat:@"The condition of the patient upon arrival was: %@. ", [ticketInputData objectForKey:@"1023:0:1"]];
        [narrativeText appendString:histStr];
    }
    
    
    
    NSInteger care = 0;
    if ([[ticketInputData objectForKey:@"1045:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1045:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* histStr = [NSString stringWithFormat:@"Patient care was transfered at: %@ ", [ticketInputData objectForKey:@"1045:0:1"]];
        [narrativeText appendString:histStr];
        care = 1;
    }
    
    if ([[ticketInputData objectForKey:@"1046:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1046:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        if (care == 1)
        {
            NSString* outcomeStr = [NSString stringWithFormat:@"and the unit was clear at: %@.", [ticketInputData objectForKey:@"1046:0:1"]];
            [narrativeText appendString:outcomeStr ];
        }
        else
        {
            NSString* outcomeStr = [NSString stringWithFormat:@"The unit was clear at %@.", [ticketInputData objectForKey:@"1046:0:1"]];
            [narrativeText appendString:outcomeStr ];
        }
        
    }
    else
    {
        if (care == 1)
        {
            [narrativeText appendString:@"."];
        }
    }
    return narrativeText;
    
}

- (IBAction)btnSegmentControlClick:(id)sender {
    [self saveNarretiveData];
    currentIndex = scNarrative.selectedSegmentIndex;
    
    if(scNarrative.selectedSegmentIndex == 0)
    {
        webView1.hidden = true;
        btnCopyNarrative.hidden = NO;
        svNarrative.userInteractionEnabled = YES;
        
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1430 and InputName = 'Medic'", ticketID ];
        NSInteger count;
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        if (count > 0)
        {
            self.newTicket = NO;
        }
        else
        {
            self.newTicket = YES;
        }
        if (!self.newTicket)
        {
            NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and inputID = 1430 and  InputName = 'Medic'", ticketID ];
            NSMutableDictionary* ticketInputData;
            @synchronized(g_SYNCDATADB)
            {
                ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if ([[ticketInputData objectForKey:@"1430:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1430:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
            {
                int asciiCode1 = 13;
                NSString *string1 = [NSString stringWithFormat:@"%c", asciiCode1];
                NSString* temp = [ticketInputData objectForKey:@"1430:0:1"];
                NSString* text = [temp stringByReplacingOccurrencesOfString:string1 withString:@""];
                self.svNarrative.text = text;
            }
            else
            {
                self.svNarrative.text = @" ";
            }
        }
        else
        {
            self.svNarrative.text = @" ";
            
        }
        
    }
    else if (scNarrative.selectedSegmentIndex == 1)
    {
        btnCopyNarrative.hidden = YES;
        //  NSString *narrativeText = [self getAutoNarrativeData];
        webView1.hidden = false;
        NSString *narrativeText = [self loadPcrXslt];
        [webView1 loadHTMLString:narrativeText baseURL:nil];
        
        //    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[narrativeText dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        //   self.svNarrative.attributedText = attributedString;
        
        svNarrative.userInteractionEnabled = NO;
    }
    else if(scNarrative.selectedSegmentIndex == 2)
    {
        webView1.hidden = true;
        btnCopyNarrative.hidden = YES;
        svNarrative.userInteractionEnabled = YES;
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1430 and InputName = 'Incident'", ticketID ];
        NSInteger count ;
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        if (count > 0)
        {
            self.newTicket = NO;
        }
        else
        {
            self.newTicket = YES;
        }
        if (!self.newTicket)
        {
            NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and inputID = 1430 and  InputName = 'Incident'", ticketID ];
            NSMutableDictionary* ticketInputData;
            @synchronized(g_SYNCDATADB)
            {
                ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if ([[ticketInputData objectForKey:@"1430:2:1"] length] > 0 && ([[ticketInputData objectForKey:@"1430:2:1"] rangeOfString:@"(null)"].location == NSNotFound))
            {
                int asciiCode1 = 13;
                NSString *string1 = [NSString stringWithFormat:@"%c", asciiCode1];
                NSString* temp = [ticketInputData objectForKey:@"1430:2:1"];
                NSString* text = [temp stringByReplacingOccurrencesOfString:string1 withString:@""];
                self.svNarrative.text = text;
            }
            else
            {
                self.svNarrative.text = @" ";
            }
        }
        else
        {
            self.svNarrative.text = @" ";
        }
    }
}

- (IBAction)btnValidateClick:(UIButton*)sender {
    [self saveTab];
    ValidateViewController *popoverView =[[ValidateViewController alloc] initWithNibName:@"ValidateViewController" bundle:nil];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(540, 590);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void) doneSelectValidate
{
    ValidateViewController *p = (ValidateViewController *)self.popover.contentViewController;
    
    [self.popover dismissPopoverAnimated:YES];
    
    if (p.ticketComplete)
    {
        [delegate dismissViewControl];
    }
    
    else if (p.tagID >= 0)
    {
        [self.delegate dismissViewControlAndStartNew:p.tagID];
    }
}




- (void) appendVital:(NSMutableDictionary*)ticketInputData text:(NSMutableString*)narrativeText searchFor:(NSString*)searchString
{
    if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3001:0:%@", searchString]]] length] > 0 )
    {
        
        NSString* str1 = [ticketInputData objectForKey:[NSString stringWithFormat:@"3012:0:%@", searchString]];
        NSString* str2 = [ticketInputData objectForKey:[NSString stringWithFormat:@"3001:0:%@", searchString]];
        NSString* str3 = [NSString stringWithFormat:@"Vital number %@ was taken %@ at %@ ", searchString, [self removeNull:str1], [self removeNull:str2]];
        [narrativeText appendString:str3];
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3013:0:%@", searchString]]] length] > 0 )
        {
            NSString* str4 = [NSString stringWithFormat:@"by %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3013:0:%@", searchString]]]];
            [narrativeText appendString:str4];
        }
        else
        {
            [narrativeText appendString:@". "];
        }
        
        [narrativeText appendString:@"Results were as follows. "];
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3005:0:%@", searchString]]] length] > 0 )
        {
            NSString* str5 = [NSString stringWithFormat:@"Heart rate was %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3005:0:%@", searchString]]]];
            [narrativeText appendString:str5];
        }
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3004:0:%@", searchString]]] length] > 0 )
        {
            NSString* str6 = [NSString stringWithFormat:@"Respiratory rate was %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3004:0:%@", searchString]]]];
            [narrativeText appendString:str6];
        }
        
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3002:0:%@", searchString]]] length] > 0 )
        {
            NSString* str7 = [NSString stringWithFormat:@"Sys BP was %@, ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3002:0:%@", searchString]]]];
            [narrativeText appendString:str7];
        }
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3003:0:%@", searchString]]] length] > 0 )
        {
            NSString* str8 = [NSString stringWithFormat:@"and Diast BP was %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3003:0:%@", searchString]]]];
            [narrativeText appendString:str8];
        }
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3008:0:%@", searchString]]] length] > 0 )
        {
            NSString* str9 = [NSString stringWithFormat:@"Glucose levels were %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3008:0:%@", searchString]]]];
            [narrativeText appendString:str9];
        }
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3010:0:%@", searchString]]] length] > 0 )
        {
            NSString* str10 = [NSString stringWithFormat:@"Patient's temperature was taken and showed %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3010:0:%@", searchString]]]];
            [narrativeText appendString:str10];
        }
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3015:0:%@", searchString]]] length] > 0 )
        {
            NSString* str11 = [NSString stringWithFormat:@"EKG showed %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3015:0:%@", searchString]]]];
            [narrativeText appendString:str11];
        }
        
    }
    
}

- (NSString *)removeHTML:(NSString*) originalText {
    static NSRegularExpression *regexp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regexp = [NSRegularExpression regularExpressionWithPattern:@"<[^>]+>" options:kNilOptions error:nil];
    });
    
    NSString* temp = [regexp stringByReplacingMatchesInString:originalText options:kNilOptions range:NSMakeRange(0, originalText.length) withTemplate:@""];
    return temp;
}

- (NSString*) removeNull:(NSString*)str
{
    if ([str length] > 0 && ([str rangeOfString:@"(null)"].location == NSNotFound))
    {
        return [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }
    else
    {
        return @"";
    }
}

- (IBAction)btnCopyAutoClick:(UIButton *)sender
{
    if(scNarrative.selectedSegmentIndex == 0 || scNarrative.selectedSegmentIndex == 2)
    {
        NSString *narrativeText = [self loadPcrXslt];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[narrativeText dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.svNarrative.attributedText = attributedString;
        
    }
}


#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
}

- (IBAction)btnQuickClick:(UIButton*)sender {
    QuickViewController *popoverView =[[QuickViewController alloc] initWithNibName:@"QuickViewController" bundle:nil];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];
    self.popover.popoverContentSize = CGSizeMake(540, 580);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (void) doneQuickButton
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

- (IBAction)btnQAMessageClick:(UIButton *)sender {
    
    NSString* sql = [NSString stringWithFormat:@"Select ticketAdminNotes from Tickets where TicketID = %@", ticketID ];
    NSString* notes;
    @synchronized(g_SYNCDATADB)
    {
        notes = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    QAMessageViewController* popoverView = [[QAMessageViewController alloc] initWithNibName:@"QAMessageViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    popoverView.adminNotes = notes;
    popoverView.ticketID = [ticketID intValue];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    
    if (notes.length > 1)
    {
        self.popover.popoverContentSize = CGSizeMake(502, 455);
    }
    else
    {
        self.popover.popoverContentSize = CGSizeMake(502, 355);
    }
    CGRect rect = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 16, sender.frame.size.width, sender.frame.size.height);
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (void) setControl
{
    
    NSString* outcomeVal;
    NSString* sqlOutcome = [NSString stringWithFormat:@"select InputValue from TicketInputs where ticketID = %@ and InputID = 1401", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        outcomeVal = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlOutcome];
    }
    
    
    NSString* outcomeTypeSql = [NSString stringWithFormat:@"SELECT outcomeID, Description, outcomeTypeDesc FROM Outcomes o inner join OutcomeTypes d on d.OutcomeTypeID = o.transportType where description = '%@'", outcomeVal];
    
    NSMutableArray* outcomeTypeArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        outcomeTypeArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:outcomeTypeSql WithExtraInfo:NO];
    }
    NSString* sql;
    if (outcomeTypeArray.count > 0)
    {
        ClsTableKey* key = [outcomeTypeArray objectAtIndex:0];
        if ([key.desc isEqualToString:@"Transport"])
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from Inputs where InputRequiredField = 1 and inputpage like 'Comment' union select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = %ld" , outcomeVal, key.key];
        }
        else
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = %ld" , outcomeVal, key.key];
            
        }
        
    }
    else
    {
        sql = @"SELECT distinct i.inputid, i.inputname, i.inputpage FROM inputs i where i.inputrequiredfield = 1 and i.inputpage like 'Comment%'";
    }
    NSMutableArray* requiredArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        requiredArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    for (int i = 0; i < [requiredArray count]; i++)
    {
        ClsTableKey* key = [requiredArray objectAtIndex:i];
        if (key.key == 1430)
        {
            [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} forState:UIControlStateSelected];
            [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} forState:UIControlStateNormal];
        }
        
    }
}

- (IBAction)btnScratchpadClick:(UIButton*)sender
{
    ScratchpadViewController* popoverView = [[ScratchpadViewController alloc] initWithNibName:@"ScratchpadViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    popoverView.delegate = self;
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    
    
    self.popover.popoverContentSize = CGSizeMake(600, 550);
    
    CGRect rect = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 5, sender.frame.size.width, sender.frame.size.height);
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    
}

- (void) doneScratchpad
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}


- (void) caenelScratchpad
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}



-(NSString*) loadPcrXslt
{
    NSString* querySql =[NSString stringWithFormat:@"Select inputID, inputvalue from ticketInputs where ticketID = %@ and inputPage != 'Assessment' and (inputValue is not null and inputValue != '' and inputValue != ' ' and inputValue != '(null)') order by inputID", ticketID];
    NSMutableArray* dataArray;
    @synchronized(g_SYNCDATADB)
    {
        dataArray = [DAO SelectInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:querySql];
    }
    NSMutableString* htmlString = [[NSMutableString alloc] init];
    
    [htmlString appendString:@"<PCR>"];
    
    NSString* logoStr = @"Select FileString from customerContent where FileType = 'Logo'";
    NSString* logo;
    @synchronized(g_SYNCLOOKUPDB)
    {
        logo =  [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:logoStr];
    }
    [htmlString appendString:[NSString stringWithFormat:@"<LOGO>data:image/png;base64,%@</LOGO>", logo]];
    
    NSString* sql1 = [NSString stringWithFormat:@"Select ticketStatus from tickets where ticketId = %@", ticketID];
    NSString* status;
    NSString* statusStr;
    @synchronized(g_SYNCDATADB)
    {
        status = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql1];
    }
    if ([status isEqualToString:@"1"])
    {
        statusStr = @"Incomplete";
    }
    else if ([status isEqualToString:@"2"])
    {
        statusStr = @"Complete";
    }
    else if ([status isEqualToString:@"3"])
    {
        statusStr = @"Review";
    }
    else if ([status isEqualToString:@"4"])
    {
        statusStr = @"Transfer";
    }
    [htmlString appendString:[NSString stringWithFormat:@"<STATUS>%@</STATUS>", statusStr]];
    NSDate *date = [[NSDate alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [htmlString appendString:[NSString stringWithFormat:@"<TIMECREATED>%@</TIMECREATED>", dateString]];
    
    [htmlString appendString:@"<CREW>"];
    
    NSString* sql9101 = [NSString stringWithFormat:@"Select inputValue from ticketinputs where ticketId = %@ and inputID = 9101", ticketID];
    NSString* input9101;
    
    @synchronized(g_SYNCDATADB)
    {
        input9101 = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql9101];
    }
    
    if (input9101.length > 0 && (![input9101 isEqualToString:@" "]) && (![input9101 isEqualToString:@"(null)"]) )
    {
        [htmlString appendString:[NSString stringWithFormat:@"Initial Crew - %@ Participating Crew -", input9101]];
    }
    
    NSMutableArray* crewData;
    NSMutableArray* unitData;
    
    NSString* sqlcrew = [NSString stringWithFormat:@"Select ticketcrew from tickets where ticketId = %@", ticketID];
    NSString* crews;
    @synchronized(g_SYNCDATADB)
    {
        crews = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlcrew];
    }
    
    NSString* crewIds = [crews stringByReplacingOccurrencesOfString:@"|" withString:@","];
    NSString* crewIDStr;
    if (crewIds.length >= 1)
    {
        if ([[crewIds substringFromIndex:(crewIds.length - 1)] isEqualToString:@","])
        {
            crewIDStr = [crewIds substringToIndex:[crewIds length] - 1];
        }
        else
        {
            crewIDStr = crewIds;
        }
    }
    NSString* sqlUnitNum = [NSString stringWithFormat:@"Select ticketUnitNumber from tickets where ticketId = %@", ticketID];
    NSString* unitNum;
    
    @synchronized(g_SYNCDATADB)
    {
        unitNum = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlUnitNum];
    }
    
    NSString* crewSql = [NSString stringWithFormat:@"Select * from users where userID in (%@)", crewIDStr ];
    @synchronized(g_SYNCLOOKUPDB)
    {
        crewData = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:crewSql];
    }
    NSString* unitsql = [NSString stringWithFormat:@"UnitID = %@", unitNum];
    @synchronized(g_SYNCLOOKUPDB)
    {
        unitData = [DAO loadUnits:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Filter:unitsql];
    }
    
    NSMutableString* crewList = [[NSMutableString alloc] init];
    for (int i =0; i< [crewData count]; i++)
    {
        ClsUsers* user = [crewData objectAtIndex:i];
        if (i == [crewData count] - 1)
        {
            [crewList appendString:[NSString stringWithFormat:@"%@ %@ %@", user.userFirstName, user.userLastName, user.userIDNumber]];
        }
        else
        {
            [crewList appendString:[NSString stringWithFormat:@"%@ %@ %@, ", user.userFirstName, user.userLastName, user.userIDNumber]];
        }
        
    }
    
    NSMutableString* unitList = [[NSMutableString alloc] init];
    for (int i =0; i< [unitData count]; i++)
    {
        ClsUnits* unit = [unitData objectAtIndex:i];
        if (i == [unitData count] - 1)
        {
            [unitList appendString:[NSString stringWithFormat:@"%@", unit.unitDescription]];
        }
        else
        {
            [unitList appendString:[NSString stringWithFormat:@"%@ | ", unit.unitDescription]];
        }
        
    }
    [htmlString appendString:[NSString stringWithFormat:@"%@ - %@", unitList, crewList]];
    [htmlString appendString:@"</CREW>"];
    
    if ([[g_SETTINGS objectForKey:@"TrackShift"] isEqualToString:@"1"] )
    {
        NSString* sqlShift = [NSString stringWithFormat:@"Select ticketShift from tickets where ticketId = %@", ticketID];
        NSString* shift;
        @synchronized(g_SYNCDATADB)
        {
            shift = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlShift];
        }
        if (shift.length > 0 && (![shift isEqualToString:@" "]) && (![shift isEqualToString:@"(null)"]) )
        {
            [htmlString appendString:[NSString stringWithFormat:@"<SHIFT>%@</SHIFT>", shift]];
        }
    }
    
    for (int i = 0; i < dataArray.count; i++)
    {
        NSString* data = [dataArray objectAtIndex:i];
        if (![data containsString:@"ID1430"])
        {
            [htmlString appendString:data];
        }
    }
    
    NSString* sql = [NSString stringWithFormat:@"Select count(distinct inputInstance) from TicketInputs where TicketID = %@ and inputID = 1800 and (deleted is null or deleted = 0)", ticketID];
    
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSInteger NumOfAssesment = count;
    NSInteger minInstance;
    
    NSString* sqlMin = [NSString stringWithFormat:@"Select min(inputInstance) from TicketInputs where TicketID = %@ and inputID = 1800 and (deleted is null or deleted = 0)", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        minInstance = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlMin];
    }
    
    int i = minInstance-1;
    if (i < 0)
    {
        i = 0;
    }
    [htmlString appendString:@"<MultiAssessment>1</MultiAssessment>"];
    
    for (int j = minInstance; j< minInstance+NumOfAssesment; j++)
    {
        //  ClsAssesment* assesment1 = [[ClsAssesment alloc] init];
        
        NSInteger count = -1;
        i++;
        while (count < 0)
        {
            NSString* sqlStr = [NSString stringWithFormat:@"Select InputID, deleted from TicketInputs where TicketID = %@ and InputID = 1800 and InputInstance = %d", ticketID , i];
            
            @synchronized(g_SYNCDATADB)
            {
                count = [DAO getCountWithCheck:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            if (count == -1)
            {
                i++;
            }
        }
        
        NSMutableArray* assessmentArray;
        
        sql = [NSString stringWithFormat:@"Select inputID, inputvalue from TicketInputs where TicketID = %@ and (inputPage = 'Assessment' or inputpage = 'Assesment') and inputInstance = %d and (deleted is null or deleted = 0)", ticketID, i];
        @synchronized(g_SYNCDATADB)
        {
            assessmentArray = [DAO SelectInputsAssessment:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            
        }
        [htmlString appendString:@"<Assessment>"];
        for (int i = 0; i < assessmentArray.count; i++)
        {
            NSString* data = [assessmentArray objectAtIndex:i];
            [htmlString appendString:data];
        }
        [htmlString appendString:@"</Assessment>"];
    }
    
    
    
    NSMutableArray* unitArray;
    NSString* sqlUnitOnScene = [NSString stringWithFormat:@"Select inputID, inputvalue from TicketInputs where TicketID = %@ and (inputPage = 'Units' ) and (deleted is null or deleted = 0) and inputID in (1750, 1751, 1752, 1753)", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        unitArray = [DAO SelectInputsAssessment:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlUnitOnScene];
        
    }
    if (unitArray.count > 0)
    {
        [htmlString appendString:@"<UnitOnScene>"];
        for (int i =0; i < unitArray.count; i++)
        {
            [htmlString appendString:[unitArray objectAtIndex:i]];
        }
        [htmlString appendString:@"</UnitOnScene>"];
    }
    
    NSString* sqlShift = [NSString stringWithFormat:@"Select ticketShift from tickets where ticketId = %@", ticketID];
    NSString* shift;
    @synchronized(g_SYNCDATADB)
    {
        shift = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlShift];
    }
    if (shift.length > 0 && (![shift isEqualToString:@" "]) && (![shift isEqualToString:@"(null)"]) )
    {
        [htmlString appendString:[NSString stringWithFormat:@"<SHIFT>%@</SHIFT>", shift]];
    }
    
    NSMutableArray* insuranceList;
    sql = [NSString stringWithFormat:@"Select * from ticketInputs where ticketId = %@ and InputID >= 7001 and InputID <= 7005", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        insuranceList = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    NSMutableArray* insuranceArray = [[NSMutableArray alloc] init];
    NSInteger inputID = 0;
    NSMutableString* insuranceProvider = [[NSMutableString alloc] init];
    for (int i=0; i< [insuranceList count]; i++)
    {
        ClsTicketInputs* insuranceInput = [insuranceList objectAtIndex:i];
        if (inputID != insuranceInput.inputId)
        {
            if (inputID != 0)
            {
                [insuranceArray addObject:insuranceProvider];
            }
            inputID = 0;
        }
        if (inputID == 0)
        {
            inputID = insuranceInput.inputId;
            [insuranceProvider appendString:[NSString stringWithFormat:@"%@ - ", insuranceInput.inputPage]];
        }
        
        if (inputID == 7001 && insuranceInput.inputSubId == 1)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Medicare Payer: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7001 && insuranceInput.inputSubId == 2)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Medicare ID #: %@ ,", insuranceInput.inputValue]];
        }
        
        if (inputID == 7002 && insuranceInput.inputSubId == 1)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Medicaid Payer: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7002 && insuranceInput.inputSubId == 2)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Medicaid ID #: %@ ,", insuranceInput.inputValue]];
        }
        
        if (inputID == 7003 && insuranceInput.inputSubId == 1)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Company Name: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7003 && insuranceInput.inputSubId == 2)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Subsriber ID: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7003 && insuranceInput.inputSubId == 3)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Group Number: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7003 && insuranceInput.inputSubId == 4)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Insurance Phone: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7003 && insuranceInput.inputSubId == 5)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Plan Type: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7003 && insuranceInput.inputSubId == 6)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Insured Name: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7003 && insuranceInput.inputSubId == 7)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Insured SSN: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7003 && insuranceInput.inputSubId == 8)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Insured DOB: %@ ,", insuranceInput.inputValue]];
        }
        
        if (inputID == 7004 && insuranceInput.inputSubId == 1)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"First Name: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7004 && insuranceInput.inputSubId == 2)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Last Name: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7004 && insuranceInput.inputSubId == 3)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Address: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7004 && insuranceInput.inputSubId == 4)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"City: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7004 && insuranceInput.inputSubId == 5)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"State: %@ ", insuranceInput.inputValue]];
        }
        
        if (inputID == 7004 && insuranceInput.inputSubId == 6)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Zip: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7004 && insuranceInput.inputSubId == 7)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Relationship: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7004 && insuranceInput.inputSubId == 8)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Phone: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7004 && insuranceInput.inputSubId == 9)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Next of Kin: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7004 && insuranceInput.inputSubId == 10)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Phone: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7004 && insuranceInput.inputSubId == 11)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Employer: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7004 && insuranceInput.inputSubId == 12)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Employer Phone: %@ ", insuranceInput.inputValue]];
        }
        if (inputID == 7004 && insuranceInput.inputSubId == 13)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Date of Birth: %@ ,", insuranceInput.inputValue]];
        }
        
        if (inputID == 7005 && insuranceInput.inputSubId == 1)
        {
            [insuranceProvider appendString:[NSString stringWithFormat:@"Reason Not Obtained: %@ ,", insuranceInput.inputValue]];
        }
        
    }
    //   if ([insuranceList count] > 0)
    //   {
    //        [insuranceArray addObject:insuranceProvider];
    //   }
    if (insuranceProvider.length > 0)
    {
        [htmlString appendString:@"<INSURANCE>"];
        
        [htmlString appendString:insuranceProvider];
        
        [htmlString appendString:@"</INSURANCE>"];
    }
    
    NSString* sqlVital = [NSString stringWithFormat:@"Select count(distinct inputInstance) from TicketInputs where TicketID = %@ and inputID = 3001 and (deleted is null or deleted = 0)", ticketID];
    
    NSInteger countVital;
    @synchronized(g_SYNCDATADB)
    {
        countVital = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlVital];
    }
    
    NSInteger NumOfVitals = countVital;
    NSInteger minVitalsInstance;
    
    NSString* sqlVitalMin = [NSString stringWithFormat:@"Select min(inputInstance) from TicketInputs where TicketID = %@ and inputID = 3001 and (deleted is null or deleted = 0)", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        minVitalsInstance = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlVitalMin];
    }
    
    int iVital = minVitalsInstance-1;
    if (iVital < 0)
    {
        iVital = 0;
    }
    
    for (int j = minVitalsInstance; j< minVitalsInstance+NumOfVitals; j++)
    {
        
        int count = -1;
        iVital++;
        while (count < 0)
        {
            NSString* sqlStr = [NSString stringWithFormat:@"Select InputID, deleted from TicketInputs where TicketID = %@ and InputID = 3001 and InputInstance = %d", ticketID , iVital];
            
            @synchronized(g_SYNCDATADB)
            {
                count = [DAO getCountWithCheck:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            if (count == -1)
            {
                iVital++;
            }
        }
        
        NSMutableDictionary* vitaldict;
        
        sql = [NSString stringWithFormat:@"Select InputName, inputvalue from TicketInputs where TicketID = %@ and (inputPage = 'Vital') and inputInstance = %d and (deleted is null or deleted = 0)", ticketID, iVital];
        @synchronized(g_SYNCDATADB)
        {
            vitaldict = [DAO SelectInputsVital:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            
        }
        bool vitalEkg = false;
        if (vitaldict.count > 0)
        {
            NSString *dateStr = [vitaldict objectForKey:@"Vital Time"];
            if (dateStr.length > 6)
            {
                NSRange range = NSMakeRange(dateStr.length - 8, 5);
                [htmlString appendString:[NSString stringWithFormat:@"<Vital><Time>%@</Time>", [dateStr substringWithRange:range]]];
                [htmlString appendString:[NSString stringWithFormat:@"<VitalIndex>%d</VitalIndex>", j+ 1]];
                for (NSString* key in vitaldict)
                {
                    
                    NSString* vitalVal = [vitaldict objectForKey:key];
                    NSString* cleanVital = [self removeNull:vitalVal];
                    
                    if ([key isEqualToString:@"Vital_SYSBP"])
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<SYSBP>%@</SYSBP>", cleanVital]];
                    }
                    else if ([key isEqualToString:@"Vital_DIABP"])
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<DIABP>%@</DIABP>", cleanVital]];
                    }
                    else if ([key isEqualToString:@"Vital_RR"])
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<RR>%@</RR>", cleanVital]];
                    }
                    else if ([key isEqualToString:@"Vital_HR"])
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<HR>%@</HR>", cleanVital]];
                    }
                    else if ([key isEqualToString:@"Vital_SPO2"])
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<SPO2>%@</SPO2>", cleanVital]];
                    }
                    else if ([key isEqualToString:@"Vital_ETCO2"])
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<ETCO2>%@</ETCO2>", cleanVital]];
                    }
                    else if ([key isEqualToString:@"Vital_Glucose"])
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<Glucose>%@</Glucose>", cleanVital]];
                    }
                    else if ([key isEqualToString:@"Vital_Temperature"])
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<Temp>%@</Temp>", cleanVital]];
                    }
                    else if ([key isEqualToString:@"Vital_DoneBy"])
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<DoneBy>%@</DoneBy>", [vitaldict objectForKey:key]]];
                    }
                    else if ([key isEqualToString:@"Vital_EKG"] && (((NSString*)[vitaldict objectForKey:key]).length > 0) )
                    {
                        vitalEkg = true;
                        [htmlString appendString:[NSString stringWithFormat:@"<EKG>%@</EKG>", cleanVital]];
                    }
                    else if ([key isEqualToString:@"Vital_Skin"] && (((NSString*)[vitaldict objectForKey:key]).length > 0) )
                    {
                        vitalEkg = true;
                        [htmlString appendString:[NSString stringWithFormat:@"<Skin>%@</Skin>", cleanVital]];
                    }
                    
                    
                    else if ([key isEqualToString:@"Vital_CRT"] && (((NSString*)[vitaldict objectForKey:key]).length > 0) )
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<CRT>%@</CRT>", cleanVital]];
                    }
                    else if ([key isEqualToString:@"Vital_Eyes"] && (((NSString*)[vitaldict objectForKey:key]).length > 0) )
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<Eyes>%@</Eyes>", cleanVital]];
                    }
                    else if ([key isEqualToString:@"Vital_RTS"] && (((NSString*)[vitaldict objectForKey:key]).length > 0) )
                    {
                        [htmlString appendString:[NSString stringWithFormat:@"<RTS>%@</RTS>", cleanVital]];
                    }
                    
                    
                    
                }
                
                
                if ( (((NSString*)[vitaldict objectForKey:@"Vital_GCSMotor"]).length > 0) || (((NSString*)[vitaldict objectForKey:@"Vital_GCSVerbal"]).length > 0) || (((NSString*)[vitaldict objectForKey:@"Vital_GCSEye"]).length > 0))
                {
                    NSString* gcs;
                    @try {
                        NSString* motor = [((NSString*)[vitaldict objectForKey:@"Vital_GCSMotor"]) substringToIndex:1];
                        NSString* verbal = [((NSString*)[vitaldict objectForKey:@"Vital_GCSVerbal"]) substringToIndex:1];
                        NSString* eye = [((NSString*)[vitaldict objectForKey:@"Vital_GCSEye"]) substringToIndex:1];
                        gcs = [NSString stringWithFormat:@"%@/%@/%@", motor, verbal, eye];
                    }
                    @catch (NSException *exception) {
                        gcs = @" ";
                    }
                    [htmlString appendString:[NSString stringWithFormat:@"<GCS>%@</GCS>", gcs]];
                    
                }
                NSString* tempVitr;
                @try {
                    NSString* painVal = [vitaldict objectForKey:@"Vital_Pain"];
                    NSString* pain = [NSString stringWithFormat:@"<Pain>%@</Pain>", [self removeNull:painVal]];
                    NSString* spcoVal = [vitaldict objectForKey:@"Vital_SPCO"];
                    NSString* spco = [NSString stringWithFormat:@"<SPCO>%@</SPCO>", [self removeNull:spcoVal]];
                    NSString* spmetVal = [vitaldict objectForKey:@"Vital_SPMET"];
                    NSString* spmet = [NSString stringWithFormat:@"<SPMET>%@</SPMET>", [self removeNull:spmetVal]];
                    tempVitr = [NSString stringWithFormat:@"%@%@%@",pain, spco, spmet];
                    
                }
                @catch (NSException *exception) {
                    tempVitr = @" ";
                }
                @finally {
                    [htmlString appendString:tempVitr];
                }
                
                
                if (vitalEkg)
                {
                    [htmlString appendString:@"<VitalEKG>1</VitalEKG>"];
                }
                [htmlString appendString:@"</Vital>"];
            }
        }
        
    }
    
    
    NSMutableArray* treatmentList;
    sql = [NSString stringWithFormat:@"Select * from ticketInputs where InputID > 2000 and InputID < 2099 and ticketId = %@ and (deleted is null or deleted = 0) order by InputID, InputInstance, InputSubID", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        treatmentList = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    if ([treatmentList count] > 0)
    {
        NSString* treatment;
        NSInteger instance = 0;
        NSInteger treatmentID = 0;
        
        for (int i=0; i< [treatmentList count]; i++)
        {
            ClsTicketInputs* input = [treatmentList objectAtIndex:i];
            if (instance != input.inputInstance || treatmentID != input.inputId)
            {
                if (input.inputSubId == 1)
                {
                    if (instance != 0)
                    {
                        [htmlString appendString:@"</Description>"];
                        [htmlString appendString:@"</Treatment>"];
                    }
                    [htmlString appendString:@"<Treatment>"];
                    treatment = input.inputPage;
                    [htmlString appendString:@"<Time>"];
                    [htmlString appendString:[NSString stringWithFormat:@"%@", input.inputValue]];
                    [htmlString appendString:@"</Time>"];
                    [htmlString appendString:@"<Type>"];
                    [htmlString appendString:[NSString stringWithFormat:@"%@", input.inputPage]];
                    [htmlString appendString:@"</Type>"];
                }
                instance = input.inputInstance;
                treatmentID = input.inputId;
                [htmlString appendString:@"<Description>"];
            }
            
            else
            {
                if ([self removeNull:input.inputValue].length > 0)
                {
                    [htmlString appendString:[NSString stringWithFormat:@"%@: %@ ", [self removeNull:input.inputName], [self removeNull:input.inputValue]]];
                }
            }
            
        }
        
        [htmlString appendString:@"</Description>"];
        [htmlString appendString:@"</Treatment>"];
    }
    
    NSString* protocolSql = [NSString stringWithFormat:@"Select * from ticketInputs where ticketID = %@ and inputID > 4000 and inputID < 5000", ticketID];
    NSMutableArray* protocolList;
    @synchronized(g_SYNCDATADB)
    {
        protocolList = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:protocolSql];
    }
    for (int i = 0; i< protocolList.count; i++)
    {
        
        ClsTicketInputs* input = [protocolList objectAtIndex:i];
        [htmlString appendString:@"<Protocol><Time>"];
        
        [htmlString appendString:[NSString stringWithFormat:@"%@", input.inputValue]];
        [htmlString appendString:@"</Time>"];
        NSString* newStr1 = [input.inputName stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
        NSString* newStr2 = [newStr1 stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
        NSString* newStr3 = [newStr2 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
        int asciiCode1 = 13;
        NSString *string1 = [NSString stringWithFormat:@"%c", asciiCode1];
        NSString* newStr4 = [newStr3 stringByReplacingOccurrencesOfString:string1 withString:@"&amp;"];
        int asciiCode = 3;
        NSString *string = [NSString stringWithFormat:@"%c", asciiCode];
        NSString* inputname= [newStr4 stringByReplacingOccurrencesOfString:string withString:@"&amp;"];
        
        [htmlString appendString:@"<Type>"];
        
        [htmlString appendString:[NSString stringWithFormat:@"%@", inputname]];
        [htmlString appendString:@"</Type>"];
        [htmlString appendString:@"</Protocol>"];
        
    }
    
    NSString* sqlloadedMile = [NSString stringWithFormat:@"Select inputValue from ticketinputs where ticketId = %@ and inputID = 9050", ticketID];
    NSString* loadedMile;
    @synchronized(g_SYNCDATADB)
    {
        loadedMile = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlloadedMile];
    }
    [htmlString appendString:[NSString stringWithFormat:@"<Mileage>%@</Mileage>", loadedMile]];
    
    
    //supplies
    NSString* sqlSupply = [NSString stringWithFormat:@"Select * from ticketinputs where ticketId = %@ and inputID > 4999 and inputID < 6000 and (deleted is NULL or deleted = 0)", ticketID];
    NSMutableArray* supllies;
    @synchronized(g_SYNCDATADB)
    {
        
        supllies = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlSupply] ;
    }
    if (supllies.count > 0)
    {
        [htmlString appendString:@"<SuppliedUsed>YES</SuppliedUsed>"];
        for (int i = 0; i < supllies.count; i++)
        {
            ClsTicketInputs* ticketInputs = [supllies objectAtIndex:i];
            [htmlString appendString:[NSString stringWithFormat:@"<Supply><Desc>%@</Desc>", ticketInputs.inputName]];
            [htmlString appendString:[NSString stringWithFormat:@"<Qty>%@</Qty>", ticketInputs.inputValue]];
            [htmlString appendString:@"</Supply>"];
        }
    }
    
    if ([[g_SETTINGS objectForKey:@"MultiAccount"] isEqualToString:@"1"])
    {
        NSString* sqlAccount = [NSString stringWithFormat:@"Select TicketAccount from tickets where ticketId = %@", ticketID];
        NSString* account;
        
        @synchronized(g_SYNCDATADB)
        {
            account = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlAccount];
        }
        [htmlString appendString:[NSString stringWithFormat:@"<Account>%@</Account>", account]];
    }
    
    NSString* sqlSig = @"Select SignatureType, SignatureTypeDesc, DisclaimerText, SignatureGroup from SignatureTypes";
    NSMutableArray* sigTypeArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        sigTypeArray = [DAO selectSignatureTypes:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlSig];
    }
    
    NSMutableArray* signatureList;
    sql = [NSString stringWithFormat:@"Select * from ticketSignatures where ticketId = %@  and (deleted is null or deleted = 0)", ticketID];
    @synchronized(g_SYNCBLOBSDB)
    {
        signatureList = [DAO executeSelectSignatures:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
    }
    
    
    NSInteger maxRow = 0;
    if ([signatureList count] > 4)
    {
        maxRow = [signatureList count];
    }
    else
    {
        maxRow = [signatureList count];
    }
    for (int i =0; i< maxRow; i++ )
    {
        @try {
            [htmlString appendString:@"<Signature>"];
            ClsSignatureImages* sig = [signatureList objectAtIndex:i];
            NSString* title;
            ClsSignatureTypes* sigType;
            if (sig.type >= 0 && sig.type < sigTypeArray.count)
            {
                sigType = [sigTypeArray objectAtIndex:sig.type];
                title = sigType.signatureTypeDesc;
            }
            [htmlString appendString:@"<Name>"];
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:title]]];
            [htmlString appendString:@"</Name>"];
            
            [htmlString appendString:@"<File>"];
            [htmlString appendString:[NSString stringWithFormat:@"data:image/png;base64,%@", sig.imageStr]];
            [htmlString appendString:@"</File>"];
            [htmlString appendString:@"<Disclaimer>"];
            if (sig.type >= 0 && sig.type < sigTypeArray.count)
            {
                [htmlString appendString:[NSString stringWithFormat:@"%@", sigType.disclaimerText]];
            }
            [htmlString appendString:@"</Disclaimer>"];
            [htmlString appendString:[NSString stringWithFormat:@"<SigName>%@</SigName>", sig.name]];
            [htmlString appendString:@"</Signature>"];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    
    NSString* sqlChanges = [NSString stringWithFormat:@"Select * from ticketChanges where ticketId = %@", ticketID];
    NSMutableArray* ticketChangesArray;
    
    @synchronized(g_SYNCDATADB)
    {
        ticketChangesArray = [DAO executeSelectTicketChanges:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlChanges];
    }
    if (ticketChangesArray.count > 0)
    {
        [htmlString appendString:@"<Addendum>Yes</Addendum>"];
        for (int i = 0; i< ticketChangesArray.count; i++)
        {
            ClsTicketChanges* change = [ticketChangesArray objectAtIndex:i];
            [htmlString appendString:@"<TicketChange>"];
            [htmlString appendString:[NSString stringWithFormat:@"<ChangeTime>%@</ChangeTime>", change.changeTime]];
            [htmlString appendString:[NSString stringWithFormat:@"<ChangeMade>%@</ChangeMade>", change.changeMade]];
            
            NSString* sqlUserChange = [NSString stringWithFormat:@"Select userFirstName || ' ' || userlastname as name from users where  UserID = %ld", change.modifiedBy];
            NSString* nameChanged;
            @synchronized(g_SYNCLOOKUPDB)
            {
                nameChanged = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlUserChange];
            }
            [htmlString appendString:[NSString stringWithFormat:@"<ModifiedBy>%@</ModifiedBy>", nameChanged]];
            [htmlString appendString:@"</TicketChange>"];
        }
        
    }
    
    
    NSString* sqlInjury = [NSString stringWithFormat:@"Select inputValue from ticketinputs where ticketId = %@ and inputID = 9001", ticketID];
    NSString* injuryVal;
    @synchronized(g_SYNCDATADB)
    {
        injuryVal = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlInjury];
    }
    
    if (injuryVal.length > 0 && (![injuryVal isEqualToString:@" "]))
    {
        NSArray* injuryAr = [injuryVal componentsSeparatedByString:@"|"];
        for (int i=0; i < injuryAr.count; i++)
        {
            NSString* val = [injuryAr objectAtIndex:i];
            if (val.length > 0)
            {
                [htmlString appendString:@"<Injury>"];
                NSArray* detailAr = [val componentsSeparatedByString:@","];
                
                NSString* detail = [detailAr objectAtIndex:0];
                if ([detail isEqualToString:@"Abdomen"])
                {
                    [htmlString appendString:[NSString stringWithFormat:@"<Loc>%@</Loc>", detail]];
                }
                else if ([detail isEqualToString:@"Neck"])
                {
                    [htmlString appendString:[NSString stringWithFormat:@"<Loc>%@</Loc>", detail]];
                }
                else if ([detail isEqualToString:@"Head"])
                {
                    [htmlString appendString:[NSString stringWithFormat:@"<Loc>%@</Loc>", detail]];
                }
                else if ([detail isEqualToString:@"Chest"])
                {
                    [htmlString appendString:[NSString stringWithFormat:@"<Loc>%@</Loc>", detail]];
                }
                else if ([detail isEqualToString:@"Upper Back"])
                {
                    [htmlString appendString:@"<Loc>Back</Loc>"];
                }
                else if ([detail isEqualToString:@"Lower Back"])
                {
                    [htmlString appendString:@"<Loc>Back</Loc>"];
                }
                else
                {
                    [htmlString appendString:@"<Loc>Other</Loc>"];
                }
                [htmlString appendString:[NSString stringWithFormat:@"<Inj>%@</Inj>", detail]];
                if (detailAr.count > 4)
                {
                    [htmlString appendString:[NSString stringWithFormat:@"<Details>%@</Details>", [detailAr objectAtIndex:4]]];
                }
                [htmlString appendString:@"</Injury>"];
            }
        }
    }
    
    NSString* sqGcs = [NSString stringWithFormat:@"Select inputValue from ticketinputs where ticketId = %@ and inputID = 3011", ticketID];
    NSString* gcsVal;
    @synchronized(g_SYNCDATADB)
    {
        gcsVal = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqGcs];
    }
    
    [htmlString appendString:[NSString stringWithFormat:@"<GCSTotal>%@</GCSTotal>", gcsVal]];
    
    NSString* provider = [g_SETTINGS objectForKey:@"ServiceName"];
    [htmlString appendString:[NSString stringWithFormat:@"<PROVIDERINFO>%@ ", provider]];
    
    NSString* address1 = [g_SETTINGS objectForKey:@"ServiceAddr1"];
    [htmlString appendString:[NSString stringWithFormat:@"%@ ", address1]];
    
    NSString* address2 = [g_SETTINGS objectForKey:@"ServiceAddr2"];
    [htmlString appendString:[NSString stringWithFormat:@"%@ ", address2]];
    
    NSString* city = [g_SETTINGS objectForKey:@"ServiceCity"];
    [htmlString appendString:[NSString stringWithFormat:@"%@ ", city]];
    
    NSString* state = [g_SETTINGS objectForKey:@"ServiceST"];
    [htmlString appendString:[NSString stringWithFormat:@"%@ ", state]];
    
    NSString* zip = [g_SETTINGS objectForKey:@"ServiceZip"];
    [htmlString appendString:[NSString stringWithFormat:@"%@ ", zip]];
    
    NSString* phone = [g_SETTINGS objectForKey:@"ServiceContactPhone"];
    [htmlString appendString:[NSString stringWithFormat:@"%@ ", phone]];
    
    NSString* mail = [g_SETTINGS objectForKey:@"ServiceEmail"];
    [htmlString appendString:[NSString stringWithFormat:@"%@ ", mail]];
    
    NSString* num = [g_SETTINGS objectForKey:@"ServiceProviderNumber"];
    [htmlString appendString:[NSString stringWithFormat:@"%@ ", num]];
    [htmlString appendString:@"</PROVIDERINFO>"];
    
    [htmlString appendString:@"</PCR>"];
    
    // NSString* filePath = [[NSBundle mainBundle] pathForResource: @"Test" ofType: @"xml"];
    //  NSData *xmlMem = [[NSData alloc] initWithContentsOfFile:filePath];
    NSData *xmlMem = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* styleSheetPath = [[NSBundle mainBundle] pathForResource: @"Narrative" ofType:@"xslt"];
    
    xmlDocPtr doc, res;
    xsltStylesheetPtr sty;
    
    // tells the libxml2 parser to substitute entities as it parses your file
    xmlSubstituteEntitiesDefault(1);
    // This tells libxml to load external entity subsets
    xmlLoadExtDtdDefaultValue = 1;
    
    // This following line is only really needed if you want to use XSLT params
    const char *params[3] = { [@"param1" cStringUsingEncoding:NSUTF8StringEncoding], [@"\"paramdata\"" cStringUsingEncoding:NSUTF8StringEncoding], NULL };
    
    sty = xsltParseStylesheetFile((const xmlChar *)[styleSheetPath cStringUsingEncoding: NSUTF8StringEncoding]);
    //doc = xmlParseFile([filePath cStringUsingEncoding: NSUTF8StringEncoding]);
    
    // This example loads the XML file from a memory location as a sample, you can reference file directly with different xmlParse methods
    doc = xmlParseMemory([xmlMem bytes], [xmlMem length]);
    
    // Pass in NULL instead of params if you don't need to use them
    res = xsltApplyStylesheet(sty, doc, params);
    
    xmlChar* xmlResultBuffer = nil;
    int length = 0;
    
    xsltSaveResultToString(&xmlResultBuffer, &length, res, sty);
    
    NSString* result = [NSString stringWithCString: (char *)xmlResultBuffer encoding: NSUTF8StringEncoding];
    
    // NSLog(@"Result: %@", result);
    //   [webView1 loadHTMLString:result baseURL:nil];
    
    free(xmlResultBuffer);
    
    xsltFreeStylesheet(sty);
    xmlFreeDoc(res);
    xmlFreeDoc(doc);
    
    xsltCleanupGlobals();
    xmlCleanupParser();
    res = nil;
    doc = nil;
    htmlString = nil;
    return result;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    CGRect rect = svNarrative.frame;
    rect.size.height = 298;// you can set y position according to your convinience
    svNarrative.frame = rect;
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    
    CGRect rect = svNarrative.frame;
    rect.size.height = 481; // set back orignal positions
    svNarrative.frame = rect;
    NSLog(@"EndTextView frame is %@",NSStringFromCGRect(textView.frame));
    
}
@end
