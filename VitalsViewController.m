//
//  VitalsViewController.m
//  iFhMedic
//
//  Created by admin on 10/31/15.
//  Copyright © 2015 com.emergidata. All rights reserved.
//

#import "VitalsViewController.h"
#import "global.h"
#import "DAO.h"
#import "ClsInputs.h"
#import "InputViewVital.h"
#import "QAMessageViewController.h"
#import "DDPopoverBackgroundView.h"
#import "ClsVital.h"
#import "VitalInfoCell.h"
#import "ClsVitalArray.h"
#import "ClsTableKey.h"

@interface VitalsViewController ()
{
    NSInteger lastPageCount;
    bool editMode;
    NSInteger deletedCount;
    NSInteger currentInstance;
    NSInteger maxInstance;
    NSMutableString* pageInputID;
    int labelCount;
    NSInteger start;
    int pageArray[10];
    NSInteger NumOfGroup;
    bool newVital;
}

@property (nonatomic, copy) NSString* ticketID;
@property (strong, nonatomic) VitalInfoCell *selectedCell;
@property (strong, nonatomic) NSMutableArray*  vitalArray;
@property (strong, nonatomic) NSMutableArray*  dbArray;
@property (strong, nonatomic) NSMutableDictionary* ticketInputsData;
@property (strong, nonatomic) NSMutableArray* ticketInputsArray;
@end

@implementation VitalsViewController

@synthesize popover;
@synthesize newTicket;
@synthesize delegate;
@synthesize btnNameLabel;
@synthesize incidentInput;
@synthesize inputContainer;
@synthesize btnQAMessage;
@synthesize vitalArray;
@synthesize dbArray;
@synthesize selectedCell;
@synthesize tvTreatment;
@synthesize ticketInputsData;
@synthesize ticketInputsArray;
@synthesize ticketID;

- (void)viewDidLoad {
    [super viewDidLoad];
    pageInputID = [[NSMutableString alloc] init];
    UIImage *toolBarIMG = [UIImage imageNamed:@"navigation_bar_bkg.png"];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }

    currentInstance = -1;

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    currentInstance = 1;
    lastPageCount = 0;
    labelCount = 0;
    start = 0;
    NumOfGroup = 0;
    deletedCount = 0;
    rowSelected = -1;
    newVital = false;
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    [self.pageControl setCurrentPage:0];
    self.vitalArray = [[NSMutableArray alloc] init];
    self.dbArray = [[NSMutableArray alloc] init];
    self.ticketInputsArray = [[NSMutableArray alloc] init];
    editMode = false;
    [self setViewUI:0];
    NSString* patientName;

    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
      btnNameLabel.title = patientName;
     [btnNameLabel setTintColor:[UIColor whiteColor]];

}

- (void) loadData
{
    [vitalArray removeAllObjects];
    [dbArray removeAllObjects];
    [ticketInputsArray removeAllObjects];
    

    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        NSString* sql = [NSString stringWithFormat:@"Select MAX(inputInstance) from TicketInputs where TicketID = %@ and InputID in (3001)", ticketID];
        maxInstance = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSInteger NumOfVitals = maxInstance;

    for (int i = 1; i<= NumOfVitals; i++)
    {
        ClsVital* vital1 = [[ClsVital alloc] init];
        @synchronized(g_SYNCDATADB)
        {
            self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            NSString* sql = [NSString stringWithFormat:@"Select * from TicketInputs where TicketID = %@ and InputID > 3000 and inputID < 4000 and inputInstance = %d", ticketID, i];
            
            ticketInputsData = [DAO selectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
        if ([[ticketInputsData objectForKey:@"Deleted"] length] > 0 && ([[ticketInputsData objectForKey:@"Deleted"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.deleted = [ticketInputsData objectForKey:@"Deleted"];
            if ([vital1.deleted isEqualToString:@"1"])
            {
                deletedCount++;
            }
            else
            {
                ClsVitalArray* inputarray = [[ClsVitalArray alloc] init];
                inputarray.inputData = ticketInputsData;
                inputarray.instance = i;
                [self.ticketInputsArray addObject:inputarray];
            }
        }
        else
        {
            ClsVitalArray* inputarray = [[ClsVitalArray alloc] init];
            inputarray.inputData = ticketInputsData;
            inputarray.instance = i;
            [self.ticketInputsArray addObject:inputarray];
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
        
        
        
        if ([[ticketInputsData objectForKey:@"3018"] length] > 0 && ([[ticketInputsData objectForKey:@"3018"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.gsc1 = [[ticketInputsData objectForKey:@"3018"] integerValue];
        }
        
        if ([[ticketInputsData objectForKey:@"3019"] length] > 0 && ([[ticketInputsData objectForKey:@"3019"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.gsc2 = [[ticketInputsData objectForKey:@"3019"] integerValue];
        }
        
        if ([[ticketInputsData objectForKey:@"3020"] length] > 0 && ([[ticketInputsData objectForKey:@"3020"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.gsc3 = [[ticketInputsData objectForKey:@"3020"] integerValue];
        }
        
        if ([[ticketInputsData objectForKey:@"3011"] length] > 0 && ([[ticketInputsData objectForKey:@"3011"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.gscTotal = [[ticketInputsData objectForKey:@"3011"] integerValue];
            vital1.gsc4 = [[ticketInputsData objectForKey:@"3011"] integerValue];
        }
        
        if ([[ticketInputsData objectForKey:@"3013"] length] > 0 && ([[ticketInputsData objectForKey:@"3013"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.performedBy = [ticketInputsData objectForKey:@"3013"];
        }
        
        if ([[ticketInputsData objectForKey:@"3012"] length] > 0 && ([[ticketInputsData objectForKey:@"3012"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.cbg = [ticketInputsData objectForKey:@"3012"];
        }
        
        if ([[ticketInputsData objectForKey:@"3029"] length] > 0 && ([[ticketInputsData objectForKey:@"3029"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.painScale = [ticketInputsData objectForKey:@"3029"];
        }
        if ([[ticketInputsData objectForKey:@"3035"] length] > 0 && ([[ticketInputsData objectForKey:@"3035"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.spmet = [ticketInputsData objectForKey:@"3035"];
        }
        if ([[ticketInputsData objectForKey:@"3036"] length] > 0 && ([[ticketInputsData objectForKey:@"3036"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.bpMeasure = [ticketInputsData objectForKey:@"3036"];
        }
        if ([[ticketInputsData objectForKey:@"3037"] length] > 0 && ([[ticketInputsData objectForKey:@"3037"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.emr = [ticketInputsData objectForKey:@"3037"];
        }
        
        if ([[ticketInputsData objectForKey:@"3038"] length] > 0 && ([[ticketInputsData objectForKey:@"3038"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.pulse = [ticketInputsData objectForKey:@"3038"];
        }
        
        if ([[ticketInputsData objectForKey:@"3021"] length] > 0 && ([[ticketInputsData objectForKey:@"3021"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.rts = [ticketInputsData objectForKey:@"3021"];
        }
        if ([[ticketInputsData objectForKey:@"3039"] length] > 0 && ([[ticketInputsData objectForKey:@"3039"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.respEffort = [ticketInputsData objectForKey:@"3039"];
        }
        if ([[ticketInputsData objectForKey:@"3040"] length] > 0 && ([[ticketInputsData objectForKey:@"3040"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.GCSQualifier = [ticketInputsData objectForKey:@"3040"];
        }
        if ([[ticketInputsData objectForKey:@"3041"] length] > 0 && ([[ticketInputsData objectForKey:@"3041"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.level = [ticketInputsData objectForKey:@"3041"];
        }
        if ([[ticketInputsData objectForKey:@"3015"] length] > 0 && ([[ticketInputsData objectForKey:@"3015"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.ekg = [ticketInputsData objectForKey:@"3015"];
        }
        if ([[ticketInputsData objectForKey:@"3042"] length] > 0 && ([[ticketInputsData objectForKey:@"3042"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.stroke = [ticketInputsData objectForKey:@"3042"];
        }
        if ([[ticketInputsData objectForKey:@"3034"] length] > 0 && ([[ticketInputsData objectForKey:@"3034"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.spco = [ticketInputsData objectForKey:@"3034"];
        }
        if ([[ticketInputsData objectForKey:@"3102"] length] > 0 && ([[ticketInputsData objectForKey:@"3102"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblSystolic = [ticketInputsData objectForKey:@"3102"];
        }
        if ([[ticketInputsData objectForKey:@"3103"] length] > 0 && ([[ticketInputsData objectForKey:@"3103"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblDiastolic = [ticketInputsData objectForKey:@"3103"];
        }
        if ([[ticketInputsData objectForKey:@"3104"] length] > 0 && ([[ticketInputsData objectForKey:@"3104"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblRr = [ticketInputsData objectForKey:@"3104"];
        }
        if ([[ticketInputsData objectForKey:@"3105"] length] > 0 && ([[ticketInputsData objectForKey:@"3105"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblhr = [ticketInputsData objectForKey:@"3105"];
        }
        if ([[ticketInputsData objectForKey:@"3106"] length] > 0 && ([[ticketInputsData objectForKey:@"3106"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblSpo2 = [ticketInputsData objectForKey:@"3106"];
        }
        if ([[ticketInputsData objectForKey:@"3107"] length] > 0 && ([[ticketInputsData objectForKey:@"3107"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblEtc02 = [ticketInputsData objectForKey:@"3107"];
        }
        if ([[ticketInputsData objectForKey:@"3108"] length] > 0 && ([[ticketInputsData objectForKey:@"3108"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblGlucose = [ticketInputsData objectForKey:@"3108"];
        }
        if ([[ticketInputsData objectForKey:@"3110"] length] > 0 && ([[ticketInputsData objectForKey:@"3110"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblTemp = [ticketInputsData objectForKey:@"3110"];
        }
        
        [self.dbArray addObject:vital1];

    }
    
    for (int i = 0; i<dbArray.count; i++)
    {
        ClsVital* vital1 = [dbArray objectAtIndex:i];
        
        if (![vital1.deleted isEqualToString:@"1"])
        {
            [self.vitalArray addObject:vital1];
        }
    }
    
    if (rowSelected == -1)
    {
        if(self.vitalArray.count > 0)
        {
            rowSelected = vitalArray.count - 1;
            ClsVitalArray* vitalToLoad = [ticketInputsArray objectAtIndex:rowSelected];
            currentInstance = vitalToLoad.instance;
            NSMutableDictionary* dict = vitalToLoad.inputData;
            currentInstance = vitalToLoad.instance;
            NSInteger page = self.pageControl.currentPage;
            for (NSInteger i =start; i < incidentInput.count && i <(self.pageControl.currentPage + 1)*8; i++)
            {
                InputViewVital* inputView = (InputViewVital*)[inputContainer viewWithTag:i+1];
                NSString* value = [dict objectForKey:[NSString stringWithFormat:@"%li", inputView.btnInput.tag]];
                if (value != nil || value.length > 0)
                {
                    [inputView setBtnText:value];
                }
            }
        }
        else
        {
            currentInstance = maxInstance + 1;
        }
        
    }
    else
    {
        ClsVitalArray* vitalToLoad = [ticketInputsArray objectAtIndex:rowSelected];
        NSMutableDictionary* dict = vitalToLoad.inputData;
        currentInstance = vitalToLoad.instance;
     //   NSInteger page = self.pageControl.currentPage;
        currentInstance = vitalToLoad.instance;
        for (NSInteger i =start; i < incidentInput.count && i <(self.pageControl.currentPage + 1)*8; i++)
        {
            InputViewVital* inputView = (InputViewVital*)[inputContainer viewWithTag:i+1];
            NSString* value = [dict objectForKey:[NSString stringWithFormat:@"%li", inputView.btnInput.tag]];
            if (value != nil || value.length > 0)
            {
                [inputView setBtnText:value];
            }
        }
        
        
        
    }
    [tvTreatment reloadData];
}


- (void) loadDefault
{
    
    NSString* sql = @"Select inputID, 'Inputs', InputDefault from Inputs where (InputPage = 'Vitals') and (inputDefault != '')";
    NSMutableArray* defaultArray;
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        defaultArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    
    for (NSInteger i =start; i < incidentInput.count && i <(self.pageControl.currentPage + 1)*8; i++)
    {
        for (int j = 0; j < defaultArray.count; j++)
        {
            ClsTableKey* key = [defaultArray objectAtIndex:j];
            InputViewVital* inputView = (InputViewVital*)[inputContainer viewWithTag:i+1];
            if (inputView.btnInput.tag == key.key)
            {
                [inputView.btnInput setTitle:key.desc forState:UIControlStateNormal];
            }
        }
        
    }
    
    
}


- (void) loadTableView
{
    [vitalArray removeAllObjects];
    [dbArray removeAllObjects];
    [ticketInputsArray removeAllObjects];
    
    
    NSString* sql = [NSString stringWithFormat:@"Select MAX(inputInstance) from TicketInputs where TicketID = %@ and InputID in (3001)", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        maxInstance = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSInteger NumOfVitals = maxInstance;
    
    for (int i = 1; i<= NumOfVitals; i++)
    {
        ClsVital* vital1 = [[ClsVital alloc] init];
        sql = [NSString stringWithFormat:@"Select * from TicketInputs where TicketID = %@ and InputID > 3000 and inputID < 4000 and inputInstance = %d", ticketID, i];
        @synchronized(g_SYNCDATADB)
        {
            ticketInputsData = [DAO selectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
        if ([[ticketInputsData objectForKey:@"Deleted"] length] > 0 && ([[ticketInputsData objectForKey:@"Deleted"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.deleted = [ticketInputsData objectForKey:@"Deleted"];
            if ([vital1.deleted isEqualToString:@"1"])
            {
                deletedCount++;
            }
            else
            {
                ClsVitalArray* inputarray = [[ClsVitalArray alloc] init];
                inputarray.inputData = ticketInputsData;
                inputarray.instance = i;
                [self.ticketInputsArray addObject:inputarray];
            }
        }
        else
        {
            ClsVitalArray* inputarray = [[ClsVitalArray alloc] init];
            inputarray.inputData = ticketInputsData;
            inputarray.instance = i;
            [self.ticketInputsArray addObject:inputarray];
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
        
        
        
        if ([[ticketInputsData objectForKey:@"3018"] length] > 0 && ([[ticketInputsData objectForKey:@"3018"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.gsc1 = [[ticketInputsData objectForKey:@"3018"] integerValue];
        }
        
        if ([[ticketInputsData objectForKey:@"3019"] length] > 0 && ([[ticketInputsData objectForKey:@"3019"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.gsc2 = [[ticketInputsData objectForKey:@"3019"] integerValue];
        }
        
        if ([[ticketInputsData objectForKey:@"3020"] length] > 0 && ([[ticketInputsData objectForKey:@"3020"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.gsc3 = [[ticketInputsData objectForKey:@"3020"] integerValue];
        }
        
        if ([[ticketInputsData objectForKey:@"3011"] length] > 0 && ([[ticketInputsData objectForKey:@"3011"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.gscTotal = [[ticketInputsData objectForKey:@"3011"] integerValue];
            vital1.gsc4 = [[ticketInputsData objectForKey:@"3011"] integerValue];
        }
        
        if ([[ticketInputsData objectForKey:@"3013"] length] > 0 && ([[ticketInputsData objectForKey:@"3013"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.performedBy = [ticketInputsData objectForKey:@"3013"];
        }
        
        if ([[ticketInputsData objectForKey:@"3012"] length] > 0 && ([[ticketInputsData objectForKey:@"3012"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.cbg = [ticketInputsData objectForKey:@"3012"];
        }
        
        if ([[ticketInputsData objectForKey:@"3029"] length] > 0 && ([[ticketInputsData objectForKey:@"3029"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.painScale = [ticketInputsData objectForKey:@"3029"];
        }
        if ([[ticketInputsData objectForKey:@"3035"] length] > 0 && ([[ticketInputsData objectForKey:@"3035"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.spmet = [ticketInputsData objectForKey:@"3035"];
        }
        if ([[ticketInputsData objectForKey:@"3036"] length] > 0 && ([[ticketInputsData objectForKey:@"3036"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.bpMeasure = [ticketInputsData objectForKey:@"3036"];
        }
        if ([[ticketInputsData objectForKey:@"3037"] length] > 0 && ([[ticketInputsData objectForKey:@"3037"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.emr = [ticketInputsData objectForKey:@"3037"];
        }
        
        if ([[ticketInputsData objectForKey:@"3038"] length] > 0 && ([[ticketInputsData objectForKey:@"3038"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.pulse = [ticketInputsData objectForKey:@"3038"];
        }
        
        if ([[ticketInputsData objectForKey:@"3021"] length] > 0 && ([[ticketInputsData objectForKey:@"3021"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.rts = [ticketInputsData objectForKey:@"3021"];
        }
        if ([[ticketInputsData objectForKey:@"3039"] length] > 0 && ([[ticketInputsData objectForKey:@"3039"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.respEffort = [ticketInputsData objectForKey:@"3039"];
        }
        if ([[ticketInputsData objectForKey:@"3040"] length] > 0 && ([[ticketInputsData objectForKey:@"3040"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.GCSQualifier = [ticketInputsData objectForKey:@"3040"];
        }
        if ([[ticketInputsData objectForKey:@"3041"] length] > 0 && ([[ticketInputsData objectForKey:@"3041"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.level = [ticketInputsData objectForKey:@"3041"];
        }
        if ([[ticketInputsData objectForKey:@"3015"] length] > 0 && ([[ticketInputsData objectForKey:@"3015"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.ekg = [ticketInputsData objectForKey:@"3015"];
        }
        if ([[ticketInputsData objectForKey:@"3042"] length] > 0 && ([[ticketInputsData objectForKey:@"3042"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.stroke = [ticketInputsData objectForKey:@"3042"];
        }
        if ([[ticketInputsData objectForKey:@"3034"] length] > 0 && ([[ticketInputsData objectForKey:@"3034"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.spco = [ticketInputsData objectForKey:@"3034"];
        }
        if ([[ticketInputsData objectForKey:@"3102"] length] > 0 && ([[ticketInputsData objectForKey:@"3102"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblSystolic = [ticketInputsData objectForKey:@"3102"];
        }
        if ([[ticketInputsData objectForKey:@"3103"] length] > 0 && ([[ticketInputsData objectForKey:@"3103"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblDiastolic = [ticketInputsData objectForKey:@"3103"];
        }
        if ([[ticketInputsData objectForKey:@"3104"] length] > 0 && ([[ticketInputsData objectForKey:@"3104"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblRr = [ticketInputsData objectForKey:@"3104"];
        }
        if ([[ticketInputsData objectForKey:@"3105"] length] > 0 && ([[ticketInputsData objectForKey:@"3105"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblhr = [ticketInputsData objectForKey:@"3105"];
        }
        if ([[ticketInputsData objectForKey:@"3106"] length] > 0 && ([[ticketInputsData objectForKey:@"3106"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblSpo2 = [ticketInputsData objectForKey:@"3106"];
        }
        if ([[ticketInputsData objectForKey:@"3107"] length] > 0 && ([[ticketInputsData objectForKey:@"3107"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblEtc02 = [ticketInputsData objectForKey:@"3107"];
        }
        if ([[ticketInputsData objectForKey:@"3108"] length] > 0 && ([[ticketInputsData objectForKey:@"3108"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblGlucose = [ticketInputsData objectForKey:@"3108"];
        }
        if ([[ticketInputsData objectForKey:@"3110"] length] > 0 && ([[ticketInputsData objectForKey:@"3110"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            vital1.lblTemp = [ticketInputsData objectForKey:@"3110"];
        }
        
        [self.dbArray addObject:vital1];
        
    }
    
    for (int i = 0; i<dbArray.count; i++)
    {
        ClsVital* vital1 = [dbArray objectAtIndex:i];
        if (![vital1.deleted isEqualToString:@"1"])
        {
            [self.vitalArray addObject:[dbArray objectAtIndex:i]];
        }
    }
    

    [tvTreatment reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setViewUI:(NSInteger)page
{
    for (UIView* subview in self.inputContainer.subviews)
    {
        [subview removeFromSuperview];
    }
    if (page == 0)
    {
        labelCount = 0;
    }
    NSString* sqlGroup = @"SELECT count (distinct VitalsGroup) FROM vitals";
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        NumOfGroup = [DAO getCount:[[g_SETTINGS objectForKey:@"lookupDB"]pointerValue] Sql:sqlGroup];
    }
    if (self.pageControl.currentPage >= lastPageCount)
    {
        start = (int) (page * 8) - labelCount;
    }
    else
    {
        if (page == 0)
        {
            start = 0;
        }
        else
        {
            start = (int) (page * 8) - pageArray[self.pageControl.currentPage - 1];
            labelCount = pageArray[self.pageControl.currentPage - 1];
        }
    }
    
    if (self.incidentInput == nil)
    {
        NSString* querySql = @"select InputID, VitalName as InputName, VitalDataType as InputDataType, VitalsGroup as InputGroup, vitalRequired as InputRequiredField, inputDesc from Vitals where vitalVisible = 1 order by VitalsGroup DESC, VitalsIndex";
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.incidentInput = [DAO selectVitalInputs:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql];
        }
        int numOfPage = ((int) (self.incidentInput.count + NumOfGroup)/8) + 1;
        self.pageControl.numberOfPages = numOfPage;
    }
    
    NSInteger ypos = 5;

    NSString* lastGroup;
    for (int i = start; i < incidentInput.count; i++)
    {
        ClsInputs* input = [incidentInput objectAtIndex:i];
        if (lastGroup == nil || ![lastGroup isEqualToString:input.inputGroup])
        {
            UILabel* label = [[UILabel alloc] init];
            label.frame = CGRectMake(0, ypos, 1024, 44);
            label.text = [NSString stringWithFormat:@"   %@", input.inputGroup];
            label.textAlignment = NSTextAlignmentLeft;
            [label setFont:[UIFont boldSystemFontOfSize:18]];
            [self.inputContainer addSubview:label];
            ypos += 45;
            lastGroup = input.inputGroup;
            labelCount++;
            pageArray[self.pageControl.currentPage] = labelCount;
        }
        
        InputViewVital* inputView = [[InputViewVital alloc] init];
        inputView.tabPage = 2;
        inputView.backgroundColor = [UIColor whiteColor];
        inputView.frame = CGRectMake(0, ypos, 1024, 44);
        inputView.inputType = input.inputDataType;
        inputView.inputID = input.inputID;
        inputView.delegate = self;
        inputView.tag = i + 1;
        inputView.btnInput.tag = input.inputID;
        [self.inputContainer addSubview:inputView];
        [inputView setLabelText:input.inputName dataType:input.inputDataType inputRequired:input.inputRequiredField];
        ypos += 45;
        
        if (ypos > 330)
        {
            break;
        }
    }
    
    [pageInputID setString:@""];
    
    for (int i = start; i < incidentInput.count; i++)
    {
        ClsInputs* input = [incidentInput objectAtIndex:i];
        [pageInputID appendString:[NSString stringWithFormat:@"%ld", input.inputID]];
        if (i < incidentInput.count - 1)
        {
            [pageInputID appendString:@","];
        }
        
    }
    NSString* defaultStr = [NSString stringWithFormat:@"Select count(*) from ticketInputs where ticketID = %@ and inputID in (%@) and inputInstance = %d", ticketID, pageInputID, currentInstance];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:defaultStr];
    }
    
    if (count > 0)
    {
        [self loadData];
    }
    else
    {
        [self loadDefault];
        if (!newVital)
        {
            [self loadData];
        }
    }
    
    
}


- (void) viewWillDisappear:(BOOL)animated
{
    
    [self saveTab];
    self.vitalArray = nil;
    self.incidentInput = nil;
    self.dbArray = nil;
    [super viewWillDisappear:YES];
}


- (void) saveTab
{
    NSString* sqlStr;
    NSInteger count;
    newVital = false;
    NSString* status = [g_SETTINGS objectForKey:@"TicketStatus"];
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    if ( [status isEqualToString:@"3"] || [status isEqualToString:@"5"])
    {
        NSString* userID = [g_SETTINGS objectForKey:@"UserID"];
        sqlStr = [NSString stringWithFormat:@"Select max(ChangeID) from TicketChanges where TicketID = %@", ticketID ];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getInstance:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        NSDate* sourceDate = [NSDate date];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
        NSString* timeAdded = [dateFormat stringFromDate:sourceDate];
        for (NSInteger i =  start ; i < self.incidentInput.count && i < (lastPageCount + 1)* 8; i++)
        {
            InputViewVital* inputView = (InputViewVital*)[inputContainer viewWithTag:i+1];
            NSString* inputValue = [self removeNull:inputView.btnInput.titleLabel.text];
            NSString* inputKey = [NSString stringWithFormat:@"%d:0:1", inputView.btnInput.tag];
            if ( (inputValue != nil) && !([inputValue isEqualToString:[ticketInputsData objectForKey:inputKey]]) )
            {
                count++;
                sqlStr = [NSString stringWithFormat:@"Insert into TicketChanges(LocalTicketID, TicketID, ChangeID, ChangeMade, ChangeTime, ModifiedBy, ChangeInputID, OriginalValue) Values(0, %@, %d, 'Input changed from %@ to %@', '%@', %@, %d, '%@')", ticketID, count , [ticketInputsData objectForKey:inputKey] ,inputValue, timeAdded, userID, inputView.btnInput.tag, [ticketInputsData objectForKey:inputKey]];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
            }
            
        }
        
    }


    for (NSInteger i =  start; i < self.incidentInput.count && i < (lastPageCount + 1)* 8; i++)
    {
        ClsInputs* input = [incidentInput objectAtIndex:i];
        InputViewVital* inputView = (InputViewVital*)[inputContainer viewWithTag:i+1];
        NSString* inputValue = [self removeNull:inputView.btnInput.titleLabel.text];
        
        @synchronized(g_SYNCDATADB)
        {
            self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, inputView.btnInput.tag, 0, currentInstance, @"Vital", input.inputShortDesc, inputValue];
            NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d and inputInstance = %d", inputValue, ticketID, inputView.btnInput.tag, currentInstance];
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
        }
    }


}


- (IBAction)btnPageControlClick:(UIPageControl *)sender {
    [self saveTab];
    [self setViewUI:self.pageControl.currentPage];
   lastPageCount = self.pageControl.currentPage;
    [self.tvTreatment reloadData];
}

- (void) doneInputViewVital:(NSInteger) tag
{
    if (tag < self.incidentInput.count && tag < (self.pageControl.currentPage + 1)*12)
    {
        InputViewVital* inputView = (InputViewVital*)[inputContainer viewWithTag:tag + 1];
        [inputView btnInputClick:inputView.btnInput];
    }
    InputViewVital* inputView = (InputViewVital*)[inputContainer viewWithTag:1];
    if (inputView.btnInput.titleLabel.text.length < 2)
    {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        [inputView setBtnText:dateString];
    }
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

- (IBAction)btnMainMenuClick:(id)sender {
    
    [delegate dismissViewControl];
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

- (IBAction)btnDeleteClick:(id)sender {
    if (rowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic For iPad" message:@"Please select a vital entry below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        [self saveTab];
        ClsVitalArray* vitalToLoad = [ticketInputsArray objectAtIndex:rowSelected];
        NSInteger instanceSelected = vitalToLoad.instance;
        NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set Deleted = 1, isUploaded = 0 where TicketID = %@ and InputPage = 'Vital' and inputInstance = %ld", ticketID, instanceSelected];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:updateStr];
        }

        rowSelected = -1;
        currentInstance = -1;
        lastPageCount = 0;
        [self setViewUI:0];
        [self loadData];
    }
}

- (IBAction)btnReplicateClick:(id)sender {
    if (rowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic For iPad" message:@"Please select a vital entry below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        [self saveTab];
        ClsVitalArray* vitalToLoad = [ticketInputsArray objectAtIndex:rowSelected];
        NSInteger sourceVitalInstance = vitalToLoad.instance;
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        NSInteger newInstance = maxInstance + 1;
        NSString* updateStr = [NSString stringWithFormat:@"Insert into TicketInputs(localTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) select localTicketID, TicketID, InputID, InputSubID, %ld, InputPage, InputName, InputValue, 0 from ticketInputs where TicketID = %@ and InputID > 3000 and inputID < 4000 and inputInstance = %ld", newInstance,ticketID, sourceVitalInstance];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:updateStr];
        }
        
        updateStr = [NSString stringWithFormat:@"Update ticketInputs set InputValue = '%@' where ticketID = %@ and inputID = 3001 and inputInstance = %ld", dateString, ticketID, newInstance];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:updateStr];
        }
        rowSelected = -1;
        currentInstance = -1;
        lastPageCount = 0;
        [self setViewUI:0];
        [self loadData];
    }
}

- (IBAction)btnEditClick:(id)sender {
    if (rowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic For iPad" message:@"Please select a vital entry below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        [self saveTab];
        lastPageCount = self.pageControl.currentPage;
        [self.pageControl setCurrentPage:0];
        lastPageCount = self.pageControl.currentPage;
        [self setViewUI:self.pageControl.currentPage];
        [self loadData];
         
    }
}

- (IBAction)btnNewVitalsClick:(id)sender {
    [self saveTab];
    [self.pageControl setCurrentPage:0];
    lastPageCount = self.pageControl.currentPage;
    currentInstance++;
    maxInstance++;
    newVital = true;
    [self setViewUI:0];
    [self loadTableView];
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    InputViewVital* inputView = (InputViewVital*)[inputContainer viewWithTag:1];
    [inputView setBtnText:dateString];
    rowSelected = ticketInputsArray.count;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [vitalArray count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"Time Taken                 BP Sys   BP Dia   HR         RR       SPO2%    ETCO2    Temp     Glucose  GCS1     GCS2     GCS3     GCS4";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"VitalInfoCell";
    
    VitalInfoCell *cell = (VitalInfoCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VitalInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    ClsVital* vitalCell = [vitalArray objectAtIndex:indexPath.row];
    if (![vitalCell.deleted isEqualToString:@"1"])
    {
        cell.lblTimeTaken.text = vitalCell.timeTaken;
        cell.lblBPSys.text = vitalCell.bpSys;
        cell.lblBPDia.text = vitalCell.bpDia;
        cell.lblHR.text = vitalCell.hr;
        cell.lblRR.text = vitalCell.rr;
        cell.lblSPO2.text = vitalCell.spo2;
        cell.lblETCO2.text = vitalCell.etco2;
        cell.lblGlucose.text = vitalCell.glucose;
        cell.lblTemperature.text = vitalCell.temperature;
        cell.lblPosition.text = vitalCell.position;
        cell.lblSpco.text = vitalCell.spco;
        cell.lblGsc1.text = [NSString stringWithFormat:@"%d",vitalCell.gsc1];
        cell.lblGsc2.text = [NSString stringWithFormat:@"%d",vitalCell.gsc2];
        cell.lblGsc3.text = [NSString stringWithFormat:@"%d",vitalCell.gsc3];
        cell.lblGsc4.text = [NSString stringWithFormat:@"%d",vitalCell.gsc4];
        cell.lblGscTotal.text = [NSString stringWithFormat:@"%d",vitalCell.gscTotal];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    rowSelected = indexPath.row;
   // self.selectedCell = (VitalInfoCell *)[tableView cellForRowAtIndexPath:indexPath];

    
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

- (IBAction)btnRightClick:(id)sender {
    if (lastPageCount < self.pageControl.numberOfPages - 1)
    {
        [self saveTab];
        self.pageControl.currentPage = lastPageCount + 1;
        [self setViewUI:self.pageControl.currentPage];
        lastPageCount = self.pageControl.currentPage;
    }
}

- (IBAction)btnLeftClick:(id)sender {
    if (lastPageCount > 0)
    {
        [self saveTab];
        self.pageControl.currentPage = lastPageCount - 1;
        [self setViewUI:self.pageControl.currentPage];
        lastPageCount = self.pageControl.currentPage;
    }
}
@end
