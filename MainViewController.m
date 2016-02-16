//  MainViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "ServiceSvc.h"
#import "global.h"
#import "DAO.h"
#import "ClsChangeQue.h"
#import "TicketDataInfoCell.h"
#import "ClsTickets.h"
#import "ClsTicketInputs.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LoginViewController.h"
#import "PopoverViewController.h"
#import "DDPopoverBackgroundView.h"
#import "WebViewController.h"
#import "ClsTicketAttachments.h"
#import "ClsTicketSignatures.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "ClsTicketFormsInputs.h"
#import "CheckConnection.h"
#import "QAMessageViewController.h"
#import "ClsTicketNotes.h"
#import "ClsTicketChanges.h"
#import "ClsCadData.h"


@interface MainViewController ()
{
    NSInteger stopTimer;
    NSInteger backupStart;
    NSInteger mergeRowSelected;
    bool receiveWarning;
    bool logoutStatus;
    NSMutableArray* unitsArray;
}
@property (strong, nonatomic) ClsCadData* cadData;
@property (nonatomic, retain) NSTimer* g_BACKUPTIMER;
@property (strong, nonatomic) NSMutableArray* ticketIncident;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@end

@implementation MainViewController
@synthesize mapview;
@synthesize _sender;
@synthesize ticketData;
@synthesize btnSegmentedControl;

@synthesize toolBar1;
@synthesize btnShowPractice;
@synthesize popover;
@synthesize btnReview;
@synthesize btnIncomplete;
@synthesize btnComplete;
@synthesize btnAll;
@synthesize cadData;
@synthesize ticketIncident;
@synthesize backgroundTask;

#define kHELP_PHONENUMBER 8009215300

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
    receiveWarning = false;
    showPractice = YES;
    logoutStatus = false;
    transfer = false;
    self.backgroundTask = UIBackgroundTaskInvalid;
    g_SYNCDATADB = [[NSObject alloc] init];
    g_SYNCLOOKUPDB = [[NSObject alloc] init];
    g_SYNCBLOBSDB = [[NSObject alloc] init];
    unitsArray = [DAO loadUnits:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Filter:@""];
    NSString* machineCheck = [g_SETTINGS objectForKey:@"MachineID"];
    if (![machineCheck isEqualToString:@"LOCAL"])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"Downloading data";
        hud.detailsLabelText = @"Please wait...";
        hud.mode = MBProgressHUDAnimationFade;
        [self.view addSubview:hud];
        [hud showWhileExecuting:@selector(downloadData) onTarget:self withObject:Nil animated:YES];
        self.g_BACKUPTIMER = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(runBackupProcess) userInfo:nil repeats:YES];
        g_CLEANUP = [NSTimer scheduledTimerWithTimeInterval: 86400 target:self selector:@selector(runCleanup) userInfo:nil repeats:YES];
        stopTimer = 0;
        backupStart = 0;
    }
    else
    {
        [self cleanupData];
    }
	// Do any additional setup after loading the view.
    reloadData = NO;
    syncQueueDB = [[NSObject alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResign) name:UIApplicationWillResignActiveNotification object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillBecomeActive) name:UIApplicationDidBecomeActiveNotification object:NULL];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate startUpdatingLoaction];
    mapTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(runMapLocator) userInfo:nil repeats:NO];
    
    [self setViewUI];
    
}


-(void) downloadData
{
    if (CheckConnection.hasConnectivity)
    {
        backupStart = 1;

        [self DownloadTicketInfo];
        [self DownloadTicketInputsInfo];
        [self DownloadTicketAttachmentsInfo];
        [self DownloadTicketSignaturesInfo];
        [self DownloadNotes];
        [self downloadTicketFormsInputs];
        
        [self DownloadIncompleteTicketInfo];
        [self DownloadIncompleteTicketInputsInfo];
        [self DownloadIncompleteTicketAttachmentsInfo];
        [self DownloadIncompleteTicketSignaturesInfo];
        [self DownloadIncompleteNotes];
        [self downloadIncompleteTicketFormsInputs];
        [self downloadIncompleteTicketChanges];
        
        NSString* unit = [g_SETTINGS objectForKey:@"Unit"];
        NSString* sql = [NSString stringWithFormat:@"Select DISTINCT T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount , TI.InputValue as TicketAdminNotes from Tickets T Left join TicketInputs TI on T.TicketID = TI.TicketID and TI.InputID = 1003 WHERE t.TicketOwner = %@ or (t.ticketUnitNumber = %@ and t.ticketStatus = 4) order by T.LocalTicketID desc", [g_SETTINGS objectForKey:@"UserID"], unit];
        
        //[g_SETTINGS objectForKey:@"UserID"]
        
        @synchronized(g_SYNCDATADB)
        {
            self.ticketData = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }

        transfer = false;
        backupStart = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView reloadData];
            
        });
    }
}

- (void) downloadTicketFormsInputs
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetReviewTransferTicketForms *req = [[ServiceSvc_GetReviewTransferTicketForms alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetReviewTransferTicketFormsUsingParameters:req];
            
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetReviewTransferTicketFormsResponse class]])
                {
                    ServiceSvc_ArrayOfClsTicketFormsInputs* resultArray = [mine GetReviewTransferTicketFormsResult];
                    NSMutableArray* array = [resultArray ClsTicketFormsInputs];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTicketFormsInputs* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* FormID = [record valueForKey:@"FormID"];
                        NSString* FormInputID = [record valueForKey:@"InputSubID"];
  
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FormID = %@ and FormInputID = %@", TicketID , FormID, FormInputID];
                        
                        NSInteger count;
                        @synchronized(g_SYNCDATADB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* FormInputValue = [self removeNull:[record valueForKey:@"FormInputValue"]];

                            NSString* Deleted = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Deleted"]]];
                            NSString* Modified = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Modified"]]];
                            
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, Deleted, Modified, IsUploaded) Values(0, %@, %@, %@,'%@', %@, %@, 1)", TicketID, FormID, FormInputID, FormInputValue, Deleted, Modified];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            
        }
    }
}


- (void) DownloadNotes
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetReviewTransferTicketNotes *req = [[ServiceSvc_GetReviewTransferTicketNotes alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetReviewTransferTicketNotesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetReviewTransferTicketNotesResponse class]])
                {
                    ServiceSvc_ArrayOfClsTicketNotes* resultArray = [mine GetReviewTransferTicketNotesResult];
                    NSMutableArray* array = [resultArray ClsTicketNotes];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTicketNotes* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* NoteUID = [record valueForKey:@"NoteUID"];
                        
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketNotes where TicketID = %@ and NoteUID = %@", TicketID , NoteUID];
                        
                        NSInteger count;
                        @synchronized(g_SYNCDATADB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* Note = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Note"]]];

                            NSString* NoteTime = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"NoteTime"]]];
//                            NSString* Deleted = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Deleted"]]];
                            
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into TicketNotes(LocalTicketID, TicketID, NoteUID, Note, NoteTime, IsUploaded) Values(0, %@, %@, '%@', '%@', 1)", TicketID, NoteUID, Note, NoteTime];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            
        }
    }
}


- (void) DownloadTicketInfo
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {

            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetReviewTransferTickets *req = [[ServiceSvc_GetReviewTransferTickets alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetReviewTransferTicketsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetReviewTransferTicketsResponse class]])
                {
                    ServiceSvc_ArrayOfClsTickets* resultArray = [mine GetReviewTransferTicketsResult];
                    NSMutableArray* array = [resultArray ClsTickets];

                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTickets* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from Tickets where TicketID = %@", TicketID ];
                        
                        NSInteger count;
                        @synchronized(g_SYNCDATADB)
                        {
                             count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* TicketGUID = [record valueForKey:@"TicketGUID"];
                            NSString* TicketIncidentNumber = [record valueForKey:@"TicketIncidentNumber"];
                            NSString* TicketDesc = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketDesc"]]];
                            NSString* TicketDOS = [self removeNull:[record valueForKey:@"TicketDOS"]];
                            NSString* TicketStatus = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketStatus"]]];
                            NSString* TicketOwner = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketOwner"]]];
                            NSString* TicketCreator = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketCreator"]]];
                            NSString* TicketUnitNumber = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketUnitNumber"]]];
                            NSString* TicketFinalized = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketFinalized"]]];
                            NSString* TicketDateFinalized = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketDateFinalized"]]];
                            NSString* TicketCrew = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketCrew"]]];
                            NSString* TicketPractice = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketPractice"]]];
                            NSString* TicketCreatedTime = [self removeNull:[record valueForKey:@"TicketCreatedTime"]];
                            NSString* TicketShift = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketShift"]]];
                            NSString* TicketLocked = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketLocked"]]];
                            NSString* TicketReviewed = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketReviewed"]]];
                            NSString* TicketAccount = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketAccount"]]];
                            NSString* TicketAdminNotes = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketAdminNotes"]]];
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into Tickets(TicketID, TicketGUID, TicketIncidentNumber, TicketDesc, TicketDOS, TicketStatus, TicketOwner, TicketCreator, TicketUnitNumber, TicketFinalized, TicketDateFinalized, TicketCrew, TicketPractice, TicketCreatedTime, TicketShift, TicketLocked, TicketReviewed, TicketAccount, TicketAdminNotes, IsUploaded) Values(%@, '%@', '%@','%@', '%@', %@, %@, %@, %@, %@, '%@', '%@', %@, '%@', %@, %@, %@, %@, '%@', 1)", TicketID, TicketGUID, TicketIncidentNumber, TicketDesc, TicketDOS, TicketStatus, TicketOwner, TicketCreator, TicketUnitNumber, TicketFinalized, TicketDateFinalized, TicketCrew, TicketPractice, TicketCreatedTime, TicketShift, TicketLocked, TicketReviewed, TicketAccount, TicketAdminNotes];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                        else
                        {
                            NSString* TicketPractice = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketPractice"]]];

                            NSString* TicketShift = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketShift"]]];
                            NSString* TicketLocked = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketLocked"]]];
                            NSString* TicketReviewed = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketReviewed"]]];
                            NSString* TicketAccount = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketAccount"]]];
                            NSString* TicketAdminNotes = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketAdminNotes"]]];
                             NSString* TicketStatus = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketStatus"]]];
                            
                            NSString* sql = [NSString stringWithFormat:@"Update Tickets set TicketPractice = %@, TicketShift = %@, TicketLocked = %@, TicketReviewed = %@, TicketAdminNotes = '%@', TicketAccount = %@, TicketStatus = %@ where ticketID = %@", TicketPractice, TicketShift, TicketLocked, TicketReviewed, TicketAdminNotes, TicketAccount, TicketStatus, TicketID];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {

        }
    }
}

- (void) DownloadTicketInputsInfo
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetReviewTransferTicketInputs *req = [[ServiceSvc_GetReviewTransferTicketInputs alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetReviewTransferTicketInputsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetReviewTransferTicketInputsResponse class]])
                {
                    ServiceSvc_ArrayOfClsTicketInputs* resultArray = [mine GetReviewTransferTicketInputsResult];
                    NSMutableArray* array = [resultArray ClsTicketInputs];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTicketInputs* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* InputID = [record valueForKey:@"InputID"];
                        NSString* InputSubID = [record valueForKey:@"InputSubID"];
                        NSString* InputInstance = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputInstance"]]];
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = %@ and InputSubID = %@ and InputInstance = %@", TicketID , InputID, InputSubID, InputInstance];
                        
                        NSInteger count;
                        @synchronized(g_SYNCDATADB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* InputPage = [self removeNull:[record valueForKey:@"InputPage"]];
                            NSString* InputName = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputName"]]];
                            NSString* InputValue = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputValue"]]];
                            NSString* Deleted = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Deleted"]]];
                            NSString* Modified = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Modified"]]];
                          
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, Deleted, Modified, IsUploaded) Values(0, %@, %@, %@, %@, '%@', '%@', '%@', %@, %@, 1)", TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, Deleted, Modified];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {

        }
    }
}


- (void) DownloadTicketAttachmentsInfo
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetReviewTransferTicketAttachments *req = [[ServiceSvc_GetReviewTransferTicketAttachments alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetReviewTransferTicketAttachmentsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetReviewTransferTicketAttachmentsResponse class]])
                {
                    ServiceSvc_ArrayOfClsTicketAttachments* resultArray = [mine GetReviewTransferTicketAttachmentsResult];
                    NSMutableArray* array = [resultArray ClsTicketAttachments];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTicketAttachments* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* AttachmentID = [record valueForKey:@"AttachmentID"];
                        
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketAttachments where TicketID = %@ and AttachmentID = %@", TicketID , AttachmentID];
                        
                        NSInteger count;
                        @synchronized(g_SYNCBLOBSDB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* FileType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"FileType"]]];
                            NSString* FileStr = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"FileStr"]]];
                            NSString* FileName = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"FileName"]]];
                            NSString* TimeAdded = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TimeAdded"]]];
                            NSString* Deleted = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Deleted"]]];
                            
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into TicketAttachments(LocalTicketID, TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded, Deleted, IsUploaded) Values(0, %@, %@, '%@', '%@', '%@', '%@', %@, 1)", TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded, Deleted];
                            @synchronized(g_SYNCBLOBSDB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            
        }
    }
}


- (void) DownloadTicketSignaturesInfo
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetReviewTransferTicketSignatures *req = [[ServiceSvc_GetReviewTransferTicketSignatures alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetReviewTransferTicketSignaturesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetReviewTransferTicketSignaturesResponse class]])
                {
                    ServiceSvc_ArrayOfClsTicketSignatures* resultArray = [mine GetReviewTransferTicketSignaturesResult];
                    NSMutableArray* array = [resultArray ClsTicketSignatures];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTicketSignatures* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* SignatureID = [record valueForKey:@"SignatureID"];
                        
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketSignatures where TicketID = %@ and SignatureID = %@", TicketID , SignatureID];
                        
                        NSInteger count;
                        @synchronized(g_SYNCBLOBSDB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* SignatureType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SignatureType"]]];
                            NSString* SignatureText = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SignatureText"]]];
                            NSString* SignatureString = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SignatureString"]]];
                            NSString* SignatureTime = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SignatureTime"]]];
                            NSString* Deleted = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Deleted"]]];
                            
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into TicketSignatures(LocalTicketID, TicketID, SignatureID, SignatureType, SignatureText, SignatureString, SignatureTime, Deleted, IsUploaded) Values(0, %@, %@, %@, '%@', '%@', '%@', %@, 1)", TicketID, SignatureID, SignatureType, SignatureText, SignatureString, SignatureTime, Deleted];
                            @synchronized(g_SYNCBLOBSDB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
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

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    ticketRowSelected = -1;
    [self refreshView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     btnAll.titleLabel.font  = [UIFont boldSystemFontOfSize:15.0];
    

}

- (void) refreshView
{
    
    NSString* unit = [g_SETTINGS objectForKey:@"Unit"];
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount , TI.InputValue, TI.InputName as TicketAdminNotes from Tickets T left join TicketInputs TI on T.TicketID = TI.TicketID and TI.INPUTID = 1003 WHERE t.TicketOwner = %@ or (t.ticketUnitNumber = %@ and t.ticketStatus = 4) order by TicketCreatedTime DESC, t.ticketID DESC", [g_SETTINGS objectForKey:@"UserID"], unit];

    
    @synchronized(g_SYNCDATADB)
    {
        self.ticketData = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    [self.mainTableView reloadData];
}


-(void) runMapLocator
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MKCoordinateRegion region;
    
    region.center.latitude = appdelegate.dblCurrentLatitude;
    region.center.longitude =  appdelegate.dblCurrentLongitude;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.0009;
    span.longitudeDelta = 0.0009;
    region.span = span;
    
    [mapview setRegion:region animated:YES];
}


- (void) applicationWillResign
{
    receiveWarning = true;
    NSLog(@"About to sleep");
    if (backupStart == 0)
     {
         backupStart = 1;
         NSLog(@"Shutdown Timer 1");
       //  [self.g_BACKUPTIMER invalidate];
       //  self.g_BACKUPTIMER = nil;
     }
}

- (void) applicationWillBecomeActive
{
    backupStart = 0;
    receiveWarning = false;
    NSLog(@"About to Awake");
    stopTimer = 0;
    self.g_BACKUPTIMER = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(runBackupProcess) userInfo:nil repeats:YES];
}


-(void)runBackupProcess
{
    if ((receiveWarning == false) && (backupStart == 0) && !(logoutStatus))
    {
        if (CheckConnection.hasConnectivity)
        {
            self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                NSLog(@"Shutdown Timer 2");
               // [self.g_BACKUPTIMER invalidate];
              //  self.g_BACKUPTIMER = nil;
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
                self.backgroundTask = UIBackgroundTaskInvalid;
            }];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [self uploadBackupData];
                if (receiveWarning)
                {
                    NSLog(@"Shutdown Timer");
                 //   [self.g_BACKUPTIMER invalidate];
                 //   self.g_BACKUPTIMER = nil;
                }
                
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
                
                self.backgroundTask = UIBackgroundTaskInvalid;
                
            });
            // [NSThread detachNewThreadSelector: @selector(uploadBackupData) toTarget:self withObject:nil];
        }
        else
        {
            NSLog(@"No Network connection detected.");

        }
    }
    else
    {
            NSLog(@"received shutdown notif or busy running back up.");
    }
}

-(void)runCleanup
{
    //   if (CheckConnection.hasConnectivity)
    {
        [NSThread detachNewThreadSelector: @selector(cleanupData) toTarget:self withObject:nil];
    }
}

- (void) cleanupData
{
    
    NSString* MachineID = [g_SETTINGS objectForKey:@"MachineID"];
    if ([MachineID isEqualToString:@"LOCAL"])
    {
        NSString* sql = @"Delete from tickets";
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeDelete:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        sql = @"Delete from ticketInputs";
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeDelete:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        sql = @"Delete from ticketFormsInputs";
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeDelete:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        sql = @"Delete from ticketNotes";
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeDelete:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        sql = @"Delete from ticketSignatures";
        @synchronized(g_SYNCBLOBSDB)
        {
            [DAO executeDelete:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
        }
        sql = @"Delete from TicketAttachments";
        @synchronized(g_SYNCBLOBSDB)
        {
            [DAO executeDelete:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
        }
        
    }
    else  
    {
        NSString* sql = @"Select TicketID, TicketCreatedTime from tickets where TicketID > 0 and TicketFinalized = 1 and TicketStatus = 2 and isUploaded = 1;";
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeCleanup:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
    }
}


-(void) uploadBackupData
{
    backupStart = 1;
    @autoreleasepool {
        @try
        {
            NSLog(@"Start backup");
            NSString* sql = @"Select count(*) from Tickets where IsUploaded = 0";
            NSInteger ticketCount = 0;
            @synchronized(g_SYNCDATADB)
            {
                ticketCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (ticketCount > 0)
            {
                NSMutableArray* ticketArray;
                NSString* sql = @"Select localTicketID, TicketID, TicketGUID, TicketIncidentNumber, TicketDesc, TicketDOS, TicketStatus, TicketOwner, TicketCreator, TicketUnitNumber, TicketFinalized, TicketDateFinalized, TicketCrew, TicketPractice, TicketCreatedTime, TicketShift, TicketLocked, TicketReviewed, TicketAccount, TicketAdminNotes, IsUploaded from tickets where IsUploaded = 0 Limit 1";
                @synchronized(g_SYNCDATADB)
                {
                    ticketArray = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                }
                ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
                binding.timeout = 50;
                binding.logXMLInOut = NO;
                ServiceSvc_BackupTicket *req = [[ServiceSvc_BackupTicket alloc] init];
                ServiceSvc_ArrayOfClsTickets* obj = [[ServiceSvc_ArrayOfClsTickets alloc] init];
                ClsTickets* ticketItem;
                NSInteger tempTicket = 0;
                //for (ticketItem in ticketArray)
                for (int i = 0; i < [ticketArray count]; i++)
                {
                    ticketItem = (ClsTickets*)[ticketArray objectAtIndex:i];
                    ServiceSvc_ClsTickets* ticket = [[ServiceSvc_ClsTickets alloc] init];
                    ticket.TicketID = [NSNumber numberWithInteger:ticketItem.ticketID];
                    tempTicket = ticketItem.ticketID;
                    ticket.TicketGUID = ticketItem.TicketGUID;
                    ticket.TicketIncidentNumber = ticketItem.ticketIncidentNumber;
                    ticket.TicketDesc = ticketItem.ticketDesc;
                    ticket.TicketDOS = ticketItem.ticketDOS;
                    ticket.TicketStatus = [NSNumber numberWithInteger:ticketItem.ticketStatus];
                    ticket.TicketOwner = [NSNumber numberWithInteger:ticketItem.ticketOwner];
                    ticket.TicketCreator = [NSNumber numberWithInteger:ticketItem.ticketCreator];
                    ticket.TicketUnitNumber = [NSNumber numberWithInteger:ticketItem.ticketUnitNumber];
                    ticket.TicketFinalized = [NSNumber numberWithInteger:ticketItem.ticketFinalized];
                    ticket.TicketDateFinalized = ticketItem.ticketDateFinalized;
                    ticket.TicketCrew = ticketItem.ticketCrew;
                    ticket.TicketPractice = [NSNumber numberWithInteger:ticketItem.ticketPractice];
                    ticket.TicketCreatedTime = ticketItem.ticketCreatedTime;
                    ticket.TicketShift = [NSNumber numberWithInteger:ticketItem.TicketShift];
                    ticket.TicketLocked = [NSNumber numberWithInteger:ticketItem.ticketLocked];
                    ticket.TicketReviewed = [NSNumber numberWithInteger:ticketItem.ticketReviewed];
                    ticket.TicketAccount = [NSNumber numberWithInteger:ticketItem.ticketAccount];
                    ticket.TicketAdminNotes = ticketItem.ticketAdminNotes;
                    [obj addClsTickets:ticket];
                }
                req.dsChangesMade = obj;
                
                req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
                req.MachineID = [g_SETTINGS objectForKey:@"MachineID"];
                ServiceSoapBindingResponse* resp = [binding BackupTicketUsingParameters:req];
                for (id mine in resp.bodyParts)
                {
                    if ([mine isKindOfClass:[ServiceSvc_BackupTicketResponse class]])
                    {
                        ServiceSvc_ClsTicketUpdate* resultArray = [mine BackupTicketResult];
                        
                        NSString* serverTicketID = [resultArray valueForKey:@"ServerTicketID"];
                        
                        if (([serverTicketID intValue] > 0) && ([serverTicketID intValue] != tempTicket))
                        {
                            @synchronized(g_SYNCDATADB)
                            {
                                if (tempTicket == [[g_SETTINGS objectForKey:@"currentTicketID"] intValue])
                                {
                                    [g_SETTINGS setObject:serverTicketID forKey:@"currentTicketID"];
                                }
                                NSString* sql = [NSString stringWithFormat:@"Update Tickets set TicketID = %@, isUploaded = 1 where TicketID = %d", serverTicketID, tempTicket];
                                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                                
                                
                                sql = [NSString stringWithFormat:@"Update TicketInputs set TicketID = %@ where TicketID = %d", serverTicketID, tempTicket];
                                
                                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                                
                                sql = [NSString stringWithFormat:@"Update TicketNotes set TicketID = %@ where TicketID = %d", serverTicketID, tempTicket];
                                
                                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                                
                                sql = [NSString stringWithFormat:@"Update TicketChanges set TicketID = %@ where TicketID = %d", serverTicketID, tempTicket];
                                
                                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                                
                            }
                            @synchronized(g_SYNCBLOBSDB)
                            {
                                sql = [NSString stringWithFormat:@"Update TicketAttachments set TicketID = %@ where TicketID = %d", serverTicketID, tempTicket];
                                
                                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                                
                                sql = [NSString stringWithFormat:@"Update TicketSignatures set TicketID = %@ where TicketID = %d", serverTicketID, tempTicket];
                                
                                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                                
                            }
                            
                        }
                        else if ( ([serverTicketID intValue] > 0) && ([serverTicketID intValue] == tempTicket))
                        {
                            NSString* sql = [NSString stringWithFormat:@"Update Tickets set isUploaded = 1 where TicketID = %d", tempTicket];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                        
                        resultArray = nil;
                    }
                    
                }
                
                obj = nil;
                req = nil;
                resp = nil;
                binding = nil;
                ticketArray = nil;
            } // end ticketCount
            
            sql = @"Select count(*) from TicketInputs where IsUploaded = 0 and TicketID > 0";
            NSInteger ticketInputsCount = 0;
            @synchronized(g_SYNCDATADB)
            {
                ticketInputsCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (ticketInputsCount > 0)
            {
                NSMutableArray* ticketInputsArray;
                sql = @"Select * from TicketInputs where TicketID = (select TicketID from TicketInputs where TicketID > 0  and isUploaded = 0 LIMIT 1) and isUploaded = 0 limit 10";
                @synchronized(g_SYNCDATADB)
                {
                    ticketInputsArray = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                }
                if ([ticketInputsArray count] >0 )
                {
                    ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
                    binding.timeout = 50;
                    binding.logXMLInOut = NO;
                    
                    ServiceSvc_BackupTicketInputs *req1 = [[ServiceSvc_BackupTicketInputs alloc] init];
                    ServiceSvc_ArrayOfClsTicketInputs* obj1 = [[ServiceSvc_ArrayOfClsTicketInputs alloc] init];
                    ClsTicketInputs* ticketInputsItem;
                    
                    for (ticketInputsItem in ticketInputsArray)
                    {
                        ServiceSvc_ClsTicketInputs* ticketInputs = [[ServiceSvc_ClsTicketInputs alloc] init];
                        ticketInputs.TicketID = [NSNumber numberWithInteger:ticketInputsItem.ticketId];
                        ticketInputs.InputID = [NSNumber numberWithInteger:ticketInputsItem.inputId];
                        ticketInputs.InputSubID = [NSNumber numberWithInteger:ticketInputsItem.inputSubId];
                        ticketInputs.InputInstance = [NSNumber numberWithInteger:ticketInputsItem.inputInstance];
                        
                        ticketInputs.InputPage = ticketInputsItem.inputPage;
                        ticketInputs.InputName = ticketInputsItem.inputName;
                        ticketInputs.InputValue = ticketInputsItem.inputValue;
                        ticketInputs.Deleted = [NSNumber numberWithInteger:ticketInputsItem.deleted];
                        ticketInputs.Modified = [NSNumber numberWithInteger:ticketInputsItem.modified];
                        
                        [obj1 addClsTicketInputs:ticketInputs];
                        ticketInputs = nil;
                    }
                    
                    req1.dsChangesMade = obj1;
                    
                    req1.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
                    req1.MachineID = [g_SETTINGS objectForKey:@"MachineID"];
                    ServiceSoapBindingResponse* resp = [binding BackupTicketInputsUsingParameters:req1];
                    for (id mine in resp.bodyParts)
                    {
                        if ([mine isKindOfClass:[ServiceSvc_BackupTicketInputsResponse class]])
                        {
                            ServiceSvc_ClsTicketUpdate* resultArray = [mine BackupTicketInputsResult];
                            
                            NSString* completedChanges = [resultArray valueForKey:@"CompletedChanges"];
                            NSArray* changeArray = [completedChanges componentsSeparatedByString: @","];
                            if ([changeArray count] > 0)
                            {
                                for (int i = 0; i < [changeArray count] - 1; i++)
                                {
                                    NSString* wholeString = [changeArray objectAtIndex:i];
                                    NSArray* keyArray = [wholeString componentsSeparatedByString: @":"];
                                    
                                    NSString* ticketId = [keyArray objectAtIndex: 0];
                                    NSString* inputID = [keyArray objectAtIndex: 1];
                                    NSString* inputSubID = [keyArray objectAtIndex: 2];
                                    NSString* inputInstance = [keyArray objectAtIndex: 3];
                                    if ( ([ticketId length] > 0) && ([ticketId rangeOfString:@"(null)"].location == NSNotFound))
                                    {
                                        NSString* sql = [NSString stringWithFormat:@"Update TicketInputs set isUploaded = 1 where TicketID = %@ and InputID = %@ and InputSubID = %@ and InputInstance = %@", ticketId, 	inputID, inputSubID, inputInstance];
                                        @synchronized(g_SYNCDATADB)
                                        {
                                            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                                        }
                                    }
                                }
                            }  // end if ([changeArray count] > 0)
                            
                            resultArray = nil;
                        } // end if mine
                    } // end for id mine
                    
                    resp = nil;
                    req1 = nil;
                    obj1 = nil;
                  
                }
                ticketInputsArray = nil;
            } // end TicketInputsCount
            
            sql = @"Select count(*) from TicketFormsInputs where IsUploaded = 0 and TicketID > 0";
            int formCount = 0;
            @synchronized(g_SYNCDATADB)
            {
                formCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (formCount > 0)
            {
                NSMutableArray* TicketFormsArray;
                sql = @"Select * from TicketFormsInputs where TicketID > 0 and isUploaded = 0 LIMIT 1";
                @synchronized(g_SYNCDATADB)
                {
                    TicketFormsArray = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                }
                if ([TicketFormsArray count] >0 )
                {
                    ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
                    binding.timeout = 50;
                    binding.logXMLInOut = NO;
                    
                    ServiceSvc_BackupTicketFormsInput *req1 = [[ServiceSvc_BackupTicketFormsInput alloc] init];
                    ServiceSvc_ArrayOfClsTicketFormsInputs * obj1 = [[ServiceSvc_ArrayOfClsTicketFormsInputs alloc] init];
                    ClsTicketFormsInputs* input;
                    for (input in TicketFormsArray)
                    {
                        ServiceSvc_ClsTicketFormsInputs* form = [[ServiceSvc_ClsTicketFormsInputs alloc] init];
                        form.TicketID = [NSNumber numberWithInteger:input.ticketID];
                        form.FormID = [NSNumber numberWithInteger:input.formID];
                        form.FormInputID = [NSNumber numberWithInteger:input.formInputID];
                        form.FormInputValue = input.formInputValue;
                        form.Deleted = [NSNumber numberWithInteger:input.deleted];
                        form.Modified = [NSNumber numberWithInteger:input.modified];
                        [obj1 addClsTicketFormsInputs:form];
                    }
                    
                    req1.dsChangesMade = obj1;
                    
                    req1.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
                    req1.MachineID = [g_SETTINGS objectForKey:@"MachineID"];
                    ServiceSoapBindingResponse* resp = [binding BackupTicketFormsInputUsingParameters:req1];
                    for (id mine in resp.bodyParts)
                    {
                        if ([mine isKindOfClass:[ServiceSvc_BackupTicketFormsInputResponse class]])
                        {
                            ServiceSvc_ClsTicketUpdate* resultArray = [mine BackupTicketFormsInputResult];
                            
                            NSString* completedChanges = [resultArray valueForKey:@"CompletedChanges"];
                            NSArray* changeArray = [completedChanges componentsSeparatedByString: @","];
                            if ([changeArray count] > 0)
                            {
                                for (int i = 0; i < [changeArray count] - 1; i++)
                                {
                                    NSString* wholeString = [changeArray objectAtIndex:i];
                                    NSArray* keyArray = [wholeString componentsSeparatedByString: @":"];
                                    
                                    NSString* ticketId = [keyArray objectAtIndex: 0];
                                    NSString* formID = [keyArray objectAtIndex: 1];
                                    NSString* formInputID = [keyArray objectAtIndex: 2];
                                    
                                    if ( ([ticketId length] > 0) && ([ticketId rangeOfString:@"(null)"].location == NSNotFound))
                                    {
                                        NSString* sql = [NSString stringWithFormat:@"Update TicketFormsInputs set isUploaded = 1 where TicketID = %@ and FormID = %@ and FormInputID = %@", ticketId, formID, formInputID];
                                        @synchronized(g_SYNCDATADB)
                                        {
                                            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                }
                
            }   // end sigcount
            
            
            
            sql = @"Select count(*) from TicketAttachments where IsUploaded = 0 and TicketID > 0";
            int blobsCount = 0;
            @synchronized(g_SYNCBLOBSDB)
            {
                blobsCount = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            if (blobsCount > 0)
            {
                NSMutableArray* TicketAttachmentArray;
                sql = @"Select * from TicketAttachments where TicketID = (select TicketID from TicketAttachments where TicketID > 0  and isUploaded = 0 LIMIT 1) and isUploaded = 0 limit 1";
                @synchronized(g_SYNCBLOBSDB)
                {
                    TicketAttachmentArray = [DAO executeSelectTicketAttachments:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                }
                if ([TicketAttachmentArray count] >0 )
                {
                    ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
                    binding.timeout = 50;
                    binding.logXMLInOut = NO;
                    
                    ServiceSvc_BackupTicketAttachments *req1 = [[ServiceSvc_BackupTicketAttachments alloc] init];
                    ServiceSvc_ArrayOfClsTicketAttachments* obj1 = [[ServiceSvc_ArrayOfClsTicketAttachments alloc] init];
                    ClsTicketAttachments* ticketAttachment;
                    for (ticketAttachment in TicketAttachmentArray)
                    {
                        ServiceSvc_ClsTicketAttachments* attachment = [[ServiceSvc_ClsTicketAttachments alloc] init];
                        attachment.TicketID = [NSNumber numberWithInteger:ticketAttachment.ticketID];
                        attachment.AttachmentID = [NSNumber numberWithInteger:ticketAttachment.attachmentID];
                        attachment.FileType = ticketAttachment.fileType;
                        attachment.FileStr = ticketAttachment.fileStr;
                        
                        attachment.FileName = ticketAttachment.fileName;
                        attachment.TimeAdded = ticketAttachment.timeAdded;
                        attachment.Deleted = [NSNumber numberWithInteger:ticketAttachment.deleted];
                        
                        [obj1 addClsTicketAttachments:attachment];
                    }
                    
                    req1.dsChangesMade = obj1;
                    
                    req1.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
                    req1.MachineID = [g_SETTINGS objectForKey:@"MachineID"];
                    ServiceSoapBindingResponse* resp = [binding BackupTicketAttachmentsUsingParameters:req1];
                    for (id mine in resp.bodyParts)
                    {
                        if ([mine isKindOfClass:[ServiceSvc_BackupTicketAttachmentsResponse class]])
                        {
                            ServiceSvc_ClsTicketUpdate* resultArray = [mine BackupTicketAttachmentsResult];
                            
                            NSString* completedChanges = [resultArray valueForKey:@"CompletedChanges"];
                            NSArray* changeArray = [completedChanges componentsSeparatedByString: @","];
                            if ([changeArray count] > 0)
                            {
                                for (int i = 0; i < [changeArray count] - 1; i++)
                                {
                                    NSString* wholeString = [changeArray objectAtIndex:i];
                                    NSArray* keyArray = [wholeString componentsSeparatedByString: @":"];
                                    
                                    NSString* ticketId = [keyArray objectAtIndex: 0];
                                    NSString* attachmentID = [keyArray objectAtIndex: 1];
                                    
                                    if ( ([ticketId length] > 0) && ([ticketId rangeOfString:@"(null)"].location == NSNotFound))
                                    {
                                        NSString* sql = [NSString stringWithFormat:@"Update TicketAttachments set isUploaded = 1 where TicketID = %@ and AttachmentID = %@", ticketId, attachmentID];
                                        @synchronized(g_SYNCBLOBSDB)
                                        {
                                            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                                        }
                                    }
                                }
                            }

                        }
                    }
                    
                    
                }
            } // end blobsCount
            
            sql = @"Select count(*) from TicketSignatures where IsUploaded = 0 and TicketID > 0";
            int sigCount = 0;
            @synchronized(g_SYNCBLOBSDB)
            {
                sigCount = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            if (sigCount > 0)
            {
                NSMutableArray* TicketSigArray;
                sql = @"Select * from TicketSignatures where TicketID = (select TicketID from TicketSignatures where TicketID > 0  and isUploaded = 0 LIMIT 1) and isUploaded = 0 limit 1";
                @synchronized(g_SYNCBLOBSDB)
                {
                    TicketSigArray = [DAO executeSelectTicketSignatures:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                }
                if ([TicketSigArray count] >0 )
                {
                    ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
                    binding.timeout = 50;
                    binding.logXMLInOut = NO;
                    
                    ServiceSvc_BackupTicketSignatures *req1 = [[ServiceSvc_BackupTicketSignatures alloc] init];
                    ServiceSvc_ArrayOfClsTicketSignatures* obj1 = [[ServiceSvc_ArrayOfClsTicketSignatures alloc] init];
                    ClsTicketSignatures* ticketSignature;
                    for (ticketSignature in TicketSigArray)
                    {
                        ServiceSvc_ClsTicketSignatures* sig = [[ServiceSvc_ClsTicketSignatures alloc] init];
                        sig.TicketID = [NSNumber numberWithInteger:ticketSignature.ticketID];
                        sig.SignatureID = [NSNumber numberWithInteger:ticketSignature.signatureID];
                        sig.SignatureType = [NSNumber numberWithInteger:ticketSignature.signatureType];
                        sig.SignatureText = ticketSignature.signatureText;
                        
                        sig.SignatureString = ticketSignature.signatureString;
                        sig.SignatureTime = ticketSignature.signatureTime;
                        sig.Deleted = [NSNumber numberWithInteger:ticketSignature.deleted];
                        
                        [obj1 addClsTicketSignatures:sig];
                    }
                    
                    req1.dsChangesMade = obj1;
                    
                    req1.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
                    req1.MachineID = [g_SETTINGS objectForKey:@"MachineID"];
                    ServiceSoapBindingResponse* resp = [binding BackupTicketSignaturesUsingParameters:req1];
                    for (id mine in resp.bodyParts)
                    {
                        if ([mine isKindOfClass:[ServiceSvc_BackupTicketSignaturesResponse class]])
                        {
                            ServiceSvc_ClsTicketUpdate* resultArray = [mine BackupTicketSignaturesResult];
                            
                            NSString* completedChanges = [resultArray valueForKey:@"CompletedChanges"];
                            NSArray* changeArray = [completedChanges componentsSeparatedByString: @","];
                            if ([changeArray count] > 0)
                            {
                                for (int i = 0; i < [changeArray count] - 1; i++)
                                {
                                    NSString* wholeString = [changeArray objectAtIndex:i];
                                    NSArray* keyArray = [wholeString componentsSeparatedByString: @":"];
                                    
                                    NSString* ticketId = [keyArray objectAtIndex: 0];
                                    NSString* signatureID = [keyArray objectAtIndex: 1];
                                    
                                    if ( ([ticketId length] > 0) && ([ticketId rangeOfString:@"(null)"].location == NSNotFound))
                                    {
                                        NSString* sql = [NSString stringWithFormat:@"Update TicketSignatures set isUploaded = 1 where TicketID = %@ and SignatureID = %@", ticketId, signatureID];
                                        @synchronized(g_SYNCBLOBSDB)
                                        {
                                            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                                        }
                                    }
                                }
                            }

                        }
                    }
                    
                    
                }

            }   // end sigcount
            
            sql = @"Select count(*) from TicketNotes where IsUploaded = 0 and TicketID > 0";
            NSInteger ticketNotesCount = 0;
            @synchronized(g_SYNCDATADB)
            {
                ticketNotesCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (ticketNotesCount > 0)
            {
                NSMutableArray* ticketNotesArray;
                sql = @"Select LocalTicketID, TicketID, NoteUID, Note, UserID, NoteTime, NoteRead, ForAdmin from TicketNotes where TicketID = (select TicketID from TicketNotes where TicketID > 0  and isUploaded = 0 LIMIT 1) and isUploaded = 0 limit 10";
                @synchronized(g_SYNCDATADB)
                {
                    ticketNotesArray = [DAO executeSelectTicketNotes:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                }
                if ([ticketNotesArray count] >0 )
                {
                    ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
                    binding.timeout = 50;
                    binding.logXMLInOut = NO;
                    
                    ServiceSvc_BackupTicketNotes *req1 = [[ServiceSvc_BackupTicketNotes alloc] init];
                    ServiceSvc_ArrayOfClsTicketNotes* obj1 = [[ServiceSvc_ArrayOfClsTicketNotes alloc] init];
                    ClsTicketNotes* ticketNotesItem;
                    
                    for (ticketNotesItem in ticketNotesArray)
                    {
                        ServiceSvc_ClsTicketNotes* ticketNotes = [[ServiceSvc_ClsTicketNotes alloc] init];
                        ticketNotes.TicketID = [NSNumber numberWithInteger:ticketNotesItem.ticketID];
                        ticketNotes.NoteUID = [NSNumber numberWithInteger:ticketNotesItem.noteUID];
                        ticketNotes.Note = ticketNotesItem.note;
                        ticketNotes.UserID = ticketNotesItem.userID;
                        ticketNotes.NoteTime = ticketNotesItem.noteTime;
                        ticketNotes.NoteRead = NO;
                        ticketNotes.ForAdmin = NO;
                        [obj1 addClsTicketNotes:ticketNotes];
                    }
                    
                    req1.dsChangesMade = obj1;
                    
                    req1.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
                    req1.MachineID = [g_SETTINGS objectForKey:@"MachineID"];
                    ServiceSoapBindingResponse* resp = [binding BackupTicketNotesUsingParameters:req1];
                    for (id mine in resp.bodyParts)
                    {
                        if ([mine isKindOfClass:[ServiceSvc_BackupTicketNotesResponse class]])
                        {
                            ServiceSvc_ClsTicketUpdate* resultArray = [mine BackupTicketNotesResult];
                            
                            NSString* completedChanges = [resultArray valueForKey:@"CompletedChanges"];
                            NSArray* changeArray = [completedChanges componentsSeparatedByString: @","];
                            if ([changeArray count] > 0)
                            {
                                for (int i = 0; i < [changeArray count] - 1; i++)
                                {
                                    NSString* wholeString = [changeArray objectAtIndex:i];
                                    NSArray* keyArray = [wholeString componentsSeparatedByString: @":"];
                                    
                                    NSString* ticketId = [keyArray objectAtIndex: 0];
                                    NSString* noteUID = [keyArray objectAtIndex: 1];
                                    if ( ([ticketId length] > 0) && ([ticketId rangeOfString:@"(null)"].location == NSNotFound))
                                    {
                                        NSString* sql = [NSString stringWithFormat:@"Update TicketNotes set isUploaded = 1 where TicketID = %@ and NoteUID = %@", ticketId, 	noteUID];
                                        @synchronized(g_SYNCDATADB)
                                        {
                                            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            } // end TicketNotesCount
            
            sql = @"Select count(*) from TicketChanges where IsUploaded = 0 and TicketID > 0";
            NSInteger ticketChangesCount = 0;
            @synchronized(g_SYNCDATADB)
            {
                ticketChangesCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (ticketChangesCount > 0)
            {
                NSMutableArray* ticketChangesArray;
                sql = @"Select TicketID, ChangeID, ChangeMade, ChangeTime, ModifiedBy, ChangeInputID, OriginalValue from TicketChanges where TicketID = (select TicketID from TicketChanges where TicketID > 0  and isUploaded = 0 LIMIT 1) and isUploaded = 0 limit 10";
                @synchronized(g_SYNCDATADB)
                {
                    ticketChangesArray = [DAO executeSelectTicketChanges:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                }
                if ([ticketChangesArray count] >0 )
                {
                    ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
                    binding.timeout = 50;
                    binding.logXMLInOut = NO;
                    
                    ServiceSvc_BackupTicketChanges *req1 = [[ServiceSvc_BackupTicketChanges alloc] init];
                    ServiceSvc_ArrayOfClsTicketChanges* obj1 = [[ServiceSvc_ArrayOfClsTicketChanges alloc] init];
                    ClsTicketChanges* ticketChangesItem;
                    
                    for (ticketChangesItem in ticketChangesArray)
                    {
                        ServiceSvc_ClsTicketChanges* ticketChanges = [[ServiceSvc_ClsTicketChanges alloc] init];
                        ticketChanges.TicketID = [NSNumber numberWithInteger:ticketChangesItem.ticketID];
                        ticketChanges.ChangeID = [NSNumber numberWithInteger:ticketChangesItem.changeID];
                        ticketChanges.ChangeMade = ticketChangesItem.changeMade;
                        ticketChanges.ChangeTime = ticketChangesItem.changeTime;
                        ticketChanges.ModifiedBy = [NSNumber numberWithInteger:ticketChangesItem.modifiedBy];
                        ticketChanges.ChangeInputID = [NSNumber numberWithInteger:ticketChangesItem.changeInputID];
                        ticketChanges.OriginalValue = ticketChangesItem.originalValue;
                        [obj1 addClsTicketChanges:ticketChanges];
                    }
                    
                    req1.dsChangesMade = obj1;
                    
                    req1.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
                    req1.MachineID = [g_SETTINGS objectForKey:@"MachineID"];
                    ServiceSoapBindingResponse* resp = [binding BackupTicketChangesUsingParameters:req1];
                    for (id mine in resp.bodyParts)
                    {
                        if ([mine isKindOfClass:[ServiceSvc_BackupTicketChangesResponse class]])
                        {
                            ServiceSvc_ClsTicketUpdate* resultArray = [mine BackupTicketChangesResult];
                            
                            NSString* completedChanges = [resultArray valueForKey:@"CompletedChanges"];
                            NSArray* changeArray = [completedChanges componentsSeparatedByString: @","];
                            if ([changeArray count] > 0)
                            {
                                for (int i = 0; i < [changeArray count] - 1; i++)
                                {
                                    NSString* wholeString = [changeArray objectAtIndex:i];
                                    NSArray* keyArray = [wholeString componentsSeparatedByString: @":"];
                                    
                                    NSString* ticketId = [keyArray objectAtIndex: 0];
                                    NSString* changeID = [keyArray objectAtIndex: 1];
                                    if ( ([ticketId length] > 0) && ([ticketId rangeOfString:@"(null)"].location == NSNotFound))
                                    {
                                        NSString* sql = [NSString stringWithFormat:@"Update TicketChanges set isUploaded = 1 where TicketID = %@ and ChangeID = %@", ticketId, changeID];
                                        @synchronized(g_SYNCDATADB)
                                        {
                                            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                                        }
                                    }
                                }
                            }

                        }
                    }
                }
            } // end TicketChangesCount
            
            
            // Do unit admin Messages
            ServiceSoapBinding *binding1 = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding1.logXMLInOut = NO;
            ServiceSvc_DoAdminUnitIpad *req1 = [[ServiceSvc_DoAdminUnitIpad alloc] init];
            req1.UnitDesc = [g_SETTINGS objectForKey:@"UnitName"];
            req1.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req1.MachineID = nil;
            req1.UnitID = [g_SETTINGS objectForKey:@"Unit"];
            req1.GPSData = nil;
            ServiceSoapBindingResponse* resp1 = [binding1 DoAdminUnitIpadUsingParameters:req1];
            for (id mine in resp1.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_DoAdminUnitIpadResponse class]])
                {
                    ServiceSvc_ArrayOfClsUnitMsgs* resultArray = [mine DoAdminUnitIpadResult];
                    NSMutableArray* array = [resultArray ClsUnitMsgs];
                 //   NSMutableString* msgStr = [[NSMutableString alloc] init];
                    NSString* msg;
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsUnitMsgs* record = [array objectAtIndex:i];
                        msg = [record valueForKey:@"Msg"];
                     /*   NSString* sentFrom = [record valueForKey:@"SentBy"];
                        NSString* sentTo = [record valueForKey:@"SentTo"];
                        NSString* msgID = [record valueForKey:@"UnitMsgsID"];
                        NSString* timeStamp = [record valueForKey:@"TimeStamp"];
                        NSString* msg = [record valueForKey:@"Msg"];
                        NSString* refID = [record valueForKey:@"RefID"];  */
                      //  [msgStr appendFormat:@"MessageID: %@ , Time: %@\n", msgID, timeStamp];
                      //  [msgStr appendFormat:@"Sent By: %@ , Sent To: %@\n", sentFrom, sentTo];
                      //  [msgStr appendFormat:@"Ref ID: %@ \n", refID];
                      //  [msgStr appendFormat:@"Message: %@ \n", msg];
                    }
                    if ([array count] > 0)
                    {
                        [self performSelectorOnMainThread:@selector(msgTask:) withObject:msg waitUntilDone:NO];
                    }

                }
            }
            
            // do machine admin message
            ServiceSoapBinding *binding2 = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding2.logXMLInOut = NO;
            ServiceSvc_DoAdminMachineIpad *req2 = [[ServiceSvc_DoAdminMachineIpad alloc] init];
            req2.UnitDesc = [g_SETTINGS objectForKey:@"UnitName"];
            req2.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req2.MachineID = nil;
            req2.UnitID = [g_SETTINGS objectForKey:@"Unit"];
            req2.GPSData = nil;
            ServiceSoapBindingResponse* resp2 = [binding2 DoAdminMachineIpadUsingParameters:req2];
            for (id mine in resp2.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_DoAdminMachineIpadResponse class]])
                {
                    ServiceSvc_ArrayOfClsMachineMsgs* resultArray = [mine DoAdminMachineIpadResult];
                    NSMutableArray* array = [resultArray ClsMachineMsgs];
                    //NSMutableString* msgStr = [[NSMutableString alloc] init];
                    NSString* msg;
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsMachineMsgs* record = [array objectAtIndex:i];

                        msg = [record valueForKey:@"Msg"];

                    }
                    if ([array count] > 0)
                    {
                        [self performSelectorOnMainThread:@selector(msgTask:) withObject:msg waitUntilDone:NO];
                    }
                    
                }
            }
            
            
            
        } // end try
        @catch (NSException *exception)
        {
        }
        @finally
        {
        }
    }  // end autoreleasepool
    backupStart = 0;
    NSLog(@"End backup");
}


- (void) msgTask:(NSString*) msg
{
    NSArray* msgArray = [msg componentsSeparatedByString:@"@"];
    if ([msgArray count] > 0)
    {
        NSString* msgCommand = [msgArray objectAtIndex:0];
        if ([msgCommand rangeOfString:@"SYSADMINWEBCAD"].location != NSNotFound)
        {
            if ([msgArray count] > 1)
            {
                self.cadData = [[ClsCadData alloc] init];
                
                NSString* dataStr = [msgArray objectAtIndex:1];
                NSArray* dataArray = [dataStr componentsSeparatedByString:@"|"];
                for (int i = 0; i< [dataArray count]; i++)
                {
                    if (i == 0)
                    {
                       cadData.incidentDate  = [dataArray objectAtIndex:i];
                    }
                    else if (i == 1)
                    {
                        cadData.incidentNum = [dataArray objectAtIndex:i];
                        cadData.runNumber  = cadData.incidentNum;
                    }
                    else if (i == 2)
                    {
                       cadData.secondaryNumber = [dataArray objectAtIndex:i];
                    }
                    else if (i == 3)
                    {
                        cadData.acccountCode = [dataArray objectAtIndex:i];
                    }
                    else if (i == 4)
                    {

                    }
                    else if (i == 5)
                    {
                        cadData.toIncidentCode = [dataArray objectAtIndex:i];
                    }
                    else if (i == 6)
                    {
                       cadData.ToDestinationCode = [dataArray objectAtIndex:i];
                    }
                    else if (i == 7)
                    {
                       cadData.TransportReason = [dataArray objectAtIndex:i];
                    }
                    else if (i == 8)
                    {
                       cadData.PickupFacilityCode = [dataArray objectAtIndex:i];
                    }
                    else if (i == 9)
                    {
                       cadData.IncidentAddress = [dataArray objectAtIndex:i];
                    }
                    else if (i == 10)
                    {
                       cadData.IncidentAddress2 = [dataArray objectAtIndex:i];
                    }
                    
                    else if (i == 11)
                    {
                        cadData.IncidentCity = [dataArray objectAtIndex:i];
                    }
                    
                    else if (i == 12)
                    {
                       cadData.IncidentState = [dataArray objectAtIndex:i];
                    }
                    else if (i == 13)
                    {
                       cadData.IncidentZip = [dataArray objectAtIndex:i];
                    }
                    else if (i == 14)
                    {
                        cadData.DestFacilityCode = [dataArray objectAtIndex:i];
                    }
                    else if (i == 15)
                    {
                       cadData.DestAddress = [dataArray objectAtIndex:i];
                    }
                    else if (i == 16)
                    {
                       cadData.DestAddress2 = [dataArray objectAtIndex:i];
                    }
                    else if (i == 17)
                    {
                        cadData.DestCity = [dataArray objectAtIndex:i];
                    }
                    
                    else if (i == 18)
                    {
                       cadData.DestState = [dataArray objectAtIndex:i];
                    }
                    else if (i == 19)
                    {
                        cadData.DestZip = [dataArray objectAtIndex:i];
                    }
                    else if (i == 20)
                    {
                       cadData.CallReceivedDate = [dataArray objectAtIndex:i];
                    }

                    else if (i == 21)
                    {
                        cadData.CallReceivedTime = [dataArray objectAtIndex:i];
                    }
                    else if (i == 22)
                    {
                       cadData.DispatchDate = [dataArray objectAtIndex:i];
                    }
                    else if (i == 23)
                    {
                        cadData.DispatchTime = [dataArray objectAtIndex:i];
                    }
                    else if (i == 24)
                    {
                       cadData.EnrouteDate = [dataArray objectAtIndex:i];
                    }
                    else if (i == 25)
                    {
                       cadData.EnrouteTime = [dataArray objectAtIndex:i];
                    }
                    else if (i == 26)
                    {
                       cadData.AtSceneDate = [dataArray objectAtIndex:i];
                    }
                    else if (i == 27)
                    {
                       cadData.AtSceneTime = [dataArray objectAtIndex:i];
                    }
                    else if (i == 28)
                    {
                       cadData.ToDestDate = [dataArray objectAtIndex:i];
                    }
                    else if (i == 29)
                    {
                       cadData.ToDestTime = [dataArray objectAtIndex:i];
                    }
                    else if (i == 30)
                    {
                       cadData.AtDestDate = [dataArray objectAtIndex:i];
                    }
                    else if (i == 31)
                    {
                       cadData.AtDestTime = [dataArray objectAtIndex:i];
                    }
                    
                    else if (i == 32)
                    {
                        cadData.ClearDate = [dataArray objectAtIndex:i];
                    }
                    else if (i == 33)
                    {
                       cadData.ClearTime = [dataArray objectAtIndex:i];
                    }
                    else if (i == 34)
                    {
                       cadData.PTFirstName = [dataArray objectAtIndex:i];
                    }
                    else if (i == 35)
                    {
                       cadData.PTMI = [dataArray objectAtIndex:i];
                    }
                    else if (i == 36)
                    {
                        cadData.PTLastName = [dataArray objectAtIndex:i];
                    }
                    else if (i == 37)
                    {
                        cadData.PTAddress = [dataArray objectAtIndex:i];
                    }
                    
                    else if (i == 38)
                    {
                        cadData.PTAddress2 = [dataArray objectAtIndex:i];
                    }
                    else if (i == 39)
                    {
                        cadData.PTCity = [dataArray objectAtIndex:i];
                    }
                    else if (i == 40)
                    {
                        cadData.PTState = [dataArray objectAtIndex:i];
                    }
                    
                    
                    else if (i == 41)
                    {
                        cadData.PTZip = [dataArray objectAtIndex:i];
                    }
                    else if (i == 42)
                    {
                        cadData.PTSSN = [dataArray objectAtIndex:i];
                    }
                    else if (i == 43)
                    {
                        cadData.PTAge = [dataArray objectAtIndex:i];
                    }
                    else if (i == 44)
                    {
                        cadData.PTSex = [dataArray objectAtIndex:i];
                    }
                    else if (i == 45)
                    {
                        cadData.PTWeight = [dataArray objectAtIndex:i];
                    }
                    else if (i == 46)
                    {
                        cadData.PTDOB  = [dataArray objectAtIndex:i];
                    }
                    else if (i == 47)
                    {
                        cadData.DriverName = [dataArray objectAtIndex:i];
                    }
                    else if (i == 48)
                    {
                        cadData.DriverCert = [dataArray objectAtIndex:i];
                    }
                    else if (i == 49)
                    {
                        cadData.Attendant1Name = [dataArray objectAtIndex:i];
                    }
                    else if (i == 50)
                    {
                        cadData.Attendant1Cert = [dataArray objectAtIndex:i];
                    }
                    else if (i == 51)
                    {
                        cadData.Attendant2Name = [dataArray objectAtIndex:i];
                    }
                    
                    else if (i == 52)
                    {
                        cadData.Attnedant2Cert = [dataArray objectAtIndex:i];
                    }
                    else if (i == 53)
                    {
                        cadData.ChiefComplaint = [dataArray objectAtIndex:i];
                    }
                    else if (i == 54)
                    {
                        cadData.Notes = [dataArray objectAtIndex:i];
                    }
                    else if (i == 55)
                    {
                        cadData.CallType = [dataArray objectAtIndex:i];
                    }
                    else if (i == 56)
                    {
                        cadData.BusinessName = [dataArray objectAtIndex:i];
                    }
                    else if (i == 57)
                    {
                        cadData.CrossStreet  = [dataArray objectAtIndex:i];
                    }
                    
                    else if (i == 58)
                    {
                        cadData.MapCode = [dataArray objectAtIndex:i];
                    }
                    else if (i == 59)
                    {
                        cadData.OdometerResponding = [dataArray objectAtIndex:i];
                    }

                    else if (i == 60)
                    {
                       cadData.OdometerAtScene = [dataArray objectAtIndex:i];
                    }
                    
                    else if (i == 61)
                    {
                       cadData.OdometerPatientDestination = [dataArray objectAtIndex:i];
                    }
                    else if (i == 62)
                    {
                       cadData.OdometerClear = [dataArray objectAtIndex:i];
                    }
                    else if (i == 63)
                    {
                       cadData.AtPatientDate = [dataArray objectAtIndex:i];
                    }
                    else if (i == 64)
                    {
                       cadData.AtPatientTime = [dataArray objectAtIndex:i];
                    }
                    else if (i == 65)
                    {
                       cadData.TransferPatientDate = [dataArray objectAtIndex:i];
                    }
                    else if (i == 66)
                    {
                       cadData.TransferPatientTime = [dataArray objectAtIndex:i];
                    }
                    else if (i == 67)
                    {
                       cadData.PriorCalls = [dataArray objectAtIndex:i];
                    }
                    else if (i == 68)
                    {
                       cadData.LocationHazards = [dataArray objectAtIndex:i];
                    }
                    else if (i == 69)
                    {
                       cadData.Zone = [dataArray objectAtIndex:i];
                    }
                    else if (i == 70)
                    {
                       cadData.Latitude = [dataArray objectAtIndex:i];
                    }
                    else if (i == 71)
                    {
                       cadData.Longitude = [dataArray objectAtIndex:i];
                    }
                    
                    else if (i == 72)
                    {
                       cadData.Phone = [dataArray objectAtIndex:i];
                    }
                    else if (i == 73)
                    {
                       cadData.StreetNumber = [dataArray objectAtIndex:i];
                    }
                    else if (i == 74)
                    {
                       cadData.StreetPrefix = [dataArray objectAtIndex:i];
                    }
                    else if (i == 75)
                    {
                       cadData.StreetName = [dataArray objectAtIndex:i];
                    }
                    else if (i == 76)
                    {
                      cadData.StreetType  = [dataArray objectAtIndex:i];
                    }
                    else if (i == 77)
                    {
                       cadData.StreetSuffix = [dataArray objectAtIndex:i];
                    }
                    
                    else if (i == 78)
                    {
                       cadData.xStreetPrefix = [dataArray objectAtIndex:i];
                    }
                    else if (i == 79)
                    {
                       cadData.xStreetName = [dataArray objectAtIndex:i];
                    }
                    else if (i == 80)
                    {
                      cadData.xStreetType  = [dataArray objectAtIndex:i];
                    }
   
                    else if (i == 81)
                    {
                        cadData.xStreetSuffix  = [dataArray objectAtIndex:i];
                    }
    
                    
                }
  
                NSString* sql = [NSString stringWithFormat:@"Select ticketID from tickets where ticketIncidentNumber = '%@' Limit 1", cadData.incidentNum];
                NSString* ticketNo;
                @synchronized(g_SYNCDATADB)
                {
                    ticketNo = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                }
                
                if (ticketNo.length > 0)
                {
                    [self mergeTicket:ticketNo];
                    [self refreshView];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CADUPDATE" object:nil];
                }
                else
                {
                    NSString* msgText = [NSString stringWithFormat:@"Incident #: %@\nAddress: %@, %@, %@ %@\nDate/Time: %@ %@\n Unit: %@", cadData.incidentNum, cadData.IncidentAddress, cadData.IncidentCity, cadData.IncidentState, cadData.IncidentZip, cadData.incidentDate, cadData.CallReceivedDate, [g_SETTINGS objectForKey:@"UnitName"]];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New CAD Incident Available\n\n" message:msgText delegate:self cancelButtonTitle:@"Discard" otherButtonTitles:@"Create and Edit Ticket", @"Create New Ticket But Stay On Current Page", @"Merge With Existing Ticket", nil];
                    alert.tag = 3;
                    [alert show];
                }

                
            }  // end of msglength is > 1
            
            
        }  // end of if //SysAdminWebCad

    }
}



- (CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
    
}

- (void)zoomToMapView
{
    ClsTickets* ticket = [ticketData objectAtIndex:ticketRowSelected];
    if([ticket.ticketDesc length] >0)
    {
        CLLocationCoordinate2D coordinates = [self getLocationFromAddressString:ticket.ticketDesc];
        MKCoordinateRegion region;
        region.center.latitude = coordinates.latitude;
        region.center.longitude =  coordinates.longitude;
        
        MKCoordinateSpan span;
        span.latitudeDelta = 0.0009;
        span.longitudeDelta = 0.0009;
        region.span = span;
        
        [mapview setRegion:region animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPracticeClicked:(id)sender
{
    NSString* sql;
    
    if(showPractice)
    {
        showPractice = NO;
         //reload table
        [btnShowPractice setTitle:@"Show Practice" forState:UIControlStateNormal];
         sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount , TI.InputValue as TicketAdminNotes from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID and TI.INPUTID = 1003 where T.ticketPractice == 0 and t.TicketOwner = %@ order by T.LocalTicketID desc", [g_SETTINGS objectForKey:@"UserID"]];
    }
    else
    {
        showPractice = YES;
         sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount , TI.InputValue as TicketAdminNotes from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID and TI.INPUTID = 1003 WHERE t.TicketOwner = %@ order by T.LocalTicketID desc", [g_SETTINGS objectForKey:@"UserID"]];
        [btnShowPractice setTitle:@"Hide Practice" forState:UIControlStateNormal];

    }
    [self.ticketData removeAllObjects];
    
   
    @synchronized(g_SYNCDATADB)
    {
        self.ticketData = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    [self.mainTableView reloadData];
}


- (IBAction)btnCopyNew:(UIButton *)sender {
    if (ticketRowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Select Ticket" message:@"Please select a ticket below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        NSString *uuid = (__bridge NSString *) uuidStringRef;
        NSInteger ticketID;
        @synchronized(g_SYNCDATADB)
        {
            ticketID = [DAO getNewTicketID:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
        }

        @synchronized(g_SYNCDATADB)
        {
            [DAO createNewTicketForCopy:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] TicketID:ticketID TicketPractice:0 TicketGUID:uuid];
        }
        CFRelease(uuidStringRef);
        
        NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs Select localTicketID, %ld, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, null, null, 1 from ticketInputs where TicketID = %ld and inputID in (1001, 1002, 1003, 1004, 1005, 1006, 1007, 1040, 1041, 1042)", ticketID, selectedCell.tag ];

        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        NSString* incidentNo;
        sqlStr = [NSString stringWithFormat:@"Select inputValue from TicketInputs where InputID = 1001 and ticketID = %ld", selectedCell.tag];
        @synchronized(g_SYNCDATADB)
        {
            incidentNo = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Update Tickets set TicketIncidentNumber = '%@', isUploaded = 1 where TicketID = %ld", incidentNo, ticketID];
        
        
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1009, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1401, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        


        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1011, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1050, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        //  NSString *location = [NSString stringWithFormat:@"%f,%f", currentLocation.latitude, currentLocation.longitude];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%f')", ticketID, 9010, 0, 1, @"", @"", 0.0];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%f')", ticketID, 9011, 0, 1, @"", @"", 0.0];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 20805, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 20302, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 20303, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1070, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 20813, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1080, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1081, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1082, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1047, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1043, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1044, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1045, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1046, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1060, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1061, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 9050, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1067, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1066, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1550, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1551, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1552, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1553, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1554, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
       
        sqlStr = [NSString stringWithFormat:@"Update TicketInputs set IsUploaded = 0 where ticketID = %ld", ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
 
        sqlStr = [NSString stringWithFormat:@"Update Tickets set IsUploaded = 0 where ticketID = %ld", ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        [self refreshView];
    }
    
}


- (IBAction)btnCrewClick:(id)sender {
     [self performSegueWithIdentifier:@"MainToCrew" sender:sender];
}

- (IBAction)btnSegmentedControlClick:(id)sender {
        [self.mainTableView reloadData];
}



- (IBAction)incompleteButtonPressed:(id)sender
{
    btnIncomplete.titleLabel.font  = [UIFont boldSystemFontOfSize:15.0];
    btnReview.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    btnComplete.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    btnAll.titleLabel.font  = [UIFont systemFontOfSize:15.0];

    [self.ticketData removeAllObjects];
    
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount , TI.InputValue as TicketAdminNotes from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID and TI.INPUTID = 1003 and t.TicketStatus = 1 WHERE t.TicketOwner = %@ order by T.LocalTicketID desc", [g_SETTINGS objectForKey:@"UserID"]];
    
    
    
    @synchronized(g_SYNCDATADB)
    {
        self.ticketData = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    [self.mainTableView reloadData];
}

- (IBAction)completeButtonPressed:(id)sender
{
    btnComplete.titleLabel.font  = [UIFont boldSystemFontOfSize:15.0];
    btnReview.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    btnIncomplete.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    btnAll.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    [self.ticketData removeAllObjects];
    
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount , TI.InputValue as TicketAdminNotes from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID and TI.INPUTID = 1003 and t.TicketStatus = 2 WHERE t.TicketOwner = %@ order by T.LocalTicketID desc", [g_SETTINGS objectForKey:@"UserID"]];
    
    
    
    @synchronized(g_SYNCDATADB)
    {
        self.ticketData = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    [self.mainTableView reloadData];
}

- (IBAction)reviewButtonPressed:(id)sender
{
    btnReview.titleLabel.font  = [UIFont boldSystemFontOfSize:15.0];
    btnComplete.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    btnIncomplete.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    btnAll.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    [self.ticketData removeAllObjects];
    
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount , TI.InputValue as TicketAdminNotes from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID and TI.INPUTID = 1003 and t.TicketStatus = 3 WHERE t.TicketOwner = %@ order by T.LocalTicketID desc", [g_SETTINGS objectForKey:@"UserID"]];
    
    
    
    @synchronized(g_SYNCDATADB)
    {
        self.ticketData = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    [self.mainTableView reloadData];
}

- (IBAction)btnQAMessageClick:(UIButton *)sender {
    if (ticketRowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Select Ticket" message:@"Please select a ticket below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        NSString* sql = [NSString stringWithFormat:@"Select ticketAdminNotes from Tickets where TicketID = %d", selectedCell.tag ];
        NSString* notes;
        @synchronized(g_SYNCDATADB)
        {
            notes = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
    
        QAMessageViewController* popoverView = [[QAMessageViewController alloc] initWithNibName:@"QAMessageViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.adminNotes = notes;
        popoverView.ticketID = selectedCell.tag;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani

        if (notes.length > 1)
        {
            self.popover.popoverContentSize = CGSizeMake(502, 520);
        }
        else
        {
            self.popover.popoverContentSize = CGSizeMake(502, 355);
        }
        CGRect rect = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 16, sender.frame.size.width, sender.frame.size.height);
        [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        popoverView = nil;
    }
}

- (IBAction)btnTransferClick:(id)sender
{
    if (transfer == false)
    {
        transfer = true;
        NSString* machineCheck = [g_SETTINGS objectForKey:@"MachineID"];
        if (![machineCheck isEqualToString:@"LOCAL"])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.labelText = @"Downloading data";
            hud.detailsLabelText = @"Please wait...";
            hud.mode = MBProgressHUDAnimationFade;
            [self.view addSubview:hud];
            [hud showWhileExecuting:@selector(downloadData) onTarget:self withObject:Nil animated:YES];
        }
        
    }
}

- (IBAction)btnTransferTicketClick:(UIButton *)sender {
    if (transfer == false)
    {
        transfer = true;
        NSString* machineCheck = [g_SETTINGS objectForKey:@"MachineID"];
        if (![machineCheck isEqualToString:@"LOCAL"])
        {
            
            if (ticketRowSelected < 0)
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic For Ipad" message:@"Please select a ticket below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                transfer = false;
                return;
            }
            else
            {
                NSString* sqlStr = [NSString stringWithFormat:@"Select TicketStatus from Tickets where TicketID = %d", selectedCell.tag ];
                NSString* status;
                @synchronized(g_SYNCDATADB)
                {
                    status = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                if ([status intValue] == 1)
                {
                    TransferViewController *popoverView =[[TransferViewController alloc] initWithNibName:@"TransferViewController" bundle:nil];
                    popoverView.view.backgroundColor = [UIColor whiteColor];
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];
                    self.popover.popoverContentSize = CGSizeMake(550, 250);
                    popoverView.delegate = self;
                    popoverView.ticketID = selectedCell.tag;
                    CGRect frame = sender.frame;
                    frame.origin.y += 20;
                    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
                    transfer = false;
                }
                else
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic For Ipad" message:@"Ticket can not be transferred." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    transfer = false;
                    return;
                }
                
            }
        }
        
    }
}


- (IBAction)AllButtonPressed:(id)sender
{
    btnAll.titleLabel.font  = [UIFont boldSystemFontOfSize:15.0];
    btnReview.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    btnIncomplete.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    btnComplete.titleLabel.font  = [UIFont systemFontOfSize:15.0];
    [self.ticketData removeAllObjects];
    
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount , TI.InputValue as TicketAdminNotes from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID and TI.INPUTID = 1003 WHERE t.TicketOwner = %@ order by T.LocalTicketID desc", [g_SETTINGS objectForKey:@"UserID"]];
    
    
    
    @synchronized(g_SYNCDATADB)
    {
        self.ticketData = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    [self.mainTableView reloadData];
}

-(void) didTap
{
    PopoverViewController *p = (PopoverViewController *)self.popover.contentViewController;
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    if(functionSelected == 1)
    {
        
        if(p.rowSelected == 0)
        {
            g_NEWTICKET = YES;
            [g_SETTINGS setObject:@"NO" forKey:@"TicketPractice"];
            [g_SETTINGS setObject:@"1" forKey:@"TicketStatus"];
            newTicket = YES;
            CFUUIDRef uuidRef = CFUUIDCreate(NULL);
            CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
            NSString *uuid = (__bridge NSString *) uuidStringRef;
            [g_SETTINGS setObject:uuid forKey:@"currentTicketGUID"];
            NSInteger ticketID;
            @synchronized(g_SYNCDATADB)
            {
                ticketID = [DAO getNewTicketID:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
            }
            [g_SETTINGS setObject:[NSString stringWithFormat:@"%d", ticketID] forKey:@"currentTicketID"];
            @synchronized(g_SYNCDATADB)
            {
                [DAO createNewTicket:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] TicketID:ticketID TicketPractice:0 TicketGUID:uuid];
            }
            CFRelease(uuidStringRef);
            //    [self performSegueWithIdentifier:@"MainToTabSegue" sender:self._sender];
            [self performSegueWithIdentifier:@"MainToTabSegue" sender:self._sender];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sure" message:@"Are you sure you want to create a PRACTICE ticket?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            alert.tag = 1;
            [alert show];
        }
    }
    else if(functionSelected == 2)
    {
        if(p.rowSelected == 0)
        {
            if([MFMailComposeViewController canSendMail] == NO)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Mail Accounts" message:@"Please set up a Mail account in order to send email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
                
                mailController.mailComposeDelegate = self;
                
                NSString *sSubject = @" Contact Support";
                [mailController setSubject:sSubject];
                
                [mailController setToRecipients:[NSArray arrayWithObject:@"FHMedicforiPad@xerox.com"]];
                
                
                [self presentModalViewController:mailController animated:YES];
            }

        }
        else  if(p.rowSelected == 1)
        {
            UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                          bundle:nil];
            
            WebViewController *Webview = [sb instantiateViewControllerWithIdentifier:@"WebViewController"];
            [self presentModalViewController:Webview animated:YES];

        }
        else if(p.rowSelected == 2)
        {
            NSString *phoneCallNum = [NSString stringWithFormat:@"tel://8009215300" ];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
        }
    }
    
}

- (void) doneTransfer
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    ticketRowSelected = -1;
    [self refreshView];
}

- (void) cancelTransfer
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}


- (IBAction)btnNewTicketClick:(UIButton *)sender {
    self._sender = sender;
    g_NEWTICKET = YES;
    newTicket = YES;

    
    NSMutableArray *arrSetting = [[NSMutableArray alloc] initWithObjects:@"New Report", @"New Practice Report", nil];
    
    functionSelected = 1;
    PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    popoverView.functionSelected = 5;
    
    popoverView.arrays = arrSetting;
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(250, 100);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

}


- (IBAction)btnEditTicketClick:(id)sender {

    if (ticketRowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Select Ticket" message:@"Please select a ticket below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Select TicketStatus from Tickets where TicketID = %d", selectedCell.tag ];
        NSString* status;
        @synchronized(g_SYNCDATADB)
        {
            status = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if ([status intValue] == 2)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ticket Completed" message:@"This ticket has been completed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        g_NEWTICKET = NO;
        newTicket = NO;
        [g_SETTINGS setObject:status forKey:@"TicketStatus"];
        [g_SETTINGS setObject:[NSString stringWithFormat:@"%d", selectedCell.tag] forKey:@"currentTicketID"];

        [self performSegueWithIdentifier:@"MainToTabSegue" sender:self._sender];
    }
    
}

- (IBAction)btnViewPCRClick:(id)sender {
    if (ticketRowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Select Ticket" message:@"Please select a ticket below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        g_NEWTICKET = NO;
        newTicket = NO;
        
        [g_SETTINGS setObject:[NSString stringWithFormat:@"%d", selectedCell.tag] forKey:@"currentTicketID"];
        
        [self performSegueWithIdentifier:@"MainToPCRSegue" sender:self._sender];
    }
}

- (IBAction)btnHelpClick:(UIButton *)sender
{
    self._sender = sender;
    
    NSString* version = [NSString stringWithFormat:@"Version: %@",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
    NSMutableArray *arrSetting = [[NSMutableArray alloc] initWithObjects:@"Contact Support", @"Web Link", @"Phone Number- 800-921-5300,2", version, nil];
    
    functionSelected = 2;
    PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    popoverView.functionSelected = 5;
    
    popoverView.arrays = arrSetting;
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(300, 200);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (IBAction)doneButtonPressed:(id)sender
{

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Quit" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 5;
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
    
    else if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            g_NEWTICKET = YES;
            newTicket = YES;
            CFUUIDRef uuidRef = CFUUIDCreate(NULL);
            CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
            NSString *uuid = (__bridge NSString *) uuidStringRef;            
            [g_SETTINGS setObject:uuid forKey:@"currentTicketGUID"];
            [g_SETTINGS setObject:@"Practice:" forKey:@"TicketPractice"];          
            NSInteger ticketID;
            @synchronized(g_SYNCDATADB)
            {
               ticketID = [DAO getNewTicketID:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
            }
            [g_SETTINGS setObject:[NSString stringWithFormat:@"%d", ticketID] forKey:@"currentTicketID"];
            [g_SETTINGS setObject:@"1" forKey:@"TicketStatus"];
            @synchronized(g_SYNCDATADB)
            {
                [DAO createNewTicket:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] TicketID:ticketID TicketPractice:1 TicketGUID:uuid];
            }
/*            @synchronized(syncQueueDB)
            {
                [DAO insertDataToQueue:[[g_SETTINGS objectForKey:@"queueDB"] pointerValue] Table:@"Tickets" TicketID:ticketID Data:data];
            } */
            
            CFRelease(uuidStringRef);
            [self performSegueWithIdentifier:@"MainToTabSegue" sender:self._sender];
        }
        else
        {
            
        }
    }
    else  if (alertView.tag == 3)
    {
        if (buttonIndex == 0) // Discard
        {

        }
        else if (buttonIndex == 1)  // Create Edit
        {
            [self saveNewTicket:false];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIF_Dismiss" object:nil];
            [self refreshView];
            for (int i = 0; i < [self.ticketData count]; i++)
            {
                ClsTickets* ticket = [self.ticketData objectAtIndex:i];
                if (ticket.ticketID == [cadData.ticketID integerValue])
                {
                    ticketRowSelected = i;
                    break;
                }
            }
            
            NSString* sqlStr = [NSString stringWithFormat:@"Select TicketStatus from Tickets where TicketID = %@", cadData.ticketID ];
            NSString* status;
            @synchronized(g_SYNCDATADB)
            {
                status = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            g_NEWTICKET = NO;
            newTicket = NO;
            [g_SETTINGS setObject:status forKey:@"TicketStatus"];
            [g_SETTINGS setObject:[NSString stringWithFormat:@"%@", cadData.ticketID] forKey:@"currentTicketID"];
            [self setUploadStatus];
            [self performSegueWithIdentifier:@"MainToTabViewSeque" sender:self._sender];
            
        }
        else if (buttonIndex == 2)   //create Stay
        {
            [self saveNewTicket:true];
            [self setUploadStatus];
            [self refreshView];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CADUPDATE" object:nil];
        }
        else  if (buttonIndex == 3)  //Merge
        {
            NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount , TI.InputValue, TI.InputName as TicketAdminNotes from Tickets T left join TicketInputs TI on T.TicketID = TI.TicketID and TI.INPUTID = 1003 WHERE t.TicketOwner = %@  order by t.ticketID DESC", [g_SETTINGS objectForKey:@"UserID"]];
            
            
            @synchronized(g_SYNCDATADB)
            {
                self.ticketIncident = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if ([self.ticketIncident count] > 0)
            {
                mergeRowSelected = -1;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"Select an incident to merge" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
                UITableView* myTableView = [[UITableView alloc] initWithFrame:CGRectMake(11, 50, 261, 400) style:UITableViewStylePlain];
                myTableView.scrollEnabled = YES;
                myTableView.tag = 1;
                [myTableView setDelegate:self];
                [myTableView setDataSource:self];
                av.tag = 4;
                [av setValue:myTableView forKey:@"accessoryView"];
                [av show];
                
            }
            else
            {
                UIAlertView* incidentView = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"No incomplete ticket to merge" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [incidentView show];
            }
        }
        
    }
    else  if (alertView.tag == 4)
    {
        if (buttonIndex == 0)
        {
            return;
        }
        else if (buttonIndex == 1)
        {
            if (mergeRowSelected < 0)
            {
                UIAlertView* incidentView = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"CAD data was not merged since you did not select a row." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [incidentView show];
            }
            else
            {
                ClsTickets* ticket = [self.ticketIncident objectAtIndex:mergeRowSelected];
                [self mergeTicket:[NSString stringWithFormat:@"%ld", ticket.ticketID]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CADUPDATE" object:nil];
                 UIAlertView* incidentView = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"CAD data was merged." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [incidentView show];
            }
        }
    }
    else if (alertView.tag == 5)
    {
        if (buttonIndex == 1)
        {
            logoutStatus = true;
            while (backupStart == 1)
            {
                sleep(.5);
            }
            [self.g_BACKUPTIMER invalidate];
            self.g_BACKUPTIMER = nil;
            [g_CLEANUP invalidate];
            g_CLEANUP = nil;
            [mapTimer invalidate];
            mapTimer = nil;
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            self.mapview.mapType = MKMapTypeSatellite;
            [self.mapview removeFromSuperview];
            self.mapview = nil;
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            logoutStatus = false;
        }
            
    }

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
/*    if ([[segue identifier] isEqualToString:@"MainToTabSegue"]) {
        
        UITabBarController *tabController  = (UITabBarController *)segue.destinationViewController;        
        SceneViewController* nextVC = (SceneViewController*)[[tabController customizableViewControllers ]objectAtIndex:0];
        nextVC.newTicket = newTicket;
    }
    
    if ([[segue identifier] isEqualToString:@"MainToTabViewSeque"]) {
        
        TabViewController *tabViewController  = (TabViewController *)segue.destinationViewController;
//        IncidentViewController* nextVC = (IncidentViewController*)[[tabViewController customizableViewControllers ]objectAtIndex:0];
        tabViewController.newTicket = newTicket;
        if(newTicket == NO)
        {
            ClsTickets* ticket = [ticketData objectAtIndex:ticketRowSelected];
            if([ticket.ticketType isEqualToString:@"CallTimes"])
            {
                [tabViewController infiniTabBar:tabViewController.tabBar didSelectItemWithTag:2];
            }
        }
        
    } */
}


-(void) viewWillDisappear:(BOOL)animated
{
    self.ticketData = nil;
    self.popover = nil;
    self.toolBar1 = nil;
    self.toolBar = nil;
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0)
    {
        return [ticketData count];
    }
    else
    {
        return [ticketIncident count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0)
    {
        static NSString *simpleTableIdentifier = @"TicketInfoCell";
        
        TicketDataInfoCell *cell = (TicketDataInfoCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TicketInfoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            // cell = [[TicketDataInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:50/255.0 green:158/255.0 blue:174/255.0 alpha:0.5];
            cell.selectedBackgroundView =  customColorView;
            
            //customColorView = nil;
        }
        
        //  NSLog(@"indexPath.row : %d", indexPath.row % 2);
        
        
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = [UIColor whiteColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.5];
            
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:0.5];
            cell.backgroundView = customColorView;
            
            customColorView = nil;
        }
        
        
        
        ClsTickets* ticket = [ticketData objectAtIndex:indexPath.row];
        cell.incidentNumber.text =  [self removeNull:ticket.ticketIncidentNumber];
        if(ticket.ticketStatus == 1 || ticket.ticketStatus == 4)
        {
            cell.image.image = [UIImage imageNamed:@"red_indicator.png"];
        }
        else if(ticket.ticketStatus == 2)
        {
            cell.image.image = [UIImage imageNamed:@"green_indicator.png"];
            
        }
        else
        {
            cell.image.image = [UIImage imageNamed:@"blue_indicator.png"];
            
        }
        if ([ticket.ticketDOS length] >= 10)
        {
            if ([ticket.ticketDOS rangeOfString:@"-"].location != NSNotFound)
            {
                NSDateFormatter* format = [[NSDateFormatter alloc]init];
                [format setDateFormat:@"yyyy-MM-dd"];
                NSDate* date = [format dateFromString:[ticket.ticketDOS substringToIndex:10]];
                [format setDateFormat:@"MM/dd/yyyy"];
                cell.incidentDate.text = [format stringFromDate:date];
                
            }
            else
            {
                cell.incidentDate.text = [ticket.ticketDOS substringToIndex:10];
            }
        }
        
        if (btnSegmentedControl.selectedSegmentIndex == 1)
        {
            if ([ticket.ticketDesc length] > 0 && ([ticket.ticketDesc rangeOfString:@"(null)"].location == NSNotFound))
            {
                cell.address.text = ticket.ticketDesc;
            }
            else
            {
                cell.address.text = @"";
            }
            
        }
        else
        {
            cell.address.text = ticket.ticketAdminNotes;
        }
       // cell.unit.text = [NSString stringWithFormat:@"%d",ticket.ticketUnitNumber];
        bool found = false;
        for (int j = 0; j< [unitsArray count]; j++)
        {
            ClsUnits* unit = [unitsArray objectAtIndex:j];
            if (unit.unitID == ticket.ticketUnitNumber)
            {
                cell.unit.text = unit.unitDescription;
                found = true;
            }
        }
        if (!found)
        {
            cell.unit.text = [g_SETTINGS objectForKey:@"UnitName"];
        }
        cell.tag = ticket.ticketID;
        return cell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }

        ClsTickets* ticket = [ticketIncident objectAtIndex:indexPath.row];
        cell.textLabel.text = ticket.ticketIncidentNumber;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if (tableView.tag == 0)
    {
        ticketRowSelected = indexPath.row;
        selectedCell = (TicketDataInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
    }
    else
    {
        mergeRowSelected = indexPath.row;
    }

}

#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    toolBar1.tintColor = [UIColor blackColor];
    
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - admin message


- (void) saveNewTicket:(bool) stay
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    NSString *uuid = (__bridge NSString *) uuidStringRef;
    CFRelease(uuidStringRef);
    NSInteger ticketID;
    @synchronized(g_SYNCDATADB)
    {
        ticketID = [DAO getNewTicketID:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
        [DAO createNewTicket:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] TicketID:ticketID TicketPractice:0 TicketGUID:uuid];
        cadData.ticketID = [NSString stringWithFormat:@"%d", ticketID];
        NSString* sqlStr = [NSString stringWithFormat:@"Update tickets set isUploaded = 1 where ticketID = %d", ticketID];
        
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
    }
    
    [self saveSceneTab];
    [self saveCallTimeTab];
    [self savePatientTab];
    [self saveOutcomeTab];
    if (stay)
    {
        NSString* mesg = [NSString stringWithFormat:@"CAD Admin ticket created for Incident #: %@", cadData.incidentNum];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:mesg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag = 1;
        [alert show];
    }
}


- (void) setUploadStatus
{
    NSString* sql = [NSString stringWithFormat:@"Update tickets set isUploaded = 0 where ticketID = %@", cadData.ticketID];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    sql = [NSString stringWithFormat:@"Update ticketInputs set isUploaded = 0 where ticketID = %@", cadData.ticketID];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }

}



- (void) saveSceneTab
{
    NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1002, 0, 1, @"", @"", cadData.incidentDate];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    if (cadData.acccountCode.length > 0)
    {
        sqlStr = [NSString stringWithFormat:@"Update Tickets set TicketIncidentNumber = '%@', ticketAccount = %@, IsUploaded = 1 where TicketID = %@", cadData.incidentNum, cadData.acccountCode,cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    else
    {
        sqlStr = [NSString stringWithFormat:@"Update Tickets set TicketIncidentNumber = '%@', IsUploaded = 1 where TicketID = %@", cadData.incidentNum, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1001, 0, 1, @"", @"", cadData.incidentNum];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1009, 0, 1, @"", @"", @""];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1401, 0, 1, @"", @"", @""];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1003, 0, 1, @"", @"", cadData.IncidentAddress];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1004, 0, 1, @"", @"", cadData.IncidentCity];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1005, 0, 1, @"", @"", cadData.IncidentState];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1006, 0, 1, @"", @"", cadData.IncidentZip];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1007, 0, 1, @"", @"", @""];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1011, 0, 1, @"", @"", cadData.PickupFacilityCode];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1050, 0, 1, @"", @"", @""];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    
    
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 20805, 0, 1, @"", @"", @""];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 20302, 0, 1, @"", @"", @""];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 20303, 0, 1, @"", @"", @""];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1070, 0, 1, @"", @"", cadData.ChiefComplaint];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 20813, 0, 1, @"", @"", @""];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1080, 0, 1, @"", @"", cadData.StreetNumber];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1081, 0, 1, @"", @"", cadData.StreetPrefix];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1082, 0, 1, @"", @"", cadData.StreetName];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1083, 0, 1, @"", @"", cadData.StreetType];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1084, 0, 1, @"", @"", cadData.StreetSuffix];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1021, 0, 1, @"", @"", cadData.IncidentAddress2];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1022, 0, 1, @"", @"", cadData.Notes];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 9010, 0, 1, @"", @"", cadData.Latitude];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 9011, 0, 1, @"", @"", cadData.Longitude];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
}


- (void) saveCallTimeTab
{
    @synchronized(g_SYNCDATADB)
    {
        NSString*  sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@ %@', 1)", cadData.ticketID, 1040, 0, 1, @"", @"CallTimes", cadData.DispatchDate, cadData.DispatchTime];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@ %@', 1)", cadData.ticketID, 1041, 0, 1, @"", @"CallTimes", cadData.EnrouteDate, cadData.EnrouteTime];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@ %@', 1)", cadData.ticketID, 1042, 0, 1, @"", @"CallTimes", cadData.AtSceneDate, cadData.AtSceneTime];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@ %@', 1)", cadData.ticketID, 1047, 0, 1, @"", @"CallTimes", cadData.AtPatientDate, cadData.AtPatientTime];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@ %@', 1)", cadData.ticketID, 1043, 0, 1, @"", @"CallTimes", cadData.ToDestDate, cadData.ToDestTime];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@ %@', 1)", cadData.ticketID, 1044, 0, 1, @"", @"CallTimes", cadData.AtDestDate, cadData.AtDestTime];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@ %@', 1)", cadData.ticketID, 1045, 0, 1, @"", @"CallTimes", cadData.TransferPatientDate, cadData.TransferPatientTime];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@ %@', 1)", cadData.ticketID, 1046, 0, 1, @"", @"CallTimes", cadData.ClearDate, cadData.ClearTime];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1060, 0, 1, @"", @"CallTimes", cadData.OdometerAtScene];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1061, 0, 1, @"", @"CallTimes", cadData.OdometerPatientDestination];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 9050, 0, 1, @"", @"CallTimes", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1067, 0, 1, @"", @"CallTimes", cadData.OdometerResponding];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1066, 0, 1, @"", @"CallTimes", cadData.OdometerClear];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1550, 0, 1, @"", @"CallTimes", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1551, 0, 1, @"", @"CallTimes", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1552, 0, 1, @"", @"CallTimes", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1553, 0, 1, @"", @"CallTimes", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1554, 0, 1, @"", @"CallTimes", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
    }
    
    NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@ %@', 1)", cadData.ticketID, 1048, 0, 1, @"", @"", cadData.CallReceivedDate, cadData.CallReceivedTime];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1051, 0, 1, @"", @"", cadData.CallReceivedDate];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1052, 0, 1, @"", @"", cadData.DispatchDate];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1053, 0, 1, @"", @"", cadData.EnrouteDate];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1054, 0, 1, @"", @"", cadData.AtSceneDate];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1055, 0, 1, @"", @"", cadData.AtPatientDate];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1056, 0, 1, @"", @"", cadData.ToDestDate];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1057, 0, 1, @"", @"", cadData.AtDestDate];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1059, 0, 1, @"", @"", cadData.ClearDate];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1058, 0, 1, @"", @"", cadData.TransferPatientDate];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
}

- (void) savePatientTab
{
    @synchronized(g_SYNCDATADB)
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1101, 0, 1, @"", @"", cadData.PTLastName];
        
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1102, 0, 1, @"", @"", cadData.PTFirstName];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1118, 0, 1, @"", @"", cadData.PTMI];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1107, 0, 1, @"", @"", cadData.PTAddress];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1108, 0, 1, @"", @"", cadData.PTAddress2];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1109, 0, 1, @"", @"", cadData.PTCity];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1110, 0, 1, @"", @"", cadData.PTState];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1112, 0, 1, @"", @"", cadData.PTZip];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1133, 0, 1, @"", @"", cadData.PTSSN];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1105, 0, 1, @"", @"", cadData.PTSex];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1104, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1119, 0, 1, @"", @"", cadData.PTAge];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1103, 0, 1, @"", @"", cadData.PTDOB];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1106, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1130, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1134, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1135, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1131, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1132, 0, 1, @"", @"", cadData.PTWeight];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 20613, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1111, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1110, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
    }
}


- (void) saveOutcomeTab
{
    @synchronized(g_SYNCDATADB)
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1402, 0, 1, @"", @"", cadData.DestFacilityCode];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1403, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1420, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1421, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1422, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1423, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1424, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1425, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1426, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1427, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1428, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1434, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 22011, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 22012, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 22013, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 22014, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1228, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1029, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1429, 0, 1, @"", @"", @""];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
    }
    
    NSString* sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1033, 0, 1, @"", @"", cadData.secondaryNumber];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1030, 0, 1, @"", @"", cadData.toIncidentCode];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1031, 0, 1, @"", @"", cadData.ToDestinationCode];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1032, 0, 1, @"", @"", cadData.TransportReason];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 9004, 0, 1, @"", @"", cadData.PickupFacilityCode];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1702, 0, 1, @"", @"", cadData.DestAddress];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1703, 0, 1, @"", @"", cadData.DestAddress2];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1704, 0, 1, @"", @"", cadData.DestZip];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1705, 0, 1, @"", @"", cadData.DestCity];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1706, 0, 1, @"", @"", cadData.DestState];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
}

- (void) mergeTicket:(NSString*) ticketNo
{
    
    cadData.ticketID = ticketNo;
    NSString* cadOverwriteSql = @"Select SettingValue from Settings where SettingDesc = 'CADInputsToOverwrite'";
    NSString* cadOverwriteStr;
    @synchronized(g_SYNCLOOKUPDB)
    {
        cadOverwriteStr = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:cadOverwriteSql];
    }
    
    [self mergeScene:cadOverwriteStr];
    [self mergeCallTimes:cadOverwriteStr];
    [self mergePatient:cadOverwriteStr];
    [self mergeOutcome:cadOverwriteStr];
    NSString* sql = [NSString stringWithFormat:@"Update tickets set isUploaded = 0 where ticketID = %@", cadData.ticketID];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    sql = [NSString stringWithFormat:@"Update ticketInputs set isUploaded = 0 where ticketID = %@", cadData.ticketID];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    [self refreshView];

}


- (void) mergeScene:(NSString*) cadOverwriteSql
{

    if (cadData.acccountCode.length > 0)
    {
        NSString* sql = [NSString stringWithFormat:@"Select ticketAccount from tickets where ticketID = %@", cadData.ticketID];
        NSString* value;
        @synchronized(g_SYNCDATADB)
        {
           value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        if (value.length < 1)
        {
            NSString* sqlStr = [NSString stringWithFormat:@"Update Tickets set ticketAccount = %@, IsUploaded = 1 where TicketID = %@",cadData.acccountCode, cadData.ticketID];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }

        }
    }
    
    if (cadData.incidentNum.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1001, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1001, 0, 1, @"", @"", cadData.incidentNum];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            sqlStr = [NSString stringWithFormat:@"Update Tickets set TicketIncidentNumber = '%@', IsUploaded = 1 where TicketID = %@", cadData.incidentNum, cadData.ticketID];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1001", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1001", cadData.incidentNum, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                sqlStr = [NSString stringWithFormat:@"Update Tickets set TicketIncidentNumber = '%@', IsUploaded = 1 where TicketID = %@", cadData.incidentNum, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1001"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1001", cadData.incidentNum, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    sqlStr = [NSString stringWithFormat:@"Update Tickets set TicketIncidentNumber = '%@', IsUploaded = 1 where TicketID = %@", cadData.incidentNum, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    

    if (cadData.incidentDate.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1002, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1002, 0, 1, @"", @"", cadData.incidentDate];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }

        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1002", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1002", cadData.incidentDate, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }

            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1002"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1002", cadData.incidentDate, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
    
    NSString* sql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1009, cadData.ticketID];
    NSInteger tempCount;
    @synchronized(g_SYNCDATADB)
    {
        tempCount =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (tempCount < 1)
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1009, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    
    sql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1401, cadData.ticketID];
    @synchronized(g_SYNCDATADB)
    {
        tempCount =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (tempCount < 1)
    {
        NSString*  sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1401, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    
    
    if (cadData.IncidentAddress.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1003, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1003, 0, 1, @"", @"", cadData.IncidentAddress];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1003", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1003", cadData.IncidentAddress, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1003"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1003", cadData.IncidentAddress, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    

    
    
    if (cadData.IncidentCity.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1004, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1004, 0, 1, @"", @"", cadData.IncidentCity];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1004", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1004", cadData.IncidentCity, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1004"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1004", cadData.IncidentCity, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    

    if (cadData.IncidentState.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1005, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*      sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1005, 0, 1, @"", @"", cadData.IncidentState];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1005", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1005", cadData.IncidentState, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1005"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1005", cadData.IncidentState, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    

    if (cadData.IncidentZip.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1006, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1006, 0, 1, @"", @"", cadData.IncidentZip];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1006", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1006", cadData.IncidentZip, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1006"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1006", cadData.IncidentZip, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
    
    sql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1007, cadData.ticketID];
    @synchronized(g_SYNCDATADB)
    {
        tempCount =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (tempCount < 1)
    {
        NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1007, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    
    
    if (cadData.PickupFacilityCode.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1011, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1011, 0, 1, @"", @"", cadData.PickupFacilityCode];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1011", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1011", cadData.PickupFacilityCode, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1011"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1011", cadData.PickupFacilityCode, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
    
    sql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1050, cadData.ticketID];
    @synchronized(g_SYNCDATADB)
    {
        tempCount =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (tempCount < 1)
    {
        NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1050, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }

    sql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 20805, cadData.ticketID];
    @synchronized(g_SYNCDATADB)
    {
        tempCount =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (tempCount < 1)
    {
        NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 20805, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    
    sql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 20302, cadData.ticketID];
    @synchronized(g_SYNCDATADB)
    {
        tempCount =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (tempCount < 1)
    {
        NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 20302, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    
    sql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 20303, cadData.ticketID];
    @synchronized(g_SYNCDATADB)
    {
        tempCount =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (tempCount < 1)
    {
        NSString*      sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 20303, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    
    
    if (cadData.ChiefComplaint.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1070, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1070, 0, 1, @"", @"", cadData.ChiefComplaint];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1070", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1070", cadData.ChiefComplaint, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1070"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1070", cadData.ChiefComplaint, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
    
    sql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 20813, cadData.ticketID];
    @synchronized(g_SYNCDATADB)
    {
        tempCount =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (tempCount < 1)
    {
        NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 20813, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    
    
    if (cadData.StreetNumber.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1080, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1080, 0, 1, @"", @"", cadData.StreetNumber];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1080", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1080", cadData.StreetNumber, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1080"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1080", cadData.StreetNumber, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
    if (cadData.StreetPrefix.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1081, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1081, 0, 1, @"", @"", cadData.StreetPrefix];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1081", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1081", cadData.StreetPrefix, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1081"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1081", cadData.StreetPrefix, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
    
    if (cadData.StreetName.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1082, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*     sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1082, 0, 1, @"", @"", cadData.StreetName];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1082", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1082", cadData.StreetName, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1082"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1082", cadData.StreetName, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
    
    if (cadData.StreetType.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1083, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1083, 0, 1, @"", @"", cadData.StreetType];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1083", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1083", cadData.StreetType, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1083"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1083", cadData.StreetType, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
    if (cadData.StreetSuffix.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1084, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1084, 0, 1, @"", @"", cadData.StreetSuffix];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1084", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1084", cadData.StreetSuffix, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1084"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1084", cadData.StreetSuffix, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }

    
    if (cadData.IncidentAddress2.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1021, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1021, 0, 1, @"", @"", cadData.IncidentAddress2];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1021", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1021", cadData.IncidentAddress2, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1021"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1021", cadData.IncidentAddress2, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
    
    if (cadData.Notes.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1022, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1022, 0, 1, @"", @"", cadData.Notes];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 1022", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1022", cadData.IncidentAddress2, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"1022"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 1022", cadData.IncidentAddress2, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
    
    if (cadData.Latitude.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 9010, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 9010, 0, 1, @"", @"", cadData.Latitude];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 9010", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 9010", cadData.Latitude, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"9010"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 9010", cadData.Latitude, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
    
    if (cadData.Longitude.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 9011, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 9011, 0, 1, @"", @"", cadData.Longitude];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = 9011", cadData.ticketID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 9011", cadData.Longitude, cadData.ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:@"9011"])
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = 9011", cadData.Longitude, cadData.ticketID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
}



- (void) mergeData:(NSString*) data inputNum:(NSInteger) inputID CadStr:(NSString*) cadOverwriteSql
{
    if (data.length > 0)
    {
        NSInteger count;
        
        NSString* countSql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %ld and ticketID = %@", inputID, cadData.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO  getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:countSql];
        }
        if (count < 1) // row doesnt exist
        {
            NSString*    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %ld, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, inputID, 0, 1, @"", @"", data];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            NSString* sql = [NSString stringWithFormat:@"Select inputvalue from ticketinputs where ticketID = %@ and inputID = %ld", cadData.ticketID, inputID];
            NSString* value;
            
            @synchronized(g_SYNCDATADB)
            {
                value = [DAO  executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (value.length < 1)   // exist but no data
            {
                NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = %ld", data, cadData.ticketID, inputID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
                
            }
            else  // exist with data
            {
                if ([cadOverwriteSql containsString:[NSString stringWithFormat:@"%ld", inputID]])
                    
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 1 where TicketID = %@ and InputID = %ld", data, cadData.ticketID, inputID];
                    @synchronized(g_SYNCDATADB)
                    {
                        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    }
                    
                }
            }
            
        }
        
    }
    
}


- (void) mergeCallTimes:(NSString*) cadOverwriteSql
{

    [self mergeData:[NSString stringWithFormat:@"%@ %@", cadData.DispatchDate, cadData.DispatchTime] inputNum:1040 CadStr:cadOverwriteSql];
    
    [self mergeData:[NSString stringWithFormat:@"%@ %@",cadData.EnrouteDate,  cadData.EnrouteTime] inputNum:1041 CadStr:cadOverwriteSql];
    
    [self mergeData:[NSString stringWithFormat:@"%@ %@",cadData.AtSceneDate,  cadData.AtSceneTime] inputNum:1042 CadStr:cadOverwriteSql];

    [self mergeData:[NSString stringWithFormat:@"%@ %@",cadData.ToDestDate,  cadData.ToDestTime] inputNum:1043 CadStr:cadOverwriteSql];
    
     [self mergeData:[NSString stringWithFormat:@"%@ %@",cadData.AtDestDate,  cadData.AtDestTime] inputNum:1044 CadStr:cadOverwriteSql];
    
    [self mergeData:[NSString stringWithFormat:@"%@ %@",cadData.TransferPatientDate,  cadData.TransferPatientTime] inputNum:1045 CadStr:cadOverwriteSql];
    [self mergeData:[NSString stringWithFormat:@"%@ %@",cadData.ClearDate,  cadData.ClearTime] inputNum:1046 CadStr:cadOverwriteSql];
    [self mergeData:[NSString stringWithFormat:@"%@ %@",cadData.CallReceivedDate,  cadData.CallReceivedTime] inputNum:1048 CadStr:cadOverwriteSql];
    [self mergeData:[NSString stringWithFormat:@"%@ %@",@" ",  @" "] inputNum:1049 CadStr:cadOverwriteSql];
    [self mergeData:cadData.OdometerAtScene inputNum:1060 CadStr:cadOverwriteSql];
    
    [self mergeData:cadData.OdometerPatientDestination inputNum:1061 CadStr:cadOverwriteSql];
    
    
    
    
    NSString* sql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 9050, cadData.ticketID];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (count < 1)
    {
        NSString*sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 9050, 0, 1, @"", @"CallTimes", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1550, 0, 1, @"", @"CallTimes", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1551, 0, 1, @"", @"CallTimes", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1552, 0, 1, @"", @"CallTimes", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1553, 0, 1, @"", @"CallTimes", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1554, 0, 1, @"", @"CallTimes", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
 
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, IsUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1049, 0, 1, @"", @"CallTimes", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    
    
    [self mergeData:cadData.OdometerResponding inputNum:1067 CadStr:cadOverwriteSql];
    [self mergeData:cadData.OdometerClear inputNum:1066 CadStr:cadOverwriteSql];
   // [self mergeData:cadData.CallReceivedTime inputNum:1048 CadStr:cadOverwriteSql];
    [self mergeData:cadData.CallReceivedDate inputNum:1051 CadStr:cadOverwriteSql];
     [self mergeData:cadData.DispatchDate inputNum:1052 CadStr:cadOverwriteSql];
     [self mergeData:cadData.EnrouteDate inputNum:1053 CadStr:cadOverwriteSql];
     [self mergeData:cadData.AtSceneDate inputNum:1054 CadStr:cadOverwriteSql];
     [self mergeData:cadData.AtPatientDate inputNum:1055 CadStr:cadOverwriteSql];
     [self mergeData:cadData.ToDestDate inputNum:1056 CadStr:cadOverwriteSql];
     [self mergeData:cadData.AtDestDate inputNum:1057 CadStr:cadOverwriteSql];
     [self mergeData:cadData.ClearDate inputNum:1059 CadStr:cadOverwriteSql];
     [self mergeData:cadData.TransferPatientDate inputNum:1058 CadStr:cadOverwriteSql];
    
}

- (void) mergePatient:(NSString*) cadOverwriteSql
{
     [self mergeData:cadData.PTLastName inputNum:1101 CadStr:cadOverwriteSql];
     [self mergeData:cadData.PTFirstName inputNum:1102 CadStr:cadOverwriteSql];
     [self mergeData:cadData.PTMI inputNum:1118 CadStr:cadOverwriteSql];
     [self mergeData:cadData.PTAddress inputNum:1107 CadStr:cadOverwriteSql];
     [self mergeData:cadData.PTAddress2 inputNum:1108 CadStr:cadOverwriteSql];
     [self mergeData:cadData.PTCity inputNum:1109 CadStr:cadOverwriteSql];
     [self mergeData:cadData.PTState inputNum:1110 CadStr:cadOverwriteSql];
     [self mergeData:cadData.PTZip inputNum:1112 CadStr:cadOverwriteSql];
     [self mergeData:cadData.PTSSN inputNum:1133 CadStr:cadOverwriteSql];
     [self mergeData:cadData.PTSex inputNum:1105 CadStr:cadOverwriteSql];
    
    
    NSString* sql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1104, cadData.ticketID];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (count < 1)
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1104, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1119, 0, 1, @"", @"", cadData.PTAge];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1103, 0, 1, @"", @"", cadData.PTDOB];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1106, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1130, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1134, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1135, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1131, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1132, 0, 1, @"", @"", cadData.PTWeight];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 20613, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1111, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1110, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    
}


- (void) mergeOutcome:(NSString*) cadOverwriteSql
{
    
     [self mergeData:cadData.DestFacilityCode inputNum:1402 CadStr:cadOverwriteSql];
    
    NSString* sql = [NSString stringWithFormat:@"Select count(InputID) from ticketInputs where inputID = %d and ticketID = %@", 1403, cadData.ticketID];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if (count < 1)
    {
        
        NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1403, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1420, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1421, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1422, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1423, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1424, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1425, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1426, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1427, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1428, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1434, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 22011, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 22012, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 22013, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 22014, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1228, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1029, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, isUploaded) Values(0, %@, %d, %d, %d, '%@', '%@', '%@', 1)", cadData.ticketID, 1429, 0, 1, @"", @"", @""];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
        }
        
    }
    
     [self mergeData:cadData.secondaryNumber inputNum:1033 CadStr:cadOverwriteSql];
     [self mergeData:cadData.toIncidentCode inputNum:1030 CadStr:cadOverwriteSql];
     [self mergeData:cadData.ToDestinationCode inputNum:1031 CadStr:cadOverwriteSql];
     [self mergeData:cadData.TransportReason inputNum:1032 CadStr:cadOverwriteSql];
     [self mergeData:cadData.PickupFacilityCode inputNum:9004 CadStr:cadOverwriteSql];
     [self mergeData:cadData.DestAddress inputNum:1702 CadStr:cadOverwriteSql];
     [self mergeData:cadData.DestAddress2 inputNum:1703 CadStr:cadOverwriteSql];
     [self mergeData:cadData.DestZip inputNum:1704 CadStr:cadOverwriteSql];
     [self mergeData:cadData.DestCity inputNum:1705 CadStr:cadOverwriteSql];
     [self mergeData:cadData.DestState inputNum:1706 CadStr:cadOverwriteSql];

    
}


- (void) downloadIncompleteTicketFormsInputs
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetIncompTicketForms *req = [[ServiceSvc_GetIncompTicketForms alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetIncompTicketFormsUsingParameters:req];
            
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetIncompTicketFormsResponse class]])
                {
                    ServiceSvc_ArrayOfClsTicketFormsInputs* resultArray = [mine GetIncompTicketFormsResult];
                    NSMutableArray* array = [resultArray ClsTicketFormsInputs];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTicketFormsInputs* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* FormID = [record valueForKey:@"FormID"];
                        NSString* FormInputID = [record valueForKey:@"InputSubID"];
                        
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FormID = %@ and FormInputID = %@", TicketID , FormID, FormInputID];
                        
                        NSInteger count;
                        @synchronized(g_SYNCDATADB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* FormInputValue = [self removeNull:[record valueForKey:@"FormInputValue"]];
                            
                            NSString* Deleted = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Deleted"]]];
                            NSString* Modified = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Modified"]]];
                            
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, Deleted, Modified, IsUploaded) Values(0, %@, %@, %@,'%@', %@, %@, 1)", TicketID, FormID, FormInputID, FormInputValue, Deleted, Modified];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            
        }
    }
}

- (void) downloadIncompleteTicketChanges
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
  
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetIncompTicketChanges *req = [[ServiceSvc_GetIncompTicketChanges alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetIncompTicketChangesUsingParameters:req];
            
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetIncompTicketChangesResponse class]])
                {
                    ServiceSvc_ArrayOfClsTicketChanges* resultArray = [mine GetIncompTicketChangesResult];
                    NSMutableArray* array = [resultArray ClsTicketChanges];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTicketChanges* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* ChangeID = [record valueForKey:@"ChangeID"];
                        NSString* ChangeInputID = [record valueForKey:@"ChangeInputID"];
                        
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketChanges where TicketID = %@ and ChangeID = %@ and ChangeInputID = %@", TicketID , ChangeID, ChangeInputID];
                        
                        NSInteger count;
                        @synchronized(g_SYNCDATADB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* ChangeMade = [self removeNull:[record valueForKey:@"ChangeMade"]];
                            NSString* ChangeTime = [self removeNull:[record valueForKey:@"ChangeTime"]];
                            NSString* OriginalValue = [self removeNull:[record valueForKey:@"OriginalValue"]];
                            NSString* ModifiedBy = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"ModifiedBy"]]];
                            
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into TicketChanges(LocalTicketID, TicketID, ChangeID, ChangeInputID, ChangeMade, ChangeTime, OriginalValue, ModifiedBy, IsUploaded) Values(0, %@, %@, %@,'%@', '%@', '%@', %@, 1)", TicketID, ChangeID, ChangeInputID, ChangeMade, ChangeTime, OriginalValue, ModifiedBy];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            
        }
    }
}


- (void) DownloadIncompleteNotes
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetIncompTicketNotes *req = [[ServiceSvc_GetIncompTicketNotes alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetIncompTicketNotesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetIncompTicketNotesResponse class]])
                {
                    ServiceSvc_ArrayOfClsTicketNotes* resultArray = [mine GetIncompTicketNotesResult];
                    NSMutableArray* array = [resultArray ClsTicketNotes];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTicketNotes* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* NoteUID = [record valueForKey:@"NoteUID"];
                        
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketNotes where TicketID = %@ and NoteUID = %@", TicketID , NoteUID];
                        
                        NSInteger count;
                        @synchronized(g_SYNCDATADB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* Note = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Note"]]];
                            
                            NSString* NoteTime = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"NoteTime"]]];
                            //                            NSString* Deleted = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Deleted"]]];
                            
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into TicketNotes(LocalTicketID, TicketID, NoteUID, Note, NoteTime, IsUploaded) Values(0, %@, %@, '%@', '%@', 1)", TicketID, NoteUID, Note, NoteTime];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            
        }
    }
}


- (void) DownloadIncompleteTicketInfo
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetIncompTickets *req = [[ServiceSvc_GetIncompTickets alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetIncompTicketsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetIncompTicketsResponse class]])
                {
                    ServiceSvc_ArrayOfClsTickets* resultArray = [mine GetIncompTicketsResult];
                    NSMutableArray* array = [resultArray ClsTickets];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTickets* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from Tickets where TicketID = %@", TicketID ];
                        
                        NSInteger count;
                        @synchronized(g_SYNCDATADB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* TicketGUID = [record valueForKey:@"TicketGUID"];
                            NSString* TicketIncidentNumber = [record valueForKey:@"TicketIncidentNumber"];
                            NSString* TicketDesc = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketDesc"]]];
                            NSString* TicketDOS = [self removeNull:[record valueForKey:@"TicketDOS"]];
                            NSString* TicketStatus = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketStatus"]]];
                            NSString* TicketOwner = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketOwner"]]];
                            NSString* TicketCreator = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketCreator"]]];
                            NSString* TicketUnitNumber = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketUnitNumber"]]];
                            NSString* TicketFinalized = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketFinalized"]]];
                            NSString* TicketDateFinalized = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketDateFinalized"]]];
                            NSString* TicketCrew = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketCrew"]]];
                            NSString* TicketPractice = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketPractice"]]];
                            NSString* TicketCreatedTime = [self removeNull:[record valueForKey:@"TicketCreatedTime"]];
                            NSString* TicketShift = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketShift"]]];
                            NSString* TicketLocked = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketLocked"]]];
                            NSString* TicketReviewed = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketReviewed"]]];
                            NSString* TicketAccount = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketAccount"]]];
                            NSString* TicketAdminNotes = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketAdminNotes"]]];
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into Tickets(TicketID, TicketGUID, TicketIncidentNumber, TicketDesc, TicketDOS, TicketStatus, TicketOwner, TicketCreator, TicketUnitNumber, TicketFinalized, TicketDateFinalized, TicketCrew, TicketPractice, TicketCreatedTime, TicketShift, TicketLocked, TicketReviewed, TicketAccount, TicketAdminNotes, IsUploaded) Values(%@, '%@', '%@','%@', '%@', %@, %@, %@, %@, %@, '%@', '%@', %@, '%@', %@, %@, %@, %@, '%@', 1)", TicketID, TicketGUID, TicketIncidentNumber, TicketDesc, TicketDOS, TicketStatus, TicketOwner, TicketCreator, TicketUnitNumber, TicketFinalized, TicketDateFinalized, TicketCrew, TicketPractice, TicketCreatedTime, TicketShift, TicketLocked, TicketReviewed, TicketAccount, TicketAdminNotes];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                        else
                        {
                            NSString* TicketPractice = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketPractice"]]];
                            
                            NSString* TicketShift = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketShift"]]];
                            NSString* TicketLocked = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketLocked"]]];
                            NSString* TicketReviewed = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketReviewed"]]];
                            NSString* TicketAccount = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketAccount"]]];
                            NSString* TicketAdminNotes = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketAdminNotes"]]];
                            NSString* TicketStatus = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TicketStatus"]]];
                            
                            NSString* sql = [NSString stringWithFormat:@"Update Tickets set TicketPractice = %@, TicketShift = %@, TicketLocked = %@, TicketReviewed = %@, TicketAdminNotes = '%@', TicketAccount = %@, TicketStatus = %@ where ticketID = %@", TicketPractice, TicketShift, TicketLocked, TicketReviewed, TicketAdminNotes, TicketAccount, TicketStatus, TicketID];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            
        }
    }
}

- (void) DownloadIncompleteTicketInputsInfo
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetIncompTicketInputs *req = [[ServiceSvc_GetIncompTicketInputs alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetIncompTicketInputsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetIncompTicketInputsResponse class]])
                {
                    ServiceSvc_ArrayOfClsTicketInputs* resultArray = [mine GetIncompTicketInputsResult];
                    NSMutableArray* array = [resultArray ClsTicketInputs];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTicketInputs* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* InputID = [record valueForKey:@"InputID"];
                        NSString* InputSubID = [record valueForKey:@"InputSubID"];
                        NSString* InputInstance = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputInstance"]]];
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = %@ and InputSubID = %@ and InputInstance = %@", TicketID , InputID, InputSubID, InputInstance];
                        
                        NSInteger count;
                        @synchronized(g_SYNCDATADB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* InputPage = [self removeNull:[record valueForKey:@"InputPage"]];
                            NSString* InputName = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputName"]]];
                            NSString* InputValue = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"InputValue"]]];
                            NSString* Deleted = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Deleted"]]];
                            NSString* Modified = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Modified"]]];
                            
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, Deleted, Modified, IsUploaded) Values(0, %@, %@, %@, %@, '%@', '%@', '%@', %@, %@, 1)", TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue, Deleted, Modified];
                            @synchronized(g_SYNCDATADB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            
        }
    }
}


- (void) DownloadIncompleteTicketAttachmentsInfo
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetIncompTicketAttachments *req = [[ServiceSvc_GetIncompTicketAttachments alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetIncompTicketAttachmentsUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetIncompTicketAttachmentsResponse class]])
                {
                    ServiceSvc_ArrayOfClsTicketAttachments* resultArray = [mine GetIncompTicketAttachmentsResult];
                    NSMutableArray* array = [resultArray ClsTicketAttachments];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTicketAttachments* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* AttachmentID = [record valueForKey:@"AttachmentID"];
                        
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketAttachments where TicketID = %@ and AttachmentID = %@", TicketID , AttachmentID];
                        
                        NSInteger count;
                        @synchronized(g_SYNCBLOBSDB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* FileType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"FileType"]]];
                            NSString* FileStr = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"FileStr"]]];
                            NSString* FileName = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"FileName"]]];
                            NSString* TimeAdded = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"TimeAdded"]]];
                            NSString* Deleted = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Deleted"]]];
                            
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into TicketAttachments(LocalTicketID, TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded, Deleted, IsUploaded) Values(0, %@, %@, '%@', '%@', '%@', '%@', %@, 1)", TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded, Deleted];
                            @synchronized(g_SYNCBLOBSDB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            
        }
    }
}


- (void) DownloadIncompleteTicketSignaturesInfo
{
    NSInteger result = 0;
    Reachability* hostReach = [Reachability reachabilityWithHostName:g_WEBSERVICE];
    BOOL connectionRequired= [hostReach connectionRequired];
    if (!connectionRequired)
    {
        @try {
            
            ServiceSoapBinding *binding = [[ServiceSvc ServiceSoapBinding] initWithAddress:g_WEBSERVICE];
            binding.logXMLInOut = NO;
            ServiceSvc_GetIncompTicketSignatures *req = [[ServiceSvc_GetIncompTicketSignatures alloc] init];
            req.User = [g_SETTINGS objectForKey:@"UserID"];
            req.CustomerID = [g_SETTINGS objectForKey:@"CustomerID"];
            req.MachineID = nil;
            req.Unit = [g_SETTINGS objectForKey:@"Unit"];
            ServiceSoapBindingResponse* resp = [binding GetIncompTicketSignaturesUsingParameters:req];
            for (id mine in resp.bodyParts)
            {
                if ([mine isKindOfClass:[ServiceSvc_GetIncompTicketSignaturesResponse class]])
                {
                    ServiceSvc_ArrayOfClsTicketSignatures* resultArray = [mine GetIncompTicketSignaturesResult];
                    NSMutableArray* array = [resultArray ClsTicketSignatures];
                    
                    for (int i = 0; i < [array count]; i++)
                    {
                        ServiceSvc_ClsTicketSignatures* record = [array objectAtIndex:i];
                        NSString* TicketID = [record valueForKey:@"TicketID"];
                        NSString* SignatureID = [record valueForKey:@"SignatureID"];
                        
                        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketSignatures where TicketID = %@ and SignatureID = %@", TicketID , SignatureID];
                        
                        NSInteger count;
                        @synchronized(g_SYNCBLOBSDB)
                        {
                            count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
                        }
                        if (count < 1)
                        {
                            NSString* SignatureType = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SignatureType"]]];
                            NSString* SignatureText = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SignatureText"]]];
                            NSString* SignatureString = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SignatureString"]]];
                            NSString* SignatureTime = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"SignatureTime"]]];
                            NSString* Deleted = [self removeNull:[NSString stringWithFormat:@"%@",[record valueForKey:@"Deleted"]]];
                            
                            
                            NSString* sql = [NSString stringWithFormat:@"Insert into TicketSignatures(LocalTicketID, TicketID, SignatureID, SignatureType, SignatureText, SignatureString, SignatureTime, Deleted, IsUploaded) Values(0, %@, %@, %@, '%@', '%@', '%@', %@, 1)", TicketID, SignatureID, SignatureType, SignatureText, SignatureString, SignatureTime, Deleted];
                            @synchronized(g_SYNCBLOBSDB)
                            {
                                [DAO executeInsert:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
                            }
                        }
                    }
                    result = 1;
                    
                }
            }
        }
        @catch (NSException *exception) {
            result = -1;
        }
        @finally {
            
        }
    }
}


@end
