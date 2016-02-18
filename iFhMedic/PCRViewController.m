//
//  PCRViewController.m
//  iRescueMedic
//
//  Created by Nathan on 7/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "PCRViewController.h"
#import "global.h"
#import "DAO.h"
#import "ClsUsers.h"
#import "ClsUnits.h"
#import "ClsTicketInputs.h"
#import "ClsSignatureImages.h"
#import "Base64.h"
#import "ClsTicketChanges.h"
#import "ClsSignatureTypes.h"
#import "FaxViewController.h"
#import "DDPopoverBackgroundView.h"
#import <WebKit/WebKit.h>
#import "Reachability.h"
#import "ServiceSvc.h"

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

@interface PCRViewController ()
{
    WKWebView* webView1;
}
@end

@implementation PCRViewController
@synthesize htmlString;
@synthesize btnPrint;
@synthesize btnBarPrint;
@synthesize popover;

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
    
    CGRect rect = CGRectMake(0, 64, 1024, 705);
    webView1 = [[WKWebView alloc] initWithFrame:rect];
    
    [self.view addSubview:webView1];
    [self loadPcrXslt];
    // [self loadPCR];
    [self setViewUI];
}
-(void) loadPcrXslt
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* querySql =[NSString stringWithFormat:@"Select inputID, inputvalue from ticketInputs where ticketID = %@ and inputPage != 'Assessment' and (inputValue is not null and inputValue != '' and inputValue != ' ' and inputValue != '(null)') order by inputID", ticketID];
    NSMutableArray* dataArray;
    @synchronized(g_SYNCDATADB)
    {
        dataArray = [DAO SelectInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:querySql];
    }
    htmlString = [[NSMutableString alloc] init];
    [htmlString appendString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>"];
    
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
        [htmlString appendString:data];
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
            [htmlString appendString:[NSString stringWithFormat:@"%@", title]];
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
    
    NSString* sqlChanges = [NSString stringWithFormat:@"Select ticketID, changeID, changeMade, changeTime, modifiedby, changeinputID, originalValue from ticketChanges where ticketId = %@", ticketID];
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
            NSString* newStr1 = [change.changeMade stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
            NSString* newStr2 = [newStr1 stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
            NSString* newStr3 = [newStr2 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
            
            [htmlString appendString:[NSString stringWithFormat:@"<ChangeMade>%@</ChangeMade>", newStr3]];
            
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
    
    
    NSString*  styleSheetPath;
    
    NSString* custom = [g_SETTINGS objectForKey:@"CustomPCR"];
    
    if ([custom isEqualToString:@"1"])
    {
        styleSheetPath = [[NSBundle mainBundle] pathForResource: @"CustomPCR" ofType:@"xsl"];
    }
    else
    {
        styleSheetPath = [[NSBundle mainBundle] pathForResource: @"PCR" ofType:@"xslt"];
    }
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
    //  NSString* tempStr = [result stringByReplacingOccurrencesOfString:@"?>" withString:@"?> <header><meta name=\"viewport\" content=\"initial-scale=0.5\" /></header>"];
    NSString* newStr = [result stringByReplacingOccurrencesOfString:@"|CRLF|" withString:@"<br/>"];
    [webView1 loadHTMLString:newStr baseURL:nil];
    
    free(xmlResultBuffer);
    
    xsltFreeStylesheet(sty);
    xmlFreeDoc(res);
    xmlFreeDoc(doc);
    
    xsltCleanupGlobals();
    xmlCleanupParser();
    
}


-(void) loadPCR
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketUnitNumber, ticketShift as TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and (deleted is null or deleted = 0)", ticketID ];
    
    NSMutableDictionary* ticketInputsData;
    NSMutableArray* crewData;
    NSMutableArray* unitData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSString* crewIds = [[ticketInputsData objectForKey:@"TicketCrew"] stringByReplacingOccurrencesOfString:@"|" withString:@","];
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
    sql = [NSString stringWithFormat:@"Select * from users where userID in (%@)", crewIDStr ];
    @synchronized(g_SYNCLOOKUPDB)
    {
        crewData = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    sql = [NSString stringWithFormat:@"UnitID = %@", [ticketInputsData objectForKey:@"TicketID"] ];
    @synchronized(g_SYNCLOOKUPDB)
    {
        unitData = [DAO loadUnits:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Filter:sql];
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
    if ([insuranceList count] > 0)
    {
        [insuranceArray addObject:insuranceProvider];
    }
    
    
    // NSString *path = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"jpg"];
    NSString* logoStr = @"Select FileString from customerContent where FileType = 'Logo'";
    NSString* logo;
    @synchronized(g_SYNCLOOKUPDB)
    {
        logo =  [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:logoStr];
    }
    htmlString = [NSMutableString stringWithString:@"<html><head><title>PCR Report</title>"];
    [htmlString appendString:@"<style type=\"text/css\">"];
    [htmlString appendString:@"BODY{ font-family:sans-serif; font-size: 14px;}"];
    [htmlString appendString:@"#header { clear: both; position: relative; height: 10em; margin: 0 auto;}"];
    [htmlString appendString:@"#header img {position: absolute; top: 4%; right: 10px; height: 80%;}"];
    [htmlString appendString:@"#SubHeader {position: relative; top: 0%; left: 25px}"];
    [htmlString appendString:@"#SectionTitle { clear: both; position: relative; height: 1em; margin: 0 auto; background-color: #CDD2E5;}"];
    [htmlString appendString:@"#PatientInfo { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Insurance { clear: both; position: relative;}"];
    [htmlString appendString:@"#PatientAssessment { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Vitals { clear: both; position: relative; height: auto; margin: 5px auto; font-size: 14px; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Treatments { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Protocols { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Comments { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#IncidentInformation { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#CallTimes { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Signatures { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Amendments { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Provider { clear: both; position: relative; height: auto; margin: 5px auto; font-size: 12px;}"];
    [htmlString appendString:@"#Footer { clear: both; position: relative; height: auto; margin: 5px auto; border-top: 2px solid #48525B}"];
    [htmlString appendString:@"</style>"];
    
    [htmlString appendString:@"</head>"];
    [htmlString appendString:@"<body style=\"background:transparent;\">"];
    [htmlString appendString:@"<div id=\"header\" class=\"width100\">"];
    // [htmlString appendString:[NSString stringWithFormat:@"<img src=\"file://%@\" alt=\"\" border=\"0\">", path]];
    [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\">", logo]];
    [htmlString appendString:@"</img>"];
    [htmlString appendString:@"</img>"];
    [htmlString appendString:@"<H2>Patient Care Report</H2>"];
    [htmlString appendString:@"<div id=\"SubHeader\" class=\"width100\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Incident Number:</b> %@ <br>", [self removeNull:[ticketInputsData objectForKey:@"1001:0:1"]]]];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Date of Service:</b> %@ <br>", [self removeNull:[ticketInputsData objectForKey:@"1002:0:1"]]]];
    
    [htmlString appendString:[NSString stringWithFormat:@"<b>Impression:</b> %@ <br>", [self removeNull:[ticketInputsData objectForKey:@"1008:0:1"]]]];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Chief Complaint:</b> %@ <br>", [self removeNull:[ticketInputsData objectForKey:@"1013:0:1"]]]];
    NSString* shift = [self removeNull:[ticketInputsData objectForKey:@"TicketGUID"]];
    NSString* shiftSql = [NSString stringWithFormat:@"Select shiftname from shifts where shiftID = %@", shift];
    NSString* shiftName;
    @synchronized(g_SYNCLOOKUPDB)
    {
        shiftName =  [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:shiftSql];
    }
    [htmlString appendString:[NSString stringWithFormat:@"<b>Unit/Crew:</b> %@ - %@ <b>Shift:</b> %@<br>", unitList, crewList, [self removeNull:shiftName]]];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"<div id=\"PatientInfo\" class=\"width100\">"];
    [htmlString appendString:@"<div id=\"SectionTitle\" class=\"width100\">"];
    [htmlString appendString:@"<b>Patient Information</b><br>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<div>"];
    [htmlString appendString:@"<table border=\"0\"; align=\"left\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td WIDTH=\"20%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Last Name:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1101:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"20%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>First Name:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1102:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"16%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>MI:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1118:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"16%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>DOB:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1103:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"16%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Age:</b> %@ <br>", [self removeNull:[ticketInputsData objectForKey:@"1119:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"16%\">"];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td WIDTH=\"20%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Sex: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1105:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"20%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Race: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1104:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"16%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Phone: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1106:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"16%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"SSN: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1133:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"16%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"DL#: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1130:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"10%\">"];
    
    [htmlString appendString:[NSString stringWithFormat:@"Height: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1131:0:1"]]]];
    
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td WIDTH=\"20%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Address: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1107:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"20%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"City: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1109:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"16%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"State: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1110:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"16%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Zip: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1112:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"16%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"County: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1111:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"10%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Weight: %@ ", [self removeNull:[ticketInputsData objectForKey:@"1132:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"<div id=\"Insurance\">"];
    [htmlString appendString:@"<table border=\"0\" width=\"100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width=\"10%\" valign=\"top\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Residency:</b>  %@", [self removeNull:[ticketInputsData objectForKey:@"1135:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td valign=\"top\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Insurance:</b> %@ ", insuranceProvider]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Patient Medications:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1433:0:1"]]]];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"<b>Patient Allergies:</b>"];
    if ([self removeNull:[ticketInputsData objectForKey:@"1224:0:1"]].length > 0)
    {
        [htmlString appendString:[NSString stringWithFormat:@"<b> Environmental</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1224:0:1"]]]];
    }
    if ([self removeNull:[ticketInputsData objectForKey:@"1225:0:1"]].length > 0)
    {
        [htmlString appendString:[NSString stringWithFormat:@"<b> Food</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1225:0:1"]]]];
    }
    if ([self removeNull:[ticketInputsData objectForKey:@"1226:0:1"]].length > 0)
    {
        [htmlString appendString:[NSString stringWithFormat:@"<b> Insects</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1226:0:1"]]]];
    }
    if ([self removeNull:[ticketInputsData objectForKey:@"1227:0:1"]].length > 0)
    {
        [htmlString appendString:[NSString stringWithFormat:@"<b> Medications</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1227:0:1"]]]];
    }
    [htmlString appendString:@"<br>"];
    if ([[self removeNull:[ticketInputsData objectForKey:@"1132:0:1"]] length] > 0 )
    {
        [htmlString appendString:[NSString stringWithFormat:@"<b>EMS Exposure:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1132"]]]];
        [htmlString appendString:@"<br>"];
    }
    
    NSMutableString* histList = [[NSMutableString alloc] init];
    if ([[self removeNull:[ticketInputsData objectForKey:@"1601:0:1"]] length] > 0 )
    {
        [histList appendString:[NSString stringWithFormat:@"<b>Cardio</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1601:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1602:0:1"]] length] > 0 )
    {
        [histList appendString:[NSString stringWithFormat:@"<b>Cancer</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1602:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1603:0:1"]] length] > 0 )
    {
        [histList appendString:[NSString stringWithFormat:@"<b>Neuro</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1603:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1604:0:1"]] length] > 0 )
    {
        [histList appendString:[NSString stringWithFormat:@"<b>GI</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1604:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1605:0:1"]] length] > 0 )
    {
        [histList appendString:[NSString stringWithFormat:@"<b>Genitourinary</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1605:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1606:0:1"]] length] > 0 )
    {
        [histList appendString:[NSString stringWithFormat:@"<b>Infectious</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1606:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1607:0:1"]] length] > 0 )
    {
        [histList appendString:[NSString stringWithFormat:@"<b>Metabolic/Endocrine</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1607:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1608:0:1"]] length] > 0 )
    {
        [histList appendString:[NSString stringWithFormat:@"<b>Respiratory</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1608:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1609:0:1"]] length] > 0 )
    {
        [histList appendString:[NSString stringWithFormat:@"<b>Psych</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1609:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1610:0:1"]] length] > 0 )
    {
        [histList appendString:[NSString stringWithFormat:@"<b>Womens Health</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1610:0:1"]]]];
    }
    
    [htmlString appendString:[NSString stringWithFormat:@"<b>Patient History:</b> %@ ", histList]];
    [htmlString appendString:@"<br>"];
    
    NSMutableString* symtomsList = [[NSMutableString alloc] init];
    if ([[self removeNull:[ticketInputsData objectForKey:@"1501:0:1"]] length] > 0 )
    {
        [symtomsList appendString:[NSString stringWithFormat:@"<b>General</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1501:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1502:0:1"]] length] > 0 )
    {
        [symtomsList appendString:[NSString stringWithFormat:@"<b>Respiratory</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1502:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1503:0:1"]] length] > 0 )
    {
        [symtomsList appendString:[NSString stringWithFormat:@"<b>Cardiovascular</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1503:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1504:0:1"]] length] > 0 )
    {
        [symtomsList appendString:[NSString stringWithFormat:@"<b>Neurological</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1504:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1505:0:1"]] length] > 0 )
    {
        [symtomsList appendString:[NSString stringWithFormat:@"<b>Head / Neck</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1505:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1506:0:1"]] length] > 0 )
    {
        [symtomsList appendString:[NSString stringWithFormat:@"<b>GI</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1506:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1507:0:1"]] length] > 0 )
    {
        [symtomsList appendString:[NSString stringWithFormat:@"<b>GU / GYN</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1507:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1508:0:1"]] length] > 0 )
    {
        [symtomsList appendString:[NSString stringWithFormat:@"<b>Musculoskeletal</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1508:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1509:0:1"]] length] > 0 )
    {
        [symtomsList appendString:[NSString stringWithFormat:@"<b>Metabolic</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1509:0:1"]]]];
    }
    
    [htmlString appendString:[NSString stringWithFormat:@"<b>Patient Symptoms:</b> %@ ", symtomsList]];
    [htmlString appendString:@"<br>"];
    if ([[self removeNull:[ticketInputsData objectForKey:@"1010:0:1"]] length] > 0 )
    {
        [htmlString appendString:[NSString stringWithFormat:@"<b>Secondary Complaint:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1010:0:1"]]]];
    }
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"<div id=\"PatientAssessment\" class=\"width100\">"];
    [htmlString appendString:@"<div id=\"SectionTitle\" class=\"width100\">"];
    [htmlString appendString:@"<b>Patient Assessment</b><br>"];
    [htmlString appendString:@"</div>"];
    
    NSString* sqlAssess = [NSString stringWithFormat:@"Select count(distinct inputInstance) from TicketInputs where TicketID = %@ and inputID = 1800 and (deleted is null or deleted = 0)", ticketID];
    
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlAssess];
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
    for (int j = minInstance; j< minInstance+NumOfAssesment; j++)
    {
        
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
        
        [self appendAssessment:ticketInputsData searchFor:i];
    }
    
    NSMutableString* gcsList = [[NSMutableString alloc] init];
    NSInteger gcsCount = 0;
    if ([[self removeNull:[ticketInputsData objectForKey:@"1235:0:1"]] length] > 0 )
    {
        [gcsList appendString:[NSString stringWithFormat:@"<b>Motor</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1235:0:1"]]]];
        gcsCount++;
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1236:0:1"]] length] > 0 )
    {
        [gcsList appendString:[NSString stringWithFormat:@"<b>Verbal</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1236:0:1"]]]];
        gcsCount++;
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1237:0:1"]] length] > 0 )
    {
        [gcsList appendString:[NSString stringWithFormat:@"<b>Eye</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1237:0:1"]]]];
        gcsCount++;
    }
    if (gcsCount > 0 )
    {
        [gcsList appendString:[NSString stringWithFormat:@"<b>Total</b> - %i ", gcsCount]];
    }
    
    if (gcsList.length > 0)
    {
        [htmlString appendString:[NSString stringWithFormat:@"<b>GCS:</b> %@ ", gcsList]];
        [htmlString appendString:@"<br>"];
    }
    NSMutableString* opqrst = [[NSMutableString alloc] init];
    NSMutableString* injuryList = [[NSMutableString alloc] init];
    if ([[self removeNull:[ticketInputsData objectForKey:@"1210:0:1"]] length] > 0 )
    {
        [opqrst appendString:[NSString stringWithFormat:@"<b>Onset</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1210:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1211:0:1"]] length] > 0 )
    {
        [opqrst appendString:[NSString stringWithFormat:@"<b>Provocation</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1211:0:1"]]]];
    }
    
    if ([[self removeNull:[ticketInputsData objectForKey:@"1212:0:1"]] length] > 0 )
    {
        [opqrst appendString:[NSString stringWithFormat:@"<b>Quality</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1212:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1213:0:1"]] length] > 0 )
    {
        [opqrst appendString:[NSString stringWithFormat:@"<b>Radiation</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1213:0:1"]]]];
    }
    
    
    NSInteger timeFlag = 0;
    if ([[self removeNull:[ticketInputsData objectForKey:@"1216:0:1"]] length] > 0 )
    {
        [opqrst appendString:[NSString stringWithFormat:@"<b>Time</b> - "]];
        timeFlag = 1;
        [opqrst appendString:[NSString stringWithFormat:@"%@ Days ", [self removeNull:[ticketInputsData objectForKey:@"1216:0:1"]]]];
    }
    
    if ([[self removeNull:[ticketInputsData objectForKey:@"1217:0:1"]] length] > 0 )
    {
        if (timeFlag == 0)
        {
            [opqrst appendString:[NSString stringWithFormat:@"<b>Time</b> - "]];
            timeFlag = 1;
        }
        [opqrst appendString:[NSString stringWithFormat:@"%@ Hours ", [self removeNull:[ticketInputsData objectForKey:@"1217:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1218:0:1"]] length] > 0 )
    {
        if (timeFlag == 0)
        {
            [opqrst appendString:[NSString stringWithFormat:@"<b>Time</b> - "]];
            timeFlag = 1;
        }
        [opqrst appendString:[NSString stringWithFormat:@"%@ Minutes", [self removeNull:[ticketInputsData objectForKey:@"1218:0:1"]]]];
    }
    
    if ([[self removeNull:[ticketInputsData objectForKey:@"1262:0:1"]] length] > 0 )
    {
        [opqrst appendString:[NSString stringWithFormat:@"<b> Additional Info</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1262:0:1"]]]];
    }
    
    
    //    [htmlString appendString:[NSString stringWithFormat:@"<b>Injury:</b> %@ ", injuryList]];
    
    if ([[self removeNull:[ticketInputsData objectForKey:@"1219:0:1"]] length] > 0 )
    {
        [htmlString appendString:@"<br>"];
        if ([[self removeNull:[ticketInputsData objectForKey:@"1250:0:1"]] length] > 0 )
        {
            [injuryList appendString:[NSString stringWithFormat:@"<b>MOI</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1250:0:1"]]]];
        }
        [injuryList appendString:[NSString stringWithFormat:@"<b>Type of Activity</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1219:0:1"]]]];
        
        if ([[self removeNull:[ticketInputsData objectForKey:@"1220:0:1"]] length] > 0 )
        {
            [injuryList appendString:[NSString stringWithFormat:@"<b>Location</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1220:0:1"]]]];
        }
        if ([[self removeNull:[ticketInputsData objectForKey:@"1221:0:1"]] length] > 0 )
        {
            [injuryList appendString:[NSString stringWithFormat:@"<b>Safety Equipment</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1221:0:1"]]]];
        }
        if ([[self removeNull:[ticketInputsData objectForKey:@"1222:0:1"]] length] > 0 )
        {
            [injuryList appendString:[NSString stringWithFormat:@"<b>Incident Type</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1222:0:1"]]]];
        }
        if ([[self removeNull:[ticketInputsData objectForKey:@"1223:0:1"]] length] > 0 )
        {
            [injuryList appendString:[NSString stringWithFormat:@"<b>Intent</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1223:0:1"]]]];
        }
        
        if ([[self removeNull:[ticketInputsData objectForKey:@"1251:0:1"]] length] > 0 )
        {
            [injuryList appendString:[NSString stringWithFormat:@"<b>Extrication</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1251:0:1"]]]];
        }
        if ([[self removeNull:[ticketInputsData objectForKey:@"1252:0:1"]] length] > 0 )
        {
            [injuryList appendString:[NSString stringWithFormat:@"<b>Ejected</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1252:0:1"]]]];
        }
        if ([[self removeNull:[ticketInputsData objectForKey:@"1253:0:1"]] length] > 0 )
        {
            [injuryList appendString:[NSString stringWithFormat:@"<b>Exposure</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1253:0:1"]]]];
        }
        if ([[self removeNull:[ticketInputsData objectForKey:@"1254:0:1"]] length] > 0 )
        {
            [injuryList appendString:[NSString stringWithFormat:@"<b>MVC Patient Position</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:@"1254:0:1"]]]];
        }
    }
    
    [htmlString appendString:[NSString stringWithFormat:@"<b>OPQRST:</b> %@ ", opqrst]];
    
    [htmlString appendString:@"<br>"];
    
    [htmlString appendString:[NSString stringWithFormat:@"<b>Injury:</b> %@ ", injuryList]];
    
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"<div id=\"Vitals\" class=\"width100\">"];
    [htmlString appendString:@"<div id=\"SectionTitle\" class=\"width100\">"];
    [htmlString appendString:@"<b>Vitals</b><br>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<table border=\"0\" width=\"100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td WIDTH=\"7%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Time"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"4%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"HR"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"4%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"RR"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"BPSys"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"BPDias"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"SPO2"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"ETCO2"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Glucose"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Temp"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"8%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Position"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"GCS"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"RTS"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Pain"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"SPCO"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"SPMET"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"8%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"EKG"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"8%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"DoneBy"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    
    for (int i = 1; i< 10; i++)
    {
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3001:0:%d", i]]] length] > 0 )
        {
            [self appendVital:ticketInputsData searchFor:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"<div id=\"Treatments\" class=\"width100\">"];
    [htmlString appendString:@"<div id=\"SectionTitle\" class=\"width100\">"];
    [htmlString appendString:@"<b>Treatments</b><br>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<table border=\"0\" width=\"100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td WIDTH=\"15%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Time</b>"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"25%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Treatment</b>"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"60%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Details</b>"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
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
                        [htmlString appendString:@"</td>"];
                        [htmlString appendString:@"</tr>"];
                    }
                    [htmlString appendString:@"<tr>"];
                    treatment = input.inputPage;
                    [htmlString appendString:@"<td>"];
                    [htmlString appendString:[NSString stringWithFormat:@"%@", input.inputValue]];
                    [htmlString appendString:@"</td>"];
                    [htmlString appendString:@"<td>"];
                    [htmlString appendString:[NSString stringWithFormat:@"%@", input.inputPage]];
                    [htmlString appendString:@"</td>"];
                }
                instance = input.inputInstance;
                treatmentID = input.inputId;
                [htmlString appendString:@"<td>"];
            }
            
            else
            {
                if ([self removeNull:input.inputValue].length > 0)
                {
                    [htmlString appendString:[NSString stringWithFormat:@"%@: %@ ", [self removeNull:input.inputName], [self removeNull:input.inputValue]]];
                }
            }
            
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
    }
    
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"<div id=\"Protocols\" class=\"width100\">"];
    [htmlString appendString:@"<div id=\"SectionTitle\" class=\"width100\">"];
    [htmlString appendString:@"<b>Protocols</b><br>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<table border=\"0\" width=\"100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td WIDTH=\"20%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Time"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"80%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"Protocol"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    NSString* protocolSql = [NSString stringWithFormat:@"Select * from ticketInputs where ticketID = %@ and inputID > 4000 and inputID < 5000", ticketID];
    NSMutableArray* protocolList;
    @synchronized(g_SYNCDATADB)
    {
        protocolList = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:protocolSql];
    }
    for (int i = 0; i< protocolList.count; i++)
    {
        
        ClsTicketInputs* input = [protocolList objectAtIndex:i];
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td WIDTH=\"20%\">"];
        [htmlString appendString:[NSString stringWithFormat:@"%@", input.inputValue]];
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"80%\">"];
        [htmlString appendString:[NSString stringWithFormat:@"%@", input.inputName]];
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
        
    }
    
    
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"<div id=\"Comments\" class=\"width100\">"];
    [htmlString appendString:@"<div id=\"SectionTitle\" class=\"width100\">"];
    [htmlString appendString:@"<b>Comments</b><br>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Narrative:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1430:0:1"]]]];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"<div id=\"IncidentInformation\" class=\"width100\">"];
    [htmlString appendString:@"<div id=\"SectionTitle\" class=\"width100\">"];
    [htmlString appendString:@"<b>Incident Information</b><br>"];
    [htmlString appendString:@"</div>"];
    //    [htmlString appendString:@"<table border=\"0\" width=\"100%\">"];
    //    [htmlString appendString:@"<tr>"];
    //   [htmlString appendString:@"<td style=\"width:60%\">"];
    
    NSMutableString* locationString = [[NSMutableString alloc] init];
    if ([[self removeNull:[ticketInputsData objectForKey:@"1003:0:1"]] length] > 0 )
    {
        [locationString appendString:[NSString stringWithFormat:@"%@, ", [self removeNull:[ticketInputsData objectForKey:@"1003:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1004:0:1"]] length] > 0 )
    {
        [locationString appendString:[NSString stringWithFormat:@"%@, ", [self removeNull:[ticketInputsData objectForKey:@"1004:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1005:0:1"]] length] > 0 )
    {
        [locationString appendString:[NSString stringWithFormat:@"%@ ", [self removeNull:[ticketInputsData objectForKey:@"1005:0:1"]]]];
    }
    if ([[self removeNull:[ticketInputsData objectForKey:@"1006:0:1"]] length] > 0 )
    {
        [locationString appendString:[NSString stringWithFormat:@"%@ ", [self removeNull:[ticketInputsData objectForKey:@"1006:0:1"]]]];
    }
    [htmlString appendString:[NSString stringWithFormat:@"<b>Location:</b> %@ ", locationString]];
    
    
    
    //   [htmlString appendString:@"</td>"];
    //   [htmlString appendString:@"<td style=\"width:20%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Type:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1007:0:1"]]]];
    //   [htmlString appendString:@"</td>"];
    //   [htmlString appendString:@"<td style=\"width:20%\">"];
    //   [htmlString appendString:[NSString stringWithFormat:@"<b>Run Type:</b> %@", [self removeNull:[ticketInputsData objectForKey:@"1050:0:1"]]]];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Dispatch Complaint:</b> %@", [self removeNull:[ticketInputsData objectForKey:@"1070:0:1"]]]];
    //   [htmlString appendString:@"</td>"];
    //   [htmlString appendString:@"</tr>"];
    //   [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Outcome:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1401:0:1"]]]];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Destination:</b> %@, %@, %@, %@, %@", [self removeNull:[ticketInputsData objectForKey:@"1701:0:1"]], [self removeNull:[ticketInputsData objectForKey:@"1702:0:1"]], [self removeNull:[ticketInputsData objectForKey:@"1705:0:1"]], [self removeNull:[ticketInputsData objectForKey:@"1706:0:1"]], [self removeNull:[ticketInputsData objectForKey:@"1704:0:1"]]]];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Location Choice:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1403:0:1"]]]];
    
    if ([self removeNull:[ticketInputsData objectForKey:@"1031:0:1"]])
    {
        [htmlString appendString:[NSString stringWithFormat:@"<b>Code to Destination:</b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"1031:0:1"]]]];
    }
    [htmlString appendString:@"<br>"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Mileage - </b> %@ ", [self removeNull:[ticketInputsData objectForKey:@"9050:0:1"]]]];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"<div id=\"CallTimes\" class=\"width100\">"];
    [htmlString appendString:@"<div id=\"SectionTitle\" class=\"width100\">"];
    [htmlString appendString:@"<b>Call Times</b><br>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<table border=\"0\" width=\"100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td WIDTH=\"12.5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Dispatched</b>"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"12.5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>EnRoute</b>"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"12.5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>At Scene</b>"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"12.5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>At Patient</b>"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"12.5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Depart Scene</b>"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"12.5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Destination</b>"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"12.5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Transfer Care</b>"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"12.5%\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Unit Clear</b>"]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td>"];
    [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:@"1040:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td>"];
    [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:@"1041:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td>"];
    [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:@"1042:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td>"];
    [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:@"1047:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td>"];
    [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:@"1043:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td>"];
    [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:@"1044:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td>"];
    [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:@"1045:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td>"];
    [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:@"1046:0:1"]]]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"<div id=\"Signatures\" class=\"width100\">"];
    [htmlString appendString:@"<div id=\"SectionTitle\" class=\"width100\">"];
    [htmlString appendString:@"<b>Signatures</b>"];
    [htmlString appendString:@"</div>"];
    [self appendSignature:ticketID];
    [htmlString appendString:@"</div>"];
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
    if ([status isEqualToString:@"2"] || [status isEqualToString:@"3"])
    {
        [htmlString appendString:@"<div id=\"Amendments\" class=\"width100\">"];
        [htmlString appendString:@"<div id=\"SectionTitle\" class=\"width100\">"];
        [htmlString appendString:@"<b>Amendments</b><br>"];
        [htmlString appendString:@"</div>"];
        [self appendAddendum:ticketID];
        [htmlString appendString:@"<br>"];
        [htmlString appendString:@"</div>"];
    }
    
    [htmlString appendString:@"<div id=\"Provider\" class=\"width100\">"];
    [htmlString appendString:@"<br><br>"];
    [htmlString appendString:@"Provider Info:"];
    [self appendProvider:ticketID];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"<div id=\"Footer\" class=\"width100\">"];
    [htmlString appendString:@"<table border=\"0\" width=\"100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td  Width=\"38%\"; Align=\"left\">"];
    [htmlString appendString:@"FHMedic - All rights reserved 2015"];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td Width=\"62%\"; Align=\"right\">"];
    
    
    NSDate *date = [[NSDate alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [htmlString appendString:[NSString stringWithFormat:@"PCR Status: %@ Date/Time Created: %@", [self removeNull:statusStr], dateString]];
    
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"</html>"];
    [webView1 loadHTMLString:htmlString baseURL:nil];
}

- (void) appendAddendum:(NSString*) ticketID
{
    NSMutableArray* addendumList;
    
    NSString* sql = [NSString stringWithFormat:@"Select ticketID, changeID, changeMade, changetime, modifiedBy, changeInputID, originalValue from ticketChanges where ticketId = %@", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        addendumList = [DAO executeSelectTicketChanges:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    [htmlString appendString:@"<table border=\"0\" width=\"100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td WIDTH=\"15%\">"];
    [htmlString appendString:@"Time"];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"70%\">"];
    [htmlString appendString:@"Change Made"];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td WIDTH=\"15%\">"];
    [htmlString appendString:@"Modified By"];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    for (int i=0; i<addendumList.count; i++)
    {
        ClsTicketChanges* change = [addendumList objectAtIndex:i];
        NSString* sql = [NSString stringWithFormat:@"Select (UserLastName || ', ' || UserFirstname) as name from Users where UserID = %d", change.modifiedBy];
        NSString* userName;
        @synchronized(g_SYNCLOOKUPDB)
        {
            userName = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
        }
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td WIDTH=\"15%\">"];
        [htmlString appendString:change.changeTime];
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"70%\">"];
        [htmlString appendString:change.changeMade];
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"15%\">"];
        [htmlString appendString:userName];
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
        
    }
    [htmlString appendString:@"</table>"];
}

- (void) appendProvider:(NSString*) ticketID
{
    NSMutableString* provider = [[NSMutableString alloc] init];
    NSString* sql = @"Select SettingValue from Settings where SettingDesc = 'ServiceName'";
    @synchronized(g_SYNCLOOKUPDB)
    {
        [provider appendString:[NSString stringWithFormat:@" %@",[DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql]]];
    }
    NSString* sql1 = @"Select SettingValue from Settings where SettingDesc = 'ServiceAddr1'";
    @synchronized(g_SYNCLOOKUPDB)
    {
        [provider appendString:[NSString stringWithFormat:@" %@",[DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql1]]];
    }
    NSString* sql2 = @"Select SettingValue from Settings where SettingDesc = 'ServiceCity'";
    @synchronized(g_SYNCLOOKUPDB)
    {
        [provider appendString:[NSString stringWithFormat:@" %@",[DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql2]]];
    }
    NSString* sql3 = @"Select SettingValue from Settings where SettingDesc = 'ServiceST'";
    @synchronized(g_SYNCLOOKUPDB)
    {
        [provider appendString:[NSString stringWithFormat:@" %@",[DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql3]]];
    }
    NSString* sql4 = @"Select SettingValue from Settings where SettingDesc = 'ServiceZip'";
    @synchronized(g_SYNCLOOKUPDB)
    {
        [provider appendString:[NSString stringWithFormat:@" %@",[DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql4]]];
    }
    NSString* sql5 = @"Select SettingValue from Settings where SettingDesc = 'ServiceContactPhone'";
    @synchronized(g_SYNCLOOKUPDB)
    {
        [provider appendString:[NSString stringWithFormat:@" %@",[DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql5]]];
    }
    
    NSString* sql6 = @"Select SettingValue from Settings where SettingDesc = 'ServiceEmail'";
    @synchronized(g_SYNCLOOKUPDB)
    {
        [provider appendString:[NSString stringWithFormat:@" %@",[DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql6]]];
    }
    NSString* sql7 = @"Select SettingValue from Settings where SettingDesc = 'ServiceProviderNumber'";
    @synchronized(g_SYNCLOOKUPDB)
    {
        [provider appendString:[NSString stringWithFormat:@" %@",[DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql7]]];
    }
    [htmlString appendString:provider];
}

- (void) appendSignature:(NSString*) ticketID
{
    NSString* sql = @"Select SignatureType, SignatureTypeDesc, DisclaimerText, SignatureGroup from SignatureTypes";
    NSMutableArray* sigTypeArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        sigTypeArray = [DAO selectSignatureTypes:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    
    NSMutableArray* signatureList;
    sql = [NSString stringWithFormat:@"Select * from ticketSignatures where ticketId = %@  and (deleted is null or deleted = 0)", ticketID];
    @synchronized(g_SYNCBLOBSDB)
    {
        signatureList = [DAO executeSelectSignatures:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
    }
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"<table border=\"0\" width=\"100%\">"];
    
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
        [htmlString appendString:@"<tr>"];
        ClsSignatureImages* sig = [signatureList objectAtIndex:i];
        NSString* title;
        ClsSignatureTypes* sigType;
        if (sig.type >= 0 && sig.type < sigTypeArray.count)
        {
            sigType = [sigTypeArray objectAtIndex:sig.type];
            title = sigType.signatureTypeDesc;
        }
        [htmlString appendString:@"<td WIDTH=\"18%\"  Align=\"left\">"];
        [htmlString appendString:[NSString stringWithFormat:@"%@ - %@", title, sig.name]];
        [htmlString appendString:@"</td>"];
        
        [htmlString appendString:@"<td WIDTH=\"25%\" Align=\"center\">"];
        [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\" width=\"200\" height=\"100\">", sig.imageStr]];
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"57%\"  Align=\"right\">"];
        if (sig.type >= 0 && sig.type < sigTypeArray.count)
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", sigType.disclaimerText]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
    }
    
    
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<br>"];
}


- (void) appendAssessment:(NSMutableDictionary*)ticketInputsData searchFor:(NSInteger)intsearch
{
    NSMutableString* assessmentList = [[NSMutableString alloc] init];
    NSString* searchString = [NSString stringWithFormat:@"1800:0:%d", intsearch];
    
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Time</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1801:0:%d", intsearch];
    
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Skin</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    
    searchString = [NSString stringWithFormat:@"1802:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Head/Face</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    
    searchString = [NSString stringWithFormat:@"1803:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Neck</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1804:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Chest/Lungs</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1805:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Heart</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1806:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>LU Abdomen</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1807:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>LL Abdomen</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1808:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>RU Abdomen</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1809:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>RL Abdomen</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1810:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>GU</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1811:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Back Cervical</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1812:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Back Thoracic</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1813:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Back Lumbar/Sacral</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1814:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>RU Extremities</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1815:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>RL Extremities</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1816:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>LU Extremities</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1817:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>LL Extremities</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1818:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Left Eye</b> - %@ ", [self removeNull:[ticketInputsData objectForKey: searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1819:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Right Eye</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1820:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Mental Status</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    searchString = [NSString stringWithFormat:@"1821:0:%d", intsearch];
    if ([[self removeNull:[ticketInputsData objectForKey:searchString]] length] > 0 )
    {
        [assessmentList appendString:[NSString stringWithFormat:@"<b>Neurological</b> - %@ ", [self removeNull:[ticketInputsData objectForKey:searchString]]]];
    }
    
    
    
    [htmlString appendString:[NSString stringWithFormat:@"<b>Assessment:</b> %@ ", assessmentList]];
    [htmlString appendString:@"<br>"];
    
}

- (void) appendVital:(NSMutableDictionary*)ticketInputsData searchFor:(NSString*)searchString
{
    if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3001:0:%@", searchString]]] length] > 0 )
    {
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td WIDTH=\"7%\">"];
        [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3001:0:%@", searchString]]]]];
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"4%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3005:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3005:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"4%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3004:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3004:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"5%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3002:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3002:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"5%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3003:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3003:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"5%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3006:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3006:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"5%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3007:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3007:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"5%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3008:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3008:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"5%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3010:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3010:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"8%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3012:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3012:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"5%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3011:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3011:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"5%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3021:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3021:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"5%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3029:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3029:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"5%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3034:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3034:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"5%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3035:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3035:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"8%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3015:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3015:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"8%\">"];
        if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3013:0:%@", searchString]]] length] > 0 )
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"3013:0:%@", searchString]]]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
    }
    
}

- (void) appendTreatment:(NSMutableDictionary*)ticketInputsData searchFor:(NSString*)searchString
{
    if ([[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"2072:1:%@", searchString]]] length] > 0 )
    {
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td WIDTH=\"10%\">"];
        [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"2072:1:%@", searchString]]]]];
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"25%\">"];
        [htmlString appendString:[NSString stringWithFormat:@"%@", [self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"2072:-1:%@", searchString]]]]];
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td WIDTH=\"65%\">"];
        [htmlString appendString:[NSString stringWithFormat:@":1Performed By: %@ Notes: %@",[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"2072:101:%@", searchString]]] ,[self removeNull:[ticketInputsData objectForKey:[NSString stringWithFormat:@"2072:102:%@", searchString]]]]];
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDelete:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnPrintClick:(id)sender {
    
    //  UIGraphicsBeginImageContextWithOptions(webView1.bounds.size, YES, 0);
    
    //  bool test = [webView1 drawViewHierarchyInRect:webView1.bounds afterScreenUpdates:YES];
    //  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //  NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //  UIGraphicsEndImageContext();
    
    // CGRect rect = webView1.frame;
    // UIWebView *webview2 = [[UIWebView alloc] initWithFrame:rect];
    //   [webview2 loadData:imageData MIMEType:@"image/jpg" textEncodingName:nil baseURL:[NSURL URLWithString:@""]];
    
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"PCR";
    pc.printInfo = printInfo;
    pc.showsPageRange = NO;
    
    UIViewPrintFormatter *formatter = [webView1 viewPrintFormatter];
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    formatter.contentInsets = titleInsets;
    
    pc.printFormatter = formatter;
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed,
      NSError *error) {
        if(!completed && error){
            NSLog(@"Print failed - domain: %@ error code %u", error.domain,
                  error.code);
        }
    };
    [pc presentFromBarButtonItem:self.btnBarPrint animated:YES
               completionHandler:completionHandler];
}

- (IBAction)btnFaxPressed:(UIButton*)sender {
    
    NSString* MachineID = [g_SETTINGS objectForKey:@"MachineID"];
    if ([MachineID isEqualToString:@"LOCAL"])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"This feature is not available in the demo version." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        FaxViewController *popoverView =[[FaxViewController alloc] initWithNibName:@"FaxViewController" bundle:nil];
        
        popoverView.view.backgroundColor = [UIColor whiteColor];
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(600, 440);
        // popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.y += 30;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
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

@end
