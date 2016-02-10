//
//  SummeryViewController.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 10/04/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "SummeryViewController.h"
#import "global.h"
#import "DAO.h"
#import "ClsTreatments.h"
#import "SummaryInfoCell.h"
#import "ClsCallTimes.h"
#import "ClsVital.h"
#import "TabViewController.h"
#import "ClsTicketInputs.h"
#import "ClsTableKey.h"
#import "ClsAssesment.h"

@interface SummeryViewController ()

@end

@implementation SummeryViewController
@synthesize delegate;
@synthesize toolBar;
@synthesize newTicket;
@synthesize arrSummary;
@synthesize rowSelected;
@synthesize selectedType;

@synthesize tblSummary;
@synthesize arrAssessment;

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
     [self setViewUI];
    
     ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    self.arrAssessment = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    rowSelected = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData
{
    
    if (self.arrSummary == nil)
    {
        self.arrSummary = [[NSMutableArray alloc] init];
    }
    else
    {
        [self.arrSummary removeAllObjects];
    }
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and ((InputID > 2000 and InputID < 2099 and (deleted is null or deleted = 0)) Or inputID = 1040)", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    if (count > 0)
    {
        NSString* sql = [NSString stringWithFormat:@"Select * from ticketInputs where InputID > 2000 and InputID < 2099 and ticketId = %@ and (deleted is null or deleted = 0) order by InputID, InputInstance, InputSubID", ticketID];
        
        
        NSMutableArray* treatmentList;
        @synchronized(g_SYNCDATADB)
        {
            treatmentList = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        if ([treatmentList count] > 0)
        {
            ClsTreatments* treatment;
            bool done = true;
            for (int i=0; i< [treatmentList count]; i++)
            {
                ClsTicketInputs* input = [treatmentList objectAtIndex:i];

                if (input.inputSubId == 1)
                {
                    if (!done)
                    {
                        [arrSummary addObject:treatment];
                    }
                    done = false;
                    treatment = [[ClsTreatments alloc] init];
                    treatment.treatmentID = input.inputId;
                    treatment.dose = [NSString stringWithFormat:@"%d-%d-%d-%@", input.inputId, input.inputSubId, input.inputInstance, input.inputValue];
                    treatment.treatmentTime = input.inputValue;
                    treatment.drugName = input.inputPage;
                }
                else if (input.inputSubId == 2)
                {
                    treatment.treatmentDesc = input.inputValue;
                    [arrSummary addObject:treatment];
                    done = true;
                }
 /*               else if (input.inputSubId == 101)
                {
                    [desc setString: @""];
                    [desc appendString:[NSString stringWithFormat:@"Performed By:%@ ",input.inputValue]];

                }
                else if (input.inputSubId == 102)
                {
                    [desc appendString:[NSString stringWithFormat:@"Note:%@ ",input.inputValue]];
                    treatment.treatmentDesc = desc;
                    [arrSummary addObject:treatment];
                    treatment = nil;
                } */
            }
            if (!done)
            {
                [arrSummary addObject:treatment];
            }
            
        }
    }

        [self sortArray];
        
        sqlStr = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and inputID >= 1040 and inputID <= 1049", ticketID ];
      
        NSMutableDictionary* ticketInputsData;
        @synchronized(g_SYNCDATADB)
        {
            ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        if ([ticketInputsData count] > 0)
        {
            
            if ([ [self removeNull:[ticketInputsData objectForKey:@"1040:0:1"]] length] > 0 && ([[ticketInputsData objectForKey:@"1040:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
            {
                ClsTableKey* key = [[ClsTableKey alloc] init];
                key.tableID = 1040;
                key.tableName = @"Dispatch";
                key.desc = [ticketInputsData objectForKey:@"1040:0:1"] ;
                [arrSummary addObject:key];
            }
            
            if ([ [self removeNull:[ticketInputsData objectForKey:@"1041:0:1"]] length] > 0 && ([[ticketInputsData objectForKey:@"1041:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
            {
                ClsTableKey* key = [[ClsTableKey alloc] init];
                key.tableID = 1041;
                key.tableName = @"enRoute";
                key.desc = [ticketInputsData objectForKey:@"1041:0:1"] ;
                [arrSummary addObject:key];
            }
            
            if ([ [self removeNull:[ticketInputsData objectForKey:@"1042:0:1"]] length] > 0 && ([[ticketInputsData objectForKey:@"1042:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
            {
                ClsTableKey* key = [[ClsTableKey alloc] init];
                key.tableID = 1042;
                key.tableName = @"atScene";
                key.desc = [ticketInputsData objectForKey:@"1042:0:1"] ;
                [arrSummary addObject:key];

            }
            
            if ([ [self removeNull:[ticketInputsData objectForKey:@"1047:0:1"]] length] > 0 && ([[ticketInputsData objectForKey:@"1047:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
            {
                ClsTableKey* key = [[ClsTableKey alloc] init];
                key.tableID = 1047;
                key.tableName = @"atPatient";
                key.desc = [ticketInputsData objectForKey:@"1047:0:1"] ;
                [arrSummary addObject:key];

            }
            
            if ([ [self removeNull:[ticketInputsData objectForKey:@"1043:0:1"]] length] > 0 && ([[ticketInputsData objectForKey:@"1043:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
            {
                ClsTableKey* key = [[ClsTableKey alloc] init];
                key.tableID = 1043;
                key.tableName = @"departScene";
                key.desc = [ticketInputsData objectForKey:@"1043:0:1"] ;
                [arrSummary addObject:key];

            }
            
            if ([ [self removeNull:[ticketInputsData objectForKey:@"1044:0:1"]] length] > 0 && ([[ticketInputsData objectForKey:@"1044:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
            {
                ClsTableKey* key = [[ClsTableKey alloc] init];
                key.tableID = 1044;
                key.tableName = @"arriveDest";
                key.desc = [ticketInputsData objectForKey:@"1044:0:1"] ;
                [arrSummary addObject:key];

            }
            
            if ([ [self removeNull:[ticketInputsData objectForKey:@"1045:0:1"]] length] > 0 && ([[ticketInputsData objectForKey:@"1045:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
            {
                ClsTableKey* key = [[ClsTableKey alloc] init];
                key.tableID = 1045;
                key.tableName = @"transferCare";
                key.desc = [ticketInputsData objectForKey:@"1045:0:1"] ;
                [arrSummary addObject:key];
                
            }
            
            if ([ [self removeNull:[ticketInputsData objectForKey:@"1046:0:1"]] length] > 0 && ([[ticketInputsData objectForKey:@"1046:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
            {
                ClsTableKey* key = [[ClsTableKey alloc] init];
                key.tableID = 1046;
                key.tableName = @"unitCare";
                key.desc = [ticketInputsData objectForKey:@"1046:0:1"] ;
                [arrSummary addObject:key];

            }
            
        }
        
        [self loadVitalData];
        
        [self loadAssessmentData];
        

    
    
    [tblSummary reloadData];
    
    arrAll = [[NSMutableArray alloc] initWithArray:arrSummary];


}

- (void)loadAssessmentData
{
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
    NSMutableDictionary* ticketInputData;
    int i = minInstance-1;
    if (i < 0)
    {
        i = 0;
    }
    for (int j = minInstance; j< minInstance+NumOfAssesment; j++)
    {
        ClsAssesment* assesment1 = [[ClsAssesment alloc] init];
        
        int count = -1;
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
        
        
        
        sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and inputID in (1800, 1801, 1802, 1803, 1804, 1805, 1806, 1807, 1808, 1809, 1810, 1811, 1812, 1813, 1814, 1815, 1816, 1817, 1818, 1819, 1820, 1821, 1822, 1823, 1824, 1825, 1826, 1827) and inputInstance = %d and (deleted is null or deleted = 0)", ticketID, i];
        @synchronized(g_SYNCDATADB)
        {
            ticketInputData = [DAO executeSelectTicketAssesmentInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            
        }
        
        if ([[ticketInputData objectForKey:@"1800"] length] > 0 && ([[ticketInputData objectForKey:@"1800"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.time = [ticketInputData objectForKey:@"1800"] ;
        }
        
        if ([[ticketInputData objectForKey:@"1801"] length] > 0 && ([[ticketInputData objectForKey:@"1801"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.skin = [ticketInputData objectForKey:@"1801"];
        }
        
        if ([[ticketInputData objectForKey:@"1802"] length] > 0 && ([[ticketInputData objectForKey:@"1802"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.head = [ticketInputData objectForKey:@"1802"];
            
        }
        
        if ([[ticketInputData objectForKey:@"1803"] length] > 0 && ([[ticketInputData objectForKey:@"1803"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.neck = [ticketInputData objectForKey:@"1803"];
        }
        
        if ([[ticketInputData objectForKey:@"1804"] length] > 0 && ([[ticketInputData objectForKey:@"1804"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.chest = [ticketInputData objectForKey:@"1804"];
        }
        
        if ([[ticketInputData objectForKey:@"1805"] length] > 0 && ([[ticketInputData objectForKey:@"1805"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.heart = [ticketInputData objectForKey:@"1805"];
        }
        
        if ([[ticketInputData objectForKey:@"1806"] length] > 0 && ([[ticketInputData objectForKey:@"1806"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.luAbd = [ticketInputData objectForKey:@"1806"];
        }
        
        if ([[ticketInputData objectForKey:@"1807"] length] > 0 && ([[ticketInputData objectForKey:@"1807"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.llAbd = [ticketInputData objectForKey:@"1807"];
        }
        
        if ([[ticketInputData objectForKey:@"1808"] length] > 0 && ([[ticketInputData objectForKey:@"1808"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.ruAbd =  [ticketInputData objectForKey:@"1808"];
        }
        
        if ([[ticketInputData objectForKey:@"1809"] length] > 0 && ([[ticketInputData objectForKey:@"1809"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.rrAbd = [ticketInputData objectForKey:@"1809"];
            
        }
        
        if ([[ticketInputData objectForKey:@"1810"] length] > 0 && ([[ticketInputData objectForKey:@"1810"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.gu = [ticketInputData objectForKey:@"1810"];
        }
        
        if ([[ticketInputData objectForKey:@"1811"] length] > 0 && ([[ticketInputData objectForKey:@"1811"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.cervical = [ticketInputData objectForKey:@"1811"];
        }
        
        if ([[ticketInputData objectForKey:@"1812"] length] > 0 && ([[ticketInputData objectForKey:@"1812"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.thoracic = [ticketInputData objectForKey:@"1812"];
        }
        
        if ([[ticketInputData objectForKey:@"1813"] length] > 0 && ([[ticketInputData objectForKey:@"1813"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.lumbar = [ticketInputData objectForKey:@"1813"];
        }
        
        if ([[ticketInputData objectForKey:@"1814"] length] > 0 && ([[ticketInputData objectForKey:@"1814"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.ruExt =  [ticketInputData objectForKey:@"1814"];
        }
        
        if ([[ticketInputData objectForKey:@"1815"] length] > 0 && ([[ticketInputData objectForKey:@"1815"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.rrExt = [ticketInputData objectForKey:@"1815"] ;
        }
        
        if ([[ticketInputData objectForKey:@"1816"] length] > 0 && ([[ticketInputData objectForKey:@"1816"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.luExt =  [ticketInputData objectForKey:@"1816"];
        }
        
        if ([[ticketInputData objectForKey:@"1817"] length] > 0 && ([[ticketInputData objectForKey:@"1817"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.llExt =  [ticketInputData objectForKey:@"1817"];
        }
        if ([[ticketInputData objectForKey:@"1818"] length] > 0 && ([[ticketInputData objectForKey:@"1818"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.leftEye = [ticketInputData objectForKey:@"1818"];
        }
        
        if ([[ticketInputData objectForKey:@"1819"] length] > 0 && ([[ticketInputData objectForKey:@"1819"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.rightEye =  [ticketInputData objectForKey:@"1819"];
        }
        
        if ([[ticketInputData objectForKey:@"1820"] length] > 0 && ([[ticketInputData objectForKey:@"1820"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.mentalStatus = [ticketInputData objectForKey:@"1820"];
        }
        
        if ([[ticketInputData objectForKey:@"1821"] length] > 0 && ([[ticketInputData objectForKey:@"1821"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.neurological = [ticketInputData objectForKey:@"1821"];
        }
        if ([[ticketInputData objectForKey:@"1822"] length] > 0 && ([[ticketInputData objectForKey:@"1822"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.avpu = [ticketInputData objectForKey:@"1822"];
        }
        if ([[ticketInputData objectForKey:@"1823"] length] > 0 && ([[ticketInputData objectForKey:@"1823"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.motor = [ticketInputData objectForKey:@"1823"];
        }
        if ([[ticketInputData objectForKey:@"1824"] length] > 0 && ([[ticketInputData objectForKey:@"1824"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.sensory = [ticketInputData objectForKey:@"1824"];
        }
        if ([[ticketInputData objectForKey:@"1825"] length] > 0 && ([[ticketInputData objectForKey:@"1825"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.speech = [ticketInputData objectForKey:@"1825"];
        }
        if ([[ticketInputData objectForKey:@"1826"] length] > 0 && ([[ticketInputData objectForKey:@"1826"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.leftEye = [ticketInputData objectForKey:@"1826"];
        }
        
        if ([[ticketInputData objectForKey:@"1827"] length] > 0 && ([[ticketInputData objectForKey:@"1827"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assesment1.rightEye = [ticketInputData objectForKey:@"1827"];
        }
        
        [self.arrAssessment addObject:assesment1];
        [self.arrSummary addObject:assesment1];
    }
   
}

- (void) sortArray
{
    NSDateFormatter* format1 = [[NSDateFormatter alloc] init];
    [format1 setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    for (int i = 0; i < [arrSummary count]; i++)
    {

        for (int j = 0; j < [arrSummary count] - 1; j++)
        {
            ClsTreatments* ass1 = [arrSummary objectAtIndex:j];
            
            NSString* temp1 = ass1.treatmentTime;
            NSDate* date1 = [format1 dateFromString:temp1];
            
            ClsTreatments* ass2 = [arrSummary objectAtIndex:j+1];
            
            NSString* temp2 = ass2.treatmentTime;
            
            NSDate* date2 = [format1 dateFromString:temp2];
            
            
            if ([date1 compare:date2] == NSOrderedDescending)
            {
                
                [arrSummary insertObject:ass2 atIndex:j];
                [arrSummary removeObjectAtIndex:j+2];

            }
            
        }
    }
    
}




- (void)loadVitalData
{
    ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sql = [NSString stringWithFormat:@"Select MAX(inputInstance) from TicketInputs where TicketID = %@ and InputID in (3001)", ticketID];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSInteger NumOfVitals = count;
    NSMutableDictionary* ticketInputsData;
    for (int i = 1; i<= NumOfVitals; i++)
    {
        ClsVital* vital1 = [[ClsVital alloc] init];
        sql = [NSString stringWithFormat:@"Select * from TicketInputs where TicketID = %@ and InputID in (3001, 3002, 3003, 3004, 3005, 3006, 3007, 3008, 3010, 3012, 3013, 3015) and inputInstance = %d", ticketID, i];
        @synchronized(g_SYNCDATADB)
        {
            ticketInputsData = [DAO selectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
        if ([[ticketInputsData objectForKey:@"3001"] length] > 0 && ([[ticketInputsData objectForKey:@"3001"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.timeTaken = [ticketInputsData objectForKey:@"3001"];
        }
        
        if ([[ticketInputsData objectForKey:@"3002"] length] > 0 && ([[ticketInputsData objectForKey:@"3002"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.bpSys = [ticketInputsData objectForKey:@"3002"];
        }
        
        if ([[ticketInputsData objectForKey:@"3003"] length] > 0 && ([[ticketInputsData objectForKey:@"3003"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.bpDia = [ticketInputsData objectForKey:@"3003"];
        }
        
        if ([[ticketInputsData objectForKey:@"3004"] length] > 0 && ([[ticketInputsData objectForKey:@"3004"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.rr = [ticketInputsData objectForKey:@"3004"];
        }
        
        if ([[ticketInputsData objectForKey:@"3005"] length] > 0 && ([[ticketInputsData objectForKey:@"3005"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.hr = [ticketInputsData objectForKey:@"3005"];
        }
        
        if ([[ticketInputsData objectForKey:@"3006"] length] > 0 && ([[ticketInputsData objectForKey:@"3006"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.spo2 = [ticketInputsData objectForKey:@"3006"];
        }
        
        if ([[ticketInputsData objectForKey:@"3007"] length] > 0 && ([[ticketInputsData objectForKey:@"3007"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.etco2 = [ticketInputsData objectForKey:@"3007"];
        }
        
        if ([[ticketInputsData objectForKey:@"3008"] length] > 0 && ([[ticketInputsData objectForKey:@"3008"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.glucose = [ticketInputsData objectForKey:@"3008"];
        }
        
        if ([[ticketInputsData objectForKey:@"3010"] length] > 0 && ([[ticketInputsData objectForKey:@"3010"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.temperature = [ticketInputsData objectForKey:@"3010"];
        }
        
        if ([[ticketInputsData objectForKey:@"3012"] length] > 0 && ([[ticketInputsData objectForKey:@"3012"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.position = [ticketInputsData objectForKey:@"3012"];
        }
        
        if ([[ticketInputsData objectForKey:@"3013"] length] > 0 && ([[ticketInputsData objectForKey:@"3013"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.performedBy = [ticketInputsData objectForKey:@"3013"];
        }
        
        if ([[ticketInputsData objectForKey:@"3015"] length] > 0 && ([[ticketInputsData objectForKey:@"3015"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.ekg = [ticketInputsData objectForKey:@"3015"];
        }
        [arrSummary addObject:vital1];
    }
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSummary count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"TreatmentInfoCell";
    SummaryInfoCell *cell = (SummaryInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SummaryInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
  //  cell.backgroundColor = [UIColor clearColor];
 //   cell.backgroundView = [UIView new];
   // cell.selectedBackgroundView = [UIView new];
    if([[arrSummary objectAtIndex:indexPath.row] isKindOfClass:[ClsTreatments class]])
        {
            ClsTreatments* treatment = [arrSummary objectAtIndex:indexPath.row];
            cell.lblTime.text = treatment.treatmentTime;
            cell.lblType.text = treatment.drugName;
            cell.lblDesc.text = treatment.treatmentDesc;
        }
    else if([[arrSummary objectAtIndex:indexPath.row] isKindOfClass:[ClsTableKey class]])
    {

        ClsTableKey* key = [arrSummary objectAtIndex:indexPath.row];
        cell.lblTime.text = key.desc;
        cell.lblType.text = @"CallTimes";
        cell.lblDesc.text = key.tableName;
 
    }
    else if([[arrSummary objectAtIndex:indexPath.row] isKindOfClass:[ClsVital class]])
    {
        ClsVital* vitalCell = [arrSummary objectAtIndex:indexPath.row];
        cell.lblTime.text = vitalCell.timeTaken;
        cell.lblType.text = @"Vital";
        cell.lblDesc.text = [NSString stringWithFormat:@"BPS:%@, BPD:%@, RR:%@, HR:%@", [self removeNull:vitalCell.bpSys], [self removeNull:vitalCell.bpDia], [self removeNull:vitalCell.rr], [self removeNull:vitalCell.hr]];
    }

    else if([[arrSummary objectAtIndex:indexPath.row] isKindOfClass:[ClsAssesment class]])
    {
        ClsAssesment* assCell = [arrSummary objectAtIndex:indexPath.row];
        cell.lblTime.text = assCell.time;
        cell.lblType.text = @"Assessment";
        cell.lblDesc.text = [NSString stringWithFormat:@"Skin:%@, Head/Face:%@, Neck:%@, Chest/Lungs:%@", [self removeNull:assCell.skin], [self removeNull:assCell.head], [self removeNull:assCell.neck], [self removeNull:assCell.chest]];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*    editTreatmentSelected = indexPath.row;
     
     ClsTreatments* treatment = [arrAllTreatments objectAtIndex:editTreatmentSelected];
     [lblTime setText:treatment.treatmentTime];
     [btnDrug setTitle:treatment.drugName forState:UIControlStateNormal]; */
    rowSelected = indexPath.row;
    if([[arrSummary objectAtIndex:indexPath.row] isKindOfClass:[ClsTreatments class]])
    {
        selectedType = @"Treatment";
    }
    else if([[arrSummary objectAtIndex:indexPath.row] isKindOfClass:[ClsTableKey class]])
    {
        selectedType = @"CallTimes";

    }
    else if([[arrSummary objectAtIndex:indexPath.row] isKindOfClass:[ClsVital class]])
    {
        selectedType = @"Vital";
    }
    else if([[arrSummary objectAtIndex:indexPath.row] isKindOfClass:[ClsAssesment class]])
    {
        selectedType = @"Assessment";
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

#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
}

#pragma mark-
#pragma mark UIControll callback

- (IBAction)btnAllPressed:(id)sender
{
    [arrSummary removeAllObjects];
    arrSummary = Nil;
    arrSummary = [[NSMutableArray alloc] initWithArray:arrAll];
    for(int i=0;i<[arrAssessment count] ; i++)
    {
        if([[arrAssessment objectAtIndex:i] isKindOfClass:[ClsTableKey class]])
        {
            [arrSummary addObject:[arrAssessment objectAtIndex:i]];
        }
        
    }
    [tblSummary reloadData];
}

- (IBAction)btnVitalPressed:(id)sender
{
    
    [arrSummary removeAllObjects];
    for(int i=0;i<[arrAll count] ; i++)
    {
        if([[arrAll objectAtIndex:i] isKindOfClass:[ClsVital class]])
        {
            [arrSummary addObject:[arrAll objectAtIndex:i]];
        }

    }
    [tblSummary reloadData];
}

-  (IBAction)btnTreatmentPressed:(id)sender
{
    [arrSummary removeAllObjects];

    for(int i=0;i<[arrAll count] ; i++)
    {
        if([[arrAll objectAtIndex:i] isKindOfClass:[ClsTreatments class]])
        {
            [arrSummary addObject:[arrAll objectAtIndex:i]];
        }
        
    }
    [tblSummary reloadData];
}

- (IBAction)btnCalltimesPressed:(id)sender
{
    [arrSummary removeAllObjects];

    for(int i=0;i<[arrAll count] ; i++)
    {
        if([[arrAll objectAtIndex:i] isKindOfClass:[ClsTableKey class]])
        {
            [arrSummary addObject:[arrAll objectAtIndex:i]];
        }
        
    }
    [tblSummary reloadData];
}

- (IBAction)btnEditClick:(id)sender {
    if (rowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"Please select an item to edit before continuing." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        if ([selectedType isEqualToString:@"Treatment"])
        {
            ClsTreatments* treatmentSelected = [arrSummary objectAtIndex:rowSelected];
            
            [g_SETTINGS setObject:treatmentSelected.dose forKey:@"SUMMARYKEY"];
            [g_SETTINGS setObject:@"3" forKey:@"SUMMARY"];
            [delegate doneSummaryView:3];
        }
        else if ([selectedType isEqualToString:@"CallTimes"])
        {
             [delegate doneSummaryView:4];
        }
        else if ([selectedType isEqualToString:@"Assessment"])
        {
            ClsAssesment* assessment = [arrSummary objectAtIndex:rowSelected];
            [g_SETTINGS setObject:assessment forKey:@"SUMMARYKEY"];
            [g_SETTINGS setObject:@"1" forKey:@"SUMMARY"];
            [delegate doneSummaryView:1];
        }
        else
        {
            ClsVital* vital = [arrSummary objectAtIndex:rowSelected];
            [g_SETTINGS setObject:vital forKey:@"SUMMARYKEY"];
            [g_SETTINGS setObject:@"2" forKey:@"SUMMARY"];
            [delegate doneSummaryView:2];
        }
    }
}

- (IBAction)btnAssessmentClick:(id)sender {
    
    [arrSummary removeAllObjects];
    for(int i=0;i<[arrAssessment count] ; i++)
    {
        if([[arrAssessment objectAtIndex:i] isKindOfClass:[ClsAssesment class]])
        {
            [arrSummary addObject:[arrAssessment objectAtIndex:i]];
        }
        
    }
    [tblSummary reloadData];
}


@end
