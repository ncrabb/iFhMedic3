//
//  PatientViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "PatientViewController.h"
#import "global.h"
#import "DAO.h"
#import "ClsTableKey.h"
#import "ClsTickets.h"
#import "DDPopoverBackgroundView.h"  // Mani
#import <MobileCoreServices/MobileCoreServices.h>
#import "PopoverViewController.h"
#import "QAMessageViewController.h"
#import "ClsInputs.h"

#define USE_MWOVERLAY true

#include <mach/mach_host.h>
#import "BarcodeScanner.h"


#if USE_MWOVERLAY
#import "MWOverlay.h"
#endif

#define PDF_OPTIMIZED true

// !!! Rects are in format: x, y, width, height !!!
#define RECT_LANDSCAPE_1D       4, 20, 92, 60
#define RECT_LANDSCAPE_2D       20, 5, 60, 90
#define RECT_PORTRAIT_1D        20, 4, 60, 92
#define RECT_PORTRAIT_2D        20, 5, 60, 90
#define RECT_FULL_1D            4, 4, 92, 92
#define RECT_FULL_2D            20, 5, 60, 90
#define RECT_DOTCODE            30, 20, 40, 60

static NSString *DecoderResultNotification = @"DecoderResultNotification";


@interface PatientViewController ()
{
    bool keyboardDown;
    NSInteger lastPageCount;
    NSMutableString* pageInputID;
    int labelCount;
    NSInteger start;
    NSInteger NumOfGroup;
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_device;
    AVCaptureVideoPreviewLayer *_prevLayer;
    bool running;
    NSString * lastFormat;

    CGImageRef	decodeImage;
    NSString *	decodeResult;
    int iWidth;
    int iHeight;
    int bytesPerRow;
    unsigned char *baseAddress;
    NSTimer *focusTimer;
    int pageArray[10];
}
@property (nonatomic, copy) NSString* ticketID;
@property (nonatomic, copy) NSString* lastName;
@property (nonatomic, copy) NSString* firstName;
@property (nonatomic, copy) NSString* middleInitial;
@property (nonatomic, copy) NSString* address1;
@property (nonatomic, copy) NSString* city;
@property (nonatomic, copy) NSString* state;
@property (nonatomic, copy) NSString* zip;
@property (nonatomic, copy) NSString* county;
@property (nonatomic, copy) NSString* resident;
@property (nonatomic, copy) NSString* ssNum;
@property (nonatomic, copy) NSString* gender;
@property (nonatomic, copy) NSString* race;
@property (nonatomic, copy) NSString* dob;
@property (nonatomic, copy) NSString* age;
@property (nonatomic, copy) NSString* ageUnit;
@property (nonatomic, copy) NSString* height;
@property (nonatomic, copy) NSString* weight;
@property (nonatomic, copy) NSString* phone;
@property (nonatomic, copy) NSString* dlNum;
@property (nonatomic, copy) NSString* dlState;
@property (nonatomic, copy) NSString* ethnicity;

@property (nonatomic, assign) MainScreenState scannerState;
@end

@implementation PatientViewController
@synthesize lastName;
@synthesize firstName;
@synthesize middleInitial;
@synthesize address1;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize county;
@synthesize resident;
@synthesize ssNum;
@synthesize gender;
@synthesize race;
@synthesize dob;
@synthesize age;
@synthesize ageUnit;
//@synthesize height;
@synthesize weight;
@synthesize phone;
@synthesize dlNum;
@synthesize dlState;
@synthesize ethnicity;
@synthesize scannerState;


@synthesize pageControl;
@synthesize incidentInput;
@synthesize inputContainer;
@synthesize ticketInputData;

@synthesize  popover;
@synthesize delegate;
@synthesize btnNameLabel;
@synthesize popoverController;
@synthesize imageview;

@synthesize btnCopyIncident;
@synthesize page2Container;


@synthesize captureSession = _captureSession;
@synthesize prevLayer = _prevLayer;
@synthesize device = _device;

@synthesize focusTimer;
@synthesize result;
@synthesize btnInbox;
@synthesize btnScanDl;
@synthesize lblAddress;
@synthesize lblAge;
@synthesize lblAgeUnit;
@synthesize lblCity;
@synthesize lblCounty;
@synthesize lblDob;
@synthesize lblFirstName;
@synthesize lblGender;
@synthesize lblLastName;
@synthesize lblPhone;
@synthesize lblRace;
@synthesize lblResident;
@synthesize lblSSNum;
@synthesize lblState;
@synthesize lblZip;
@synthesize btnLookupPat;
@synthesize search;
@synthesize selectedPatient;
@synthesize lblWeight;
@synthesize btnQAMessage;
@synthesize ticketID;


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
    pageInputID = [[NSMutableString alloc] init];
    UIImage *toolBarIMG = [UIImage imageNamed:@"navigation_bar_bkg.png"];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }

}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    lastPageCount = 0;
    labelCount = 0;
    NumOfGroup = 0;
    start = 0;
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    [self setViewUI:0];
    NSString* sqlStr;
    NSInteger count = 0;
    cameraOn = NO;
    NSString* patientName;
    sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1101", ticketID ];
    
    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1101", ticketID ];
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"]
                               pointerValue] Sql:sqlStr];
    }
    if (count > 0)
    {
        @synchronized(g_SYNCDATADB)
        {
            self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
        }
    }
    
    if ([patientName length] > 0)
    {
        btnNameLabel.title = patientName;
    }
    else
    {
        btnNameLabel.title = @"Patient:      CC:";
    }
    [btnNameLabel setTintColor:[UIColor whiteColor]];
    

    if (copyIncident)
    {
        [self copyIncidentAddress];
    }
}

- (void) loadDefault
{
    
    NSString* sql = @"Select inputID, 'Inputs', InputDefault from Inputs where inputPage like 'Personal%' and (inputDefault != '')";
    NSMutableArray* defaultArray;
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        defaultArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    
    for (NSInteger i =start; i < incidentInput.count && i <(self.pageControl.currentPage + 1)*12; i++)
    {
        for (int j = 0; j < defaultArray.count; j++)
        {
            ClsTableKey* key = [defaultArray objectAtIndex:j];
            InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
            if (inputView.btnInput.tag == key.key)
            {
                [inputView.btnInput setTitle:key.desc forState:UIControlStateNormal];
            }
        }
        
    }
    
}


-(void) loadData
{
    
    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@", ticketID ];
        self.ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    for (NSInteger i =start; i < incidentInput.count && i <(self.pageControl.currentPage + 1)*12; i++)
    {
        ClsInputs* input = [incidentInput objectAtIndex:i];
        
        NSString* inputStr = [NSString stringWithFormat:@"%ld:0:1", input.inputID];
        InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
        NSString* value = [ticketInputData objectForKey:inputStr];
        if (value != nil || value.length > 0)
        {
            [inputView setBtnText:value];
        }
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



- (IBAction)btnValidateClick:(UIButton *)sender {
    [self saveTab];
    ValidateViewController *popoverView =[[ValidateViewController alloc] initWithNibName:@"ValidateViewController" bundle:nil];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(540, 590);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnCopyIncidentClick:(id)sender {
   /* if (copyIncident)
    {
        copyIncident = false;
        [btnCopyIncident setBackgroundImage:[UIImage imageNamed:@"Unchecked.png"] forState:UIControlStateNormal];
        [self clearAddress];
    }
    else
    {
        copyIncident = true;
        [btnCopyIncident setBackgroundImage:[UIImage imageNamed:@"check_box.png"] forState:UIControlStateNormal];
        [self copyIncidentAddress];
    }*/
    
    [self copyIncidentAddress];

}

- (IBAction)btnCopySettingPressed:(UIButton *)sender
{
    [self.currentResponder resignFirstResponder];
    
    NSMutableArray *arrSetting = [[NSMutableArray alloc] initWithObjects:@"Copy From Scene", @"Copy To Scene", nil];
    
    functionSelected = 8;
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


- (void) copyIncidentAddress
{
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@", ticketID ];
    NSMutableDictionary* ticketInputData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    if ([[ticketInputData objectForKey:@"1003:0:1"] length] > 0)
    {
        self.address1 = [ticketInputData objectForKey:@"1003:0:1"];
    }
    if ([[ticketInputData objectForKey:@"1004:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1004:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        self.city = [ticketInputData objectForKey:@"1004:0:1"];
    }
    
    if ([[ticketInputData objectForKey:@"1005:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1005:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        self.state = [ticketInputData objectForKey:@"1005:0:1"];
    }
    
    if ([[ticketInputData objectForKey:@"1006:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1006:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        self.zip = [ticketInputData objectForKey:@"1006:0:1"];
    }
    
}

- (void)copyAddressToScene
{
    NSString* sqlStr;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    @synchronized(g_SYNCDATADB)
    {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1003, 0, 1, @"", @"", self.address1];
            NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1003", self.address1, ticketID];
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
             
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1004, 0, 1, @"", @"", self.city];
            updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1004", self.city, ticketID];
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1005, 0, 1, @"", @"", self.state];
            updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1005", self.state, ticketID];
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1006, 0, 1, @"", @"", self.zip];
            updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1006", self.zip, ticketID];
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];

    }
}

- (IBAction)btnLoopUpClick:(id)sender {
    if ([[g_SETTINGS objectForKey:@"MachineID"] isEqualToString:@"LOCAL"])
    {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iFhMedic" message:@"This feature is not available in Demo mode." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    else
    {
        self.search = [[PatientSearchViewController alloc] init];
        search.delegate = self;
        [self presentViewController:search animated:YES completion:nil];
    }
}

- (void) doneSelectPatient
{
    self.selectedPatient = search.patientSelected;
    NSString* dobStr = selectedPatient.dob;
    NSString* month;
    NSString* day;
    NSString* year;
    NSInteger ageInt = 0;
    NSString* datebirth = @"";
    if (dobStr.length > 0)
    {
        if ([dobStr rangeOfString:@"-"].location == NSNotFound)
        {
            NSRange range11 = NSMakeRange(3,2);
            month = [dobStr substringToIndex:2];
            day = [dobStr substringWithRange:range11];
            range11 = NSMakeRange(6,4);
            year = [dobStr substringWithRange:range11];
            
        }
        else
        {
            NSRange range11 = NSMakeRange(5,2);
            year = [dobStr substringToIndex:4];
            month = [dobStr substringWithRange:range11];
            range11 = NSMakeRange(8,2);
            day = [dobStr substringWithRange:range11];
        }
        
        NSString* datebirth = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
        self.dob = datebirth;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* dateOfBirth = [formatter dateFromString:datebirth];
        
        NSDate* now = [NSDate date];
        NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                           components:NSCalendarUnitYear
                                           fromDate:dateOfBirth
                                           toDate:now
                                           options:0];
        ageInt = [ageComponents year];
        self.age = [NSString stringWithFormat:@"%ld", ageInt];
        self.ageUnit = @"Years";
    }

        NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1101, 0, 1, @"", @"", [self removeNull:selectedPatient.lastName]];
        NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1101", [self removeNull:selectedPatient.lastName], ticketID];
    
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
    
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1102, 0, 1, @"", @"", [self removeNull:selectedPatient.firstName]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1102", [self removeNull:selectedPatient.firstName], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
    
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1118, 0, 1, @"", @"", [self removeNull:selectedPatient.mi]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1118", [self removeNull:selectedPatient.mi], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
    
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1107, 0, 1, @"", @"", [self removeNull:selectedPatient.address1]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1107", [self removeNull:selectedPatient.address1], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
    
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1108, 0, 1, @"", @"", [self removeNull:selectedPatient.address2]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1108", [self removeNull:selectedPatient.address2], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1109, 0, 1, @"", @"", [self removeNull:selectedPatient.city]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1109", [self removeNull:selectedPatient.city], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
    
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1110, 0, 1, @"", @"", [self removeNull:selectedPatient.state]];
         updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1110", [self removeNull:selectedPatient.state], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
    
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1112, 0, 1, @"", @"", [self removeNull:selectedPatient.zip]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1112", [self removeNull:selectedPatient.zip], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1111, 0, 1, @"", @"", [self removeNull:selectedPatient.county]];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1111", [self removeNull:selectedPatient.county], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }

        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1135, 0, 1, @"", @"", [self removeNull:selectedPatient.resident]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1135", [self removeNull:selectedPatient.resident], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
        
        
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1133, 0, 1, @"", @"", [self removeNull:selectedPatient.ssn]];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1133", [self removeNull:selectedPatient.ssn], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
    
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1105, 0, 1, @"", @"", [self removeNull:selectedPatient.sex]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1105", [self removeNull:selectedPatient.sex], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
    
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1104, 0, 1, @"", @"", [self removeNull:selectedPatient.race]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1104", [self removeNull:selectedPatient.race], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
            
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1119, 0, 1, @"", @"", [self removeNull:age]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1119", [self removeNull:age], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
    
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1103, 0, 1, @"", @"", [self removeNull:datebirth]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1103", [self removeNull:datebirth], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
    
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1106, 0, 1, @"", @"", [self removeNull:selectedPatient.phone]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1106", [self removeNull:selectedPatient.phone], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
            
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1130, 0, 1, @"", @"", [self removeNull:selectedPatient.dlNumber]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1130", [self removeNull:selectedPatient.dlNumber], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
            
            
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1134, 0, 1, @"", @"", @"Years"];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1134", @"Years", ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }

            
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1131, 0, 1, @"", @"", [self removeNull:selectedPatient.height]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1131", [self removeNull:selectedPatient.height], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
            
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1132, 0, 1, @"", @"", [self removeNull:selectedPatient.weight]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1132", [self removeNull:selectedPatient.weight], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
            
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 20613, 0, 1, @"", @"", [self removeNull:selectedPatient.ethnicity]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 20613", [self removeNull:selectedPatient.ethnicity], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }
            
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1110, 0, 1, @"", @"", [self removeNull:selectedPatient.state]];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1110", [self removeNull:selectedPatient.state], ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  InsertSql:sqlStr UpdateSql:updateStr];
        }

    
    NSString* patientStr = [NSString stringWithFormat:@"%@ %@ %@", selectedPatient.lastName, age, selectedPatient.sex];
    sqlStr = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount, T.TicketAdminNotes from Tickets T where TicketID = %@", ticketID];
    NSMutableArray* ticketsInfo;
    @synchronized(g_SYNCDATADB)
    {
        ticketsInfo = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    ClsTickets* ticketInfo = [ticketsInfo objectAtIndex:0];
    NSString* desc = ticketInfo.ticketDesc;
    if ([desc length] > 0 && ([desc rangeOfString:@"(null)"].location == NSNotFound))
    {
        if ([desc rangeOfString:@"Practice:"].location == NSNotFound)   // part after practice
        {
            if ([desc rangeOfString:@","].location == NSNotFound)   // part after practice
            {
                desc = [NSString stringWithFormat:@"%@", patientStr];
            }
            else
            {
                NSRange startRange = [ticketInfo.ticketDesc rangeOfString:@","];
                desc = [NSString stringWithFormat:@"%@,%@", [ticketInfo.ticketDesc substringToIndex:startRange.location], patientStr];
            }
        }
        else
        {
            NSRange startRange = [ticketInfo.ticketDesc rangeOfString:@":"];
            if ([desc rangeOfString:@","].location == NSNotFound)   // part after practice
            {
                desc = [NSString stringWithFormat:@"%@ %@", [ticketInfo.ticketDesc substringToIndex:startRange.location +1], patientStr];
            }
            else
            {
                NSRange endRange = [ticketInfo.ticketDesc rangeOfString:@","];
                desc = [NSString stringWithFormat:@"%@,%@", [ticketInfo.ticketDesc substringToIndex:endRange.location], patientStr];
            }
            
        }
    }
    else
    {
        desc = [NSString stringWithFormat:@"%@", patientStr];
    }
    sqlStr = [NSString stringWithFormat:@"UPDATE Tickets Set TicketDesc = '%@', isUploaded = 0 where TicketID = %@", desc, ticketID];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    [self saveHistory];
    [self saveInsurace];
    [self saveAllergy];
}


- (void) saveInsurace
{
    
}

- (void) saveAllergy
{
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1224", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    if (count < 1)
    {
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1224, 0, 1, @"", @"", selectedPatient.allenv];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1225, 0, 1, @"", @"", selectedPatient.allfood];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1226, 0, 1, @"", @"", selectedPatient.allinsects];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1227, 0, 1, @"", @"", selectedPatient.allmeds];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }

}

- (void) saveHistory
{
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1601", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    if (count < 1)
    {
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1601, 0, 1, @"", @"", selectedPatient.histCardio];
        
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1602, 0, 1, @"", @"", selectedPatient.histCancer];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1603, 0, 1, @"", @"", selectedPatient.histNeuro];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1604, 0, 1, @"", @"", selectedPatient.histGastro];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1605, 0, 1, @"", @"", selectedPatient.histGenit];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1606, 0, 1, @"", @"", selectedPatient.histInfect];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1607, 0, 1, @"", @"", selectedPatient.histEndo];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1608, 0, 1, @"", @"", selectedPatient.histResp];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1609, 0, 1, @"", @"", selectedPatient.histPsych];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1610, 0, 1, @"", @"", selectedPatient.histWomen];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1611, 0, 1, @"", @"", selectedPatient.histMusc];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1613, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1614, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 21211, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 21219, 0, 1, @"", @"", @""];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverController dismissPopoverAnimated:true];
    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        
        //       UIImageOrientationUp = 0 = Landscape left = 1
        //  UIImageOrientationDown = 1 = Landscape right = 3
        if (image.imageOrientation == UIImageOrientationUp)
        {
            NSLog(@"portrait");
            CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(10, 10, 480, 300));
            //CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(520, 480, 1318, 810));
            UIImage *img = [UIImage imageWithCGImage:ref scale:1 orientation:UIImageOrientationUp];
            CGImageRelease(ref);
            imageview.image = img;
        }
        else if (image.imageOrientation == UIImageOrientationDown)
        {
            CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(10, 10, 480, 300));
            //CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(520, 480, 1318, 810));
            UIImage *img = [UIImage imageWithCGImage:ref scale:1 orientation:UIImageOrientationDown];
            CGImageRelease(ref);
            imageview.image = img;
        }
        else if (image.imageOrientation == UIImageOrientationLeft)
        {
            CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(10, 10, 480, 300));
            //CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(520, 480, 1318, 810));
            UIImage *img = [UIImage imageWithCGImage:ref scale:1 orientation:UIImageOrientationLeft];
            CGImageRelease(ref);
            imageview.image = img;
        }
        else if (image.imageOrientation == UIImageOrientationRight)
        {
            CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(10, 300, 300, 480));
            //CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(520, 480, 1318, 810));
            UIImage *img = [UIImage imageWithCGImage:ref scale:1 orientation:UIImageOrientationRight];
            CGImageRelease(ref);
            imageview.image = img;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iRescueMedic" message:@"Image was taken with the wrong orientation. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        
    }
}

- (UIImage *) toGrayscale:(UIImage*)img
{
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, img.size.width * img.scale, img.size.height * img.scale);
    
    int width = imageRect.size.width;
    int iHeight = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * iHeight * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * iHeight * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, iHeight, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, iHeight), [img CGImage]);
    
    for(int y = 0; y < iHeight; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:img.scale
                                           orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}


- (IBAction)btnMainMenuClick:(id)sender {
    [delegate dismissViewControl];
//    [self dismissViewControllerAnimated:YES completion:nil];
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



-(void) viewWillDisappear:(BOOL)animated
{
    if (cameraOn)
    {
        pageControl.enabled = true;
        for (int i = start; i < self.incidentInput.count && i < (lastPageCount + 1)* 12; i++)
        {
            InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
            inputView.btnInput.enabled = true;
        }
        cameraOn = NO;
        self.toolBar.userInteractionEnabled = YES;
        self.containerView1.userInteractionEnabled = YES;
        self.containerView2.userInteractionEnabled = YES;
        self.containerView3.userInteractionEnabled = YES;
        self.btnLookupPat.userInteractionEnabled = YES;
        [btnScanDl setTitle:@"Scan DL" forState:UIControlStateNormal];
        btnInbox.enabled = YES;
        [self cancelClick];
    }
    [self saveTab];
    [super viewWillDisappear:animated];
}

- (void) saveTab
{
    NSString* sqlStr;
    NSInteger count;
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* status = [g_SETTINGS objectForKey:@"TicketStatus"];
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
        for (NSInteger i =  start ; i < self.incidentInput.count && i < (lastPageCount + 1)* 12; i++)
        {
            InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
            NSString* inputValue = [self removeNull:inputView.btnInput.titleLabel.text];
            NSString* inputKey = [NSString stringWithFormat:@"%d:0:1", inputView.btnInput.tag];
            if ( (inputValue != nil) && !([inputValue isEqualToString:[ticketInputData objectForKey:inputKey]]) )
            {
                count++;
                sqlStr = [NSString stringWithFormat:@"Insert into TicketChanges(LocalTicketID, TicketID, ChangeID, ChangeMade, ChangeTime, ModifiedBy, ChangeInputID, OriginalValue) Values(0, %@, %d, 'Input changed from %@ to %@', '%@', %@, %d, '%@')", ticketID, count , [ticketInputData objectForKey:inputKey] ,inputValue, timeAdded, userID, inputView.btnInput.tag, [ticketInputData objectForKey:inputKey]];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
            }
            
        }
        
    }
    
   // ClsInputs* input = [incidentInput objectAtIndex:start];
    

    for (NSInteger i =  start ; i < self.incidentInput.count && i < (lastPageCount + 1)* 12; i++)
    {
        InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
        NSString* inputValue = [self removeNull:inputView.btnInput.titleLabel.text];
        
        @synchronized(g_SYNCDATADB)
        {
            self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %ld, %d, %d, '%@', '%@', '%@')", ticketID, inputView.btnInput.tag, 0, 1, @"", @"", inputValue];
            NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %ld", inputValue, ticketID, inputView.btnInput.tag];
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
        }
        if (inputView.btnInput.tag == 1101)
        {
            self.lastName = inputValue;
        }
        if (inputView.btnInput.tag == 1119)
        {
            self.age = inputValue;
        }
        if (inputView.btnInput.tag == 1105)
        {
            self.gender = inputValue;
        }
    }

   
        NSString* patientStr = [NSString stringWithFormat:@"%@ %@ %@", self.lastName, self.age, self.gender];
        sqlStr = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount, T.TicketAdminNotes from Tickets T where TicketID = %@", ticketID];
        NSMutableArray* ticketsInfo;
        @synchronized(g_SYNCDATADB)
        {
            ticketsInfo = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if ([ticketsInfo count] > 0)
        {
            ClsTickets* ticketInfo = [ticketsInfo objectAtIndex:0];
            NSString* desc = ticketInfo.ticketDesc;
            if ([desc length] > 0 && ([desc rangeOfString:@"(null)"].location == NSNotFound))
            {
                if ([desc rangeOfString:@"Practice:"].location == NSNotFound)   // part after practice
                {
                    if ([desc rangeOfString:@","].location == NSNotFound)   // part after practice
                    {
                        desc = [NSString stringWithFormat:@"%@", patientStr];
                    }
                    else
                    {
                        NSRange startRange = [ticketInfo.ticketDesc rangeOfString:@","];
                        desc = [NSString stringWithFormat:@"%@,%@", [ticketInfo.ticketDesc substringToIndex:startRange.location], patientStr];
                    }
                }
                else
                {
                    NSRange startRange = [ticketInfo.ticketDesc rangeOfString:@":"];
                    if ([desc rangeOfString:@","].location == NSNotFound)   // part after practice
                    {
                        desc = [NSString stringWithFormat:@"%@ %@", [ticketInfo.ticketDesc substringToIndex:startRange.location +1], patientStr];
                    }
                    else
                    {
                        NSRange endRange = [ticketInfo.ticketDesc rangeOfString:@","];
                        desc = [NSString stringWithFormat:@"%@,%@", [ticketInfo.ticketDesc substringToIndex:endRange.location], patientStr];
                    }
                    
                }
            }
            else
            {
                desc = [NSString stringWithFormat:@"%@", patientStr];
            }
            sqlStr = [NSString stringWithFormat:@"UPDATE Tickets Set TicketDesc = '%@', isUploaded = 0 where TicketID = %@", desc, ticketID];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }

}

- (void)setViewMovedUp:(BOOL)movedUp
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        if(rect.origin.y == 0)
            rect.origin.y = self.view.frame.origin.y - 260;
    }
    else
    {
        if(rect.origin.y < 0)
            rect.origin.y = self.view.frame.origin.y + 260;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
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

- (void)viewDidUnload {

    [super viewDidUnload];
}

#pragma mark- UI controls adjustments
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
    NSString* sqlGroup = @"SELECT count (distinct InputGroup) FROM inputs where inputpage = 'Personal' ";
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        NumOfGroup = [DAO getCount:[[g_SETTINGS objectForKey:@"lookupDB"]pointerValue] Sql:sqlGroup];
    }
    if (self.pageControl.currentPage >= lastPageCount)
    {
        start = (int) (page * 12) - labelCount;
    }
    else
    {
        if (page == 0)
        {
            start = 0;
        }
        else
        {
            start = (int) (page * 12) - pageArray[self.pageControl.currentPage - 1];
            labelCount = pageArray[self.pageControl.currentPage - 1];
        }
    }
    if (self.incidentInput == nil)
    {
        NSString* querySql = @"select InputID, InputName, InputDataType, InputGroup, InputRequiredField  from Inputs where InputPage = 'Personal' order by inputGroup, InputIndex";
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.incidentInput = [DAO selectInputs:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql];
        }
        int numOfPage = ((int) (self.incidentInput.count + NumOfGroup)/12) + 1;
        self.pageControl.numberOfPages = numOfPage;
    }
    
    NSInteger ypos = 5;

    NSString* lastGroup;
    for (int i = start; i < incidentInput.count; i++)
    {
        ClsInputs* input = [incidentInput objectAtIndex:i];
        if (lastGroup == nil || ![lastGroup isEqualToString:input.inputGroup])
        {
            if (lastGroup == nil && i != 0)
            {
                if (self.pageControl.currentPage >= lastPageCount)
                {
                    NumOfGroup++;
                    int numOfPage = ((int) (self.incidentInput.count + NumOfGroup)/12) + 1;
                    self.pageControl.numberOfPages = numOfPage;
                }
                else
                {
                    NumOfGroup--;
                }
            }
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
            if (ypos > 515)
            {
                break;
            }
        }

        
        InputViewFull* inputView = [[InputViewFull alloc] init];
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
        
        if (ypos > 515)
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
    NSString* defaultStr = [NSString stringWithFormat:@"Select count(*) from ticketInputs where ticketID = %@ and inputID in (%@)", ticketID, pageInputID];
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
    }
    
    
}

- (void) removeToolBarItems
{
    
    NSArray *items = [self.toolBar items];
    for (UIBarButtonItem *barButton in items) {
        //do something with button
    }
    
    NSMutableArray *toolbarButtons = [[self.toolBar items] mutableCopy];
    [toolbarButtons removeObjectAtIndex:4];
    [toolbarButtons removeObjectAtIndex:5];
    [toolbarButtons removeObjectAtIndex:6];
    [toolbarButtons removeObjectAtIndex:7];
    [self.toolBar setItems:toolbarButtons animated:YES];
    
}

- (IBAction)btnTakePictureClick:(id)sender {
    if (cameraOn)
    {
        pageControl.enabled = true;
        for (int i = start; i < self.incidentInput.count && i < (lastPageCount + 1)* 12; i++)
        {
            InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
            inputView.btnInput.enabled = true;
        }
        cameraOn = NO;
        self.toolBar.userInteractionEnabled = YES;
        self.containerView1.userInteractionEnabled = YES;
        self.containerView2.userInteractionEnabled = YES;
        self.containerView3.userInteractionEnabled = YES;

        self.btnLookupPat.userInteractionEnabled = YES;
        [btnScanDl setTitle:@"Scan DL" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self stopScanning];
        [self deinitCapture];
        self.prevLayer = nil;
        btnInbox.enabled = YES;
    }
    else
    {
        pageControl.enabled = false;
        for (int i = start; i < self.incidentInput.count && i < (lastPageCount + 1)* 12; i++)
        {
            InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
            inputView.btnInput.enabled = false;
        }
        [btnScanDl setTitle:@"Cancel" forState:UIControlStateNormal];
        cameraOn = YES;
        self.toolBar.userInteractionEnabled = NO;
        self.containerView1.userInteractionEnabled = NO;
        self.containerView2.userInteractionEnabled = NO;
        self.containerView3.userInteractionEnabled = NO;

        self.btnLookupPat.userInteractionEnabled = NO;
        self.prevLayer = nil;
        [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(decodeResultNotification:) name: DecoderResultNotification object: nil];
        
        [self initDecoder];
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"On iOS simulator camera is not Supported");
#else
        [self initCapture];
        [self startScanning];
#endif
        btnInbox.enabled = NO;
    }
}

- (void) cancelClick
{
 	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self stopScanning];
	[self deinitCapture];
	self.prevLayer = nil;
    btnInbox.enabled = YES;

}


- (void)initDecoder {
    
    //register your copy of library with givern user/password
    MWB_registerCode(MWB_CODE_MASK_39,      "XeroxGovSys.iOS.C39.UDL", "C52A85132543BF93EE499A426422CCC09037D92A6480F06B45EE0BDC42F34F0F");
    MWB_registerCode(MWB_CODE_MASK_93,      "XeroxGovSys.iOS.C93.UDL", "8F5E20C623C8125C9593DA310CC43493174A4F68BE0FE1D5DBB6DE8BC2498A94");
    MWB_registerCode(MWB_CODE_MASK_25,      "XeroxGovSys.iOS.C25.UDL", "C8783ED7A6BC87B1944687F9F572D93990DFB8CCD2D85D3C02DB676F61F85468");
    MWB_registerCode(MWB_CODE_MASK_128,     "XeroxGovSys.iOS.C128.UDL", "3ADC3914650AEDB310FF69C84C09135FEAE90E456E97DF21719CD152CCBBE306");
    MWB_registerCode(MWB_CODE_MASK_AZTEC,   "username", "key");
    MWB_registerCode(MWB_CODE_MASK_DM,      "username", "key");
    MWB_registerCode(MWB_CODE_MASK_EANUPC,  "XeroxGovSys.iOS.EANUPC.UDL", "302570B10FA2F9E00EECCBD8CCF416BC6F6BFC1D441D16E1FD438C96F29FBC09");
    MWB_registerCode(MWB_CODE_MASK_QR,      "XeroxGovSys.iOS.QR.UDL", "2DADF16993B5680DFBA66FB9E291AB95B0D9B85F573BE61621147CABDB9B309B");
    MWB_registerCode(MWB_CODE_MASK_PDF,     "XeroxGovSys.iOS.PDF.UDL", "425303E5DAF2634C6AFCF9E9889943198D78A61796D10F30BAFD842795660362");
    MWB_registerCode(MWB_CODE_MASK_RSS,     "username", "key");
    MWB_registerCode(MWB_CODE_MASK_CODABAR, "XeroxGovSys.iOS.CB.UDL", "DA80F4DB7BE08C2EE2F37527B7A7E2EF1C80FCAF052CB36E236E408A7EA4ACE0");
    MWB_registerCode(MWB_CODE_MASK_DOTCODE, "username", "key");
    
    
    // choose code type or types you want to search for
    
    if (PDF_OPTIMIZED){
        MWB_setActiveCodes(MWB_CODE_MASK_PDF);
        MWB_setDirection(MWB_SCANDIRECTION_HORIZONTAL);
        MWB_setScanningRect(MWB_CODE_MASK_PDF,    RECT_LANDSCAPE_1D);
    } else {
        // Our sample app is configured by default to search all supported barcodes...
        MWB_setActiveCodes(MWB_CODE_MASK_25    |
                           MWB_CODE_MASK_39     |
                           MWB_CODE_MASK_93     |
                           MWB_CODE_MASK_128    |
                           MWB_CODE_MASK_AZTEC  |
                           MWB_CODE_MASK_DM     |
                           MWB_CODE_MASK_EANUPC |
                           MWB_CODE_MASK_PDF    |
                           MWB_CODE_MASK_QR     |
                           MWB_CODE_MASK_CODABAR|
                           MWB_CODE_MASK_RSS);
        
        // Our sample app is configured by default to search both directions...
        MWB_setDirection(MWB_SCANDIRECTION_HORIZONTAL | MWB_SCANDIRECTION_VERTICAL);
        // set the scanning rectangle based on scan direction(format in pct: x, y, width, height)
        MWB_setScanningRect(MWB_CODE_MASK_25,     RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_39,     RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_93,     RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_128,    RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_AZTEC,  RECT_FULL_2D);
        MWB_setScanningRect(MWB_CODE_MASK_DM,     RECT_FULL_2D);
        MWB_setScanningRect(MWB_CODE_MASK_EANUPC, RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_PDF,    RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_QR,     RECT_FULL_2D);
        MWB_setScanningRect(MWB_CODE_MASK_RSS,    RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_CODABAR,RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_DOTCODE,RECT_DOTCODE);
    }
    
    
    // But for better performance, only activate the symbologies your application requires...
    // MWB_setActiveCodes( MWB_CODE_MASK_25 );
    // MWB_setActiveCodes( MWB_CODE_MASK_39 );
    // MWB_setActiveCodes( MWB_CODE_MASK_93 );
    // MWB_setActiveCodes( MWB_CODE_MASK_128 );
    // MWB_setActiveCodes( MWB_CODE_MASK_AZTEC );
    // MWB_setActiveCodes( MWB_CODE_MASK_DM );
    // MWB_setActiveCodes( MWB_CODE_MASK_EANUPC );
    // MWB_setActiveCodes( MWB_CODE_MASK_PDF );
    // MWB_setActiveCodes( MWB_CODE_MASK_QR );
    // MWB_setActiveCodes( MWB_CODE_MASK_RSS );
    // MWB_setActiveCodes( MWB_CODE_MASK_CODABAR );
    // MWB_setActiveCodes( MWB_CODE_MASK_DOTCODE );
    
    
    // But for better performance, set like this for PORTRAIT scanning...
    // MWB_setDirection(MWB_SCANDIRECTION_VERTICAL);
    // set the scanning rectangle based on scan direction(format in pct: x, y, width, height)
    // MWB_setScanningRect(MWB_CODE_MASK_25,     RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_39,     RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_93,     RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_128,    RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_AZTEC,  RECT_PORTRAIT_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_DM,     RECT_PORTRAIT_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_EANUPC, RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_PDF,    RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_QR,     RECT_PORTRAIT_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_RSS,    RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_CODABAR,RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_DOTCODE,RECT_DOTCODE);
    
    // or like this for LANDSCAPE scanning - Preferred for dense or wide codes...
    // MWB_setDirection(MWB_SCANDIRECTION_HORIZONTAL);
    // set the scanning rectangle based on scan direction(format in pct: x, y, width, height)
    // MWB_setScanningRect(MWB_CODE_MASK_25,     RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_39,     RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_93,     RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_128,    RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_AZTEC,  RECT_LANDSCAPE_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_DM,     RECT_LANDSCAPE_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_EANUPC, RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_PDF,    RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_QR,     RECT_LANDSCAPE_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_RSS,    RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_CODABAR,RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_DOTCODE,RECT_DOTCODE);
    
    
    // set decoder effort level (1 - 5)
    // for live scanning scenarios, a setting between 1 to 3 will suffice
    // levels 4 and 5 are typically reserved for batch scanning
    MWB_setLevel(3);
    
    //get and print Library version
    int ver = MWB_getLibVersion();
    int v1 = (ver >> 16);
    int v2 = (ver >> 8) & 0xff;
    int v3 = (ver & 0xff);
    NSString *libVersion = [NSString stringWithFormat:@"%d.%d.%d", v1, v2, v3];
    NSLog(@"Lib version: %@", libVersion);
}

// IOS 7 statusbar hide
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


-(void) reFocus {
    //NSLog(@"refocus");
    
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusPointOfInterestSupported]){
            [self.device setFocusPointOfInterest:CGPointMake(0.49,0.49)];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        [self.device unlockForConfiguration];
        
    }
}

- (void)toggleTorch
{
    if ([self.device isTorchModeSupported:AVCaptureTorchModeOn]) {
        NSError *error;
        
        if ([self.device lockForConfiguration:&error]) {
            if ([self.device torchMode] == AVCaptureTorchModeOn)
                [self.device setTorchMode:AVCaptureTorchModeOff];
            else
                [self.device setTorchMode:AVCaptureTorchModeOn];
            
            if([self.device isFocusModeSupported: AVCaptureFocusModeContinuousAutoFocus])
                self.device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            
            [self.device unlockForConfiguration];
        } else {
            
        }
    }
}

- (void)initCapture
{
	/*We setup the input*/
	self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError* error = nil;
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (!captureInput)
    {
        [btnScanDl setTitle:@"Scan DL" forState:UIControlStateNormal];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FhMedic for iPad" message:@"Please shut down this app and turn on your camera in the device's settings before continuing. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
	/*We setupt the output*/
	AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
	captureOutput.alwaysDiscardsLateVideoFrames = YES;
	//captureOutput.minFrameDuration = CMTimeMake(1, 10); Uncomment it to specify a minimum duration for each video frame
	[captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
	// Set the video output to store frame in BGRA (It is supposed to be faster)
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
	// Set the video output to store frame in 422YpCbCr8(It is supposed to be faster)
	
	//************************Note this line
	NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange];
	
	NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
	[captureOutput setVideoSettings:videoSettings];
    
	//And we create a capture session
	self.captureSession = [[AVCaptureSession alloc] init];
	//We add input and output
	[self.captureSession addInput:captureInput];
	[self.captureSession addOutput:captureOutput];
    
    
    
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        NSLog(@"Set preview port to 1280X720");
        self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    } else
        //set to 640x480 if 1280x720 not supported on device
        if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset640x480])
        {
            NSLog(@"Set preview port to 640X480");
            self.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
        }
    
    
    // Limit camera FPS to 15 for single core devices (iPhone 4 and older) so more CPU power is available for decoder
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info( mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount ) ;
    
    if (hostInfo.max_cpus < 2){
        if ([self.device respondsToSelector:@selector(setActiveVideoMinFrameDuration:)]){
            [self.device lockForConfiguration:nil];
            [self.device setActiveVideoMinFrameDuration:CMTimeMake(1, 15)];
            [self.device unlockForConfiguration];
        } else {
            AVCaptureConnection *conn = [captureOutput connectionWithMediaType:AVMediaTypeVideo];
            [conn setVideoMinFrameDuration:CMTimeMake(1, 15)];
        }
    }
    
    
	/*We add the preview layer*/
    
    self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
    
    
  //  if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
  //      self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
  //      self.prevLayer.frame = CGRectMake(0, 65, MAX(self.view.frame.size.width-200,self.view.frame.size.height-200), MIN(self.view.frame.size.width-200,self.view.frame.size.height-200));
  //  }
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        self.prevLayer.frame = CGRectMake(0, 65, MAX(self.view.frame.size.width,self.view.frame.size.height-106), MIN(self.view.frame.size.width,self.view.frame.size.height-106));
    }
    
 //   if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
 //       self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
 //       self.prevLayer.frame = CGRectMake(0, 65, MAX(self.view.frame.size.width-200,self.view.frame.size.height-200), MIN(self.view.frame.size.width-200,self.view.frame.size.height-200));
//    }
       if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
           self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
           self.prevLayer.frame = CGRectMake(0, 65, MAX(self.view.frame.size.width,self.view.frame.size.height - 106), MIN(self.view.frame.size.width,self.view.frame.size.height - 106));
        }
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        self.prevLayer.frame = CGRectMake(0, 65, MIN(self.view.frame.size.width-200,self.view.frame.size.height-200), MAX(self.view.frame.size.width-200,self.view.frame.size.height-200));
    }
    if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
        self.prevLayer.frame = CGRectMake(0, 65, MIN(self.view.frame.size.width-200,self.view.frame.size.height-200), MAX(self.view.frame.size.width-200,self.view.frame.size.height-200));
    }
    
    
	self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	[self.view.layer addSublayer: self.prevLayer];
#if USE_MWOVERLAY
    [MWOverlay addToPreviewLayer:self.prevLayer];
#endif
    
    self.focusTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reFocus) userInfo:nil repeats:YES];
}

- (void) onVideoStart: (NSNotification*) note
{
    if(running)
        return;
    running = YES;
    
    // lock device and set focus mode
    NSError *error = nil;
    if([self.device lockForConfiguration: &error])
    {
        if([self.device isFocusModeSupported: AVCaptureFocusModeContinuousAutoFocus])
            self.device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    }
}

- (void) onVideoStop: (NSNotification*) note
{
    if(!running)
        return;
    [self.device unlockForConfiguration];
    running = NO;
}

#pragma mark -
#pragma mark AVCaptureSession delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
	   fromConnection:(AVCaptureConnection *)connection
{
	if (self.scannerState != CAMERA) {
		return;
	}
	
	if (self.scannerState != CAMERA_DECODING)
	{
		self.scannerState = CAMERA_DECODING;
	}
	
	
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    //Lock the image buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    //Get information about the image
    baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
    int pixelFormat = CVPixelBufferGetPixelFormatType(imageBuffer);
	switch (pixelFormat) {
		case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:
			//NSLog(@"Capture pixel format=NV12");
			bytesPerRow = (int) CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
			iWidth = bytesPerRow;//CVPixelBufferGetWidthOfPlane(imageBuffer,0);
			iHeight = (int) CVPixelBufferGetHeightOfPlane(imageBuffer,0);
			break;
		case kCVPixelFormatType_422YpCbCr8:
			//NSLog(@"Capture pixel format=UYUY422");
			bytesPerRow = (int) CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
			iWidth = (int) CVPixelBufferGetWidth(imageBuffer);
			iHeight = (int) CVPixelBufferGetHeight(imageBuffer);
			int len = iWidth*iHeight;
			int dstpos=1;
			for (int i=0;i<len;i++){
				baseAddress[i]=baseAddress[dstpos];
				dstpos+=2;
			}
			
			break;
		default:
			//	NSLog(@"Capture pixel format=RGB32");
			break;
	}
	
    
    unsigned char *frameBuffer = malloc(iWidth * iHeight);
    memcpy(frameBuffer, baseAddress, iWidth * iHeight);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        
        unsigned char *pResult=NULL;
        
        int resLength = MWB_scanGrayscaleImage(frameBuffer,iWidth,iHeight, &pResult);
        free(frameBuffer);
        //NSLog(@"Frame decoded");
        
        //CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        
        //ignore results less than 4 characters - probably false detection
        if (resLength > 4 || ((resLength > 0 && MWB_getLastType() != FOUND_39 && MWB_getLastType() != FOUND_25_INTERLEAVED && MWB_getLastType() != FOUND_25_STANDARD)))
        {
            
            int bcType = MWB_getLastType();
            NSString *typeName=@"";
            switch (bcType) {
                case FOUND_25_INTERLEAVED: typeName = @"Code 25 Interleaved";break;
                case FOUND_25_STANDARD: typeName = @"Code 25 Standard";break;
                case FOUND_128: typeName = @"Code 128";break;
                case FOUND_128_GS1: typeName = @"Code 128 GS1";break;
                case FOUND_39: typeName = @"Code 39";break;
                case FOUND_93: typeName = @"Code 93";break;
                case FOUND_AZTEC: typeName = @"AZTEC";break;
                case FOUND_DM: typeName = @"Datamatrix";break;
                case FOUND_QR: typeName = @"QR";break;
                case FOUND_EAN_13: typeName = @"EAN 13";break;
                case FOUND_EAN_8: typeName = @"EAN 8";break;
                case FOUND_NONE: typeName = @"None";break;
                case FOUND_RSS_14: typeName = @"Databar 14";break;
                case FOUND_RSS_14_STACK: typeName = @"Databar 14 Stacked";break;
                case FOUND_RSS_EXP: typeName = @"Databar Expanded";break;
                case FOUND_RSS_LIM: typeName = @"Databar Limited";break;
                case FOUND_UPC_A: typeName = @"UPC A";break;
                case FOUND_UPC_E: typeName = @"UPC E";break;
                case FOUND_PDF: typeName = @"PDF417";break;
                case FOUND_CODABAR: typeName = @"Codabar";break;
                case FOUND_DOTCODE: typeName = @"Dotcode";break;
                    
                    
            }
            
            lastFormat = typeName;
            
            
            
            
            
            int size=resLength;
            
            char *temp = (char *)malloc(size+1);
            memcpy(temp, pResult, size+1);
            NSString *resultString = [[NSString alloc] initWithBytes: temp length: size encoding: NSUTF8StringEncoding];
            
            NSLog(@"Detected %@: %@", lastFormat, resultString);
            self.scannerState = CAMERA;
            
            
            
            NSMutableString *binString = [[NSMutableString alloc] init];
            
            for (int i = 0; i < size; i++)
                [binString appendString:[NSString stringWithFormat:@"%c", temp[i]]];
            
            if (MWB_getLastType() == FOUND_PDF || resultString == nil)
                resultString = [binString copy];
            else
                resultString = [resultString copy];
            
            free(temp);
            
            free(pResult);
            
            if (decodeImage != nil)
            {
                CGImageRelease(decodeImage);
                decodeImage = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.captureSession stopRunning];
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                DecoderResult *notificationResult = [DecoderResult createSuccess:resultString];
                [center postNotificationName:DecoderResultNotification object: notificationResult];
            });
            
        }
        else
        {
            self.scannerState = CAMERA;
        }
        
    });
    
}



- (void) startScanning {
	self.scannerState = LAUNCHING_CAMERA;
	[self.captureSession startRunning];
	self.prevLayer.hidden = NO;
	self.scannerState = CAMERA;
}

- (void)stopScanning {
	[self.captureSession stopRunning];
	self.state = NORMAL;
    self.prevLayer.hidden = YES;
    
	
}

- (void) deinitCapture {
    if (self.focusTimer){
        [self.focusTimer invalidate];
        self.focusTimer = nil;
    }
    
    if (self.captureSession != nil){
#if USE_MWOVERLAY
        [MWOverlay removeFromPreviewLayer];
#endif
        
#if !__has_feature(objc_arc)
        [self.captureSession release];
#endif
        self.captureSession=nil;
        
        [self.prevLayer removeFromSuperlayer];
        self.prevLayer = nil;
    }
}


- (void)decodeResultNotification: (NSNotification *)notification
{
    pageControl.enabled = true;
    for (int i = start; i < self.incidentInput.count && i < (lastPageCount + 1)* 12; i++)
    {
        InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
        inputView.btnInput.enabled = true;
    }
    cameraOn = NO;
    self.toolBar.userInteractionEnabled = YES;
    self.containerView1.userInteractionEnabled = YES;
    self.containerView2.userInteractionEnabled = YES;
    self.containerView3.userInteractionEnabled = YES;
    
    self.btnLookupPat.userInteractionEnabled = YES;
    [btnScanDl setTitle:@"Scan DL" forState:UIControlStateNormal];
    btnInbox.enabled = YES;
    
    if ([notification.object isKindOfClass:[DecoderResult class]])
	{
		ClsScanResult *obj = (ClsScanResult*)notification.object;
		if (obj.succeeded)
		{
            int flag = 0;
            @try
            {
                if (obj.result.length < 3)
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unable to parse input string" message:obj.result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    return;
                }
                NSString* dlStateStr = [obj.result substringToIndex:2];
                if ([dlStateStr isEqualToString:@"OH"])
                {
                    self.state = dlState;
                    self.dlState = dlState;
                    NSRange range = [obj.result rangeOfString:@"^"];
                    NSRange cityRange = NSMakeRange(2, range.location-2);
                    NSString* cityStr = [obj.result substringWithRange:cityRange];
                    self.city = cityStr;
                    NSRange range1 = [obj.result rangeOfString:@"$"];
                    self.lastName = [obj.result substringWithRange:NSMakeRange(range.location + 1, (range1.location - range.location - 2))];
                    
                    NSString* restOfStr = [obj.result substringFromIndex:range1.location+ 1];
                    NSRange range2 = [restOfStr rangeOfString:@"$"];
                    self.firstName = [restOfStr substringToIndex:range2.location];
                    restOfStr = [restOfStr substringFromIndex:range2.location+ 1];
                    NSRange range3 = [restOfStr rangeOfString:@"$"];
                    if (range3.location != NSNotFound)
                    {
                        self.middleInitial = [restOfStr substringToIndex:range3.location];
                    }
                    restOfStr = [restOfStr substringFromIndex:range3.location+ 2];
                    NSRange range4 = [restOfStr rangeOfString:@"^"];
                    self.address1 = [restOfStr substringToIndex:range4.location];
                    restOfStr = [restOfStr substringFromIndex:range4.location+ 1];
                    NSRange range5 = [restOfStr rangeOfString:@"="];
                    NSRange dlRange = NSMakeRange(range5.location - 6, 6);
                    self.dlNum = [restOfStr substringWithRange:dlRange];
                    restOfStr = [restOfStr substringFromIndex:range5.location+ 1];
                    NSRange range6 = [restOfStr rangeOfString:@" "];
                    NSRange zipRange = NSMakeRange(range6.location - 5, 5);
                    self.zip = [restOfStr substringWithRange:zipRange];
                    NSRange bdRange = NSMakeRange(range6.location - 15, 8);
                    NSString* dobStr = [restOfStr substringWithRange:bdRange];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyyMMdd"];
                    NSDate* dateOfBirth = [formatter dateFromString:dobStr];
                    
                    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy-MM-dd"];
                    NSString* datebirth = [dateFormat stringFromDate:dateOfBirth];
                    self.dob = datebirth;
                    NSDate* now = [NSDate date];
                    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                                       components:NSCalendarUnitYear
                                                       fromDate:dateOfBirth
                                                       toDate:now
                                                       options:0];
                    NSInteger ageInt = [ageComponents year];
                    
                    self.age = [NSString stringWithFormat:@"%ld", ageInt];
                    self.ageUnit = @"Yeas";
                    
                    restOfStr = [restOfStr substringFromIndex:range6.location+ 1];
                    NSRange range7 = [restOfStr rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet] ];
                    NSRange sexRage = NSMakeRange(range7.location, 1);
                    NSString* sex = [restOfStr substringWithRange:sexRage];
                    if ([sex isEqualToString:@"1"])
                    {
                        self.gender = @"Male";
                    }
                    else
                    {
                        self.gender = @"Female";
                    }

                    NSRange ftRange = NSMakeRange(range7.location + 1, 1);
                    NSRange inRange = NSMakeRange(range7.location + 2, 2);
                    self.height = [NSString stringWithFormat:@"%@ft %@", [restOfStr substringWithRange:ftRange], [restOfStr substringWithRange:inRange]];
                    self.weight = @" ";
                    [self saveDlData];
                }
                else
                {
                    if ([obj.result rangeOfString:@"ANSI"].location != NSNotFound)
                    {
                        NSRange range = [obj.result rangeOfString:@"DAJ"];
                        NSRange range1 = [obj.result rangeOfString:@"DAK"];
                        NSString* stateStr = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
                        
                        if ([stateStr rangeOfString:@"OR"].location != NSNotFound)
                        {
                            [self processOR:obj];
                        }
                        else if ([stateStr rangeOfString:@"TX"].location != NSNotFound)
                        {
                            [self processTX:obj];
                        }
                        else if ([stateStr rangeOfString:@"MA"].location != NSNotFound)
                        {
                            [self processMA:obj];
                        }
                        else if ([stateStr rangeOfString:@"WA"].location != NSNotFound)
                        {
                            [self processWA:obj];
                        }
                        else if ([stateStr rangeOfString:@"AZ"].location != NSNotFound)
                        {
                            [self processAZ:obj];
                        }
                        else if ([stateStr rangeOfString:@"IA"].location != NSNotFound)
                        {
                            [self processIAANSI:obj];
                        }
                        else if ([stateStr rangeOfString:@"FL"].location != NSNotFound)
                        {
                            [self processFL:obj];
                        }
                        else if ([stateStr rangeOfString:@"CO"].location != NSNotFound)
                        {
                            [self processCO:obj];
                        }
                        else
                        {
                            [self processTX:obj];
                        }
                        
                        
                    }
                    else if ([obj.result rangeOfString:@"AAMVA"].location != NSNotFound)
                    {
                        
                        [self processAAMVA:obj];
                    }
                    else
                    {
                        [self processTX:obj];
                    }
                    
                }
                
            }
            @catch (NSException *exception)
            {
                if (flag > 1)
                {
                    
                }
                else
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Unable to parse input string" message:obj.result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
            
		}
	}
    
    [self stopScanning];
    [self deinitCapture];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.captureSession = nil;
	self.prevLayer = nil;
    self.prevLayer = nil;
    self.device = nil;
    self.focusTimer = nil;
    self.result = nil;
    
}


- (void) processAAMVA:(ClsScanResult*) obj
{
    if ([obj.result rangeOfString:@"DAJ"].location != NSNotFound)
    {
        NSRange range = [obj.result rangeOfString:@"DAJ"];
        NSRange range1 = [obj.result rangeOfString:@"DAK"];
        
        NSString* stateStr = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
        self.state = stateStr;
        self.dlState = stateStr;
        if ([stateStr rangeOfString:@"AR"].location != NSNotFound)
        {
            [self processAR:obj];
        }
        else if ([stateStr rangeOfString:@"ME"].location != NSNotFound)
        {
            [self processME:obj];
        }
        else if ([stateStr rangeOfString:@"MD"].location != NSNotFound)
        {
            [self processMD:obj];
        }
        else if ([stateStr rangeOfString:@"CT"].location != NSNotFound)
        {
            [self processCT:obj];
        }
        else
        {
            [self processTX:obj];
        }
    }
    else if([obj.result rangeOfString:@"DAO"].location != NSNotFound)
    {
        NSRange range = [obj.result rangeOfString:@"DAO"];
        NSRange range1 = [obj.result rangeOfString:@"DAP"];
        
        NSString* stateStr = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
        self.state = stateStr;
        self.dlState = stateStr;
        NSString* rem = [obj.result substringFromIndex:range1.location];
        obj.result = nil;
        obj.result = rem;
        if ([stateStr rangeOfString:@"IA"].location != NSNotFound)
        {
            [self processIA:obj];
        }
        else if ([stateStr rangeOfString:@"OR"].location != NSNotFound)
        {
            [self processOR:obj];
        }
        else if ([stateStr rangeOfString:@"NC"].location != NSNotFound)
        {
                [self processNC:obj];
        }
        else
        {
            [self processTX:obj];
        }
        
    }
}

- (void) processNC:(ClsScanResult*) obj
{
    NSRange range = [obj.result rangeOfString:@"DAB"];
    NSRange range1 = [obj.result rangeOfString:@"DAC"];
    
    NSString* lNameStr = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    self.lastName = lNameStr;
    NSRange range2 = [obj.result rangeOfString:@"DAD"];
    NSString* name = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    self.firstName = name;
    NSRange range3 = [obj.result rangeOfString:@"DAE"];
    self.middleInitial = [obj.result substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];

    NSString* rem = [obj.result substringFromIndex:range3.location];
    
    range = [rem rangeOfString:@"DAL"];
    range1 = [rem rangeOfString:@"DAM"];
    self.address1 = [rem substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    range1 = [rem rangeOfString:@"DAN"];
    range2 = [rem rangeOfString:@"DAO"];
    self.city = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];

    range3 = [rem rangeOfString:@"DAP"];
    NSRange range4 = [rem rangeOfString:@"DAQ"];
    
    self.zip = [rem substringWithRange:NSMakeRange(range3.location + 3, (range4.location - range3.location - 3))];

    NSRange range5 = [rem rangeOfString:@"DAR"];
    
    self.dlNum = [rem substringWithRange:NSMakeRange(range4.location + 3, (range5.location - range4.location - 3))];
    
    //NSString* rem = [obj.result substringFromIndex:range5.location];
    range5 = [rem rangeOfString:@"DAV"];
    NSRange range6 = [rem rangeOfString:@"DAY"];
    
    self.height = [rem substringWithRange:NSMakeRange(range5.location + 3, (range6.location - range5.location - 3))];
    
 
    NSRange range9 = [obj.result rangeOfString:@"DBB"];
    NSRange range10 = [obj.result rangeOfString:@"DBC"];
    NSString* dobStr = [obj.result substringWithRange:NSMakeRange(range9.location + 3, (range10.location - range9.location - 3))];
    NSRange range11 = NSMakeRange(3,2);
    NSString* month = [dobStr substringToIndex:2];
    NSString* day = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,4);
    NSString* year = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";
    
    range1 = [rem rangeOfString:@"DBC"];
    
    range2 = [rem rangeOfString:@"DBD"];
    NSString* sex = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    
    if ([[sex substringToIndex:1] isEqualToString:@"F"])
    {
        self.gender = @"Female";
    }
    else
    {
        self.gender = @"Male";
    }
    
    [self saveDlData];
}


- (void) processCO:(ClsScanResult*) obj
{
    NSRange range0 = [obj.result rangeOfString:@"DAQ"];
    NSRange range1 = [obj.result rangeOfString:@"DCS"];
    NSString* dl = [obj.result substringWithRange:NSMakeRange(range0.location + 3, (range1.location - range0.location - 3))];
    self.dlNum = dl;
    NSRange range2 = [obj.result rangeOfString:@"DDE"];
    self.lastName = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 4))];
    
     NSRange range3 = [obj.result rangeOfString:@"DAC"];
    NSRange range4 = [obj.result rangeOfString:@"DDF"];
    self.firstName = [obj.result substringWithRange:NSMakeRange(range3.location + 3, (range4.location - range3.location - 4))];
    
    NSRange range5 = [obj.result rangeOfString:@"DAD"];
    NSRange range6 = [obj.result rangeOfString:@"DDG"];
    self.middleInitial = [obj.result substringWithRange:NSMakeRange(range5.location + 3, (range6.location - range5.location - 4))];
    

    NSString* rem = [obj.result substringFromIndex:range6.location];
    range2 = [rem rangeOfString:@"DAG"];
    range3 = [rem rangeOfString:@"DAI"];
    self.address1 = [rem substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];
    
    range4 = [rem rangeOfString:@"DAJ"];
    self.city  = [rem substringWithRange:NSMakeRange(range3.location + 3, (range4.location - range3.location - 3))];

    range5 = [rem rangeOfString:@"DAK"];
    self.state  = [rem substringWithRange:NSMakeRange(range4.location + 3, (range5.location - range4.location - 3))];

    self.dlState = self.state;

    self.zip  = [rem substringWithRange:NSMakeRange(range5.location + 3, 5)];
    
    
    NSRange range8 = [rem rangeOfString:@"DBB"];
    NSRange range9 = [rem rangeOfString:@"DBA"];
    NSString* dobStr = [rem substringWithRange:NSMakeRange(range8.location + 3, (range9.location - range8.location - 3))];
    NSRange range11 = NSMakeRange(2,2);
    NSString* month = [dobStr substringToIndex:2];
    NSString* day = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(4,4);
    NSString* year = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";
    range9 = [rem rangeOfString:@"DBC"];
    NSRange range = NSMakeRange((range9.location + 3), 1);
    NSString* sex = [rem substringWithRange:range];

    if ([sex isEqualToString:@"1"])
    {
        self.gender = @"Male";
    }
    else
    {
        self.gender = @"Female";
    }
    
    range6 = [rem rangeOfString:@"DAU"];
    NSRange range7 = [rem rangeOfString:@"DAY"];
    
    self.height = [rem substringWithRange:NSMakeRange(range6.location + 3, (range7.location - range6.location - 3))];
    self.weight = @" ";
  //  range8 = [rem rangeOfString:@"DAZ"];
  //  NSString* weightStr = [rem substringWithRange:NSMakeRange(range7.location + 3, (range8.location - range7.location - 3))];
  //  [btnWeight setTitle:weightStr forState:UIControlStateNormal];
    
    [self saveDlData];
    
}


- (void) processFL:(ClsScanResult*) obj
{
    NSRange range = [obj.result rangeOfString:@"LDA"];
    NSRange range1 = [obj.result rangeOfString:@"DAG"];
    
    NSString* nameStr = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    NSArray* nameArray = [nameStr componentsSeparatedByString:@","];
    for (int j=0; j< [nameArray count]; j++)
    {
        if (j == 0)
        {
            self.lastName = [nameArray objectAtIndex:j];
        }
        if (j == 1)
        {
            self.firstName = [nameArray objectAtIndex:j];
        }
        if (j == 2)
        {
            self.middleInitial = [nameArray objectAtIndex:j];
        }
    }
    
    
    NSString* rem = [obj.result substringFromIndex:range1.location];
    
    range = [rem rangeOfString:@"DAG"];
    range1 = [rem rangeOfString:@"DAI"];
    self.address1 = [rem substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    NSRange range2 = [rem rangeOfString:@"DAJ"];
    self.city = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    
    range2 = [rem rangeOfString:@"DAJ"];
    NSRange range3 = [rem rangeOfString:@"DAK"];
    self.state = [rem substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];
    self.dlState = self.state;
    
    self.zip = [rem substringWithRange:NSMakeRange(range3.location + 3, 5)];

    NSRange range5 = [rem rangeOfString:@"DAQ"];
    NSRange range6 = [rem rangeOfString:@"DAR"];
    self.dlNum = [rem substringWithRange:NSMakeRange(range5.location + 3, (range6.location - range5.location - 3))];

    
    range5 = [rem rangeOfString:@"DAU"];
    
    self.height = [rem substringWithRange:NSMakeRange(range5.location + 3, 3)];
    
    NSRange range9 = [obj.result rangeOfString:@"DBB"];
    NSRange range10 = [obj.result rangeOfString:@"DBC"];
    NSString* dobStr = [obj.result substringWithRange:NSMakeRange(range9.location + 3, (range10.location - range9.location - 3))];

    NSRange range11 = NSMakeRange(4,2);
    NSString* year = [dobStr substringToIndex:4];
    NSString* month = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,2);
    NSString* day = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";
    
    range1 = [rem rangeOfString:@"DBC"];
    
    NSString* sex = [rem substringWithRange:NSMakeRange(range1.location + 3, 1)];
    
    if ([[sex substringToIndex:1] isEqualToString:@"1"])
    {
        self.gender = @"Male";
    }
    else
    {
        self.gender = @"Female";
    }
    [self saveDlData];
    
}



- (void) processIAANSI:(ClsScanResult*) obj
{
    NSRange range = [obj.result rangeOfString:@"DCS"];
    NSRange range1 = [obj.result rangeOfString:@"DAC"];
    
    self.lastName = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    
    NSRange range2 = [obj.result rangeOfString:@"DAD"];
    self.firstName = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    NSRange range3 = [obj.result rangeOfString:@"DBD"];
    self.middleInitial = [obj.result substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];

    NSString* rem = [obj.result substringFromIndex:range3.location];
    
    range = [rem rangeOfString:@"DAG"];
    range1 = [rem rangeOfString:@"DAI"];
    self.address1 = [rem substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    range2 = [rem rangeOfString:@"DAJ"];
    self.city = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    
    range2 = [rem rangeOfString:@"DAJ"];
    range3 = [rem rangeOfString:@"DAK"];
    self.state = [rem substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];
    self.dlState = self.state;
    
    self.zip = [rem substringWithRange:NSMakeRange(range3.location + 3, 5)];

    NSRange range5 = [rem rangeOfString:@"DCK"];
    
    NSString* dlStr = [rem substringWithRange:NSMakeRange(range5.location + 3, 9)];
    self.dlNum = dlStr;
    

    range5 = [rem rangeOfString:@"DAU"];
    NSRange range6 = [rem rangeOfString:@"DAG"];
    
    self.height = [rem substringWithRange:NSMakeRange(range5.location + 3, (range6.location - range5.location - 3))];
    
    NSRange range9 = [obj.result rangeOfString:@"DBB"];
    NSRange range10 = [obj.result rangeOfString:@"DBC"];
    NSString* dobStr = [obj.result substringWithRange:NSMakeRange(range9.location + 3, (range10.location - range9.location - 3))];
    NSRange range11 = NSMakeRange(2,2);
    NSString* month = [dobStr substringToIndex:2];
    NSString* day = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(4,4);
    NSString* year = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    
    range1 = [rem rangeOfString:@"DBC"];
    
  //  range2 = [rem rangeOfString:@"DAY"];
    NSString* sex = [rem substringWithRange:NSMakeRange(range1.location + 3, 1)];
    
    if ([[sex substringToIndex:1] isEqualToString:@"1"])
    {
        self.gender = @"Male";
    }
    else
    {
        self.gender = @"Female";
    }
    [self saveDlData];
    
}

- (void) processMD:(ClsScanResult*) obj
{
    NSRange range = [obj.result rangeOfString:@"DAQ"];
    NSRange range1 = [obj.result rangeOfString:@"DAA"];
    
    NSString* dlStr = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    self.dlNum = dlStr;
    NSRange range2 = [obj.result rangeOfString:@"DAG"];
    NSString* nameStr = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    NSArray* nameArray = [nameStr componentsSeparatedByString:@","];
    for (int j=0; j< [nameArray count]; j++)
    {
        if (j == 0)
        {
            self.lastName = [nameArray objectAtIndex:j];
        }
        if (j == 1)
        {
            self.firstName = [nameArray objectAtIndex:j];
        }
        if (j == 2)
        {
            self.middleInitial = [nameArray objectAtIndex:j];
        }
    }
    
    NSString* rem = [obj.result substringFromIndex:range2.location];
    range2 = [rem rangeOfString:@"DAG"];
    NSRange range3 = [rem rangeOfString:@"DAI"];
    self.address1 = [rem substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];
    
    NSRange range4 = [rem rangeOfString:@"DAJ"];
    self.city = [rem substringWithRange:NSMakeRange(range3.location + 3, (range4.location - range3.location - 3))];
    
    range3 = [rem rangeOfString:@"DAK"];
 //   range4 = [rem rangeOfString:@"DAR"];
    self.zip = [rem substringWithRange:NSMakeRange(range3.location + 3, 5)];

    NSRange range7 = [rem rangeOfString:@"DAU"];
    NSRange range8 = [rem rangeOfString:@"DAW"];
    self.height = [rem substringWithRange:NSMakeRange(range7.location + 3, (range8.location - range7.location - 3))];

    NSRange range9 = [rem rangeOfString:@"DBA"];
    self.weight = [rem substringWithRange:NSMakeRange(range8.location + 3, (range9.location - range8.location - 3))];
    
    range1 = [rem rangeOfString:@"DBB"];
    range2 = [rem rangeOfString:@"DBC"];
    
    NSString* dobStr = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    NSRange range11 = NSMakeRange(4,2);
    NSString* year = [dobStr substringToIndex:4];
    NSString* month = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,2);
    NSString* day = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";
    
    
    range1 = [rem rangeOfString:@"DBC"];
    
    range2 = [rem rangeOfString:@"DBD"];
    NSString* sex = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];

    if ([[sex substringToIndex:1] isEqualToString:@"1"])
    {
        self.gender = @"Male";
    }
    else
    {
        self.gender = @"Female";
    }
    [self saveDlData];
    
}



- (void) processOR:(ClsScanResult*) obj
{
    NSRange range2 = [obj.result rangeOfString:@"DAA"];
    NSRange range3 = [obj.result rangeOfString:@"DAL"];
    NSString* name = [obj.result substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];
    NSArray* nameArray = [name componentsSeparatedByString:@","];
    self.lastName = [nameArray objectAtIndex:0];
    NSString* firstMid = [nameArray objectAtIndex:1];
    NSArray* firstMidArray = [firstMid componentsSeparatedByString:@" "];
    for (int j=0; j< [firstMidArray count]; j++)
    {
        if (j == 1)
        {
            self.firstName = [firstMidArray objectAtIndex:j];
        }
        if (j == 2)
        {
            self.middleInitial = [firstMidArray objectAtIndex:j];
        }
    }
    
    NSString* rem = [obj.result substringFromIndex:range3.location];
    range3 = [rem rangeOfString:@"DAL"];
    NSRange range4 = [rem rangeOfString:@"DAN"];
    self.address1 = [rem substringWithRange:NSMakeRange(range3.location + 3, (range4.location - range3.location - 3))];
    NSRange range5 = [rem rangeOfString:@"DAO"];
    self.city = [rem substringWithRange:NSMakeRange(range4.location + 3, (range5.location - range4.location - 3))];

    NSRange range6 = [rem rangeOfString:@"DAP"];
    NSString* state1 = [rem substringWithRange:NSMakeRange(range5.location + 3, (range6.location - range5.location - 3))];
    self.state = state1;
    self.dlState = state1;
    
    NSRange range = [rem rangeOfString:@"DAQ"];
    self.zip = [rem substringWithRange:NSMakeRange(range6.location + 3, (range.location - range6.location - 3))];
    
    
    NSRange range1 = [rem rangeOfString:@"DBB"];
    self.dlNum = [rem substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    
    
    
    range6 = [rem rangeOfString:@"DAU"];
    NSRange range7 = [rem rangeOfString:@"DAR"];
    
    self.height = [rem substringWithRange:NSMakeRange(range6.location + 3, (range7.location - range6.location - 3))];

    NSRange range8 = [rem rangeOfString:@"DAW"];
    self.weight = [rem substringWithRange:NSMakeRange(range8.location + 3, (range6.location - range8.location - 3))];
    
    NSRange range9 = [rem rangeOfString:@"DBB"];
    NSRange range10 = [rem rangeOfString:@"DBA"];
    NSString* dobStr = [rem substringWithRange:NSMakeRange(range9.location + 3, (range10.location - range9.location - 3))];
    NSRange range11 = NSMakeRange(4,2);
    NSString* year = [dobStr substringToIndex:4];
    NSString* month = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,2);
    NSString* day = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";
    
    range1 = [rem rangeOfString:@"DBC"];
    
    range2 = NSMakeRange((range1.location + 3), 1);
    NSString* sex = [rem substringWithRange:range2];
    if ([sex isEqualToString:@"F"])
    {
        self.gender = @"Female";
    }
    else
    {
        self.gender = @"Male";
    }
    [self saveDlData];
}

- (void) processCT:(ClsScanResult*) obj
{
    NSRange range = [obj.result rangeOfString:@"DAQ"];
    NSRange range1 = [obj.result rangeOfString:@"DAR"];
    
    self.dlNum = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    
    NSRange range2 = [obj.result rangeOfString:@"DBB"];
    NSRange range3 = [obj.result rangeOfString:@"DBC"];
    NSString* dobStr = [obj.result substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];
    NSRange range11 = NSMakeRange(4,2);
    NSString* year = [dobStr substringToIndex:4];
    NSString* month = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,2);
    NSString* day = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%li", ageInt];
    self.ageUnit = @"Years";
    
    range2 = [obj.result rangeOfString:@"DAA"];
    range3 = [obj.result rangeOfString:@"DAG"];
    
    NSString* name = [obj.result substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];

    NSArray* nameArray = [name componentsSeparatedByString:@","];
    for (int j=0; j< [nameArray count]; j++)
    {
        if (j == 0)
        {
            self.lastName = [nameArray objectAtIndex:j];
        }
        if (j == 1)
        {
            self.firstName = [nameArray objectAtIndex:j];
        }
        if (j == 2)
        {
            self.middleInitial = [nameArray objectAtIndex:j];
        }
    }
    
    
    NSString* rem = [obj.result substringFromIndex:range2.location];
    range = [rem rangeOfString:@"DAG"];
    range1 = [rem rangeOfString:@"DAI"];
    self.address1 = [rem substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    range2 = [rem rangeOfString:@"DAJ"];
    self.city = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    range3 = [rem rangeOfString:@"DAK"];
    //  NSRange range4 = [rem rangeOfString:@"DAW"];
    
   self.zip = [rem substringWithRange:NSMakeRange(range3.location + 3, 5)];
    
    
    range1 = [rem rangeOfString:@"DBC"];
    
    range2 = [rem rangeOfString:@"DBD"];
    NSString* sex = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    
    if ([[sex substringToIndex:1] isEqualToString:@"2"])
    {
        self.gender = @"Female";
    }
    else
    {
        self.gender = @"Male";
    }

    
    
    NSRange range7 = [rem rangeOfString:@"DAU"];
    NSRange range8 = [rem rangeOfString:@"DAY"];
    self.height = [rem substringWithRange:NSMakeRange(range7.location + 3, (range8.location - range7.location - 3))];
    self.weight = @" ";
    [self saveDlData];
}


- (void) processME:(ClsScanResult*) obj
{
    NSRange range = [obj.result rangeOfString:@"DAQ"];
    NSRange range1 = [obj.result rangeOfString:@"DBB"];
    
    self.dlNum = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];

    NSRange range2 = [obj.result rangeOfString:@"DBA"];
    NSString* dobStr = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    NSRange range11 = NSMakeRange(4,2);
    NSString* year = [dobStr substringToIndex:4];
    NSString* month = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,2);
    NSString* day = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";
    
    range = [obj.result rangeOfString:@"DAB"];
    range1 = [obj.result rangeOfString:@"DAC"];
    
    self.lastName = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];

    range2 = [obj.result rangeOfString:@"DAD"];
    self.firstName = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];

    if ([obj.result rangeOfString:@"DAE"].location != NSNotFound)
    {
        NSRange range3 = [obj.result rangeOfString:@"DAE"];
        self.middleInitial = [obj.result substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];

    }
    
    NSString* rem = [obj.result substringFromIndex:range2.location];
    range = [rem rangeOfString:@"DAG"];
    range1 = [rem rangeOfString:@"DAI"];
    self.address1 = [rem substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    range2 = [rem rangeOfString:@"DAJ"];
    self.city = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];

    NSRange range3 = [rem rangeOfString:@"DAK"];
  //  NSRange range4 = [rem rangeOfString:@"DAW"];
    
    self.zip = [rem substringWithRange:NSMakeRange(range3.location + 3, 5)];
    
    
    range1 = [rem rangeOfString:@"DBC"];
    
    range2 = [rem rangeOfString:@"DAZ"];
    NSString* genderStr = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    
    if ([[genderStr substringToIndex:1] isEqualToString:@"F"])
    {
        self.gender = @"Female";
    }
    else
    {
        self.gender = @"Male";
    }
    
    NSRange range5 = [rem rangeOfString:@"DAW"];
    NSRange range6 = [rem rangeOfString:@"DBC"];
    
    self.weight = [rem substringWithRange:NSMakeRange(range5.location + 3, (range6.location - range5.location - 3))];
    
    NSRange range7 = [rem rangeOfString:@"DAU"];
    NSRange range8 = [rem rangeOfString:@"DAR"];
    self.height = [rem substringWithRange:NSMakeRange(range7.location + 3, (range8.location - range7.location - 3))];
    [self saveDlData];
}


- (void) processIA:(ClsScanResult*) obj
{
    NSRange range = [obj.result rangeOfString:@"DAB"];
    NSRange range1 = [obj.result rangeOfString:@"DAC"];
    
    self.lastName = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    
    NSRange range2 = [obj.result rangeOfString:@"DAL"];
    NSString* name = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    NSArray* nameArray = [name componentsSeparatedByString:@"\n"];
    for (int j=0; j< [nameArray count]; j++)
    {
        if (j == 0)
        {
            self.firstName = [nameArray objectAtIndex:j];
        }
        if (j == 1)
        {
            self.middleInitial = [nameArray objectAtIndex:j];
        }
    }

    NSString* rem = [obj.result substringFromIndex:range2.location];
    
    range = [rem rangeOfString:@"DAL"];
    range1 = [rem rangeOfString:@"DAN"];
    self.address1 = [rem substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    range2 = [rem rangeOfString:@"DAO"];
    self.city = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    
    NSRange range3 = [rem rangeOfString:@"DAP"];
    NSRange range4 = [rem rangeOfString:@"DAQ"];
    
    self.zip = [rem substringWithRange:NSMakeRange(range3.location + 3, (range4.location - range3.location - 3))];
    NSRange range5 = [rem rangeOfString:@"DAR"];
    
    self.dlNum = [rem substringWithRange:NSMakeRange(range4.location + 3, (range5.location - range4.location - 3))];
    
    //NSString* rem = [obj.result substringFromIndex:range5.location];
    range5 = [rem rangeOfString:@"DAU"];
    NSRange range6 = [rem rangeOfString:@"DAW"];
    
    self.height = [rem substringWithRange:NSMakeRange(range5.location + 3, (range6.location - range5.location - 3))];
    
    NSRange range7 = [rem rangeOfString:@"DAY"];
    self.weight = [rem substringWithRange:NSMakeRange(range6.location + 3, (range7.location - range6.location - 3))];

    NSRange range9 = [obj.result rangeOfString:@"DBB"];
    NSRange range10 = [obj.result rangeOfString:@"DBC"];
    NSString* dobStr = [obj.result substringWithRange:NSMakeRange(range9.location + 3, (range10.location - range9.location - 3))];
    NSRange range11 = NSMakeRange(4,2);
    NSString* year = [dobStr substringToIndex:4];
    NSString* month = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,2);
    NSString* day = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";
    
    range1 = [rem rangeOfString:@"DBC"];
    
    range2 = [rem rangeOfString:@"DBD"];
    NSString* genderStr = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    
    if ([[genderStr substringToIndex:1] isEqualToString:@"F"])
    {
        self.gender = @"Female";
    }
    else
    {
        self.gender = @"Male";
    }
    
    [self saveDlData];
    
}


- (void) processAR:(ClsScanResult*) obj
{
    NSRange range = [obj.result rangeOfString:@"DAQ"];
    NSRange range1 = [obj.result rangeOfString:@"DAA"];
    
    self.dlNum = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    
    NSRange range2 = [obj.result rangeOfString:@"DAG"];
    NSString* name = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    NSArray* nameArray = [name componentsSeparatedByString:@","];
    for (int j=0; j< [nameArray count]; j++)
    {
        if (j == 0)
        {
            self.lastName = [nameArray objectAtIndex:j];
        }
        if (j == 1)
        {
            self.firstName = [nameArray objectAtIndex:j];
        }
        if (j == 2)
        {
            self.middleInitial = [nameArray objectAtIndex:j];
        }
    }
    
    range = [obj.result rangeOfString:@"DAG"];
    range1 = [obj.result rangeOfString:@"DAI"];
    self.address1 = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    range2 = [obj.result rangeOfString:@"DAJ"];
    self.city = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    
    NSRange range3 = [obj.result rangeOfString:@"DAK"];
    NSRange range4 = [obj.result rangeOfString:@"DAR"];
    
    self.zip = [obj.result substringWithRange:NSMakeRange(range3.location + 3, (range4.location - range3.location - 3))];
    
    NSRange range5 = [obj.result rangeOfString:@"DAU"];
    NSRange range6 = [obj.result rangeOfString:@"DAW"];
    
    self.height = [obj.result substringWithRange:NSMakeRange(range5.location + 3, (range6.location - range5.location - 3))];
    
    NSRange range7 = [obj.result rangeOfString:@"DAY"];
    self.weight= [obj.result substringWithRange:NSMakeRange(range6.location + 3, (range7.location - range6.location - 3))];

    NSRange range9 = [obj.result rangeOfString:@"DBB"];
    NSRange range10 = [obj.result rangeOfString:@"DBC"];
    NSString* dobStr = [obj.result substringWithRange:NSMakeRange(range9.location + 3, (range10.location - range9.location - 3))];
    NSRange range11 = NSMakeRange(4,2);
    NSString* year = [dobStr substringToIndex:4];
    NSString* month = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,2);
    NSString* day = [dob substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";

    
    range1 = [obj.result rangeOfString:@"DBC"];
    
    range2 = [obj.result rangeOfString:@"DBD"];
    NSString* genderStr = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    
    if ([[genderStr substringToIndex:1] isEqualToString:@"F"])
    {
        self.gender = @"Female";
    }
    else
    {
        self.gender = @"Male";
    }

    [self saveDlData];
}

- (void) processAnsiOR:(ClsScanResult*) obj
{
    NSRange range = [obj.result rangeOfString:@"DAQ"];
    NSRange range1 = [obj.result rangeOfString:@"DAA"];
    self.dlNum = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    
    NSRange range2 = [obj.result rangeOfString:@"DAG"];
    NSString* name = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    NSArray* nameArray = [name componentsSeparatedByString:@","];
    self.lastName = [nameArray objectAtIndex:0];
    NSString* firstMid = [nameArray objectAtIndex:1];
    NSArray* firstMidArray = [firstMid componentsSeparatedByString:@" "];
    for (int j=0; j< [firstMidArray count]; j++)
    {
        if (j == 1)
        {
            self.firstName = [firstMidArray objectAtIndex:j];
        }
        if (j == 2)
        {
            self.middleInitial = [firstMidArray objectAtIndex:j];
        }
    }
    range = [obj.result rangeOfString:@"DAL"];
    range1 = [obj.result rangeOfString:@"DAI"];
    self.address1 = [obj.result substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    range2 = [obj.result rangeOfString:@"DAJ"];
    self.city = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];

    NSRange range3 = [obj.result rangeOfString:@"DAK"];
    NSString* state1 = [obj.result substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];
    self.state = state1;
    self.dlState = state1;
    
    NSRange range4 = [obj.result rangeOfString:@"DAR"];
    self.zip = [obj.result substringWithRange:NSMakeRange(range3.location + 3, (range4.location - range3.location - 3))];
    
    NSRange range6 = [obj.result rangeOfString:@"DAU"];
    NSRange range7 = [obj.result rangeOfString:@"DAW"];
    
    self.height = [obj.result substringWithRange:NSMakeRange(range6.location + 3, (range7.location - range6.location - 3))];

    NSRange range8 = [obj.result rangeOfString:@"DBA"];
    self.weight = [obj.result substringWithRange:NSMakeRange(range7.location + 3, (range8.location - range7.location - 3))];
    
    NSRange range9 = [obj.result rangeOfString:@"DBB"];
    NSRange range10 = [obj.result rangeOfString:@"DBC"];
    NSString* dobStr = [obj.result substringWithRange:NSMakeRange(range9.location + 3, (range10.location - range9.location - 3))];
    NSRange range11 = NSMakeRange(4,2);
    NSString* year = [dobStr substringToIndex:4];
    NSString* month = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,2);
    NSString* day = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";
    
    range1 = [obj.result rangeOfString:@"DBC"];
    
    range2 = NSMakeRange((range1.location + 3), 1);
    NSString* sex = [obj.result substringWithRange:range2];

    if ([sex isEqualToString:@"1"])
    {
        self.gender = @"Male";
    }
    else
    {
        self.gender = @"Female";
    }
    [self saveDlData];
}

- (void) processWA:(ClsScanResult*) obj
{
    NSRange range1 = [obj.result rangeOfString:@"DAA"];
    NSRange range2 = [obj.result rangeOfString:@"DAG"];
    NSString* nameStr = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 4))];
    NSArray* nameArray = [nameStr componentsSeparatedByString:@","];
    for (int j=0; j< [nameArray count]; j++)
    {
        if (j == 0)
        {
            self.lastName = [nameArray objectAtIndex:j];
        }
        if (j == 1)
        {
            self.firstName = [nameArray objectAtIndex:j];
        }
        if (j == 2)
        {
            self.middleInitial = [nameArray objectAtIndex:j];
        }
        
    }
    NSString* rem = [obj.result substringFromIndex:range2.location];
    range2 = [rem rangeOfString:@"DAG"];
    NSRange range3 = [rem rangeOfString:@"DAI"];
    NSString* streetNum = [rem substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];
    self.address1 = streetNum;
    NSRange range4 = [rem rangeOfString:@"DAJ"];
    self.city  = [rem substringWithRange:NSMakeRange(range3.location + 3, (range4.location - range3.location - 3))];

    NSRange range5 = [rem rangeOfString:@"DAK"];
    NSString* state1  = [rem substringWithRange:NSMakeRange(range4.location + 3, (range5.location - range4.location - 3))];
    
    self.state = state1;
    self.dlState = state1;
    
    NSRange range6 = [rem rangeOfString:@"DAQ"];
    self.zip  = [rem substringWithRange:NSMakeRange(range5.location + 3, (range6.location - range5.location - 3))];

    NSRange range7 = [rem rangeOfString:@"DAR"];
    self.dlNum = [rem substringWithRange:NSMakeRange(range6.location + 3, (range7.location - range6.location - 3))];

    NSRange range8 = [rem rangeOfString:@"DBB"];
    NSRange range9 = [rem rangeOfString:@"DBC"];
    NSString* dobStr = [rem substringWithRange:NSMakeRange(range8.location + 3, (range9.location - range8.location - 3))];
    NSRange range11 = NSMakeRange(4,2);
    NSString* year = [dobStr substringToIndex:4];
    NSString* month = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,2);
    NSString* day = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";

    NSRange range = NSMakeRange((range9.location + 3), 1);
    NSString* sex = [rem substringWithRange:range];

    if ([sex isEqualToString:@"1"])
    {
        self.gender = @"Male";
    }
    else
    {
        self.gender = @"Female";
    }

    
    range6 = [rem rangeOfString:@"DAU"];
    range7 = [rem rangeOfString:@"DAW"];
    
    self.height = [rem substringWithRange:NSMakeRange(range6.location + 3, (range7.location - range6.location - 3))];
    range8 = [rem rangeOfString:@"DAY"];
    self.weight = [rem substringWithRange:NSMakeRange(range7.location + 3, (range8.location - range7.location - 3))];
    
    [self saveDlData];
    
}

- (void) processAZ:(ClsScanResult*) obj
{
    NSRange range0 = [obj.result rangeOfString:@"DAQ"];
    NSRange range1 = [obj.result rangeOfString:@"DAA"];
    self.dlNum = [obj.result substringWithRange:NSMakeRange(range0.location + 3, (range1.location - range0.location - 3))];

    NSRange range2 = [obj.result rangeOfString:@"DAB"];
    NSString* nameStr = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 4))];
    NSArray* nameArray = [nameStr componentsSeparatedByString:@","];
    for (int j=0; j< [nameArray count]; j++)
    {
        if (j == 0)
        {
            self.lastName = [nameArray objectAtIndex:j];
        }
        if (j == 1)
        {
            self.firstName = [nameArray objectAtIndex:j];
        }
        if (j == 2)
        {
            self.middleInitial = [nameArray objectAtIndex:j];
        }
        
    }
    NSString* rem = [obj.result substringFromIndex:range2.location];
    range2 = [rem rangeOfString:@"DAG"];
    NSRange range3 = [rem rangeOfString:@"DAI"];
    self.address1 = [rem substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];

    NSRange range4 = [rem rangeOfString:@"DAJ"];
    self.city  = [rem substringWithRange:NSMakeRange(range3.location + 3, (range4.location - range3.location - 3))];

    NSRange range5 = [rem rangeOfString:@"DAK"];
    NSString* state1  = [rem substringWithRange:NSMakeRange(range4.location + 3, (range5.location - range4.location - 3))];
    self.state = state1;
    self.dlState = state1;
    NSRange range6 = [rem rangeOfString:@"DBB"];
    self.zip  = [rem substringWithRange:NSMakeRange(range5.location + 3, (range6.location - range5.location - 3))];
    

    NSRange range8 = [rem rangeOfString:@"DBB"];
    NSRange range9 = [rem rangeOfString:@"DBA"];
    NSString* dobStr = [rem substringWithRange:NSMakeRange(range8.location + 3, (range9.location - range8.location - 3))];
    NSRange range11 = NSMakeRange(4,2);
    NSString* year = [dobStr substringToIndex:4];
    NSString* month = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,2);
    NSString* day = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";

    range9 = [rem rangeOfString:@"DBC"];
    NSRange range = NSMakeRange((range9.location + 3), 1);
    NSString* sex = [rem substringWithRange:range];

    if ([sex isEqualToString:@"1"])
    {
        self.gender = @"Male";
    }
    else
    {
        self.gender = @"Female";
    }
    
    range6 = [rem rangeOfString:@"DAU"];
    NSRange range7 = [rem rangeOfString:@"DAW"];
    
    self.height = [rem substringWithRange:NSMakeRange(range6.location + 3, (range7.location - range6.location - 3))];
    range8 = [rem rangeOfString:@"DAZ"];
    self.weight = [rem substringWithRange:NSMakeRange(range7.location + 3, (range8.location - range7.location - 3))];
    [self saveDlData];
    
    
}



- (void) processMA:(ClsScanResult*) obj
{
    NSRange range1 = [obj.result rangeOfString:@"DAA"];
    NSRange range2 = [obj.result rangeOfString:@"DAG"];
    NSString* nameStr = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 4))];
    NSArray* nameArray = [nameStr componentsSeparatedByString:@","];
    for (int j=0; j< [nameArray count]; j++)
    {
        if (j == 0)
        {
            self.lastName = [nameArray objectAtIndex:j];
        }
        if (j == 1)
        {
            self.firstName = [nameArray objectAtIndex:j];
        }
        if (j == 2)
        {
            self.middleInitial = [nameArray objectAtIndex:j];
        }
        
    }
    
    NSString* rem = [obj.result substringFromIndex:range2.location];
    range2 = [rem rangeOfString:@"DAG"];
    NSRange range3 = [rem rangeOfString:@"DAI"];
    self.address1 = [rem substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];

    NSRange range4 = [rem rangeOfString:@"DAJ"];
    self.city  = [rem substringWithRange:NSMakeRange(range3.location + 3, (range4.location - range3.location - 3))];

    NSRange range5 = [rem rangeOfString:@"DAK"];
    NSString* state1  = [rem substringWithRange:NSMakeRange(range4.location + 3, (range5.location - range4.location - 3))];
    self.state = state1;
    self.dlState = state1;
    NSRange range6 = [rem rangeOfString:@"DAQ"];
    self.zip = [rem substringWithRange:NSMakeRange(range5.location + 3, (range6.location - range5.location - 3))];

    NSRange range7 = [rem rangeOfString:@"DAR"];
    self.dlNum = [rem substringWithRange:NSMakeRange(range6.location + 3, (range7.location - range6.location - 3))];
    
    NSRange range8 = [rem rangeOfString:@"DBB"];
    NSRange range9 = [rem rangeOfString:@"DBC"];
    NSString* dobStr = [rem substringWithRange:NSMakeRange(range8.location + 3, (range9.location - range8.location - 3))];
    NSRange range11 = NSMakeRange(4,2);
    NSString* year = [dobStr substringToIndex:4];
    NSString* month = [dobStr substringWithRange:range11];
    range11 = NSMakeRange(6,2);
    NSString* day = [dobStr substringWithRange:range11];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";
    
    NSRange range = NSMakeRange((range9.location + 3), 1);
    NSString* sex = [rem substringWithRange:range];
    NSString* gender;
    if ([sex isEqualToString:@"M"])
    {
        self.gender = @"Male";
    }
    else
    {
        self.gender = @"Female";
    }
    [self saveDlData];
}

- (void) processTX:(ClsScanResult*) obj
{
    NSRange range1 = [obj.result rangeOfString:@"DCS"];
    NSRange range2 = [obj.result rangeOfString:@"DCT"];
    NSRange range3 = [obj.result rangeOfString:@"DBD"];
    self.lastName = [obj.result substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 4))];
    NSString* firstMid = [obj.result substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 4))];
    NSArray* firstMidArray = [firstMid componentsSeparatedByString:@" "];
    
    for (int j=0; j< [firstMidArray count]; j++)
    {
        if (j == 0)
        {
            self.firstName = [[firstMid componentsSeparatedByString:@" "] objectAtIndex:0];
        }
        if (j == 1)
        {
            self.middleInitial = [[firstMid componentsSeparatedByString:@" "] objectAtIndex:1];
        }
        
    }
    
    NSString* rem = [obj.result substringFromIndex:range3.location];
    
    NSRange range4 = [rem rangeOfString:@"DBB"];
    NSRange range5 = [rem rangeOfString:@"DBC"];
    NSString* dobStr = [rem substringWithRange:NSMakeRange(range4.location + 3, (range5.location - range4.location - 3))];
    NSRange range = NSMakeRange(4,4);
    NSString* year = [dobStr substringWithRange:range];
    NSString* month = [dobStr substringToIndex:2];
    range = NSMakeRange(2,2);
    NSString* day = [dobStr substringWithRange:range];
    
    self.dob = [NSString stringWithFormat:@"%@-%@-%@", year,month, day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateOfBirth = [formatter dateFromString:self.dob];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:dateOfBirth
                                       toDate:now
                                       options:0];
    NSInteger ageInt = [ageComponents year];
    
    self.age = [NSString stringWithFormat:@"%ld", ageInt];
    self.ageUnit = @"Years";
    
    range1 = [rem rangeOfString:@"DBC"];
    
    range2 = NSMakeRange((range1.location + 3), 1);
    NSString* sex = [rem substringWithRange:range2];
    if ([sex isEqualToString:@"1"])
    {
        self.gender = @"Male";
    }
    else
    {
        self.gender = @"Female";
    }

    
    NSRange range6 = [rem rangeOfString:@"DAU"];
    NSRange range7 = [rem rangeOfString:@"DAG"];
    
    self.height = [rem substringWithRange:NSMakeRange(range6.location + 3, (range7.location - range6.location - 3))];
    self.weight = @" ";
    
    range = [rem rangeOfString:@"DAG"];
    range1 = [rem rangeOfString:@"DAI"];
    self.address1 = [rem substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];

    range2 = [rem rangeOfString:@"DAJ"];
    
   self.city = [rem substringWithRange:NSMakeRange(range1.location + 3, (range2.location - range1.location - 3))];
    
    range3 = [rem rangeOfString:@"DAK"];
    NSString* stateStr = [rem substringWithRange:NSMakeRange(range2.location + 3, (range3.location - range2.location - 3))];
    
    self.state = stateStr;
    self.dlState = stateStr;
    
    range4 = NSMakeRange(range3.location + 3, 5);
    self.zip = [rem substringWithRange:range4];

    range = [rem rangeOfString:@"DAQ"];
    range1 = [rem rangeOfString:@"DCF"];
    self.dlNum = [rem substringWithRange:NSMakeRange(range.location + 3, (range1.location - range.location - 3))];
    [self saveDlData];
}

- (void) saveDlData
{
    NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1101, 0, 1, @"", @"", self.lastName];
    NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.lastName, ticketID, 1101];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1102, 0, 1, @"", @"", self.firstName];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.firstName, ticketID, 1102];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1103, 0, 1, @"", @"", self.dob];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.dob, ticketID, 1103];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1105, 0, 1, @"", @"", self.gender];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.gender, ticketID, 1105];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1107, 0, 1, @"", @"", self.address1];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.address1, ticketID, 1107];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1109, 0, 1, @"", @"", self.city];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.city, ticketID, 1109];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1110, 0, 1, @"", @"", self.state];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.state, ticketID, 1110];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1112, 0, 1, @"", @"", self.zip];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.zip, ticketID, 1112];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1118, 0, 1, @"", @"", self.middleInitial];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.middleInitial, ticketID, 1118];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }

    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1119, 0, 1, @"", @"", self.age];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.age, ticketID, 1119];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1131, 0, 1, @"", @"", self.height];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.height, ticketID, 1131];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1132, 0, 1, @"", @"", self.weight];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.weight, ticketID, 1132];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1134, 0, 1, @"", @"", self.ageUnit];
    updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", self.ageUnit, ticketID, 1134];
    @synchronized(g_SYNCDATADB)
    {
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    
    [self setViewUI:self.pageControl.currentPage];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
    //    [self startScanning];
    }
}

- (void) doneDataViewClick
{
    PopupDataViewController* p = (PopupDataViewController*) popover.contentViewController;
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}


- (NSUInteger)supportedInterfaceOrientations {
    
    
    UIInterfaceOrientation interfaceOrientation =[[UIApplication sharedApplication] statusBarOrientation];
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:
            return UIInterfaceOrientationMaskPortrait;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationMaskPortraitUpsideDown;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return UIInterfaceOrientationMaskLandscapeLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return UIInterfaceOrientationMaskLandscapeRight;
            break;
            
        default:
            break;
    }
    
    return UIInterfaceOrientationMaskAll;
    
}

- (BOOL) shouldAutorotate {
    
    return YES;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self toggleTorch];
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        self.prevLayer.frame = CGRectMake(0, 65, MAX(self.view.frame.size.width-200,self.view.frame.size.height-200), MIN(self.view.frame.size.width-200,self.view.frame.size.height-200));
    }
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        self.prevLayer.frame = CGRectMake(0, 65, MAX(self.view.frame.size.width-200,self.view.frame.size.height-200), MIN(self.view.frame.size.width-200,self.view.frame.size.height-200));
    }
    
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        self.prevLayer.frame = CGRectMake(0, 65, MIN(self.view.frame.size.width-200,self.view.frame.size.height-200), MAX(self.view.frame.size.width-200,self.view.frame.size.height-200));
    }
    if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
        self.prevLayer.frame = CGRectMake(0, 65, MIN(self.view.frame.size.width-200,self.view.frame.size.height-200), MAX(self.view.frame.size.width-200,self.view.frame.size.height-200));
    }
    
    [MWOverlay updateOverlay];
    
    
}

- (void) setControl
{
    
    [lblAddress setTextColor:[UIColor blackColor]];
    [lblAge setTextColor:[UIColor blackColor]];
    [lblCity setTextColor:[UIColor blackColor]];
    [lblAgeUnit setTextColor:[UIColor blackColor]];
    [lblCounty setTextColor:[UIColor blackColor]];
    [lblDob setTextColor:[UIColor blackColor]];
    [lblFirstName setTextColor:[UIColor blackColor]];
    [lblGender setTextColor:[UIColor blackColor]];
    [lblLastName setTextColor:[UIColor blackColor]];
    [lblPhone setTextColor:[UIColor blackColor]];
    [lblRace setTextColor:[UIColor blackColor]];
    [lblResident setTextColor:[UIColor blackColor]];
    [lblSSNum setTextColor:[UIColor blackColor]];
    [lblState setTextColor:[UIColor blackColor]];
    [lblZip setTextColor:[UIColor blackColor]];
    [lblWeight setTextColor:[UIColor blackColor]];
    
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
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from Inputs where InputRequiredField = 1 and inputpage like 'Personal' union select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 1" , outcomeVal];
            
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
        sql = @"SELECT distinct i.inputid, i.inputname, i.inputpage FROM inputs i where i.inputrequiredfield = 1 and i.inputpage like 'Personal%'";
    }
    NSMutableArray* requiredArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        requiredArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    for (int i = 0; i < [requiredArray count]; i++)
    {
        ClsTableKey* key = [requiredArray objectAtIndex:i];
        if (key.key == 1101)
        {
            [lblLastName setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1102)
        {
            [lblFirstName setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1103)
        {
            [lblDob setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1104)
        {
            [lblRace setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1105)
        {
            [lblGender setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1106)
        {
            [lblPhone setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1107)
        {
            [lblAddress setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1109)
        {
            [lblCity setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1110)
        {
            [lblState setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1111)
        {
            [lblCounty setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1112)
        {
            [lblZip setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1119)
        {
            [lblAge setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1132)
        {
            [lblWeight setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1133)
        {
            [lblSSNum setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1134)
        {
            [lblAgeUnit setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1135)
        {
            [lblResident setTextColor:[UIColor redColor]];
        }
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

- (IBAction)btnPageControlClick:(id)sender {
    
    [self saveTab];
    [self setViewUI:self.pageControl.currentPage];
    lastPageCount = self.pageControl.currentPage;

}

- (void) doneInputView:(NSInteger) tag
{
    if (tag < self.incidentInput.count && tag < (self.pageControl.currentPage + 1)*12)
    {
        InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:tag + 1];
        [inputView btnInputClick:inputView.btnInput];
    }
}

@end


@implementation DecoderResult

@synthesize succeeded;
@synthesize result;

+(DecoderResult *)createSuccess:(NSString *)result {
	DecoderResult *obj = [[DecoderResult alloc] init];
	if (obj != nil) {
		obj.succeeded = YES;
		obj.result = result;
	}
	return obj;
}

+(DecoderResult *)createFailure {
	DecoderResult *obj = [[DecoderResult alloc] init];
	if (obj != nil) {
		obj.succeeded = NO;
		obj.result = nil;
	}
	return obj;
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
	self.result = nil;
}

@end
