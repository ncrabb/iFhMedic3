//
//  NarcoticViewController.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 04/06/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "NarcoticViewController.h"
#import "global.h"
#import "DAO.h"
#import "ValidateViewController.h"
#import "DDPopoverBackgroundView.h"
#import "NarcoticPopupViewController.h"
#import "NarcoticInfoCell.h"
#import "ClsTicketInputs.h"
#import "ClsTicketFormsInputs.h"
#import "QAMessageViewController.h"
#import "Base64.h"

@interface NarcoticViewController ()
{
    bool keyboardDown;
}

@end

@implementation NarcoticViewController
@synthesize delegate;
@synthesize newTicket;
@synthesize ticketID;
@synthesize popover;
@synthesize arrNarcotic;

@synthesize btnNameLabel;
@synthesize container1;
@synthesize container2;
@synthesize container3;
@synthesize container4;
@synthesize container5;
@synthesize container6;
@synthesize container7;

@synthesize tblNarcotic;
@synthesize btnOrderPhysician;
@synthesize btnOrderStanding;
@synthesize txtBoxNumber;
@synthesize signatureView;
@synthesize txtPhysician;
@synthesize btnAdd;
@synthesize btnParamedicSig;
@synthesize btnWastageSig;
@synthesize btnWitnessSig;
@synthesize txtParamedicCert;
@synthesize txtWastageCert;
@synthesize txtWitnessCert;
@synthesize bsender;
@synthesize lblControledSub;
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
	// Do any additional setup after loading the view.
    ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    UIImage *toolBarIMG = [UIImage imageNamed:@"navigation_bar_bkg.png"];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }
    lock = NO;
    orderSelected = 0;
    self.arrNarcotic = [[NSMutableArray alloc] init];
   // [self setViewUI];
    //[self.navigationController setNavigationBarHidden:TRUE];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString* patientName;
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    btnNameLabel.title = patientName;
    [btnNameLabel setTintColor:[UIColor whiteColor]];
    [lblControledSub setTextColor:[UIColor blackColor]];
    NSString* narcoticUse;
    NSString* narcoticUseSql = @"Select SettingValue from Settings where SettingDesc = 'NarcoticForm'";
    {
        narcoticUse = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:narcoticUseSql];
    }
    
    if ([narcoticUse containsString:@"1"])
    {
        [self loadData];
    }
    else
    {
        [self lockDown];
    }
        
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self saveTab];
    [super viewWillDisappear:animated];
}

- (void) saveTab
{
    if (!lock)
    {
        NSInteger dateCount= 0;
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and  formID = 3 and formInputID = 7", ticketID];
        @synchronized(g_SYNCDATADB)
        {
            dateCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *time = [outputFormatter stringFromDate:[NSDate date]];
        NSString* value;
        if (orderSelected == 1)
        {
            value = @"Standing";
            
        }
        else
        {
            value = @"Physician";
        }
        if (dateCount < 1)
        {
            NSString* sqlincidentno = [NSString stringWithFormat:@"select InputValue from TicketInputs where ticketID = %@ and InputID = 1001", ticketID];
            NSString* incidentNo;
            @synchronized(g_SYNCDATADB)
            {
                incidentNo = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlincidentno];
            }
            
            NSString* unit = [g_SETTINGS objectForKey:@"Unit"];
            @synchronized(g_SYNCDATADB)
            {
                sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 7, '%@', 0)", ticketID, time];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 9, '%@', 0)", ticketID, [self removeChar:value]];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 10, '%@', 0)", ticketID, [self removeChar:unit]];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 11, '%@', 0)", ticketID, incidentNo];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 12, '%@', 0)", ticketID, [self removeChar:txtPhysician.text]];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                
                sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 56, '%@', 0)", ticketID, [self removeChar:txtBoxNumber.text]];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 30, '%@', 0)", ticketID, [self removeChar:txtParamedicCert.text]];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 31, '%@', 0)", ticketID, [self removeChar:txtWitnessCert.text]];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 52, '%@', 0)", ticketID, [self removeChar:txtWastageCert.text]];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
            }
        } // end dateCount < 1
        else
        {
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = 9", [self removeChar:value], ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = 12", [self removeChar:txtPhysician.text], ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = 56", [self removeChar:txtBoxNumber.text], ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = 30", [self removeChar:txtParamedicCert.text], ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = 31", [self removeChar:txtWitnessCert.text], ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = 52", [self removeChar:txtWastageCert.text], ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
        }
        
        sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FORMID = 3 and FormInputValue = 15", ticketID];
        NSInteger medCount = 0;
        @synchronized(g_SYNCDATADB)
        {
            medCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (medCount < 1)
        {
            for (int i=0; i<5; i++)
            {
                ClsNarcotic* narcotic;
                NarcoticInfoCell* cell;
                @try
                {
                    narcotic = [arrNarcotic objectAtIndex:i];
                    cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];

                    NSString* sql = [NSString stringWithFormat:@"Select count(*) from ticketFormsInputs where ticketID = %@ and FormID = 3 and formInputID = %d", ticketID, 15+(3*i)];
                    NSInteger formCount = 0;
                    @synchronized(g_SYNCDATADB)
                    {
                        formCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                    }
                    if (formCount < 1)
                    {
                        @synchronized(g_SYNCDATADB)
                        {
                            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, %d, '%@', 0)", ticketID, 15+(3*i), [self removeChar:cell.lblMedication.text]];
                            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                            
                            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, %d, '%@', 0)", ticketID, 16+(3*i), [self removeChar:cell.lblAmtUsage.text]];
                            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                            
                            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, %d, '%@', 0)", ticketID, 17+(3*i), [self removeChar:cell.btnAmtWasted.titleLabel.text]];
                            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                            
                            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, %d, '%@', 0)", ticketID, 32+i, [self removeChar:cell.lblUnitUsage.text]];
                            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                            
                            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, %d, '%@', 0)", ticketID, 37+i, [self removeChar:cell.btnUnitWasted.titleLabel.text]];
                            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                            
                            NSString* witnessUsage;
                            if (cell.btnWitnessUsage.selected)
                            {
                                witnessUsage = @"1";
                            }
                            else
                            {
                                witnessUsage = @"0";
                            }
                            NSString* witnessWastage;
                            if (cell.btnWitnessWastage.selected)
                            {
                                witnessWastage = @"1";
                            }
                            else
                            {
                                witnessWastage = @"0";
                            }
                            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, %d, '%@', 0)", ticketID, 42+(2*i), [self removeChar:witnessUsage]];
                            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                            
                            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, %d, '%@', 0)", ticketID, 43+(2*i), [self removeChar:witnessWastage]];
                            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                        }
                        
                    }  // end formCount
                    else
                    {
                        @synchronized(g_SYNCDATADB)
                        {
                            
                            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 3 and FormInputID = %d", [self removeChar:cell.btnAmtWasted.titleLabel.text], ticketID,  17+(3*i)];
                            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];

                            
                            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 3 and FormInputID = %d", [self removeChar:cell.btnUnitWasted.titleLabel.text], ticketID,  37+i];
                            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];

                        }
                    } // end else formCount
                    
                }  // end try
                @catch (NSException *exception) {
                    narcotic = [[ClsNarcotic alloc] init];
                    cell = [[NarcoticInfoCell alloc] init];
                }
                @finally {
                    
                }
                
                
            }
            
        } // end if medCount < 1
        else
        {
            
            for (int i=0; i<5; i++)
            {
                ClsNarcotic* narcotic;
                NarcoticInfoCell* cell;
                @try {
                    narcotic = [arrNarcotic objectAtIndex:i];
                    cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                }
                @catch (NSException *exception) {
                    narcotic = [[ClsNarcotic alloc] init];
                    cell = [[NarcoticInfoCell alloc] init];
                }
                @finally {
                    
                }
                
                @synchronized(g_SYNCDATADB)
                {
                    sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = %d", [self removeChar:cell.lblMedication.text], ticketID, 15+(3*i)];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = %d", [self removeChar:cell.lblAmtUsage.text], ticketID, 16+(3*i)];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = %d", [self removeChar:cell.btnAmtWasted.titleLabel.text], ticketID, 17+(3*i)];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = %d", [self removeChar:cell.lblUnitUsage.text], ticketID, 32+i];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = %d", [self removeChar:cell.btnUnitWasted.titleLabel.text], ticketID, 37+i];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    NSString* witnessUsage;
                    if (cell.btnWitnessUsage.selected)
                    {
                        witnessUsage = @"1";
                    }
                    else
                    {
                        witnessUsage = @"0";
                    }
                    NSString* witnessWastage;
                    if (cell.btnWitnessWastage.selected)
                    {
                        witnessWastage = @"1";
                    }
                    else
                    {
                        witnessWastage = @"0";
                    }
                    
                    sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = %d", [self removeChar:witnessUsage], ticketID, 42+(2*i)];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"UPDATE TicketFormsInputs Set FormInputValue = '%@', isUploaded = 0 where TicketID = %@ and FormID = 3 and FormInpuID = %d", [self removeChar:witnessWastage], ticketID, 43+(2*i)];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
            }
            
        }  // end else medCount < 1
        
    }
}


- (void) lockDown
{
  //  coverView.hidden = NO;
  //  self.view.userInteractionEnabled = NO;
    for (int i=0; i< [arrNarcotic count]; i++)
    {
        NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
   /*     cell.btnAmtWasted.enabled = NO;
        cell.btnUnitWasted.enabled = NO;
        cell.btnUsage.enabled = NO;
        cell.btnWaste.enabled = NO;
        cell.btnWitnessUsage.enabled = NO;
        cell.btnWitnessWastage.enabled = NO; */
        cell.userInteractionEnabled = NO;
    }
    btnNameLabel.enabled = NO;
    btnOrderPhysician.userInteractionEnabled= NO;
    btnOrderStanding.userInteractionEnabled = NO;

    txtBoxNumber.userInteractionEnabled = NO;

    txtPhysician.userInteractionEnabled = NO;
    btnAdd.userInteractionEnabled = NO;
    btnParamedicSig.userInteractionEnabled = NO;
    btnWastageSig.userInteractionEnabled = NO;
    btnWitnessSig.userInteractionEnabled = NO;
    txtParamedicCert.userInteractionEnabled = NO;
    txtWastageCert.userInteractionEnabled = NO;
    txtWitnessCert.userInteractionEnabled = NO;
}

- (NSInteger) checkLock
{
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FormID = 3 and FormInputID in (42, 43) and FormInputValue = 1", ticketID ];
    NSInteger inputCount = 0;
    @synchronized(g_SYNCDATADB)
    {
        inputCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FormID = 3 and FormInputID in (3, 53)", ticketID ];
    NSInteger count = 0;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    if (inputCount > 0 &&  count >= inputCount)
    {
        lock = YES;
        return 1;
    }
    return 0;
}

- (void) loadData
{
    [arrNarcotic removeAllObjects];
    NSString* sqlStr = @"Select drugname from drugs where narcotic = 1";
    NSString* narcotics;
    @synchronized(g_SYNCLOOKUPDB)
    {
        narcotics = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
    }
    
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and inputID = 2011 and inputsubid = 2", ticketID ];
    NSMutableDictionary* ticketInputData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }

    sql = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 2011 and inputSubID = 1", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    NSMutableString* searchStr = [[NSMutableString alloc] init];
    int NumOfDrug = 0;
    for (int i = 1; i <= count; i++)
    {
        NSString* name2 = [NSString stringWithFormat:@"2011:2:%d", i ];
        if ([[ticketInputData objectForKey:name2] length] > 0 && ([[ticketInputData objectForKey:name2] rangeOfString:@"(null)"].location == NSNotFound))
        {
            NSString* medicationName = [ticketInputData objectForKey:name2];
            if ([narcotics rangeOfString:medicationName].location != NSNotFound)
            {
                [searchStr appendString:[NSString stringWithFormat:@"%d,", i ]];
                NumOfDrug++;
            }
        }
    }
    
    
 /*   sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 2011 and order by ticketID, InputInstance, InputSubID ASC", ticketID ];
    
    
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    } */
    
    if (searchStr.length  > 0)
    {
        [searchStr setString:[searchStr substringToIndex:[searchStr length] -1]];
        NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and inputID = 2011 and inputinstance in (%@)", ticketID, searchStr ];
        NSMutableDictionary* ticketInputData;
        @synchronized(g_SYNCDATADB)
        {
            ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
     //   int NumOfDrug = [ticketInputData count] / 11 ;
        NSArray* instanceCount = [searchStr componentsSeparatedByString:@","];
        for (int i = 0; i < NumOfDrug; i++)
        {
            ClsNarcotic* narcotic = [[ClsNarcotic alloc] init];
            
            NSString* name = [NSString stringWithFormat:@"2011:1:%@", [instanceCount objectAtIndex:i] ];
            if ([[ticketInputData objectForKey:name] length] > 0 && ([[ticketInputData objectForKey:name] rangeOfString:@"(null)"].location == NSNotFound))
            {
                NSString* time = [ticketInputData objectForKey:name];
            }
 
            NSString* name2 = [NSString stringWithFormat:@"2011:2:%@", [instanceCount objectAtIndex:i] ];
            if ([[ticketInputData objectForKey:name2] length] > 0 && ([[ticketInputData objectForKey:name2] rangeOfString:@"(null)"].location == NSNotFound))
            {
                narcotic.MedicationName = [ticketInputData objectForKey:name2];
            }
            NSString* name3 = [NSString stringWithFormat:@"2011:3:%@", [instanceCount objectAtIndex:i] ];
            if ([[ticketInputData objectForKey:name3] length] > 0 && ([[ticketInputData objectForKey:name3] rangeOfString:@"(null)"].location == NSNotFound))
            {
                narcotic.amountUsage = [ticketInputData objectForKey:name3];
            }
            
            NSString* name4 = [NSString stringWithFormat:@"2011:4:%@", [instanceCount objectAtIndex:i] ];
            if ([[ticketInputData objectForKey:name4] length] > 0 && ([[ticketInputData objectForKey:name4] rangeOfString:@"(null)"].location == NSNotFound))
            {
                narcotic.UsageUnit = [ticketInputData objectForKey:name4];
            }
            [arrNarcotic addObject:narcotic];

            
        }
        [tblNarcotic reloadData];
        
        
        if (arrNarcotic.count > 0)
        {
            [lblControledSub setTextColor:[UIColor redColor]];
            NSInteger dataCount = 0;
            sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FormID = 3 and FormInputID = 7", ticketID ];
            @synchronized(g_SYNCDATADB)
            {
                dataCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            if (dataCount > 0)
            {
                NSMutableArray* ticketInputData;
                sqlStr = [NSString stringWithFormat:@"Select * from TicketFormsInputs where TicketID = %@ and FormID = 3", ticketID ];
                @synchronized(g_SYNCDATADB)
                {
                    ticketInputData = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
                for (int i=0; i< [ticketInputData count]; i++)
                {
                    ClsTicketFormsInputs* input = [ticketInputData objectAtIndex:i];
                    
                    if (input.formID ==3 && input.formInputID == 7)
                    {
                        sigtime = input.formInputValue;
                    }
                    
                    if (input.formID ==3 && input.formInputID == 1)
                    {
                        paramedicName = input.formInputValue;
                    }
                    if (input.formID ==3 && input.formInputID == 2)
                    {
                        paramedicSig = input.formInputValue;
                        [Base64 initialize];
                        NSData* data = [Base64 decode:paramedicSig];
                        UIImage* image = [UIImage imageWithData:data];
                        [btnParamedicSig setBackgroundImage:image forState:UIControlStateNormal];
                    }
                    if (input.formID ==3 && input.formInputID == 3)
                    {
                        witnessName = input.formInputValue;
                    }
                    if (input.formID ==3 && input.formInputID == 4)
                    {
                        witnessSig = input.formInputValue;
                        [Base64 initialize];
                        NSData* data = [Base64 decode:witnessSig];
                        UIImage* image = [UIImage imageWithData:data];
                        [btnWitnessSig setBackgroundImage:image forState:UIControlStateNormal];
                    }
                    if (input.formID ==3 && input.formInputID == 53)
                    {
                        wastageName = input.formInputValue;
                    }
                    if (input.formID ==3 && input.formInputID == 54)
                    {
                        wastageSig = input.formInputValue;
                        [Base64 initialize];
                        NSData* data = [Base64 decode:wastageSig];
                        UIImage* image = [UIImage imageWithData:data];
                        [btnWastageSig setBackgroundImage:image forState:UIControlStateNormal];
                    }
                    
                   
                    
                    if (arrNarcotic.count > 0)
                    {
                        if (input.formInputID == 17)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                            [cell.btnAmtWasted setTitle:[self removeNull:input.formInputValue] forState:UIControlStateNormal];
                        }
                        if (input.formInputID == 37)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                            [cell.btnUnitWasted setTitle:[self removeNull:input.formInputValue] forState:UIControlStateNormal];
                        }
                        if (input.formInputID == 42)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                            if ([input.formInputValue isEqualToString:@"1"])
                            {
                                cell.btnWitnessUsage.selected = YES;
                            }
                            else
                            {
                                cell.btnWitnessUsage.selected = NO;
                            }
                        }
                        if (input.formInputID == 43)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                            if ([input.formInputValue isEqualToString:@"1"])
                            {
                                cell.btnWitnessWastage.selected = YES;
                            }
                            else
                            {
                                cell.btnWitnessWastage.selected = NO;
                            }
                        }
                    }
                    

                    if (arrNarcotic.count > 1)
                    {
                        if (input.formInputID == 20)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
                            [cell.btnAmtWasted setTitle:[self removeNull:input.formInputValue] forState:UIControlStateNormal];
                        }
                        if (input.formInputID == 38)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
                            [cell.btnUnitWasted setTitle:[self removeNull:input.formInputValue] forState:UIControlStateNormal];
                        }
                        if (input.formInputID == 44)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
                            if ([input.formInputValue isEqualToString:@"1"])
                            {
                                cell.btnWitnessUsage.selected = YES;
                            }
                            else
                            {
                                cell.btnWitnessUsage.selected = NO;
                            }
                        }
                        if (input.formInputID == 45)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
                            if ([input.formInputValue isEqualToString:@"1"])
                            {
                                cell.btnWitnessWastage.selected = YES;
                            }
                            else
                            {
                                cell.btnWitnessWastage.selected = NO;
                            }
                        }
                        
                    }  // end 3
                    
                    
                    if (arrNarcotic.count > 2)
                    {
                        if (input.formInputID == 23)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
                            [cell.btnAmtWasted setTitle:[self removeNull:input.formInputValue] forState:UIControlStateNormal];
                        }
                        
                        if (input.formInputID == 39)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
                            [cell.btnUnitWasted setTitle:[self removeNull:input.formInputValue] forState:UIControlStateNormal];
                        }
                        if (input.formInputID == 46)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
                            if ([input.formInputValue isEqualToString:@"1"])
                            {
                                cell.btnWitnessUsage.selected = YES;
                            }
                            else
                            {
                                cell.btnWitnessUsage.selected = NO;
                            }
                        }
                        if (input.formInputID == 47)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
                            if ([input.formInputValue isEqualToString:@"1"])
                            {
                                cell.btnWitnessWastage.selected = YES;
                            }
                            else
                            {
                                cell.btnWitnessWastage.selected = NO;
                            }
                        }
                        
                    }
                    
                    if (arrNarcotic.count > 3)
                    {
                        if (input.formInputID == 26)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
                            [cell.btnAmtWasted setTitle:[self removeNull:input.formInputValue] forState:UIControlStateNormal];
                        }
                        if (input.formInputID == 40)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
                            [cell.btnUnitWasted setTitle:[self removeNull:input.formInputValue] forState:UIControlStateNormal];
                        }
                        if (input.formInputID == 48)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
                            if ([input.formInputValue isEqualToString:@"1"])
                            {
                                cell.btnWitnessUsage.selected = YES;
                            }
                            else
                            {
                                cell.btnWitnessUsage.selected = NO;
                            }
                        }
                        if (input.formInputID == 49)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
                            if ([input.formInputValue isEqualToString:@"1"])
                            {
                                cell.btnWitnessWastage.selected = YES;
                            }
                            else
                            {
                                cell.btnWitnessWastage.selected = NO;
                            }
                        }
                        
                    }
                        
                    if (arrNarcotic.count > 4)
                    {
                        if (input.formInputID == 29)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
                            [cell.btnAmtWasted setTitle:[self removeNull:input.formInputValue] forState:UIControlStateNormal];
                        }
                        if (input.formInputID == 41)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
                            [cell.btnUnitWasted setTitle:[self removeNull:input.formInputValue] forState:UIControlStateNormal];
                        }
                        if (input.formInputID == 50)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
                            if ([input.formInputValue isEqualToString:@"1"])
                            {
                                cell.btnWitnessUsage.selected = YES;
                            }
                            else
                            {
                                cell.btnWitnessUsage.selected = NO;
                            }
                        }
                        if (input.formInputID == 51)
                        {
                            NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
                            if ([input.formInputValue isEqualToString:@"1"])
                            {
                                cell.btnWitnessWastage.selected = YES;
                            }
                            else
                            {
                                cell.btnWitnessWastage.selected = NO;
                            }
                        }
                        
                    }
                    
                    if (input.formInputID == 9)
                    {
                        if ([input.formInputValue isEqualToString:@"Standing"])
                        {
                            btnOrderStanding.selected = YES;
                            orderSelected = 1;
                        }
                        else if ([input.formInputValue isEqualToString:@"Physician"])
                        {
                            btnOrderPhysician.selected = YES;
                            orderSelected = 0;
                        }
                    }
                    if (input.formInputID == 12)
                    {
                        if ( [[self removeNull:input.formInputValue] length] > 0)
                        {
                            txtPhysician.text = input.formInputValue;
                        }

                    }

                    if (input.formInputID == 56)
                    {
                        if ( [[self removeNull:input.formInputValue] length] > 0)
                        {
                            txtBoxNumber.text = input.formInputValue;
                        }
                        
                    }
                    
                    if (input.formInputID == 30)
                    {
                        if ( [[self removeNull:input.formInputValue] length] > 0)
                        {
                            txtParamedicCert.text = input.formInputValue;
                        }
                        
                    }
                    if (input.formInputID == 31)
                    {
                        if ( [[self removeNull:input.formInputValue] length] > 0)
                        {
                            txtWitnessCert.text = input.formInputValue;
                        }
                        
                    }
                    if (input.formInputID == 52)
                    {
                        if ( [[self removeNull:input.formInputValue] length] > 0)
                        {
                            txtWastageCert.text = input.formInputValue;
                        }
                        
                    }
                }
            }
        }
        
        int test = [self checkLock];
        if (test == 1)
        {
            lock = YES;
            //   [self lockDown];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Locked Down" message:@"This tab has been locked down." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            alert.tag = 2;
            [alert show];
            return;
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

- (NSString*) removeChar:(NSString*)str
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    [self.container1.layer setCornerRadius:10.0f];
    [self.container1.layer setMasksToBounds:YES];
    self.container1.layer.borderWidth = 1;
    self.container1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [self.container2.layer setCornerRadius:10.0f];
    [self.container2.layer setMasksToBounds:YES];
    self.container2.layer.borderWidth = 1;
    self.container2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [self.container3.layer setCornerRadius:10.0f];
    [self.container3.layer setMasksToBounds:YES];
    self.container3.layer.borderWidth = 1;
    self.container3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.container4.layer setCornerRadius:10.0f];
    [self.container4.layer setMasksToBounds:YES];
    self.container4.layer.borderWidth = 1;
    self.container4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [self.container5.layer setCornerRadius:10.0f];
    [self.container5.layer setMasksToBounds:YES];
    self.container5.layer.borderWidth = 1;
    self.container5.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [self.container6.layer setCornerRadius:10.0f];
    [self.container6.layer setMasksToBounds:YES];
    self.container6.layer.borderWidth = 1;
    self.container6.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.container7.layer setCornerRadius:10.0f];
    [self.container7.layer setMasksToBounds:YES];
    self.container7.layer.borderWidth = 1;
    self.container7.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark-
#pragma mark UIControls Callback Functions

- (IBAction)btnMainMenuClick:(id)sender {
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [delegate dismissViewControl];
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

- (IBAction)addButtonPressed:(id)sender
{
    NarcoticPopupViewController *popoverView =[[NarcoticPopupViewController alloc] initWithNibName:@"NarcoticPopupViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(730, 550);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:CGRectMake(200, 100, 700, 450) inView:self.view permittedArrowDirections:0 animated:YES];
}

- (IBAction)btnOrderOptionPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 1)
    {
        orderSelected = 1;
        btnOrderStanding.selected = YES;
        btnOrderPhysician.selected = NO;
    }
    else
    {
        orderSelected = 2;
        btnOrderStanding.selected = NO;
        btnOrderPhysician.selected = YES;
    }
}


- (void) doneSelectValidate
{
    ValidateViewController *p = (ValidateViewController *)self.popover.contentViewController;
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    
    if (p.ticketComplete)
    {
        [delegate dismissViewControl];
    }
    
    else if (p.tagID >= 0)
    {
        [self.delegate dismissViewControlAndStartNew:p.tagID];
    }
}

-(void) didTap
{
}

-(void) continueClick:(BOOL)edit
{
    NarcoticPopupViewController *p = (NarcoticPopupViewController *)self.popover.contentViewController;
    if (self.arrNarcotic == nil)
    {
        self.arrNarcotic = [[NSMutableArray alloc] init];
    }
    [arrNarcotic addObject:p.narcotic];

    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [tblNarcotic reloadData];
    
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrNarcotic count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"narcoticInfoCell";
    NarcoticInfoCell *cell = (NarcoticInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NarcoticInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    ClsNarcotic* narcotic = [arrNarcotic objectAtIndex:indexPath.row];
    cell.lblMedication.text = narcotic.MedicationName;
    cell.lblAmtUsage.text = narcotic.amountUsage;
    cell.lblUnitUsage.text = narcotic.UsageUnit;
  //  cell.lblAmtWaste.text = narcotic.amountWastage;
  //  cell.lblUnitWaste.text = narcotic.WastageUnit;
/*    if(narcotic.witnessType == 1)
    {
        cell.btnUsage.selected = YES;
        cell.btnWaste.selected = NO;
    }
    else
    {
        cell.btnUsage.selected = NO;
        cell.btnWaste.selected = YES;
    } */


    return cell;
}

- (void)setViewMovedUp:(BOOL)movedUp
{
   // [self.popover dismissPopoverAnimated:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        if(rect.origin.y == 0)
            rect.origin.y = self.view.frame.origin.y - 216;
    }
    else
    {
        if(rect.origin.y < 0)
            rect.origin.y = self.view.frame.origin.y + 216;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{

        [self setViewMovedUp:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    keyboardDown = true;
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (keyboardDown)
    {
        keyboardDown = false;
    }
    [self setViewMovedUp:NO];
    
}


- (void)doneNarcoticSigningClick
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    NarcoticSigViewController *p = (NarcoticSigViewController *)self.popover.contentViewController;
    if (p.needToSave)
    {
        if (currentButonClicked == 3)
        {
           [btnParamedicSig setBackgroundImage:p.image forState:UIControlStateNormal];
        }
        else if (currentButonClicked == 1)
        {
           [btnWitnessSig setBackgroundImage:p.image forState:UIControlStateNormal];
        }
        else
        {
           [btnWastageSig setBackgroundImage:p.image forState:UIControlStateNormal];
        }
    }
    
    NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    if (cell.btnWitnessUsage.selected && cell.btnWitnessWastage.selected)
    {
        int count = 0;
        NSString* sqlStr = [NSString stringWithFormat:@"select count(*) from TicketFormsInputs where ticketID = %@ and FormID = 3 and FormInputID in(3, 53)", ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (count >= 2)
        {
            [self lockDown];
        }
    }

    else if (cell.btnWitnessUsage.selected)
    {
        int count = 0;
        NSString* sqlStr = [NSString stringWithFormat:@"select count(*) from TicketFormsInputs where ticketID = %@ and FormID = 3 and FormInputID = 3", ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (count > 0)
        {
            [self lockDown];
        }
    }
    
    else if (cell.btnWitnessWastage.selected)
    {
        int count = 0;
        NSString* sqlStr = [NSString stringWithFormat:@"select count(*) from TicketFormsInputs where ticketID = %@ and FormID = 3 and FormInputID = 53", ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (count > 0)
        {
            [self lockDown];
        }
    }
    
}

- (IBAction)administerningSignPressed:(UIButton *)sender
{
    currentButonClicked = 3;
    self.signatureView =[[NarcoticSigViewController alloc] initWithNibName:@"NarcoticSigViewController" bundle:nil];
    signatureView.sigType = 1;
    signatureView.formInputID = 1;
    signatureView.view.backgroundColor = [UIColor whiteColor];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:signatureView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(550, 480);
    signatureView.view.tag = ((UIView *)sender).tag;
    signatureView.delegate = self;
    CGRect frame = ((UIView *)sender).frame;
    frame.origin.y+= 122;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)witnessSignPressed:(UIButton *)sender
{
    currentButonClicked = 1;
    NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

    if (cell.btnWitnessUsage.selected && cell.btnWitnessWastage.selected)
    {
        int count = 0;
        NSString* sqlStr = [NSString stringWithFormat:@"select count(*) from TicketFormsInputs where ticketID = %@ and FormID = 3 and FormInputID = 53", ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (count > 0)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"iFHMedic" message:@"Once the witness signature is obtained, you will no longer be able to edit this form. Do you want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 0;
            self.bsender = sender;
            [alert show];
            return;
        }
        else
        {
            self.signatureView =[[NarcoticSigViewController alloc] initWithNibName:@"NarcoticSigViewController" bundle:nil];
            signatureView.sigType = 1;
            signatureView.formInputID = 3;
            signatureView.view.backgroundColor = [UIColor whiteColor];
            
            self.popover =[[UIPopoverController alloc] initWithContentViewController:signatureView];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(550, 480);
            signatureView.view.tag = ((UIView *)bsender).tag;
            signatureView.lblTitle.text = @"     Usage Witness Signature";
            signatureView.delegate = self;
            CGRect frame = ((UIView *)bsender).frame;
            frame.origin.y+= 122;
            [self.popover presentPopoverFromRect:bsender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    else
    {
        if (!cell.btnWitnessUsage.selected)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Signature Not Required" message:@"No one has witnessed a Controlled Substance Usage. This signature is not required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"iFHMedic" message:@"Once the witness signature is obtained, you will no longer be able to edit this form. Do you want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 0;
            self.bsender = sender;
            [alert show];
            return;
        }
    }
}





- (IBAction)btnWastageWitnessClick:(UIButton *)sender {
    currentButonClicked = 2;
    NarcoticInfoCell* cell = (NarcoticInfoCell*) [tblNarcotic cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    if (cell.btnWitnessWastage.selected && cell.btnAmtWasted.titleLabel.text.length < 1)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing data" message:@"Amount Wasted is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (cell.btnWitnessWastage.selected && cell.btnUnitWasted.titleLabel.text.length < 1)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Missing data" message:@"Unit Wasted is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (cell.btnWitnessUsage.selected && cell.btnWitnessWastage.selected)
    {
        int count = 0;
        NSString* sqlStr = [NSString stringWithFormat:@"select count(*) from TicketFormsInputs where ticketID = %@ and FormID = 3 and FormInputID = 3", ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (count > 0)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FHMedic" message:@"Once the witness signature is obtained, you will no longer be able to edit this form. Do you want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 1;
            self.bsender = sender;
            [alert show];
            return;
        }
        else
        {
            self.signatureView =[[NarcoticSigViewController alloc] initWithNibName:@"NarcoticSigViewController" bundle:nil];
            signatureView.sigType = 1;
            signatureView.formInputID = 53;
            signatureView.view.backgroundColor = [UIColor whiteColor];
            signatureView.lblTitle.text = @"     Wastage Witness Signature";
            self.popover =[[UIPopoverController alloc] initWithContentViewController:signatureView];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(550, 480);
            signatureView.view.tag = ((UIView *)bsender).tag;
            signatureView.delegate = self;
            CGRect frame = ((UIView *)bsender).frame;
            frame.origin.y+= 122;
            [self.popover presentPopoverFromRect:bsender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    else
    {
        if (!cell.btnWitnessWastage.selected)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Signature Not Required" message:@"No one has witnessed a control substance Wastage. This signature is not required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FHMedic" message:@"Once the witness signature is obtained, you will no longer be able to edit this form. Do you want to continue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 1;
            self.bsender = sender;
            [alert show];
            
        }
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            self.signatureView =[[NarcoticSigViewController alloc] initWithNibName:@"NarcoticSigViewController" bundle:nil];
            signatureView.sigType = 1;
            signatureView.formInputID = 3;
            signatureView.view.backgroundColor = [UIColor whiteColor];
            
            self.popover =[[UIPopoverController alloc] initWithContentViewController:signatureView];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(550, 480);
            signatureView.view.tag = ((UIView *)bsender).tag;
            signatureView.lblTitle.text = @"     Usage Witness Signature";
            signatureView.delegate = self;
            CGRect frame = ((UIView *)bsender).frame;
            frame.origin.y+= 122;
            [self.popover presentPopoverFromRect:bsender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
    else if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            self.signatureView =[[NarcoticSigViewController alloc] initWithNibName:@"NarcoticSigViewController" bundle:nil];
            signatureView.sigType = 1;
            signatureView.formInputID = 53;
            signatureView.view.backgroundColor = [UIColor whiteColor];
            
            self.popover =[[UIPopoverController alloc] initWithContentViewController:signatureView];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(550, 480);
            signatureView.view.tag = ((UIView *)bsender).tag;
            signatureView.lblTitle.text = @"     Wastage Witness Signature";
            signatureView.delegate = self;
            CGRect frame = ((UIView *)bsender).frame;
            frame.origin.y+= 122;
            [self.popover presentPopoverFromRect:bsender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
    }
    else if (alertView.tag == 2)
    {
        [self lockDown];
    }
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

@end
