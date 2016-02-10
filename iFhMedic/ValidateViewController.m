//
//  ValidateViewController.m
//  iRescueMedic
//
//  Created by admin on 5/15/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "ValidateViewController.h"
#import "DAO.h"
#import "global.h"
#import "ClsTableKey.h"
#import "RequiredField.h"
#import "ClsTicketInputs.h"
#import "ClsTreatments.h"
#import "ClsTreatmentInputs.h"

@interface ValidateViewController ()
{
        NSString* ticketID ;
}
@property (strong, nonatomic)  NSMutableArray* assessmentArray;
@property (strong, nonatomic)  NSMutableArray* treatmentArray;
@property (strong, nonatomic)  NSMutableArray* vitalArray;
@end

@implementation ValidateViewController
@synthesize requiredID;
@synthesize missingInputIDs;
@synthesize tableView;
@synthesize delegate;
@synthesize tagID;
@synthesize progressView;
@synthesize lblComplete;
@synthesize outcomeVal;
@synthesize ticketComplete;
@synthesize assessmentArray;
@synthesize treatmentArray;
@synthesize vitalArray;


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
    ticketComplete = false;
   ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    self.assessmentArray = [[NSMutableArray alloc] init];
    self.treatmentArray = [[NSMutableArray alloc] init];
    self.vitalArray = [[NSMutableArray alloc] init];
    
    NSString* sqlOutcome = [NSString stringWithFormat:@"select InputValue from TicketInputs where ticketID = %@ and InputID = 1401", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        self.outcomeVal = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlOutcome];
    }
    
    if ([outcomeVal isEqualToString:@"Multi-Patient Refusal"])
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (999)", ticketID];
        NSInteger count;
        @synchronized(g_SYNCBLOBSDB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
        }
        NSInteger completed = 0;
        if (count > 0)
        {
            completed = 1;
        }
        else
        {
            self.missingInputIDs = [[NSMutableArray alloc] init];
            ClsTableKey* obj = [[ClsTableKey alloc] init];
            obj.tableName = [NSString stringWithFormat:@"Multi-Patient Refusal Needed"];
            obj.desc = @"Signature";
            obj.key = 1000040;
            [self.missingInputIDs addObject:obj];
        }
 
        
        NSInteger total = 1;
        
        lblComplete.text = [NSString stringWithFormat:@"%d/%d", completed, total];
        
        float progress = (float) completed/total;
        [progressView setProgress:progress animated:NO];
        
        if ((total - completed) == 0)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Required fields completed" message:@"All required data are entered. Would you like to finalize this ticket?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 0;
            [alert show];
            
        }
        
        return;
    }
 
    NSString* sql;
    if ([outcomeVal length] > 0 && ([outcomeVal rangeOfString:@"(null)"].location == NSNotFound))
    {
        if ([outcomeVal isEqualToString:@"Patient Transported"])
        {
            sql = [NSString stringWithFormat:@"select inputID from Inputs where InputRequiredField = 1 union select inputID from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@'" , outcomeVal];
        }
        else
        {
            sql = [NSString stringWithFormat:@"select inputID from Inputs where InputRequiredField = 1 and inputPage = 'Incident' union select inputID from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@'" , outcomeVal];
        }

    }
    else
    {
       sql = @"select inputID from Inputs where InputRequiredField = 1";
    }
    @synchronized(g_SYNCLOOKUPDB)
    {
         self.requiredID = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    
    sql = [NSString stringWithFormat:@"select InputID, InputValue from ticketInputs where TicketID = %@ and InputID in (%@) and (inputValue is not null) and inputValue NOT like '%@(null)%@' and inputValue != ''", ticketID, requiredID, @"%", @"%"];
    NSMutableDictionary* ticketInputIds;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputIds = [DAO executeSelectInputValue:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSMutableString* missingIDs = [[NSMutableString alloc] init];
    
    NSArray* requiredIDArray = [requiredID componentsSeparatedByString:@","];
    for (int i=0; i < [requiredIDArray count]; i++)
    {
        NSString* testStr = [ticketInputIds objectForKey:[requiredIDArray objectAtIndex:i]];
       if ([testStr length] > 0 && ([testStr rangeOfString:@"(null)"].location == NSNotFound))
       {
           
       }
        else
        {
            [missingIDs appendString:[requiredIDArray objectAtIndex:i]];
            [missingIDs appendString:@","];
        }
    }
    if ([missingIDs length] > 1)
    {
        [missingIDs deleteCharactersInRange:NSMakeRange([missingIDs length]-1, 1)];
    }
    
    NSArray* incomplete;
    
    if (missingIDs.length > 0)
    {
        incomplete = [missingIDs componentsSeparatedByString:@","];
        
    }
    
    
    sql = [NSString stringWithFormat:@"select InputID, InputName, InputPage from Inputs where InputID in (%@)", missingIDs];
    @synchronized(g_SYNCLOOKUPDB)
    {
        self.missingInputIDs = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    
    NSString* sqlStr = @"Select drugname from drugs where narcotic = 1";
    NSString* narcotics;
    @synchronized(g_SYNCLOOKUPDB)
    {
        narcotics = [DAO executeSelectNarcoticInput:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketInputs where ticketID = %@ and inputID = 2011 and InputValue in (%@)", ticketID, narcotics];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    NSInteger narcoticCount = 0;
    if (count > 0)
    {
        NSInteger narcoticEnteredCount = 0;
        sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FormID = 3 and FormInputID = 7", ticketID ];
        @synchronized(g_SYNCDATADB)
        {
            narcoticEnteredCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (narcoticEnteredCount < 1)
        {
            ClsTableKey* obj = [[ClsTableKey alloc] init];
            obj.tableName = @"Narcotic";
            obj.desc = @"Narcotic";
            obj.key = 1000000;
            [missingInputIDs addObject:obj];
            narcoticCount++;
        }

    }
    NSInteger signatureCount = 0;
    NSInteger hospitalCount = 0;
    NSInteger refusalCount = 0;
    NSInteger medic1Count = 0;
    NSInteger medic2Count = 0;
    NSInteger witnessCount = 0;
    NSInteger vitalCount = 0;
    NSInteger treatmentCount = 0;
    bool treatmentNeeded = false;
    NSInteger assessmentNeeded = 0;
    
    if ([outcomeVal length] > 0 && ([outcomeVal rangeOfString:@"(null)"].location == NSNotFound))
    {
        
        if ([outcomeVal isEqualToString:@"Patient Transported"])
        {
          /*  if ([[g_SETTINGS objectForKey:@"PatientSignatureRequired"] isEqualToString:@"1"])
            {
                sqlStr = [NSString stringWithFormat:@"Select signaturetype from SignatureTypes where SignatureGroup = 'Patient'"];
                NSString* sigTypeStr;
                @synchronized(g_SYNCLOOKUPDB)
                {
                    sigTypeStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
                }
                sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (%@)", ticketID, sigTypeStr];
                NSInteger count;
                @synchronized(g_SYNCBLOBSDB)
                {
                    count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
                }
                if (count < 1)
                {
                    ClsTableKey* obj = [[ClsTableKey alloc] init];
                    obj.tableName = @"Patient Signature";
                    obj.desc = @"Patient";
                    obj.key = 1000001;
                    [missingInputIDs addObject:obj];
                    signatureCount++;
                }
            }  */
            
         /*   if ([[g_SETTINGS objectForKey:@"HospitalSignatureRequired"] isEqualToString:@"1"])
            {
                sqlStr = [NSString stringWithFormat:@"Select signaturetype from SignatureTypes where SignatureGroup = 'Hospital'"];
                NSString* sigTypeStr;
                @synchronized(g_SYNCLOOKUPDB)
                {
                    sigTypeStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
                }
                sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (%@)", ticketID, sigTypeStr];
                NSInteger count;
                @synchronized(g_SYNCBLOBSDB)
                {
                    count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
                }
                if (count < 1)
                {
                    ClsTableKey* obj = [[ClsTableKey alloc] init];
                    obj.tableName = @"Hospital Representative Signature";
                    obj.desc = @"Hospital";
                    obj.key = 1000002;
                    [missingInputIDs addObject:obj];
                    hospitalCount++;
                }
            }  */
        } // end if (transport)
        else if ([outcomeVal rangeOfString:@"Refus"].location != NSNotFound)
        {
            sqlStr = [NSString stringWithFormat:@"Select signaturetype from SignatureTypes where SignatureGroup = 'Patient Refusal'"];
            NSString* sigTypeStr;
            @synchronized(g_SYNCLOOKUPDB)
            {
                sigTypeStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
            }
            sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (%@)", ticketID, sigTypeStr];
            NSInteger count;
            @synchronized(g_SYNCBLOBSDB)
            {
                count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
            }
            if (count < 1)
            {
                ClsTableKey* obj = [[ClsTableKey alloc] init];
                obj.tableName = @"Patient Refusal";
                obj.desc = @"Signature";
                obj.key = 1000003;
                [missingInputIDs addObject:obj];
                refusalCount++;
            }
            
            if ([[g_SETTINGS objectForKey:@"WitnessSignatureRequiredOnRefusal"] isEqualToString:@"1"])
            {
                sqlStr = [NSString stringWithFormat:@"Select signaturetype from SignatureTypes where SignatureGroup = 'Witness'"];
                NSString* sigTypeStr;
                @synchronized(g_SYNCLOOKUPDB)
                {
                    sigTypeStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
                }
                sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (%@)", ticketID, sigTypeStr];
                NSInteger count;
                @synchronized(g_SYNCBLOBSDB)
                {
                    count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
                }
                if (count < 1)
                {
                    ClsTableKey* obj = [[ClsTableKey alloc] init];
                    obj.tableName = @"Witness Signature";
                    obj.desc = @"Signature";
                    obj.key = 1000004;
                    [missingInputIDs addObject:obj];
                    witnessCount++;
                }
            }
            
        }   // end refusal

        if  ([[g_SETTINGS objectForKey:@"MedicSignatureRequired"] isEqualToString:@"1"])
        {
            sqlStr = [NSString stringWithFormat:@"Select signaturetype from SignatureTypes where SignatureTypeDesc = 'In Charge Medic'"];
            NSString* sigTypeStr;
            @synchronized(g_SYNCLOOKUPDB)
            {
                sigTypeStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
            }
            sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (%@)", ticketID, sigTypeStr];
            NSInteger count;
            @synchronized(g_SYNCBLOBSDB)
            {
                count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
            }
            if (count < 1)
            {
                ClsTableKey* obj = [[ClsTableKey alloc] init];
                obj.tableName = @"Primary Medic Signature";
                obj.desc = @"Signature";
                obj.key = 1000005;
                [missingInputIDs addObject:obj];
                medic1Count++;
            }
        }  // end medic1
        
        if  ([[g_SETTINGS objectForKey:@"TwoMedicSigsRequired"] isEqualToString:@"1"])
        {
            sqlStr = [NSString stringWithFormat:@"Select signaturetype from SignatureTypes where SignatureTypeDesc = 'Secondary Medic'"];
            NSString* sigTypeStr;
            @synchronized(g_SYNCLOOKUPDB)
            {
                sigTypeStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
            }
            sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (%@)", ticketID, sigTypeStr];
            NSInteger count;
            @synchronized(g_SYNCBLOBSDB)
            {
                count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
            }
            if (count < 1)
            {
                ClsTableKey* obj = [[ClsTableKey alloc] init];
                obj.tableName = @"Secondary Medic Signature";
                obj.desc = @"Signature";
                obj.key = 1000006;
                [missingInputIDs addObject:obj];
                medic2Count++;
            }
        }  // end medic1
        
        
        NSString* vitalOnNonTrans = [g_SETTINGS objectForKey:@"RequireVitalsOnNonTransports"];
        if (![vitalOnNonTrans isEqualToString:@""])
        {
            if ([outcomeVal containsString:@"Patient Refused Transport"] ||  [outcomeVal containsString:@"Patient Transferred"] || [outcomeVal containsString:@"Treatment No Transport"] || [outcomeVal containsString:@"Guardian Refusal"])
            {
               vitalCount = [[g_SETTINGS objectForKey:@"RequireVitalsOnNonTransports"] integerValue];
            }
            else if ([outcomeVal containsString:@"Patient Transport"] || [outcomeVal containsString:@"Non Emergency Transfer"])
            {
                vitalCount = [[g_SETTINGS objectForKey:@"VitalSetsRequired"] integerValue];
            }
        }
        else
        {
            if ([outcomeVal containsString:@"Patient Transport"] || [outcomeVal containsString:@"Non Emergency Transfer"])
            {
                vitalCount = [[g_SETTINGS objectForKey:@"VitalSetsRequired"] integerValue];
            }
        }
        
        NSString* currentVitalCountStr = [NSString stringWithFormat:@"select count(*) from (Select * from ticketInputs where ticketID = %@ and inputID = 3001 and  ( (deleted is null)) UNION Select * from ticketInputs where ticketID = %@ and inputID = 3001 and deleted = 0) as temp1", ticketID, ticketID];
        NSInteger enteredVitalCount = 0;
        @synchronized(g_SYNCDATADB)
        {
            enteredVitalCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:currentVitalCountStr];
        }
        if (vitalCount > 0)
        {
            if (vitalCount > enteredVitalCount)
            {
                ClsTableKey* obj = [[ClsTableKey alloc] init];
                obj.tableName = [NSString stringWithFormat:@"%d Set of Vitals Needed", vitalCount - enteredVitalCount];
                obj.desc = @"Vitals";
                obj.key = 1000011;
                //  [missingInputIDs addObject:obj];
                [vitalArray addObject:obj];
                vitalCount = vitalCount - enteredVitalCount;
            }
            else
            {
                for (int i = 1; i <= enteredVitalCount; i++)
                {
                    NSString* result = [self checkVitals:i];
                    if (result.length > 0)
                    {
                        ClsTableKey* obj = [[ClsTableKey alloc] init];
                        obj.tableName = result;
                        obj.desc = [NSString stringWithFormat:@"%@", @"Vitals"];
                        obj.key = 1000011;
                        [vitalArray addObject:obj];
                    }
                    else
                    {
                        vitalCount--;
                    }
                }
            }
            
        }
        else
        {
            vitalCount = 0;
        }
        
        NSString* treatmentRequired = [g_SETTINGS objectForKey:@"TreatmentsRequired"];
        if ([treatmentRequired isEqualToString:@"1"])
        {
            if ([outcomeVal containsString:@"Patient Transport"] || [outcomeVal containsString:@"Non Emergency Transfer"])
            {
                treatmentNeeded = true;
            }
            else
            {
                treatmentNeeded = false;
            }
            
            if (treatmentNeeded)
            {
                NSString* treatmentSql = [NSString stringWithFormat:@"Select count(*) from (select * from ticketInputs where ticketID = %@ and inputID > 1999 and inputID < 3000 and inputSubID = 1 and Deleted is NULL Union select * from ticketInputs where ticketID = %@ and inputID > 1999 and inputID < 3000 and inputSubID = 1 and Deleted = 0) as temp1", ticketID, ticketID];
                NSInteger treatmentDone = 0;
                @synchronized(g_SYNCDATADB)
                {
                    treatmentDone = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:treatmentSql];
                }
                if (treatmentDone < 1)
                {
                    ClsTableKey* obj = [[ClsTableKey alloc] init];
                    obj.tableName = [NSString stringWithFormat:@"Treatment Needed"];
                    obj.desc = @"Treatments";
                    obj.key = 1000012;
                    //[missingInputIDs addObject:obj];
                    [treatmentArray addObject:obj];
                    treatmentCount = 1;
                }
                else
                {
                    NSString* treatmentSql = [NSString stringWithFormat:@"Select distinct * from ticketInputs where ticketID = %@ and inputID > 1999 and inputID < 3000 and inputSubID = 1 and ( Deleted is NULL) Union Select distinct * from ticketInputs where ticketID = %@ and inputID > 1999 and inputID < 3000 and inputSubID = 1 and ( Deleted = 0)", ticketID, ticketID];
                    NSMutableArray* treatmentArray1;
                    @synchronized(g_SYNCDATADB)
                    {
                        treatmentArray1 = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:treatmentSql];
                    }
                    
                    for (int i = 0; i < [treatmentArray1 count]; i++)
                    {
                        ClsTicketInputs* input = [treatmentArray1 objectAtIndex:i];
                        NSString* treamtemtRequiredSql = [NSString stringWithFormat:@"Select InputID, 'treatmentRequired', InputName from TreatmentInputs where TreatmentID = %d and active = 1 and inputRequired = 1", input.inputId];
                        NSMutableArray* requiredTreatmentArray;
                        @synchronized(g_LOOKUPDB)
                        {
                            requiredTreatmentArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:treamtemtRequiredSql WithExtraInfo:NO];
                        }
                        NSMutableString* msg = [[NSMutableString alloc] init];
                        bool displayStr = false;
                        for (int j = 0; j < [requiredTreatmentArray count]; j++)
                        {
                            ClsTableKey* key = [requiredTreatmentArray objectAtIndex:j];
                            NSString* treatmentEnteredSql = [NSString stringWithFormat:@"Select count(*) from ticketInputs where ticketID = %@ and InputID = %d and inputSubID = %d and (inputValue = '(null)' or inputValue is null or inputvalue = '' or InputValue = ' ')", ticketID, input.inputId, key.key];
                            NSInteger requiredDone;
                            @synchronized(g_SYNCDATADB)
                            {
                                requiredDone = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:treatmentEnteredSql];
                            }
                            if (requiredDone > 0)
                            {
                                [msg appendString:key.desc];
                                [msg appendString:@" "];
                                displayStr = true;
                            }
                        }
                        if (displayStr)
                        {
                            ClsTableKey* obj = [[ClsTableKey alloc] init];
                            obj.tableName = [NSString stringWithFormat:@"%@", input.inputPage ];
                            obj.desc = [NSString stringWithFormat:@"%@ ", msg];
                            obj.key = 1000012;
                            //[missingInputIDs addObject:obj];
                            [treatmentArray addObject:obj];
                            treatmentCount++;
                        }
                    }
                    
                }
            }
        }  // end if treatment == 1
        

        if ([outcomeVal isEqualToString:@"Patient Transported"])
        {
            NSString* assessmentRequired = [g_SETTINGS objectForKey:@"RequiredAssessmentCount"];
            if ([assessmentRequired intValue] > 0)
            {
                NSString* assSql = [NSString stringWithFormat:@"Select count(distinct inputInstance) from TicketInputs where TicketID = %@ and inputID = 1800 and (deleted is null or deleted = 0)", ticketID];
                NSInteger asscount;
                @synchronized(g_SYNCDATADB)
                {
                    asscount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:assSql];
                }
                assessmentNeeded = [assessmentRequired intValue] - asscount;
                if (assessmentNeeded > 0)
                {
                    ClsTableKey* obj = [[ClsTableKey alloc] init];
                    obj.tableName = [NSString stringWithFormat:@"%d Assessment Needed", assessmentNeeded];
                    obj.desc = [NSString stringWithFormat:@"%@", @"Assessment"];
                    obj.key = 1000013;
                   // [missingInputIDs addObject:obj];
                    [assessmentArray addObject:obj];
                }
                else
                {
                    for (int i = 1; i <= asscount; i++)
                    {
                        NSString* result = [self checkAssessment:i];
                        if (result.length > 0)
                        {
                            ClsTableKey* obj = [[ClsTableKey alloc] init];
                            obj.tableName = result;
                            obj.desc = [NSString stringWithFormat:@"%@", @"Assessment"];
                            obj.key = 1000013;
                            // [missingInputIDs addObject:obj];
                            [assessmentArray addObject:obj];
                            assessmentNeeded++;
                        }
                        
                    }

                }
                    
            }
        }
        
    }  // end if OutcomeVal.len > 0

    
    NSInteger extraCount = narcoticCount + signatureCount + hospitalCount + refusalCount + witnessCount + medic1Count + medic2Count + vitalCount + treatmentCount + assessmentNeeded;
    
    NSInteger total = [requiredIDArray count] + extraCount;
    
    lblComplete.text = [NSString stringWithFormat:@"%d/%d", total - ([incomplete count] + extraCount), total];
    
    float progress = (float)((total - ([incomplete count])+extraCount)/total);
    [progressView setProgress:progress animated:NO];
    
    if (([incomplete count] + extraCount) == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Required fields completed" message:@"All required data are entered. Would you like to finalize this ticket?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 0;
        [alert show];
        
    }
    
}

- (void) checkTreatments:(NSInteger) vitalCount
{
    NSMutableString* msg = [[NSMutableString alloc] init];
    NSMutableString* treatmentRequiredIds = [[NSMutableString alloc] init];
    NSMutableArray* tempTreatmentArray = [[NSMutableArray alloc] init];
    
    NSString* sql = [NSString stringWithFormat:@"Select * from TicketInputs where TicketID = %@ and InputID > 2000 and InputID < 2099 order by InputID, inputInstance, inputSubID", ticketID ];
    NSMutableArray* ticketInputsData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputsData = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSInteger inputID = 0;
    NSInteger prevInputID = 0;
    NSInteger prevInputInstance = 0;
    ClsTreatments* loadTreatment;
    for (int i = 0; i< [ticketInputsData count]; i++)
    {
        ClsTicketInputs* ticketInput = (ClsTicketInputs*) [ticketInputsData objectAtIndex:i];
        inputID = ticketInput.inputId;
        if ((inputID != prevInputID) || ( ticketInput.inputInstance != prevInputInstance) )
        {
            if (prevInputID != 0)
            {
                [tempTreatmentArray addObject:loadTreatment];
            }
            loadTreatment = [[ClsTreatments alloc] init];
            loadTreatment.treatmentID = ticketInput.inputId;
            loadTreatment.treatmentDesc = ticketInput.inputPage;
            if (ticketInput.inputSubId == 1)
            {
                loadTreatment.treatmentTime = ticketInput.inputValue;
            }
            
            prevInputID = inputID;
            prevInputInstance = ticketInput.inputInstance;
            loadTreatment.arrayTreatmentInputValues = [[NSMutableArray alloc] init];
            ClsTreatmentInputs *input = [[ClsTreatmentInputs alloc ] init];
            input.inputID = ticketInput.inputSubId;
            input.inputName = ticketInput.inputName;
            input.inputValue = ticketInput.inputValue;
            [loadTreatment.arrayTreatmentInputValues addObject:input];
        }
        else
        {
            ClsTreatmentInputs *input = [[ClsTreatmentInputs alloc ] init];
            input.inputID = ticketInput.inputSubId;
            input.inputName = ticketInput.inputName;
            input.inputValue = ticketInput.inputValue;
            [loadTreatment.arrayTreatmentInputValues addObject:input];
        }
        
        
    }
    
    if ([ticketInputsData count] > 1)
    {
        [tempTreatmentArray addObject:loadTreatment];
    }
    
    for (int i=0; i < tempTreatmentArray.count; i++)
    {
        NSMutableString* msg = [[NSMutableString alloc] init];
        ClsTreatments* treatment = [tempTreatmentArray objectAtIndex:i];
        NSString* entryRequiredSql = [NSString stringWithFormat:@"Select * from treatmentInputs where treatmentID = %d and inputRequired = 1 and active = 1", treatment.treatmentID];
    
        NSMutableArray* requiredArray;
        @synchronized(g_SYNCDATADB)
        {
            requiredArray = [DAO executeSelectTreatmentInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:entryRequiredSql];
        }
        
        
        for (int j = 0; j < requiredArray.count; j++)
        {
            ClsTreatmentInputs* treatmentInputs = [requiredArray objectAtIndex:j];
            NSString* inputValidSql = [NSString stringWithFormat:@"Select inputID from ticketInputs where ticketID = %@ and inputID in (%@) and inputSubID = %d and (deleted is null or deleted = 0) and (inputValue == '(null)' or inputValue is null or inputvalue = '' or InputValue = ' ')", ticketID, treatment.treatmentID, treatmentInputs.inputID];
            NSString *requiredTreatmentFieldNotEntered;
            @synchronized(g_SYNCDATADB)
            {
                requiredTreatmentFieldNotEntered = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:inputValidSql];
            }
            if (requiredTreatmentFieldNotEntered.length > 0)
            {
                [msg appendString:treatmentInputs.inputName];
                [msg appendString:@" "];
            }
            
        }
        [treatmentArray addObject:msg];
        
    }
    
    


    
}

- (NSMutableString*) checkVitals:(NSInteger) vitalCount
{
    NSMutableString* msg = [[NSMutableString alloc] init];
    NSMutableString* vitalsRequiredIds = [[NSMutableString alloc] init];
    NSString* vitalRequiredSql = @"Select inputID from vitals where vitalRequired = 1";
    NSString* vitalsRequiredStr;
    @synchronized(g_LOOKUPDB)
    {
        vitalsRequiredStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:vitalRequiredSql];
    }
    [vitalsRequiredIds appendString:vitalsRequiredStr];
    
    NSString* vitalsEntrySql = [NSString stringWithFormat:@"Select inputID from ticketInputs where ticketID = %@ and inputInstance = %d and inputID in (%@) and (deleted is null or deleted = 0) and (inputValue == '(null)' or inputValue is null or inputvalue = '' or InputValue = ' ')", ticketID, vitalCount, vitalsRequiredIds];
    NSString *requiredVitalNotPerformed;
    @synchronized(g_SYNCDATADB)
    {
        requiredVitalNotPerformed = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:vitalsEntrySql];
    }
    
    
    if (requiredVitalNotPerformed.length > 1)
    {
        
        NSArray* requiredVitalArray =  [requiredVitalNotPerformed componentsSeparatedByString:@","];
        NSString* inputID;
        for (inputID in requiredVitalArray)
        {
            if ([inputID isEqualToString:@"3001"])
            {
                [msg appendString:@"Vital Time "];
            }
            else if ([inputID isEqualToString:@"3002"])
            {
                [msg appendString:@"Systolic BP "];
            }
            else if ([inputID isEqualToString:@"3003"])
            {
                [msg appendString:@"Diastolic BP "];
            }
            else if ([inputID isEqualToString:@"3004"])
            {
                [msg appendString:@"Heart Rate "];
            }
            else if ([inputID isEqualToString:@"3005"])
            {
                [msg appendString:@"Resp Rate "];
            }
            else if ([inputID isEqualToString:@"3006"])
            {
                [msg appendString:@"SPO2% "];
                
            }
            else if ([inputID isEqualToString:@"3018"])
            {
                [msg appendString:@"GCS Eyes "];
            }
            else if ([inputID isEqualToString:@"3019"])
            {
                [msg appendString:@"GCS Verbal "];
            }
            else if ([inputID isEqualToString:@"3020"])
            {
                [msg appendString:@"GCS Motor "];
            }
            else if ([inputID isEqualToString:@"3011"])
            {
                [msg appendString:@"GCS Total "];
            }

        }
    }
    
    
    return msg;
    
    
}


- (NSMutableString*) checkAssessment:(NSInteger) assCount
{
    NSMutableString* msg = [[NSMutableString alloc] init];
    NSString* outcomeVal;
    NSString* sqlOutcome = [NSString stringWithFormat:@"select InputValue from TicketInputs where ticketID = %@ and InputID = 1401", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        outcomeVal = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlOutcome];
    }
    
    NSString* sql;
    if ([outcomeVal length] > 0 && ([outcomeVal rangeOfString:@"(null)"].location == NSNotFound))
    {
        if ([outcomeVal isEqualToString:@"Patient Transported"])
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from Inputs where InputRequiredField = 1 and inputpage like 'MultiAssessment%%' union select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 1" , outcomeVal];
            
        }
        else if ( ([outcomeVal rangeOfString:@"Guardian Refusal"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 2" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"Patient Transferred"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 3" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"Disregarded"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 4" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"No Patient Contact"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 5" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"False Alarm"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 7" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"DOA"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 9" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"Treatment No Transport"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 10" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"Patient Tranferred to other Service"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 11" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"Did not Perform Medical Care"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 12" , outcomeVal];
        }
        else
        {
            sql = @"SELECT distinct i.inputid, i.inputname, i.inputpage FROM inputs i where i.inputrequiredfield = 1 and i.inputpage like 'Personal%'";
        }
        
    }
    else
    {
        sql = @"SELECT distinct i.inputid, i.inputname, i.inputpage FROM inputs i where i.inputrequiredfield = 1 and i.inputpage like 'MultiAssessment%'";
    }
    NSMutableArray* requiredArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        requiredArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }

    
    NSMutableString* assessmentMsg = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [requiredArray count]; i++)
    {
        ClsTableKey* key = [requiredArray objectAtIndex:i];
        if (key.key == 1801)
        {
            [assessmentMsg appendString:@"1801,"];
        }
        else if (key.key == 1802)
        {
            [assessmentMsg appendString:@"1802,"];
        }
        else if (key.key == 1803)
        {
            [assessmentMsg appendString:@"1803,"];
        }
        else if (key.key == 1804)
        {
            [assessmentMsg appendString:@"1804,"];
        }
        else if (key.key == 1805)
        {
            [assessmentMsg appendString:@"1805,"];
        }
        else if (key.key == 1806)
        {
            [assessmentMsg appendString:@"1806,"];
        }
        else if (key.key == 1807)
        {
            [assessmentMsg appendString:@"1807,"];
        }
        else if (key.key == 1808)
        {
            [assessmentMsg appendString:@"1808,"];
        }
        else if (key.key == 1809)
        {
            [assessmentMsg appendString:@"1809,"];
        }
        else if (key.key == 1810)
        {
            [assessmentMsg appendString:@"1810,"];
        }
        else if (key.key == 1811)
        {
            [assessmentMsg appendString:@"1811,"];
        }
        else if (key.key == 1812)
        {
            [assessmentMsg appendString:@"1812,"];
        }
        else if (key.key == 1813)
        {
            [assessmentMsg appendString:@"1813,"];
        }
        else if (key.key == 1814)
        {
            [assessmentMsg appendString:@"1814,"];
        }
        else if (key.key == 1815)
        {
            [assessmentMsg appendString:@"1815,"];
        }
        else if (key.key == 1816)
        {
            [assessmentMsg appendString:@"1816,"];
        }
        else if (key.key == 1817)
        {
            [assessmentMsg appendString:@"1817,"];
        }
        else if (key.key == 1818)
        {
            [assessmentMsg appendString:@"1818,"];
        }
        else if (key.key == 1819)
        {
            [assessmentMsg appendString:@"1819,"];
        }
        else if (key.key == 1820)
        {
            [assessmentMsg appendString:@"1820,"];
        }
        else if (key.key == 1821)
        {
            [assessmentMsg appendString:@"1821,"];
        }
    }
    
    NSString* assessmentStr;
    if (assessmentMsg.length > 1)
    {

        assessmentStr = [assessmentMsg substringToIndex:[assessmentMsg length] - 1];

    }
    

        NSString* assentrySql = [NSString stringWithFormat:@"Select inputID from ticketInputs where ticketID = %@ and inputID in (%@) and inputInstance = %d and (deleted is null or deleted = 0) and (inputValue == '(null)' or inputValue is null or inputvalue = '' or inputValue = ' ')", ticketID, assessmentStr, assCount];
        NSString *requiredAssStr;
        @synchronized(g_SYNCDATADB)
        {
            requiredAssStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:assentrySql];
        }
        

        if (requiredAssStr.length > 1)
        {
            
            NSArray* requiredAssessmentArray =  [requiredAssStr componentsSeparatedByString:@","];
            NSString* inputID;
            for (inputID in requiredAssessmentArray)
            {
                if ([inputID isEqualToString:@"1801"])
                {
                    [msg appendString:@"Skin "];
                }
                else if ([inputID isEqualToString:@"1802"])
                {
                    [msg appendString:@"Head/Face "];
                }
                else if ([inputID isEqualToString:@"1803"])
                {
                    [msg appendString:@"Neck "];
                }
                else if ([inputID isEqualToString:@"1804"])
                {
                    [msg appendString:@"Chest/Lungs "];
                }
                else if ([inputID isEqualToString:@"1805"])
                {
                    [msg appendString:@"Heart "];
                }
                else if ([inputID isEqualToString:@"1806"])
                {
                    [msg appendString:@"LU Abdomen "];
                }
                
                else if ([inputID isEqualToString:@"1807"])
                {
                    [msg appendString:@"LL Abdomen "];
                }
                else if ([inputID isEqualToString:@"1808"])
                {
                    [msg appendString:@"RU Abdomen "];
                }
                
                else if ([inputID isEqualToString:@"1809"])
                {
                    [msg appendString:@"RL Abdomen "];
                }
                else if ([inputID isEqualToString:@"1810"])
                {
                    [msg appendString:@"GU "];
                }
                
                else if ([inputID isEqualToString:@"1811"])
                {
                    [msg appendString:@"Back Cervical "];
                }
                else if ([inputID isEqualToString:@"1812"])
                {
                    [msg appendString:@"Back Thoracic "];
                }
                
                else if ([inputID isEqualToString:@"1813"])
                {
                    [msg appendString:@"Back Lumbar/Sacral "];
                }
                else if ([inputID isEqualToString:@"1814"])
                {
                    [msg appendString:@"RU Extremities "];
                }
                else if ([inputID isEqualToString:@"1815"])
                {
                    [msg appendString:@"RL Extremities "];
                }
                else if ([inputID isEqualToString:@"1816"])
                {
                    [msg appendString:@"LU Extremities "];
                }
                else if ([inputID isEqualToString:@"1817"])
                {
                    [msg appendString:@"LL Extremities "];
                }
                else if ([inputID isEqualToString:@"1818"])
                {
                    [msg appendString:@"Left Eye "];
                }
                else if ([inputID isEqualToString:@"1819"])
                {
                    [msg appendString:@"Right Eye "];
                }
                else if ([inputID isEqualToString:@"1820"])
                {
                    [msg appendString:@"Mental Status "];
                }
                
                else if ([inputID isEqualToString:@"1821"])
                {
                    [msg appendString:@"Neurological "];
                }
            }
        }


    return msg;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            @synchronized(g_SYNCDATADB)
            {
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
               
                //TicketStatus = 2 added
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE Tickets Set TicketFinalized = 1, TicketDateFinalized = '%@', isUploaded = 0, TicketStatus = 2  where TicketID = %@", dateString, ticketID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
              //  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ticket Finalized" message:@"Ticket has been finalized." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
              //  [alert show];
                ticketComplete = true;
                tagID = -1;
                [delegate doneSelectValidate];
            }
        } else
        {
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Required Inputs";
    }
    else if (section == 1)
    {
        return @"Required Assessments";
    }
    else if (section == 2)
    {
        return @"Required Vitals";
    }
    else
    {
        return @"Required Treatments";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return missingInputIDs.count;
    }
    else if (section == 1)
    {
        return assessmentArray.count;
    }
    else if (section == 2)
    {
        return vitalArray.count;
    }
    else
    {
        return treatmentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RequiredField *cell = (RequiredField *)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RequireField" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.section == 0)
    {
        ClsTableKey* obj = [missingInputIDs objectAtIndex:indexPath.row];
        cell.lblField.text = obj.tableName;
        cell.lblPage.text = obj.desc;
        cell.tag = obj.key;
    }
    else if (indexPath.section == 1)
    {
        ClsTableKey* obj = [assessmentArray objectAtIndex:indexPath.row];
        cell.lblField.text = obj.tableName;
        cell.lblPage.text = obj.desc;
        cell.tag = obj.key;
    }
    else if (indexPath.section == 2)
    {
        ClsTableKey* obj = [vitalArray objectAtIndex:indexPath.row];
        cell.lblField.text = obj.tableName;
        cell.lblPage.text = obj.desc;
        cell.tag = obj.key;
    }
    else
    {
        ClsTableKey* obj = [treatmentArray objectAtIndex:indexPath.row];
        cell.lblField.text = obj.tableName;
        cell.lblPage.text = obj.desc;
        cell.tag = obj.key;
    }
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequiredField *cell = (RequiredField*)[tableView1 cellForRowAtIndexPath:indexPath];
    
  /*  NSInteger tag = cell.tag;

    if ( (tag > 1000 && tag <= 1007) || tag == 1050 || tag == 1401) // scene
    {
        tagID = 0;
    }
    else if ( (tag >= 1060 && tag <= 1061)  ||  (tag >= 1040 && tag <= 1046) || (tag >= 1550  && tag <= 1554))
    {  // call times
        tagID = 1;
    }
    else if ( (tag >= 1101 && tag <= 1119) || (tag >= 1130 && tag <= 1135)) {  // Patient
        tagID = 2;
    }
    else if ( tag == 1008 || tag == 1010 || tag == 1013) { // chief complaint
        tagID = 3;
    }
    else if ( (tag >= 1801 && tag <= 1821) || tag == 1239 || tag == 1000013 ) {   // assessment
        tagID = 4;
    }
    else if ( tag >= 2001 && tag <= 2099) {  //treatment
        tagID = 6;
    }
    else if ( (tag >= 1601 && tag <= 1614) || (tag == 21211) || (tag == 21219)  ) {   // hist
        tagID = 7;
    }
    else if ( tag == 1433 ) {  // med
        tagID = 8;
    }
    
    else if ( tag == 1430 ) {   //narrative
        tagID = 14;
    }
    else if ( tag == 1228 || tag == 1029 || tag == 1031 || (tag >= 1402 && tag <= 1429) || (tag >= 22011 && tag <= 22014) || (tag >= 22201 && tag <= 22204) ) {   //outcome
        tagID = 15;
    }
    else if ( (tag >= 1000001 && tag <= 1000006) || (tag == 1000040))  // signature
    {
        tagID = 17;
    }
    else if (tag == 1000000)  // narcotic
    {
        tagID = 20;
    }

    else if (tag == 1000011)  // vital
    {
        tagID = 5;
    }
    else if (tag == 1000012)
    {
        tagID = 3;
    }  */
    
    if ([cell.lblPage.text isEqualToString:@"Incident"])
    {
         tagID = 0;
    }
    else  if ([cell.lblPage.text isEqualToString:@"Call Times"] || [cell.lblPage.text isEqualToString:@"NFIRS"])
    {
         tagID = 1;
    }
    else if ([cell.lblPage.text isEqualToString:@"Personal"])
    {
        tagID = 2;
    }
    else if ([cell.lblPage.text isEqualToString:@"Chief Complaint"] || [cell.lblPage.text isEqualToString:@"Impression"] )
    {
        tagID = 3;
    }
    else if ([cell.lblPage.text isEqualToString:@"MultiAssessment"] || [cell.lblPage.text isEqualToString:@"Assessment"])
    {
        tagID = 4;
    }
    else if ([cell.lblPage.text isEqualToString:@"Vitals"] )
    {
        tagID = 5;
    }
    else if ([cell.lblPage.text isEqualToString:@"Treatments"] || [cell.lblField.text isEqualToString:@"Treatments"])
    {
        tagID = 6;
    }
    else if ([cell.lblPage.text isEqualToString:@"History"] )
    {
        tagID = 7;
    }
    else if ([cell.lblPage.text isEqualToString:@"Meds"] )
    {
        tagID = 8;
    }
    else if ([cell.lblPage.text isEqualToString:@"Allergies"] )
    {
        tagID = 9;
    }
    else if ([cell.lblPage.text isEqualToString:@"Symptoms"] )
    {
        tagID = 10;
    }
    else if ([cell.lblPage.text isEqualToString:@"OPQRST"] )
    {
        tagID = 11;
    }
    else if ([cell.lblPage.text isEqualToString:@"Injury"] )
    {
        tagID = 12;
    }
    else if ([cell.lblPage.text isEqualToString:@"MVC"] )
    {
        tagID = 12;
    }
    else if ([cell.lblPage.text isEqualToString:@"Comments"] )
    {
        tagID = 14;
    }
    else if ([cell.lblPage.text isEqualToString:@"Outcome"] )
    {
        tagID = 15;
    }
    else if ([cell.lblPage.text isEqualToString:@"Insurance"] )
    {
        tagID = 16;
    }
    else if ([cell.lblPage.text isEqualToString:@"Signature"] )
    {
        tagID = 17;
    }
    else if ([cell.lblPage.text isEqualToString:@"Protocols"] )
    {
        tagID = 18;
    }
    else if ([cell.lblPage.text isEqualToString:@"CPR"] )
    {
        tagID = 19;
    }
    else if ([cell.lblPage.text isEqualToString:@"Narcotic"] )
    {
        tagID = 20;
    }
    [delegate doneSelectValidate];
}


- (IBAction)btnCancelClick:(id)sender {
    tagID = -1;
    [delegate doneSelectValidate];
}
@end
