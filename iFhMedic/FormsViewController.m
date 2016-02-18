//
//  FormsViewController.m
//  iRescueMedic
//
//  Created by admin on 12/22/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "FormsViewController.h"
#import "global.h"
#import "DAO.h"
#import "ClsUsers.h"
#import "ClsUnits.h"
#import "ClsTicketInputs.h"
#import "ClsSignatureImages.h"
#import "Base64.h"
#import "ClsTicketChanges.h"
#import "ClsSignatureTypes.h"
#import "ClsNarcotic.h"
#import "ClsTicketFormsInputs.h"
#import "ClsInjuryType.h"
#import "ClsTicketAttachments.h"
#import "FaxViewController.h"
#import "DDPopoverBackgroundView.h"
#import "ClsTreatmentInputs.h"
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

@interface FormsViewController ()
{
    WKWebView* webView1;
}
@end

@implementation FormsViewController
@synthesize toolbar;
@synthesize htmlString;
@synthesize btnBarPrint;
@synthesize formType;
@synthesize popover;
@synthesize btnFax;
@synthesize loadTreatment;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect rect = CGRectMake(0, 64, 1024, 705);
    webView1 = [[WKWebView alloc] initWithFrame:rect];
    [self.view addSubview:webView1];
    if (formType == 1)
    {
        // [self loadPCR];
        [self loadPcrXslt];
    }
    else if (formType == 2)
    {
        btnFax.hidden = true;
        [self loadSupplement];
    }
    else if (formType == 3)
    {
        btnFax.hidden = true;
        [self loadNarcotic];
    }
    else if (formType == 4)
    {
        btnFax.hidden = true;
        [self loadABN];
    }
    else if (formType == 5)
    {
        btnFax.hidden = true;
        [self loadPCS];
    }
    
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
    
    NSString* newStr = [result stringByReplacingOccurrencesOfString:@"|CRLF|" withString:@"<br/>"];
    [webView1 loadHTMLString:newStr baseURL:nil];
    
    free(xmlResultBuffer);
    
    xsltFreeStylesheet(sty);
    xmlFreeDoc(res);
    xmlFreeDoc(doc);
    
    xsltCleanupGlobals();
    xmlCleanupParser();
    
}




- (void) loadPCS
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* logoStr = @"Select FileString from customerContent where FileType = 'Logo'";
    NSString* logo;
    @synchronized(g_SYNCLOOKUPDB)
    {
        logo =  [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:logoStr];
    }
    NSMutableArray* formInputsData;
    NSString* sqlStr = [NSString stringWithFormat:@"Select * from TicketFormsInputs where TicketID = %@ and FormID = 2", ticketID ];
    @synchronized(g_SYNCDATADB)
    {
        formInputsData = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    
    NSString* patientName;
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientNameFromTickeID:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    
    NSString* sql = [NSString stringWithFormat:@"Select InputValue from ticketInputs where ticketID = %@ and inputID = 1103", ticketID];
    NSString* dob;
    @synchronized(g_SYNCDATADB)
    {
        dob =  [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSString* ekg;
    NSString* ventilator;
    NSString* ivMonitor;
    NSString* chemRestraint;
    NSString* emtala;
    NSString* suction;
    NSString* oxygen;
    NSString* danger;
    NSString* ortho;
    NSString* riskFall;
    NSString* safety;
    NSString* flight;
    NSString* control;
    NSString* isolation;
    NSString* patientSize;
    NSString* specHandle;
    NSString* dateStr;
    NSString* facultyName;
    NSString* facultySig;
    NSString* facultyTitle;
    for (int i=0; i< [formInputsData count]; i++)
    {
        
        ClsTicketFormsInputs* input = [formInputsData objectAtIndex:i];
        if (input.formInputID == 1)
        {
            ekg = input.formInputValue;
        }
        else if (input.formInputID == 2)
        {
            ventilator = input.formInputValue;
        }
        else if (input.formInputID == 3)
        {
            ivMonitor = input.formInputValue;
        }
        else if (input.formInputID == 4)
        {
            chemRestraint = input.formInputValue;
        }
        else if (input.formInputID == 5)
        {
            emtala = input.formInputValue;
        }
        else if (input.formInputID == 6)
        {
            suction = input.formInputValue;
        }
        else if (input.formInputID == 7)
        {
            oxygen = input.formInputValue;
        }
        else if (input.formInputID == 8)
        {
            danger = input.formInputValue;
        }
        else if (input.formInputID == 9)
        {
            ortho = input.formInputValue;
        }
        else if (input.formInputID == 10)
        {
            riskFall = input.formInputValue;
        }
        else if (input.formInputID == 11)
        {
            safety = input.formInputValue;
        }
        else if (input.formInputID == 12)
        {
            flight = input.formInputValue;
        }
        else if (input.formInputID == 13)
        {
            control = input.formInputValue;
        }
        else if (input.formInputID == 14)
        {
            isolation = input.formInputValue;
        }
        else if (input.formInputID == 15)
        {
            patientSize = input.formInputValue;
        }
        else if (input.formInputID == 16)
        {
            specHandle = input.formInputValue;
        }
        else if (input.formInputID == 18)
        {
            dateStr = input.formInputValue;
        }
        else if (input.formInputID == 20)
        {
            facultySig = input.formInputValue;
        }
        else if (input.formInputID == 21)
        {
            facultyName = input.formInputValue;
        }
        
        else if (input.formInputID == 24)
        {
            facultyTitle = input.formInputValue;
        }
    }
    
    htmlString = [NSMutableString stringWithString:@"<!DOCTYPE html><html><head><title>PCS Report</title>"];
    
    [htmlString appendString:@"<style type =\"text/css\">"];
    
    [htmlString appendString:@"body{"];
    
    [htmlString appendString:@"font-family: sans-serif;}"];
    
    [htmlString appendString:@"div#picture{"];
    [htmlString appendString:@"padding-top: 3em;"];
    [htmlString appendString:@"padding-bottom: 3em;}"];
    
    [htmlString appendString:@"div#textbox{"];
    [htmlString appendString:@"padding-left: 5em;"];
    [htmlString appendString:@"padding-right: 5em;}"];
    [htmlString appendString:@"div#table1{"];
    [htmlString appendString:@"padding-left: 5em;"];
    [htmlString appendString:@"padding-right: 5em;}"];
    
    [htmlString appendString:@"div#table2{"];
    [htmlString appendString:@"padding-left: 5em;"];
    [htmlString appendString:@"padding-right: 5em;}"];
    [htmlString appendString:@"</style>"];
    [htmlString appendString:@"<body>"];
    [htmlString appendString:@"<p><font size=\"6\"><strong><center> Physician Certification Statement </center></strong></font></p>"];
    [htmlString appendString:@"<div id=\"picture\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<center><img src=\"data:image/png;base64,%@\">", logo]];
    [htmlString appendString:@"</img></center>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<div id=\"textbox\">"];
    [htmlString appendString:@"<table style=\"border-collapse: collapse;\", width = \"100%\", border=\"1px\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td>"];
    [htmlString appendString:@"Medicare covers non-emergency ambulances transportation only if the patient's medical condition is such that other means of transportation are contraindicated. Non-emergency ambulance transportation is appropriate if either; the beneficiary is bed-confined and it is documented that the beneficiary's condition is such that other methods of transportation are contraindicated; or, if the medical condition is such that transportation by ambulance is medically required. Medicare defines bed confined as The inability to get up from bed without assistance and the inability to ambulate and the inability to sit in a chair or wheelchair."];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<div id=\"table1\">"];
    [htmlString appendString:@"<table style=\"border-collapse: collapse;\", width = \"100%\", border=\"1px\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width= \"15%\">Patient Name</td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width= \"35%%\"> %@</td>", [self removeNull:patientName]]];
    [htmlString appendString:[NSString stringWithFormat:@"<td width= \"50%%\"> Date of PCS Certification: %@</td>", [self removeNull:dateStr]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<table style=\"border-collapse: collapse;\", width = \"100%\", border=\"1px\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width= \"15%\">Date of Birth: </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width= \"25%%\">%@</td>", [self removeNull:dob]]];
    
    NSString* medIdSql = [NSString stringWithFormat:@"Select InputValue from TicketInputs where ticketID = %@ and InputID = 7001 and InputSubID = 2 and InputInstance = 1", ticketID];
    NSString* MedIdStr;
    @synchronized(g_SYNCDATADB)
    {
        MedIdStr = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:medIdSql];
    }
    [htmlString appendString:[NSString stringWithFormat:@"<td width= \"60%%\">Medicare Number: %@</td>", [self removeNull:MedIdStr]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"<div id=\"table2\">"];
    [htmlString appendString:@"<table style=\"border-collapse: collapse;\", width = \"100%\", border=\"1px\">"];
    [htmlString appendString:@"<th style=\"text-align: left\", colspan = \"4\"><em> Medical Necessity Information: Please select the condition(s)/ service(s) which require ambulance transport<em></th>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width =\"40%\"> EKG monitoring required enroute. </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width =\"10%%\">%@</td>", [self removeNull:ekg]]];
    [htmlString appendString:@"<td width = \"40%\"> Suctioning required enroute.  </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width =\"10%%\"> %@</td>", [self removeNull:suction]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width =\"40%\"> Ventilator dependent, apnea monitor, possible intubation needed or deep suctioning.</td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width =\"10%%\"> %@</td>", [self removeNull:ventilator]]];
    [htmlString appendString:@"<td width = \"40%\"> Oxygen required (not applicable to prescribed O2 as a self-administered therapy). </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width =\"10%%\"> %@</td>", [self removeNull:oxygen]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width =\"40%\"> IV monitoring or IV medications required. </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width =\"10%%\"> %@</td>", [self removeNull:ivMonitor]]];
    [htmlString appendString:@"<td width = \"40%\"> Restrained. Danger to self or others. </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width =\"10%%\"> %@</td>", [self removeNull:danger]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width =\"40%\"> Actively chemically restrained. </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width =\"10%%\"> %@</td>", [self removeNull:chemRestraint]]];
    [htmlString appendString:@"<td width = \"40%\"> Orthopedic device. Halo traction: backboard, etc. </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width =\"10%%\"> %@</td>", [self removeNull:ortho]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<table style=\"border-collapse: collapse;\", width = \"100%\", border=\"1px\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width=\"40%\"> EMTALA physician directed transfer. </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width =\"10%%\"> %@</td>", [self removeNull:emtala]]];
    [htmlString appendString:@"<td width = \"50%\"> </td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<table style=\"border-collapse: collapse;\", width = \"100%\", border=\"1px\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width=\"90%\"> Risk of falling off wheelchair or stretcher while in motion. Condition is such that patient risks injury during vehicle movement despite safety belts </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width=\"10%%\"> %@</td>", [self removeNull:riskFall]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width=\"90%\"> Patient Safety: Danger to Self: Behavioral / cognitive risk such that patient risks injury during vehicle movement despite safety belts. </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width=\"10%%\"> %@</td>", [self removeNull:safety]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width=\"90%\"> Flight risk: Behavioral / cognitive risk such that patient requires stretcher-side monitoring for safety: can not travel by wheelchair or unattended stretcher van. </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width=\"10%%\"> %@</td>", [self removeNull:flight]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width=\"90%\"> Airway control / positioning required. Condition is such that patient requires constant air way monitoring. </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width=\"10%%\"> %@</td>", [self removeNull:control]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width=\"90%\"> Isolation: Patient must be isolated from public or whose medical condition must be protected from public exposure. </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width=\"10%%\">  %@</td>", [self removeNull:isolation]]];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width=\"90%\"> Patient Size. Morbid obesity which requires additional personnel or equipment to transfer.</td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width=\"10%%\">  %@</td>", [self removeNull:patientSize]]];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td width=\"90%\"> Positioning / Specialized Handling. (1) Special handling to avoid further injury, e.g.> grande 2 decubiti on buttocks); (2) Positioning in wheelchair or standard car set inappropriate due to contractures : (3) Recent extremity fractures (e.g. post-op hip) requiring patient to remain supine / immobile during and for period of time after transport.  </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td width=\"10%%\"> %@</td>", [self removeNull:specHandle]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@" <table style=\"border-collapse: collapse;\", width = \"100%\", border=\"1px\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td colspan= \"3\"> Bed confined. See Definition above.<em> IF NO OTHER CONDITION APPLIES, PLEASE DESCRIBE THE REASON </em>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"(MEDICAL CONDITION) NON- AMBULANCE (UNATTENDED) STRETCHER TRANSPORT IS CONTRAINDICATED:"];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td colspan = \"3\"><font size = \"2\">"];
    [htmlString appendString:@"I certify I have personal knowledge of the patient's condition and such condition meets Medicare's definition of medical necessity."];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td height = \"25\"> Printed Name</td>"];
    [htmlString appendString:@"<td> Signature: </td>"];
    [htmlString appendString:@"<td> Date: </td>"];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td height = \"125\"> %@ - %@</td>", [self removeNull:facultyTitle], [self removeNull:facultyName]]];
    [htmlString appendString:@"<td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\" width=\"400\" height=\"100\">", facultySig]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td> %@ </td>", [self removeNull:dateStr]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"<html>"];
    [webView1 loadHTMLString:htmlString baseURL:nil];
}


- (void) loadABN
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    
    NSMutableArray* formInputsData;
    NSString* sqlStr = [NSString stringWithFormat:@"Select * from TicketFormsInputs where TicketID = %@ and FormID = 8", ticketID ];
    @synchronized(g_SYNCDATADB)
    {
        formInputsData = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    NSString* notifier;
    NSString* patientName;
    NSString* ssn;
    NSString* itemService;
    NSString* reasonNoPay;
    NSString* cost;
    NSString* addInfo;
    NSString* option;
    NSString* dateStr;
    NSString* patientSig;
    for (int i=0; i< [formInputsData count]; i++)
    {
        
        ClsTicketFormsInputs* input = [formInputsData objectAtIndex:i];
        if (input.formInputID == 1)
        {
            notifier = input.formInputValue;
        }
        else if (input.formInputID == 2)
        {
            patientName = input.formInputValue;
        }
        else if (input.formInputID == 3)
        {
            ssn = input.formInputValue;
        }
        else if (input.formInputID == 4)
        {
            itemService = input.formInputValue;
        }
        else if (input.formInputID == 5)
        {
            reasonNoPay = input.formInputValue;
        }
        else if (input.formInputID == 6)
        {
            cost = input.formInputValue;
        }
        else if (input.formInputID == 7)
        {
            option = input.formInputValue;
        }
        else if (input.formInputID == 8)
        {
            addInfo = input.formInputValue;
        }
        else if (input.formInputID == 9)
        {
            patientSig = input.formInputValue;
        }
        else if (input.formInputID == 10)
        {
            if (input.formInputValue.length > 10)
            {
                dateStr = [input.formInputValue substringToIndex:10];
            }
        }
    }
    
    htmlString = [NSMutableString stringWithString:@"<!DOCTYPE html><html><head><title>ABN Report</title>"];
    
    [htmlString appendString:@"<style type =\"text/css\">"];
    
    [htmlString appendString:@"div#body {"];
    [htmlString appendString:@"font-size: 19px;"];
    [htmlString appendString:@"padding-left: 6em;}"];
    
    [htmlString appendString:@"div#header {"];
    [htmlString appendString:@"padding-left: 7em;"];
    [htmlString appendString:@"padding-right: 7em;}"];
    [htmlString appendString:@"body {"];
    [htmlString appendString:@"font-family: sans-serif;}"];
    
    [htmlString appendString:@"div#table1 {"];
    [htmlString appendString:@"padding-left: 7em;"];
    [htmlString appendString:@"padding-right: 7em;}"];
    
    [htmlString appendString:@"div#whatyouneed {"];
    
    [htmlString appendString:@"padding-left: 7em;"];
    [htmlString appendString:@"padding-right: 7em; }"];
    
    [htmlString appendString:@"p, ul {"];
    [htmlString appendString:@"margin: 1px; }"];
    
    [htmlString appendString:@"div#table2 {"];
    [htmlString appendString:@"padding-left: 6em;"];
    [htmlString appendString:@"padding-right: 4.5em; }"];
    
    [htmlString appendString:@"div#disclaimer {"];
    [htmlString appendString:@"font-size: 14px;}"];
    
    [htmlString appendString:@"hr {"];
    
    [htmlString appendString:@"border: none;"];
    [htmlString appendString:@"height: 5px;"];
    [htmlString appendString:@"background-color: #333;"];
    [htmlString appendString:@"padding: 0px;"];
    [htmlString appendString:@"margin: 0px;}"];
    
    [htmlString appendString:@"</style>"];
    [htmlString appendString:@"<body>"];
    [htmlString appendString:@"<div id=\"header\">"];
    [htmlString appendString:@"<table style = \"width:100%\">"];
    [htmlString appendString:@"<tr colspan=\"2\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<td><strong> A. Notifier: </strong>%@</td>", [self removeNull:notifier]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td><strong> B. Patient Name: %@</td>", [self removeNull:patientName]]];
    [htmlString appendString:[NSString stringWithFormat:@"<td width = \"55%%\"><strong> C. Identification Number: %@</td>", [self removeNull:ssn]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@" </table>"];
    [htmlString appendString:@"<hr>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<h2><center> Advance Beneficiaary Notice of Noncovernage (ABN)<center></h2>"];
    [htmlString appendString:@"<div id=\"body\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<u><strong> NOTE</strong></u>: If Medicare doesn't pay for <strong> D.<u>%@   </u> </strong> below, you may have to pay.", [self removeNull:itemService]]];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"Medicare does not pay for everything, even some care that you or your health care provider have"];
    [htmlString appendString:[NSString stringWithFormat:@" <br> good reason to think you need. We expect Medicare may not pay for the <strong> D.<u>%@   </u></strong> below.", [self removeNull:itemService]]];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<div id=\"table1\">"];
    [htmlString appendString:@"<table style=\"border-collapse: collapse;\", width = \"100%\", border=\"1px\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<th width =\"40%\", height=\"50\"  align=\"left\", bgcolor=\"#D8D8D8\"> <strong> D. <strong></td>"];
    [htmlString appendString:@"<th width = \"40%\", align=\"left\", bgcolor=\"#D8D8D8\" ><strong> E. Reason Medicare May Not Pay:<strong> </td>"];
    [htmlString appendString:@"<th width = \"20%\", align=\"left\", bgcolor=\"#D8D8D8\"><strong> F. Estimated Cost <strong> </td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td align=\"center\" height=\"150\">%@</td>", [self removeNull:itemService]]];
    [htmlString appendString:[NSString stringWithFormat:@"<td align=\"center\">%@</td>", [self removeNull:reasonNoPay]]];
    [htmlString appendString:[NSString stringWithFormat:@"<td align=\"center\">%@</td>", [self removeNull:cost]]];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<div id=\"whatyouneed\">"];
    [htmlString appendString:@"<p><strong><font size=\"5\"> WHAT YOU NEED TO DO NOW: </strong></p>"];
    [htmlString appendString:@"<ul>"];
    [htmlString appendString:@"<li> Read this notice, so you can make an informed decision about your care. </li>"];
    [htmlString appendString:@"<li> Ask us any questions that you may have after you finish reading. </li>"];
    [htmlString appendString:[NSString stringWithFormat:@"<li> Choose an option below about whether to recieve the <strong> D. <u>%@   </u></strong>listed above. </li>", [self removeNull:itemService]]];
    [htmlString appendString:@"</ul>"];
    [htmlString appendString:@"<ul style=\"list-style-type: none;\">"];
    [htmlString appendString:@"<li><strong> Note: </strong> If you choose Option 1 or 2, we may help you to use any other insurance that you might have, but Medicare cannot require us to do this. </li>"];
    [htmlString appendString:@"<ul>"];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<div id=\"table2\">"];
    [htmlString appendString:@" <table style=\"border-collapse: collapse;\", width = \"100%\", border=\"1px\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<th bgcolor=\"#D8D8D8\", colspan =\"3\"> G. Options:   Check only one box. We can not choose a box for you. </th>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@" <td>"];
    
    if ([option isEqualToString:@"1"])
    {
        [htmlString appendString:[NSString stringWithFormat:@"<input type=\"checkbox\" name=\"option1\" value=\"1\" checked=\"checked\" disabled=\"disabled\"><strong> OPTION 1. </strong> I want the <strong> D.<u>%@   </u></strong> listed above. You may ask to be paid now, but I can also want Medicare billed for an official decision on payment, which is sent to me on a Medicare Summary Notice (MSN). I understand that if Medicare doesn't pay, I am responsible for payment, but <strong> I can appeal to Medicare </strong> by following the directions on the MSN. If Medicare does pay, you will refund any payments I made to you, less co-pays or deductibles.", [self removeNull:itemService]]];
    }
    else
    {
        [htmlString appendString:[NSString stringWithFormat:@"<input type=\"checkbox\" name=\"option1\" value=\"1\" ><strong disabled=\"disabled\"> OPTION 1. </strong> I want the <strong> D. <u>%@   </u></strong> listed above. You may ask to be paid now, but I can also want Medicare billed for an official decision on payment, which is sent to me on a Medicare Summary Notice (MSN). I understand that if Medicare doesn't pay, I am responsible for payment, but <strong> I can appeal to Medicare </strong> by following the directions on the MSN. If Medicare does pay, you will refund any payments I made to you, less co-pays or deductibles.", [self removeNull:itemService]]];
    }
    [htmlString appendString:@"<br>"];
    if ([option isEqualToString:@"2"])
    {
        [htmlString appendString:[NSString stringWithFormat:@"<input type=\"checkbox\" name=\"option2\" value=\"2\" checked=\"checked\" disabled=\"disabled\"><strong> OPTION 2. </strong> I want the <strong> D.<u>%@   </u></strong> listed above, but do not bill Medicare. You may ask to be paid now as I am responsible for payment. <strong> I cannot appeal if  Medicare is not billed. </strong>", [self removeNull:itemService]]];
    }
    else
    {
        [htmlString appendString:[NSString stringWithFormat:@"<input type=\"checkbox\" name=\"option2\" value=\"2\" disabled=\"disabled\"><strong> OPTION 2. </strong> I want the <strong> D. <u>%@   </u></strong> listed above, but do not bill Medicare. You may ask to be paid now as I am responsible for payment. <strong> I cannot appeal if  Medicare is not billed. </strong>", [self removeNull:itemService]]];
    }
    
    
    [htmlString appendString:@"<br>"];
    
    if ([option isEqualToString:@"3"])
    {
        [htmlString appendString:[NSString stringWithFormat:@"<input type=\"checkbox\" name=\"option3\" value=\"3\" checked=\"checked\" disabled=\"disabled\"><strong> OPTION 3. </strong> I don't want the <strong> D. <u>%@   </u></strong>  listed above. I understand with this choice I am <strong> not </strong> responsible for payment, and <strong> I cannot appeal to see if Medicare would pay. </strong>", [self removeNull:itemService]]];
    }
    else
    {
        [htmlString appendString:[NSString stringWithFormat:@"<input type=\"checkbox\" name=\"option3\" value=\"3\" disabled=\"disabled\"><strong> OPTION 3. </strong> I don't want the <strong> D. <u>%@   </u></strong> listed above. I understand with this choice I am <strong> not </strong> responsible for payment, and <strong> I cannot appeal to see if Medicare would pay. </strong>", [self removeNull:itemService]]];
    }
    
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<strong> H. Additional Information: </strong>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"<strong> This notice gives our opinion, not an official Medicare decision. </strong> If you have other questions on this notice or Medicare billcaing, call <strong> 1-800-MEDICARE </strong> (1-800-633-4227/<strong>TTY: </strong> 1-877-486-2048)."];
    [htmlString appendString:@"<br>Signing Below means that you have received and understood this notice. You also receive a copy."];
    [htmlString appendString:@"<table style=\"border-collapse: collapse;\", width = \"100%\", border=\"1px\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td height=\"25\"> <strong> I. Signature: </strong>"];
    
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td> <strong> J. Date:</strong> </td>"];
    
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td align=\"center\" height=\"75\">"];
    
    [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\" width=\"400\" height=\"100\">", patientSig]];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td align=\"center\">%@</td>", [self removeNull:dateStr]]];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<div id = \"disclaimer\">"];
    [htmlString appendString:@"According to the Paperwork Reduction Act of 1995, no persons are required to respond to a collection of information unless it displays a valid OMB control number."];
    [htmlString appendString:@"The valid OMB control number for this information collections is 0938-0566. The time required to complete this information collection is estimated to average 7"];
    [htmlString appendString:@"minutes per response, including the time to review instructions, search existing data resources, gather the data needed, and complete and review the information"];
    [htmlString appendString:@" collection. If you have comments concerning the accuracy of the time estimate or suggestions for improving this form, please write to: CMS, 7500 Security"];
    [htmlString appendString:@"Boulevard, Attn: PRA Reports Clearence Officier, Balitmore, Maryland 21244-1850."];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"<hr>"];
    [htmlString appendString:@"<table width= \"100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td align=\"left\"> Form CMS-R-131 (03/11) </td>"];
    [htmlString appendString:@"<td align=\"right\"> Form Approved OMB No. 0938-0566 </td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@" </table>"];
    
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"</html>"];
    
    [webView1 loadHTMLString:htmlString baseURL:nil];
    
}



- (NSMutableArray*) loadNarcoticData
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSMutableArray* arrNarcotic = [[NSMutableArray alloc] init];
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
    }
    return arrNarcotic;
}

- (void) loadNarcotic
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketUnitNumber, TicketCreatedTime, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and (deleted is null or deleted = 0)", ticketID ];
    
    NSMutableDictionary* ticketInputsData;
    NSMutableArray* unitData;
    NSMutableArray* crewData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSString* crewIds = [[ticketInputsData objectForKey:@"TicketCrew"] stringByReplacingOccurrencesOfString:@"|" withString:@","];
    NSString* crewIDStr;
    if (crewIds.length > 1)
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
    
    NSString* sql2 = [NSString stringWithFormat:@"UnitID = %@", [ticketInputsData objectForKey:@"TicketID"] ];
    @synchronized(g_SYNCLOOKUPDB)
    {
        unitData = [DAO loadUnits:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Filter:sql2];
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
    
    if (unitList.length > 1)
    {
        NSRange range = [unitList rangeOfString:@"|"];
        if (range.location != NSNotFound)
        {
            [unitList deleteCharactersInRange:range];
        }
    }
    
    NSMutableArray* narcoticArray = [self loadNarcoticData];
    
    
    htmlString = [NSMutableString stringWithString:@"<!DOCTYPE html><html><head><title>Narcotic Report</title>"];
    
    [htmlString appendString:@"<style>"];
    [htmlString appendString:@"table, th, td {"];
    [htmlString appendString:@"border: 1px solid black;"];
    [htmlString appendString:@"border-collapse: collapse;"];
    [htmlString appendString:@"}"];
    [htmlString appendString:@"</style>"];
    [htmlString appendString:@"</head>"];
    [htmlString appendString:@"<body style=\"background:transparent;\">"];
    
    [htmlString appendString:@"<h2><center><b> Controlled Substance Usage\\Wastage</b></center></h2>"];
    [htmlString appendString:@"<hr color = \"Teal \"><br>"];
    
    [htmlString appendString:@"<table style =\"width:100%\">"];
    [htmlString appendString:@"<tr>"];
    
    NSString* patientName = [NSString stringWithFormat:@"%@ %@", [self removeNull:[ticketInputsData objectForKey:@"1102:0:1"]], [self removeNull:[ticketInputsData objectForKey:@"1101:0:1"]]];
    [htmlString appendString:[NSString stringWithFormat:@"<td colspan =\"2\", height=\"30\"><b>Patient Name:</b> %@</td>", patientName]];
    
    NSString* incidentNo = [self removeNull:[ticketInputsData objectForKey:@"1001:0:1"]];
    [htmlString appendString:[NSString stringWithFormat:@"<td><b>Incident #:</b> %@</td>", incidentNo]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    NSString* DOS = [self removeNull:[ticketInputsData objectForKey:@"1002:0:1"]];
    NSString* timeStr = [self removeNull:[ticketInputsData objectForKey:@"TicketGUID"]];
    NSString* time;
    if (timeStr.length > 12)
    {
        time = [timeStr substringFromIndex:12];
    }
    [htmlString appendString:[NSString stringWithFormat:@"<td height=\"30\"><b>Date of Service:</b> %@</td>", DOS]];
    [htmlString appendString:[NSString stringWithFormat:@"<td><b>Time:</b> %@</td>", time]];
    [htmlString appendString:[NSString stringWithFormat:@"<td><b>Unit #:</b> %@</td>", unitList]];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"<table style = \"width:100%\" height = \"40\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td height=\"30\"> Medication Administered </td>"];
    [htmlString appendString:@"<td align=\"center\"> Amount Used </td>"];
    [htmlString appendString:@"<td align=\"center\"> Unit </td>"];
    [htmlString appendString:@"<td align=\"center\"> Amount Wasted </td>"];
    [htmlString appendString:@"<td align=\"center\"> Unit </td>"];
    [htmlString appendString:@"<td align=\"center\"> Witnessed Usage </td>"];
    [htmlString appendString:@"<td align=\"center\"> Witnessed Wastage </td>"];
    [htmlString appendString:@"</tr>"];
    
    NSMutableArray* formInputsData;
    NSString* sqlStr = [NSString stringWithFormat:@"Select * from TicketFormsInputs where TicketID = %@ and FormID = 3", ticketID ];
    @synchronized(g_SYNCDATADB)
    {
        formInputsData = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    NSString* paramedicName;
    NSString* paramedicSig;
    NSString* witnessName;
    NSString* witnessSig;
    NSString* wastageName;
    NSString* wastageSig;
    NSString* sigtime;
    
    for (int i=0; i< [formInputsData count]; i++)
    {
        
        ClsTicketFormsInputs* input = [formInputsData objectAtIndex:i];
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
        }
        if (input.formID ==3 && input.formInputID == 3)
        {
            witnessName = input.formInputValue;
        }
        if (input.formID ==3 && input.formInputID == 4)
        {
            witnessSig = input.formInputValue;
        }
        if (input.formID ==3 && input.formInputID == 53)
        {
            wastageName = input.formInputValue;
        }
        if (input.formID ==3 && input.formInputID == 54)
        {
            wastageSig = input.formInputValue;
        }
        
        if (narcoticArray.count > 3)
        {
            ClsNarcotic* nar1 = [narcoticArray objectAtIndex:3];
            if (input.formInputID == 26)
            {
                nar1.amountWastage =  [self removeNull:input.formInputValue];
            }
            if (input.formInputID == 40)
            {
                nar1.WastageUnit = [self removeNull:input.formInputValue];
            }
            if (input.formInputID == 48)
            {
                if ([input.formInputValue isEqualToString:@"1"])
                {
                    nar1.witnessedUsage = 1;
                }
                else
                {
                    nar1.witnessedUsage = 0;
                }
            }
            if (input.formInputID == 49)
            {
                if ([input.formInputValue isEqualToString:@"1"])
                {
                    nar1.witnessedWastage = 1;
                }
                else
                {
                    nar1.witnessedWastage = 0;
                }
            }
        }
        
        if (narcoticArray.count > 2)
        {
            ClsNarcotic* nar1 = [narcoticArray objectAtIndex:2];
            if (input.formInputID == 23)
            {
                nar1.amountWastage =  [self removeNull:input.formInputValue];
            }
            if (input.formInputID == 39)
            {
                nar1.WastageUnit = [self removeNull:input.formInputValue];
            }
            if (input.formInputID == 46)
            {
                if ([input.formInputValue isEqualToString:@"1"])
                {
                    nar1.witnessedUsage = 1;
                }
                else
                {
                    nar1.witnessedUsage = 0;
                }
            }
            if (input.formInputID == 47)
            {
                if ([input.formInputValue isEqualToString:@"1"])
                {
                    nar1.witnessedWastage = 1;
                }
                else
                {
                    nar1.witnessedWastage = 0;
                }
            }
        }
        
        if (narcoticArray.count > 1)
        {
            ClsNarcotic* nar1 = [narcoticArray objectAtIndex:1];
            if (input.formInputID == 20)
            {
                nar1.amountWastage =  [self removeNull:input.formInputValue];
            }
            if (input.formInputID == 38)
            {
                nar1.WastageUnit = [self removeNull:input.formInputValue];
            }
            if (input.formInputID == 44)
            {
                if ([input.formInputValue isEqualToString:@"1"])
                {
                    nar1.witnessedUsage = 1;
                }
                else
                {
                    nar1.witnessedUsage = 0;
                }
            }
            if (input.formInputID == 45)
            {
                if ([input.formInputValue isEqualToString:@"1"])
                {
                    nar1.witnessedWastage = 1;
                }
                else
                {
                    nar1.witnessedWastage = 0;
                }
            }
        }
        
        
        if (narcoticArray.count > 0 )
        {
            ClsNarcotic* nar1 = [narcoticArray objectAtIndex:0];
            if (input.formInputID == 17)
            {
                nar1.amountWastage =  [self removeNull:input.formInputValue];
            }
            if (input.formInputID == 37)
            {
                nar1.WastageUnit = [self removeNull:input.formInputValue];
            }
            if (input.formInputID == 42)
            {
                if ([input.formInputValue isEqualToString:@"1"])
                {
                    nar1.witnessedUsage = 1;
                }
                else
                {
                    nar1.witnessedUsage = 0;
                }
            }
            if (input.formInputID == 43)
            {
                if ([input.formInputValue isEqualToString:@"1"])
                {
                    nar1.witnessedWastage = 1;
                }
                else
                {
                    nar1.witnessedWastage = 0;
                }
                
            }
        }
        
    }
    
    for (int i = 0; i < 6; i++)
    {
        if (i < narcoticArray.count)
        {
            ClsNarcotic* nar = [narcoticArray objectAtIndex:i];
            [htmlString appendString:@"<tr>"];
            [htmlString appendString:[NSString stringWithFormat:@"<td align=\"center\" height=\"40\">%@</td>", nar.MedicationName]];
            [htmlString appendString:[NSString stringWithFormat:@"<td align=\"center\">%@</td>", nar.amountUsage]];
            [htmlString appendString:[NSString stringWithFormat:@"<td align=\"center\">%@</td>", nar.UsageUnit]];
            [htmlString appendString:[NSString stringWithFormat:@"<td align=\"center\">%@</td>", [self removeNull:nar.amountWastage]]];
            [htmlString appendString:[NSString stringWithFormat:@"<td align=\"center\">%@</td>", [self removeNull:nar.WastageUnit]]];
            NSString* witness = @"";
            if (nar.witnessedUsage == 1)
            {
                witness = @"X";
            }
            NSString* wastage = @"";
            if (nar.witnessedWastage == 1)
            {
                wastage = @"X";
            }
            [htmlString appendString:[NSString stringWithFormat:@"<td align=\"center\">%@</td>", witness]];
            [htmlString appendString:[NSString stringWithFormat:@"<td align=\"center\">%@</td>", wastage]];
            [htmlString appendString:@"</tr>"];
        }
        else
        {
            [htmlString appendString:@"<tr>"];
            [htmlString appendString:@"<td height=\"40\"> </td>"];
            [htmlString appendString:@"<td> </td>"];
            [htmlString appendString:@"<td> </td>"];
            [htmlString appendString:@"<td> </td>"];
            [htmlString appendString:@"<td> </td>"];
            [htmlString appendString:@"<td> </td>"];
            [htmlString appendString:@"<td> </td>"];
            [htmlString appendString:@"</tr>"];
        }
        
    }
    
    NSString* standingSql = [NSString stringWithFormat:@"Select FormInputValue from TicketFormsInputs where ticketID = %@ and FormID = 3 and FormInputID = 9", ticketID];
    NSString* standingStr;
    @synchronized(g_SYNCDATADB)
    {
        standingStr = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:standingSql];
    }
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td height=\"40\"> Reason of Use </td>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td colspan=\"6\">%@</td>", [self removeNull:standingStr]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<br>"];
    
    [htmlString appendString:@"<table style=\"width:100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<th align=\"left\", colspan=\"3\"> PARAMEDIC SIGNATURE </th>"];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td height=\"25\", width =\"25%\" align=\"center\"> Printed Name </td>"];
    [htmlString appendString:@"<td width=\"50%\" align=\"center\"> Signature </td>"];
    [htmlString appendString:@"<td width=\"25%\" align=\"center\"> Date </td>"];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td height=\"120\", width =\"25%%\" align=\"center\"> %@ </td>", [self removeNull:paramedicName]]];
    [htmlString appendString:@"<td width=\"50%\" align=\"center\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\" width=\"400\" height=\"100\">", paramedicSig]];
    [htmlString appendString:@"</td>"];
    if (paramedicName.length < 2)
    {
        [htmlString appendString:[NSString stringWithFormat:@"<td height=\"120\", width =\"25%%\" align=\"center\"> %@ </td>", @""]];
    }
    else
    {
        [htmlString appendString:[NSString stringWithFormat:@"<td height=\"120\", width =\"25%%\" align=\"center\"> %@ </td>", [self removeNull:sigtime]]];
    }
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"<table style =\"width:100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<th align=\"left\", colspan=\"3\"> WITNESSED USAGE SIGNATURE </th>"];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td height=\"25\", width =\"25%\" align=\"center\"> Printed Name </td>"];
    [htmlString appendString:@"<td width=\"50%\"> Signature </td>"];
    [htmlString appendString:@"<td width=\"25%\" align=\"center\"> Date </td>"];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td height=\"120\", width =\"25%%\" align=\"center\"> %@ </td>", [self removeNull:witnessName]]];
    [htmlString appendString:@"<td width=\"50%\" align=\"center\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\" width=\"400\" height=\"100\">", witnessSig]];
    [htmlString appendString:@"</td>"];
    if (witnessName.length < 2)
    {
        [htmlString appendString:[NSString stringWithFormat:@"<td height=\"120\", width =\"25%%\" align=\"center\"> %@ </td>", @""]];
    }
    else
    {
        [htmlString appendString:[NSString stringWithFormat:@"<td height=\"120\", width =\"25%%\" align=\"center\"> %@ </td>", [self removeNull:sigtime]]];
    }
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<br>"];
    [htmlString appendString:@"<table style =\"width:100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<th align=\"left\", colspan=\"3\"> WITNESSED WASTAGE SIGNATURE </th>"];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td height=\"25\", width =\"25%\" align=\"center\"> Printed Name </td>"];
    [htmlString appendString:@"<td width=\"50%\" align=\"center\"> Signature </td>"];
    [htmlString appendString:@"<td width=\"25%\" align=\"center\"> Date </td>"];
    [htmlString appendString:@"</tr>"];
    
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td height=\"120\", width =\"25%%\" align=\"center\"> %@ </td>", [self removeNull:wastageName]]];
    [htmlString appendString:@"<td width=\"50%\" align=\"center\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\" width=\"400\" height=\"100\">", wastageSig]];
    [htmlString appendString:@"</td>"];
    if (wastageName.length < 2)
    {
        [htmlString appendString:[NSString stringWithFormat:@"<td height=\"120\", width =\"25%%\" align=\"center\"> %@ </td>", @""]];
    }
    else
    {
        [htmlString appendString:[NSString stringWithFormat:@"<td height=\"120\", width =\"25%%\" align=\"center\"> %@ </td>", [self removeNull:sigtime]]];
    }
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"</html>"];
    
    
    [webView1 loadHTMLString:htmlString baseURL:nil];
}


- (void) loadSupplement
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketUnitNumber, TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and (deleted is null or deleted = 0)", ticketID ];
    
    NSMutableDictionary* ticketInputsData;
    NSMutableArray* crewData;
    NSMutableArray* unitData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSString* sql1 = [NSString stringWithFormat:@"Select ticketCrew from tickets where ticketId = %@", ticketID];
    NSMutableString* crew = [[NSMutableString alloc] init];
    
    @synchronized(g_SYNCDATADB)
    {
        [crew appendString:[DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql1]];
    }
    if (crew.length > 1)
    {
        [crew deleteCharactersInRange:NSMakeRange([crew length]-1, 1)];
    }
    
    NSString* crewIds = [[ticketInputsData objectForKey:@"TicketCrew"] stringByReplacingOccurrencesOfString:@"|" withString:@","];
    NSString* crewIDStr;
    if (crewIds.length > 1)
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
    
    if (unitList.length > 1)
    {
        NSRange range = [unitList rangeOfString:@"|"];
        if (range.location != NSNotFound)
        {
            [unitList deleteCharactersInRange:range];
        }
    }
    
    
    htmlString = [NSMutableString stringWithString:@"<!DOCTYPE html><html><head><title>Supplemental Report</title>"];
    [htmlString appendString:@"<style type=\"text/css\">"];
    
    [htmlString appendString:@"</style>"];
    [htmlString appendString:@"</head>"];
    [htmlString appendString:@"<body style=\"background:transparent;\">"];
    [htmlString appendString:@"<h2><b>Supplemental Form</b></h2>"];
    [htmlString appendString:@"<div border=\"1\">"];
    [htmlString appendString:@"<table border=\"1\" style=\"width:100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td><b>Incident Number:</b> %@</td>", [self removeNull:[ticketInputsData objectForKey:@"1001:0:1"]]]];
    [htmlString appendString:[NSString stringWithFormat:@"<td><b>Date of Service:</b> %@</td>", [self removeNull:[ticketInputsData objectForKey:@"1002:0:1"]]]];
    [htmlString appendString:[NSString stringWithFormat:@"<td><b>Unit:</b> %@</td>", unitList]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td><b>Patient Last Name:</b> %@</td>", [self removeNull:[ticketInputsData objectForKey:@"1101:0:1"]]]];
    [htmlString appendString:[NSString stringWithFormat:@"<td><b>Chief Complaint:</b> %@</td>", [self removeNull:[ticketInputsData objectForKey:@"1008:0:1"]]]];
    [htmlString appendString:[NSString stringWithFormat:@"<td><b>Crew:</b> %@</td>", crew]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"</div>"];
    
    [htmlString appendString:@"<br>"];
    
    NSMutableArray* injurySelectedAll = [[NSMutableArray alloc] init];
    NSString* diagramSql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and ti.inputID in (9001, 9002)", ticketID ];
    NSMutableDictionary* diagramData;
    @synchronized(g_SYNCDATADB)
    {
        diagramData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:diagramSql];
    }
    
    if ([[diagramData objectForKey:@"9001:0:1"] length] > 0 && ([[diagramData objectForKey:@"9001:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        NSString* data = [diagramData objectForKey:@"9001:0:1"];
        NSArray* dataArray = [data componentsSeparatedByString:@"|"];
        for (int i = 0; i < [dataArray count]-1; i++)
        {
            @try {
                ClsInjuryType* type = [[ClsInjuryType alloc] init];
                NSString* item = [dataArray objectAtIndex:i];
                NSRange range = [item rangeOfString:@":"];
                type.area = [item substringToIndex:range.location];
                NSString* remainder = [item substringFromIndex:range.location+2];
                NSArray* remainderArray = [remainder componentsSeparatedByString:@","];
                float x = 0;
                float y = 0;
                for (int j = 0; j < [remainderArray count]; j ++)
                {
                    if (j == 0)
                    {
                        type.type = [remainderArray objectAtIndex:j];
                    }
                    else if (j == 1)
                    {
                        NSString* viewPos = [remainderArray objectAtIndex:j];
                        if ([viewPos rangeOfString:@"F"].location == NSNotFound)
                        {
                            type.front = 1;
                        }
                        else
                        {
                            type.front = 0;
                        }
                    }
                    else if (j == 2)
                    {
                        x = [[remainderArray objectAtIndex:j] floatValue];
                    }
                    else if (j == 3)
                    {
                        y = [[remainderArray objectAtIndex:j] floatValue];
                        CGPoint point = CGPointMake(x, y);
                        type.location = point;
                    }
                }
                [injurySelectedAll addObject:type];
            }
            @catch (NSException *exception) {
                
            }
            
        }
    }
    [htmlString appendString:@"<br>"];
    
    if (injurySelectedAll.count > 0)
    {
        
        [htmlString appendString:@"<div border=\"1\">"];
        [htmlString appendString:@"<table border=\"1\" style=\"width:100%\">"];
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td style=\"text-align: left\", colspan = \"3\"><b>Injuries</b></td>"];
        
        [htmlString appendString:@"</tr>"];
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td>"];
        for (int i = 0; i< injurySelectedAll.count; i++)
        {
            ClsInjuryType* injType = [injurySelectedAll objectAtIndex:i];
            [htmlString appendString:[NSString stringWithFormat:@"%d. %@: %@<br>", i+1,injType.area, injType.type]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@" <td  align=\"center\">"];
        
        if ([[diagramData objectForKey:@"9002:0:1"] length] > 0 && ([[diagramData objectForKey:@"9002:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            sql = [NSString stringWithFormat:@"Select * from TicketAttachments where TicketID = %@ and AttachmentId = 2", ticketID ];
            NSMutableArray* frontImageArray;
            @synchronized(g_SYNCBLOBSDB)
            {
                frontImageArray = [DAO executeSelectTicketAttachments:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                
            }
            if ([frontImageArray count] > 0)
            {
                ClsTicketAttachments* attachment = [frontImageArray objectAtIndex:0];
                NSString* fileStr = attachment.fileStr;
                
                [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\" width=\"300\" height=\"400\">", fileStr]];
            }
            
            [htmlString appendString:@"</td>"];
            [htmlString appendString:@"<td  align=\"center\">"];
            sql = [NSString stringWithFormat:@"Select * from TicketAttachments where TicketID = %@ and AttachmentID = 4", ticketID ];
            NSMutableArray* backImageArray;
            @synchronized(g_SYNCBLOBSDB)
            {
                backImageArray = [DAO executeSelectTicketAttachments:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                
            }
            if ([backImageArray count] > 0)
            {
                ClsTicketAttachments* attachment1 = [backImageArray objectAtIndex:0];
                NSString* fileStr1 = attachment1.fileStr;
                
                [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\" width=\"300\" height=\"400\">", fileStr1]];
                
            }
        }
        
        
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
        [htmlString appendString:@"</table>"];
        [htmlString appendString:@"</div>"];
        
        
    }
    
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1221", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    if (count > 0)
    {
        
        NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and InputID in (1221, 1251, 1252, 1255, 1258, 1263, 1264)", ticketID ];
        NSMutableDictionary* MVCInputsData;
        @synchronized(g_SYNCDATADB)
        {
            MVCInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
        [htmlString appendString:@"<br>"];
        [htmlString appendString:@"<div border=\"1\">"];
        [htmlString appendString:@"<table border=\"1\" style=\"width:100%\">"];
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td style=\"text-align: left\", colspan = \"2\"><b>MVC/MVA Details</b></td>"];
        
        [htmlString appendString:@"</tr>"];
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td>"];
        
        [htmlString appendString:@"<table border=\"1\" style=\"width:80%\">"];
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1255:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1255:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:@"Collision"];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1255:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1255:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [MVCInputsData objectForKey:@"1255:0:1"]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
        
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1251:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1251:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:@"Extrication"];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1251:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1251:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [MVCInputsData objectForKey:@"1251:0:1"]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
        
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1252:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1252:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:@"Ejected"];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1252:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1252:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [MVCInputsData objectForKey:@"1252:0:1"]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
        
        
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1258:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1258:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:@"Vehicle Impact Area"];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1258:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1258:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [MVCInputsData objectForKey:@"1258:0:1"]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
        
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1221:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1221:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:@"Safety Equipment Used"];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1221:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1221:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [MVCInputsData objectForKey:@"1221:0:1"]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
        
        [htmlString appendString:@"<tr>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1263:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1263:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:@"Airbag Deployment"];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td>"];
        if ([[MVCInputsData objectForKey:@"1263:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1263:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [htmlString appendString:[NSString stringWithFormat:@"%@", [MVCInputsData objectForKey:@"1263:0:1"]]];
        }
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
        
        /*       if ([[MVCInputsData objectForKey:@"1258:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1258:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
         {
         [self.btnImpact setTitle:[MVCInputsData objectForKey:@"1258:0:1"] forState:UIControlStateNormal];
         }
         
         if ([[MVCInputsData objectForKey:@"1263:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1263:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
         {
         [self.btnDeploy setTitle:[MVCInputsData objectForKey:@"1263:0:1"] forState:UIControlStateNormal];
         }
         
         if ([[MVCInputsData objectForKey:@"1264:0:1"] length] > 0 && ([[MVCInputsData objectForKey:@"1264:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
         {
         [self.btnIndicators setTitle:[MVCInputsData objectForKey:@"1264:0:1"] forState:UIControlStateNormal];
         }  */
        [htmlString appendString:@"</table>"];
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"<td align=\"center\">"];
        sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketAttachments where TicketID = %@ and AttachmentID = 5", ticketID ];
        @synchronized(g_SYNCBLOBSDB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
        }
        if (count > 0)
        {
            NSMutableArray* ticketInputsData;
            NSString* sql = [NSString stringWithFormat:@"Select * from TicketAttachments where TicketID = %@ and AttachmentID = 5", ticketID ];
            @synchronized(g_SYNCBLOBSDB)
            {
                ticketInputsData = [DAO executeSelectTicketAttachments:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            ClsTicketAttachments* attachment = [ticketInputsData objectAtIndex:0];
            NSString* fileStr = attachment.fileStr;
            [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\" width=\"300\" height=\"400\">", fileStr]];
            
        }
        
        [htmlString appendString:@"</td>"];
        [htmlString appendString:@"</tr>"];
        
        [htmlString appendString:@"</table>"];
        [htmlString appendString:@"</div>"];
        [htmlString appendString:@"<br>"];
        
    }
    
    
    
    [htmlString appendString:@"<table border=\"1\" style=\"width:100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td> <b>Auto Narrative<b></td>"];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:[NSString stringWithFormat:@"<td>%@</td>", [self getAutoNarrativeData]]];
    [htmlString appendString:@"</tr>"];
    [htmlString appendString:@"</table>"];
    [htmlString appendString:@"<br>"];
    
    [htmlString appendString:@"<table border=\"0\" width=\"100%\">"];
    [htmlString appendString:@"<tr>"];
    [htmlString appendString:@"<td  Width=\"50%\"; Align=\"left\">"];
    [htmlString appendString:@"Supplemental Form - FH Medic"];
    [htmlString appendString:@"</td>"];
    [htmlString appendString:@"<td Width=\"50%\"; Align=\"right\">"];
    
    
    [htmlString appendString:[NSString stringWithFormat:@"Incident Date/Time Created: %@", [[[NSDate date] description] substringToIndex:19]]];
    [htmlString appendString:@"</table>"];
    
    [htmlString appendString:@"</body>"];
    [htmlString appendString:@"</html>"];
    [webView1 loadHTMLString:htmlString baseURL:nil];
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
        title = sigType.signatureTypeDesc;
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
    
    /*     [htmlString appendString:@"<tr>"];
     for (int i =0; i< maxRow; i++ )
     {
     ClsSignatureImages* sig = [signatureList objectAtIndex:i];
     NSString* title;
     
     
     ClsSignatureTypes* sigType = [sigTypeArray objectAtIndex:sig.type];
     title = sigType.signatureTypeDesc;
     
     [htmlString appendString:@"<td WIDTH=\"12.5%\"  Align=\"center\">"];
     [htmlString appendString:[NSString stringWithFormat:@"%@ - %@", title, sig.name]];
     [htmlString appendString:@"</td>"];
     }
     [htmlString appendString:@"</tr>"];    */
    /*    if ([signatureList count] > 4)
     {
     [htmlString appendString:@"<tr>"];
     for (int i=4; i< [signatureList count]; i++ )
     {
     ClsSignatureImages* sig = [signatureList objectAtIndex:i];
     [htmlString appendString:@"<td WIDTH=\"12.5%\" Align=\"center\">"];
     [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\" width=\"200\" height=\"100\">", sig.imageStr]];
     [htmlString appendString:@"</td>"];
     }
     [htmlString appendString:@"</tr>"];
     [htmlString appendString:@"<tr>"];
     
     for (int i=4; i< [signatureList count]; i++ )
     {
     ClsSignatureImages* sig = [signatureList objectAtIndex:i];
     NSString* title;
     
     ClsSignatureTypes* sigType = [sigTypeArray objectAtIndex:sig.type];
     title = sigType.signatureTypeDesc;
     [htmlString appendString:@"<td WIDTH=\"12.5%\"  Align=\"center\">"];
     [htmlString appendString:[NSString stringWithFormat:@"%@ - %@", title, sig.name]];
     [htmlString appendString:@"</td>"];
     }
     
     [htmlString appendString:@"</tr>"];
     } */
    
    [htmlString appendString:@"</table>"];
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

- (NSString *)getAutoNarrativeData
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    bool primaryComplaint = false;
    NSString* chiefComplaint = @"";
    
    //        NSString* vitalCount = @"";
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
    [narrativeText appendString:[NSString stringWithFormat:@"EMS Unit responded to a call with a chief complaint of %@. ",  chiefComplaint]];
    
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
    NSString* noallergies = @"<br><br>Patient has no known drug allergies. ";
    if ([[ticketInputData objectForKey:@"1227:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1227:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* allergyStr = [NSString stringWithFormat:@"<br><br>Allergies to the following medications were noted: %@. ", [ticketInputData objectForKey:@"1227:0:1"]];
        [narrativeText appendString:allergyStr];
    }
    else
    {
        [narrativeText appendString:noallergies];
    }
    
    
    if ([[ticketInputData objectForKey:@"1224:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1224:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* allergyStr = [NSString stringWithFormat:@"Environmental allergies included: %@. ", [ticketInputData objectForKey:@"1224:0:1"]];
        [narrativeText appendString:allergyStr];
    }
    
    
    if ([[ticketInputData objectForKey:@"1225:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1225:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* allergyStr = [NSString stringWithFormat:@"Food allergies included: %@. ", [ticketInputData objectForKey:@"1225:0:1"]];
        [narrativeText appendString:allergyStr];
    }
    
    if ([[ticketInputData objectForKey:@"1226:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1226:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* allergyStr = [NSString stringWithFormat:@"Insect allergies included: %@. ", [ticketInputData objectForKey:@"1226:0:1"]];
        [narrativeText appendString:allergyStr];
    }
    if ([[ticketInputData objectForKey:@"1228:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1228:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* allergyStr = [NSString stringWithFormat:@"<br><br>EMS exposure: %@.", [ticketInputData objectForKey:@"1228:0:1"]];
        [narrativeText appendString:allergyStr];
    }
    [narrativeText appendString:@"<br>"];
    
    NSString* histStr = @"Select count(*) from ticketInputs where inputID in (1433, 1601, 1602, 1603, 1604, 1605, 1606, 1607, 1608, 1609, 1610) where (inputValue is not null or inputValue != '(null)')";
    NSInteger histCount;
    @synchronized(g_SYNCDATADB)
    {
        histCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:histStr];
    }
    if (histCount > 0)
    {
        NSString* histHeader = @"<br><br>Patient gave the following medical history to EMT personel. ";
        [narrativeText appendString:histHeader];
        if ([[ticketInputData objectForKey:@"1433:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1433:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* medStr = [NSString stringWithFormat:@"Current medications being taken include: %@. ", [ticketInputData objectForKey:@"1433:0:1"]];
            [narrativeText appendString:medStr];
        }
        
        if ([[ticketInputData objectForKey:@"1601:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1601:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"<br><br>Cardiovascular history included: %@. ", [ticketInputData objectForKey:@"1601:0:1"]];
            [narrativeText appendString:histStr];
        }
        if ([[ticketInputData objectForKey:@"1602:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1602:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"<br><br>Patient has a history of cancer, including %@. ", [ticketInputData objectForKey:@"1602:0:1"]];
            [narrativeText appendString:histStr];
        }
        if ([[ticketInputData objectForKey:@"1603:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1603:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"<br>Neurological history includes %@. ", [ticketInputData objectForKey:@"1603:0:1"]];
            [narrativeText appendString:histStr];
        }
        if ([[ticketInputData objectForKey:@"1604:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1604:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"<br>Patient reports a gastrointestinal history of %@. ", [ticketInputData objectForKey:@"1604:0:1"]];
            [narrativeText appendString:histStr];
        }
        
        if ([[ticketInputData objectForKey:@"1605:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1605:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"<br>Genitourinary history includes %@. ", [ticketInputData objectForKey:@"1605:0:1"]];
            [narrativeText appendString:histStr];
        }
        
        if ([[ticketInputData objectForKey:@"1606:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1606:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"<br>Patient reports an infectious history of %@. ", [ticketInputData objectForKey:@"1606:0:1"]];
            [narrativeText appendString:histStr];
        }
        
        if ([[ticketInputData objectForKey:@"1607:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1607:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"<br>Metabolic - endocrine history includes %@. ", [ticketInputData objectForKey:@"1607:0:1"]];
            [narrativeText appendString:histStr];
        }
        
        if ([[ticketInputData objectForKey:@"1608:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1608:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"<br>Patient reports a respiratory history of %@. ", [ticketInputData objectForKey:@"1608:0:1"]];
            [narrativeText appendString:histStr];
        }
        
        if ([[ticketInputData objectForKey:@"1609:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1609:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"<br>Psychological history includes %@. ", [ticketInputData objectForKey:@"1609:0:1"]];
            [narrativeText appendString:histStr];
        }
        if ([[ticketInputData objectForKey:@"1610:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1610:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            
            NSString* histStr = [NSString stringWithFormat:@"<br>Patient reports the following women's health issues: %@. ", [ticketInputData objectForKey:@"1610:0:1"]];
            [narrativeText appendString:histStr];
        }
        
    }
    
    NSString* assessHeader = @"<br>Patient was assessed with the following responses noted.\n";
    [narrativeText appendString:assessHeader];
    if ([[ticketInputData objectForKey:@"1235:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1235:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Motor Response was: %@. ", [ticketInputData objectForKey:@"1235:0:1"]];
        [narrativeText appendString:str];
    }
    NSInteger verbal = 0;
    if ([[ticketInputData objectForKey:@"1236:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1236:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Verbal Response was rated at a: %@ ", [ticketInputData objectForKey:@"1236:0:1"]];
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
            NSString* str = [NSString stringWithFormat:@"<br>Eye Response was rated at a: %@. ", [ticketInputData objectForKey:@"1237:0:1"]];
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
        
        NSString* str = [NSString stringWithFormat:@"<br>Airway was : %@ ", [ticketInputData objectForKey:@"1239:0:1"]];
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
            NSString* str = [NSString stringWithFormat:@"<br>Breathing was: %@. ", [ticketInputData objectForKey:@"1237:0:1"]];
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
        
        NSString* str = [NSString stringWithFormat:@"<br>CRT (Capillary Refill Time) was %@", [ticketInputData objectForKey:@"1242:0:1"]];
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
            NSString* str = [NSString stringWithFormat:@"<br>Skin was: %@. ", [ticketInputData objectForKey:@"1237:0:1"]];
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
        
        NSString* str = [NSString stringWithFormat:@"<br>AVPU was %@. ", [ticketInputData objectForKey:@"1244:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1272:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1272:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Orientation was %@. ", [ticketInputData objectForKey:@"1272:0:1"]];
        [narrativeText appendString:str];
    }
    
    
    if ([[ticketInputData objectForKey:@"1283:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1283:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Head/Face was %@. ", [ticketInputData objectForKey:@"1283:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1284:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1284:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Neck was %@. ", [ticketInputData objectForKey:@"1284:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1285:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1285:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Lungs were %@. ", [ticketInputData objectForKey:@"1285:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1286:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1286:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Chest was %@. ", [ticketInputData objectForKey:@"1286:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1287:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1287:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>ABD was %@. ", [ticketInputData objectForKey:@"1287:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1288:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1288:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Pelvis was %@. ", [ticketInputData objectForKey:@"1288:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1270:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1270:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Ext was %@. ", [ticketInputData objectForKey:@"1270:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1271:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1271:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Back was %@. ", [ticketInputData objectForKey:@"1271:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1273:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1273:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Psychosocial was %@. ", [ticketInputData objectForKey:@"1273:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1280:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1280:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Stress level was %@. ", [ticketInputData objectForKey:@"1280:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1281:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1281:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Anxiety level was %@. ", [ticketInputData objectForKey:@"1281:0:1"]];
        [narrativeText appendString:str];
    }
    
    if ([[ticketInputData objectForKey:@"1282:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1282:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Cooperativeness level was %@. ", [ticketInputData objectForKey:@"1282:0:1"]];
        [narrativeText appendString:str];
    }
    
    
    NSInteger motor = 0;
    if ([[ticketInputData objectForKey:@"1245:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1245:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* str = [NSString stringWithFormat:@"<br>Motor rated at %@", [ticketInputData objectForKey:@"1245:0:1"]];
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
            NSString* str = [NSString stringWithFormat:@"<br>Sensory was: %@. ", [ticketInputData objectForKey:@"1246:0:1"]];
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
        
        NSString* str = [NSString stringWithFormat:@"<br>Speech was %@", [ticketInputData objectForKey:@"1247:0:1"]];
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
            NSString* str = [NSString stringWithFormat:@"<br>Eyes were: %@. ", [ticketInputData objectForKey:@"1249:0:1"]];
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
        
        NSString* str = [NSString stringWithFormat:@"<br>Overall, general assessment: %@.\n", [ticketInputData objectForKey:@"1240:0:1"]];
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
        NSString* vitalDesc = [NSString stringWithFormat:@"%d set of vitals were taken for this incident.",
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
        NSString* treatmentDesc = [NSString stringWithFormat:@"The following %d treatments were performed on the patients.\n", NumOftreatments ];
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
            
            
            NSString* treatmentDetail = [NSString stringWithFormat:@"<br>%@ was administered at %@. ", treatment.treatmentDesc, input.inputValue];
            [narrativeText appendString:treatmentDetail];
            
            //   NSString* treatmentName = [NSString stringWithFormat:@"%@ ", [ticketInputData objectForKey:Str]];
            NSString* temp = @"<br>The following details were noted for this treatment: \n";
            [narrativeText appendString:temp];
            for(int i=1;i<[treatment.arrayTreatmentInputValues count];i++)
            {
                ClsTreatmentInputs *inputs = [treatment.arrayTreatmentInputValues objectAtIndex:i];
                
                NSString* temp1 = [NSString stringWithFormat:@"%@: %@, ", inputs.inputName, inputs.inputValue];
                [narrativeText appendString:temp1];
                
                
            }
            [narrativeText appendString:@"<br>"];
            
        }
    }
    [narrativeText appendString:@"<br>"];
    NSString* outcomeHeader = [NSString stringWithFormat:@"Outcome for this incident: %@.<br>", [self removeNull:[ticketInputData objectForKey:@"1401:0:1"]]];
    [narrativeText appendString:outcomeHeader];
    
    NSInteger transported = 0;
    if ([[ticketInputData objectForKey:@"1402:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1042:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* histStr = [NSString stringWithFormat:@"<br>Patient was transported to %@. ", [ticketInputData objectForKey:@"1402:0:1"]];
        [narrativeText appendString:histStr];
        transported = 1;
    }
    if ([[ticketInputData objectForKey:@"1403:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1403:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        if (transported == 1)
        {
            NSString* str = [NSString stringWithFormat:@", escorted by: %@. ", [ticketInputData objectForKey:@"1403:0:1"]];
            [narrativeText appendString:str];
        }
        else
        {
            NSString* str = [NSString stringWithFormat:@"<br>Escorted by: %@. ", [ticketInputData objectForKey:@"1403:0:1"]];
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
        
        NSString* histStr = [NSString stringWithFormat:@"<br><br>Patient personal items included %@ ", [ticketInputData objectForKey:@"1420:0:1"]];
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
        
        NSString* histStr = [NSString stringWithFormat:@"<br><br>The condition of the patient upon arrival was: %@. ", [ticketInputData objectForKey:@"1023:0:1"]];
        [narrativeText appendString:histStr];
    }
    
    
    
    NSInteger care = 0;
    if ([[ticketInputData objectForKey:@"1045:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1045:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        NSString* histStr = [NSString stringWithFormat:@"<br><br>Patient care was transfered at: %@ ", [ticketInputData objectForKey:@"1045:0:1"]];
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
            NSString* outcomeStr = [NSString stringWithFormat:@"<br>The unit was clear at %@.", [ticketInputData objectForKey:@"1046:0:1"]];
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



- (void) appendVital:(NSMutableDictionary*)ticketInputData text:(NSString*)narrativeText searchFor:(NSString*)searchString
{
    if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3001:0:%@", searchString]]] length] > 0 )
    {
        
        [narrativeText stringByAppendingString:[NSString stringWithFormat:@"Vital number was taken %@ at %@", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3012:0:%@", searchString]]], [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3001:0:%@", searchString]]]]];
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3013:0:%@", searchString]]] length] > 0 )
        {
            [narrativeText stringByAppendingString:[NSString stringWithFormat:@"by %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3013:0:%@", searchString]]]]];
        }
        else
        {
            [narrativeText stringByAppendingString:@". "];
        }
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3005:0:%@", searchString]]] length] > 0 )
        {
            [narrativeText stringByAppendingString:[NSString stringWithFormat:@"Heart rate was %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3005:0:%@", searchString]]]]];
        }
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3004:0:%@", searchString]]] length] > 0 )
        {
            [narrativeText stringByAppendingString:[NSString stringWithFormat:@"Respiratory rate was %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3004:0:%@", searchString]]]]];
        }
        
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3002:0:%@", searchString]]] length] > 0 )
        {
            [narrativeText stringByAppendingString:[NSString stringWithFormat:@"Sys BP was %@, ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3002:0:%@", searchString]]]]];
        }
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3003:0:%@", searchString]]] length] > 0 )
        {
            [narrativeText stringByAppendingString:[NSString stringWithFormat:@"and Diast BP was %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3003:0:%@", searchString]]]]];
        }
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3008:0:%@", searchString]]] length] > 0 )
        {
            [narrativeText stringByAppendingString:[NSString stringWithFormat:@"Glucose levels were %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3008:0:%@", searchString]]]]];
        }
        
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3010:0:%@", searchString]]] length] > 0 )
        {
            [narrativeText stringByAppendingString:[NSString stringWithFormat:@"Patient's temperature was taken and showed %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3010:0:%@", searchString]]]]];
        }
        if ([[self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3015:0:%@", searchString]]] length] > 0 )
        {
            [narrativeText stringByAppendingString:[NSString stringWithFormat:@"EKG showed %@. ", [self removeNull:[ticketInputData objectForKey:[NSString stringWithFormat:@"3015:0:%@", searchString]]]]];
        }
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnPrintClick:(id)sender {
    
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"PCR";
    pc.printInfo = printInfo;
    pc.showsPageRange = YES;
    UIViewPrintFormatter *formatter = [webView1 viewPrintFormatter];
    UIEdgeInsets titleInsets = UIEdgeInsetsMake(0, -36, 0, -36);
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

- (IBAction)btnFaxClick:(UIButton *)sender {
    NSString* MachineID = [g_SETTINGS objectForKey:@"MachineID"];
    if ([MachineID isEqualToString:@"LOCAL"])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"This feature is not available in the demo version." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        FaxViewController *popoverView =[[FaxViewController alloc] initWithNibName:@"FaxViewController" bundle:nil];
        if (formType == 1)
        {
            popoverView.form = @"PCR";
        }
        else if (formType == 2)
        {
            popoverView.form = @"Supp";
        }
        else if (formType == 3)
        {
            popoverView.form = @"Narc";
        }
        else if (formType == 4)
        {
            popoverView.form = @"ABN";
        }
        else if (formType == 5)
        {
            popoverView.form = @"PCS";
        }
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


- (IBAction)btnBackClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
    [self.toolbar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
}
@end
