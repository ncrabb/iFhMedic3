//
//  InsuranceViewController.m
//  iRescueMedic
//
//  Created by Nathan on 7/18/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InsuranceViewController.h"
#import "InsuranceInfoCell.h"
#import "ClsMedicare.h"
#import "global.h"
#import "DAO.h"
#import "ClsTableKey.h"
#import "DDPopoverBackgroundView.h"
#import "CalendarViewController.h"
#import "NarcoticSigViewController.h"
#import "ClsSignatureImages.h"
#import "QAMessageViewController.h"
#import "Base64.h"
#import "ClsTicketFormsInputs.h"
#import "ClsPrivateInsurance.h"
#import "NumericViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface InsuranceViewController () <DismissNumericDelegate>
{
    NSInteger rowEdit;
    bool ending;
    bool keyboardDown;
    NSInteger deletedCount;
    NSInteger instanntCount;
    NSInteger currentPrivateCount;
    NSString* ticketID;
    NSMutableString* pageInputID;
}


@end

@implementation InsuranceViewController
@synthesize popoverController;
@synthesize imageView;

@synthesize payer;
@synthesize id;
@synthesize insuranceSelected;

@synthesize otherPayerController;
@synthesize newTicket;
@synthesize delegate;
@synthesize btnMedicarePlayer;

@synthesize btnInsuranceName;
@synthesize btnInsuredSSN;
@synthesize btnDOB;
@synthesize txtInsuredName;

@synthesize containerView1;
@synthesize containerView2;
@synthesize containerView3;
@synthesize containerView4;
@synthesize medicareArray;
@synthesize companyArray;
@synthesize btnNameLabel;
@synthesize popover;
@synthesize SegCtrl;

@synthesize page1Container;
@synthesize ABNContainer;
@synthesize PCSContainer;

@synthesize ABNContainer1;
@synthesize ABNContainer2;
@synthesize ABNContainer3;
@synthesize ABNContainer4;
@synthesize ABNContainer5;

@synthesize btnABNObtion1;
@synthesize btnABNObtion2;
@synthesize btnABNObtion3;
@synthesize btnSSN;
@synthesize txtPatientName;
@synthesize txtReason;
@synthesize btnFaculty;
@synthesize facultyArray;
@synthesize txtEstimateCost;
@synthesize txtItemServices;
@synthesize txtNotifier;
@synthesize txtReasonNotPay;
@synthesize txtAdditionalInfo;
@synthesize signView;
@synthesize sigImageView;
@synthesize segChemRestraint;
@synthesize segControl;
@synthesize segDanger;
@synthesize segEkg;
@synthesize segEMTALA;
@synthesize segFlightRisk;
@synthesize segIsolation;
@synthesize segIV;
@synthesize segOrtho;
@synthesize segOxygen;
@synthesize segPatientSize;
@synthesize segRiskFall;
@synthesize segSafety;
@synthesize segSpecHandle;
@synthesize segSuction;
@synthesize segVentilator;
@synthesize txtGroupNum;
@synthesize txtMedicaidID;
@synthesize txtMedicaidPayer;
@synthesize txtMedicareID;
@synthesize txtSubscriberID;
@synthesize segmentHospital;
@synthesize btnAddAnother;
@synthesize tableView1;
@synthesize privateInsArray;
@synthesize btnQAMessage;
@synthesize btnDelete;
@synthesize privateInsArrayAll;
@synthesize lblPrivateGroupNum;
@synthesize lblPrivateInsuranceName;
@synthesize lblPrivateInsuredDOB;
@synthesize lblPrivateInsuredName;
@synthesize lblPrivateInsuredSSN;
@synthesize lblPrivateSubscriber;
@synthesize btnOtherPayer;


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
    
    ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    UIImage *toolBarIMG = [UIImage imageNamed:@"navigation_bar_bkg.png"];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }
	//[self.navigationController setNavigationBarHidden:TRUE];
    newMedia = false;

  //  [self setViewUI];
    currentView = 0;

    txtMedicaidPayer.delegate = self;
    txtSubscriberID.delegate = self;

    txtGroupNum.delegate = self;
    txtInsuredName.delegate = self;
    
    self.privateInsArray = [[NSMutableArray alloc] init];
    [self.SegCtrl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:16.0],
                                           NSForegroundColorAttributeName:[UIColor blackColor]}
                                forState:UIControlStateNormal];
}


- (void) loadData
{
    deletedCount = 0;
    [self.privateInsArray removeAllObjects];
    saved = false;
    if (self.insuranceSelected == nil)
    {
        self.insuranceSelected = [[NSMutableArray alloc] init];
    }
    else
    {
        [self.insuranceSelected removeAllObjects];
    }
    
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and InputID in (7001, 7002, 7003)", ticketID ];
    NSMutableDictionary* ticketInputsData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]  Sql:sql];
    }
    if ([ticketInputsData count] > 0)
    {
        if ([[ticketInputsData objectForKey:@"7001:1:1"] length] > 0 && ([[ticketInputsData objectForKey:@"7001:1:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [btnMedicarePlayer setTitle:[ticketInputsData objectForKey:@"7001:1:1"] forState:UIControlStateNormal];
        }
        if ([[ticketInputsData objectForKey:@"7001:2:1"] length] > 0 && ([[ticketInputsData objectForKey:@"7001:2:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            txtMedicareID.text =  [self removeNull:[ticketInputsData objectForKey:@"7001:2:1"]];
        }
        
        if ([[ticketInputsData objectForKey:@"7002:1:1"] length] > 0 && ([[ticketInputsData objectForKey:@"7002:1:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            txtMedicaidPayer.text =  [self removeNull:[ticketInputsData objectForKey:@"7002:1:1"]];
        }
        
        if ([[ticketInputsData objectForKey:@"7002:2:1"] length] > 0 && ([[ticketInputsData objectForKey:@"7002:2:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            txtMedicaidID.text =  [self removeNull:[ticketInputsData objectForKey:@"7002:2:1"]];
        }
        
        NSString* sql = [NSString stringWithFormat:@"Select MAX(inputInstance) from TicketInputs where TicketID = %@ and InputID in (7003)", ticketID];
        @synchronized(g_SYNCDATADB)
        {
            instanntCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            currentPrivateCount = instanntCount;
        }
        
        for (int i = 1; i <= instanntCount; i++)
        {
            
            ClsPrivateInsurance* privateIns = [[ClsPrivateInsurance alloc] init];
            sql = [NSString stringWithFormat:@"Select * from TicketInputs where TicketID = %@ and InputID = 7003 and inputInstance = %d", ticketID, i];
            @synchronized(g_SYNCDATADB)
            {
                ticketInputsData = [DAO selectTicketInputsInstance:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            privateIns.insuranceID = i;
            NSString* inputStr1 = [NSString stringWithFormat:@"7003:1:%i", i];
            privateIns.insuranceName = [self removeNull:[ticketInputsData objectForKey:inputStr1]];
            NSString* inputStr2 = [NSString stringWithFormat:@"7003:2:%i", i];
            privateIns.subscribberID = [self removeNull:[ticketInputsData objectForKey:inputStr2]];
            NSString* inputStr3 = [NSString stringWithFormat:@"7003:3:%i", i];
            privateIns.groupNum = [self removeNull:[ticketInputsData objectForKey:inputStr3]];
            NSString* inputStr6 = [NSString stringWithFormat:@"7003:6:%i", i];
            privateIns.insuredName = [self removeNull:[ticketInputsData objectForKey:inputStr6]];
            NSString* inputStr7 = [NSString stringWithFormat:@"7003:7:%i", i];
            privateIns.insuredSSN = [self removeNull:[ticketInputsData objectForKey:inputStr7]];
            NSString* inputStr8 = [NSString stringWithFormat:@"7003:8:%i", i];
            privateIns.insuredDOB = [self removeNull:[ticketInputsData objectForKey:inputStr8]];
            
            if ([[ticketInputsData objectForKey:@"Deleted"] length] > 0 && ([[ticketInputsData objectForKey:@"Deleted"] rangeOfString:@"(null)"].location == NSNotFound))
            {
                privateIns.deleted = [ticketInputsData objectForKey:@"Deleted"];

                if ([privateIns.deleted isEqualToString:@"1"])
                {
                    deletedCount++;

                    [privateInsArrayAll addObject:privateIns];
                    
                }
                else
                {
                    [privateInsArray addObject:privateIns];
                }
            }
            else
            {
                [privateInsArray addObject:privateIns];
            }

        }
        [tableView1 reloadData];
    }
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setControl];
    NSString* patientName;
    ending = false;
    [self clearPrivateInsurance];
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    btnNameLabel.title = patientName;
    [btnNameLabel setTintColor:[UIColor whiteColor]];
    
    editMode = false;
    rowEdit = -1;
    insRowSelected = -1;
    saveSig = 1;
    
    page1Container.hidden = NO;
    SegCtrl.selectedSegmentIndex = 0;

    ABNContainer.hidden = true;
    
    PCSContainer.hidden = true;
    btnDelete.hidden = false;
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientNameFromTickeID:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    txtPatientName.text = patientName;
    NSString *SSNnumber;
    @synchronized(g_SYNCDATADB)
    {
        SSNnumber =  [DAO getPatientSSNFromTickeID:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    [btnSSN setTitle:SSNnumber forState:UIControlStateNormal];
    [self loadData];
}


-(void) viewWillDisappear:(BOOL)animated
{
    ending = true;

    if (currentView == 1)
    {
        [self saveABN];
    }
    else if (currentView ==2)
    {
        [self savePCS];
    }
    
    if (btnMedicarePlayer.titleLabel.text.length > 0 && txtMedicareID.text.length > 0)
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 7001", ticketID ];
        NSInteger count;
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (count > 0)
        {
            @synchronized(g_SYNCDATADB)
            {
                sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 7001 and InputSubID = 1", btnMedicarePlayer.titleLabel.text, ticketID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 7001 and InputSubID = 2", txtMedicareID.text, ticketID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        else
        {
            @synchronized(g_SYNCDATADB)
            {
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7001, 1, 1, @"Medicare", @"", btnMedicarePlayer.titleLabel.text];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7001, 2, 1, @"Medicare", @"", txtMedicareID.text];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }
    }
    
    if (txtMedicaidPayer.text.length > 0 && txtMedicaidID.text.length > 0)
    {
          NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 7002", ticketID ];
        
        NSInteger count;
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (count > 0)
        {
            @synchronized(g_SYNCDATADB)
            {
                sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 7002 and InputSubID = 1", txtMedicaidPayer.text, ticketID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 7002 and InputSubID = 2", txtMedicaidID.text, ticketID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }
        else
        {
            @synchronized(g_SYNCDATADB)
            {
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7002, 1, 1, @"Medicare", @"", txtMedicaidPayer.text];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7002, 2, 1, @"Medicare", @"", txtMedicaidID.text];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        
    }
 
    if (!saved)
    {
        if (editMode)
        {
            ClsPrivateInsurance* privateIns = [privateInsArray objectAtIndex:rowEdit];
            privateIns.insuranceName = btnInsuranceName.titleLabel.text;
            privateIns.subscribberID = txtSubscriberID.text;
            privateIns.groupNum = txtGroupNum.text;
            privateIns.insuredName = txtInsuredName.text;
            privateIns.insuredSSN = btnInsuredSSN.titleLabel.text;
            privateIns.insuredDOB = btnDOB.titleLabel.text;
        }
        else
        {
            if (btnInsuranceName.titleLabel.text.length > 0 && txtSubscriberID.text.length > 0)
            {
                currentPrivateCount++;
                ClsPrivateInsurance* privateIns = [[ClsPrivateInsurance alloc] init];
                
                privateIns.insuranceName = btnInsuranceName.titleLabel.text;
                privateIns.subscribberID = txtSubscriberID.text;
                privateIns.groupNum = txtGroupNum.text;
                privateIns.insuredName = txtInsuredName.text;
                privateIns.insuredSSN = btnInsuredSSN.titleLabel.text;
                privateIns.insuredDOB = btnDOB.titleLabel.text;
                privateIns.insuranceID = currentPrivateCount;
                [privateInsArray addObject:privateIns];
                
                
            }  // end if (txtCompany.text.length > 0 && txtSubscriberID.text > 0)
        }

        saved = true;
    }  // end if !saved
    
    for (int i = 0; i < privateInsArray.count; i++)
    {
        
        ClsPrivateInsurance* privateIns = [privateInsArray objectAtIndex:i];

        if (privateIns.insuranceID <= instanntCount)
        {

            @synchronized(g_SYNCDATADB)
            {
                NSString* sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@', IsUploaded = 0 where ticketID = %@ and inputID = 7003 and InputSubID = 1 and InputInstance = %li", privateIns.insuranceName, ticketID, privateIns.insuranceID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@', IsUploaded = 0 where ticketID = %@ and inputID = 7003 and InputSubID = 2 and InputInstance = %li", privateIns.subscribberID, ticketID, privateIns.insuranceID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@', IsUploaded = 0 where ticketID = %@ and inputID = 7003 and InputSubID = 3 and InputInstance = %li", privateIns.groupNum, ticketID, privateIns.insuranceID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@', IsUploaded = 0 where ticketID = %@ and inputID = 7003 and InputSubID = 6 and InputInstance = %li", privateIns.insuredName, ticketID, privateIns.insuranceID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@', IsUploaded = 0 where ticketID = %@ and inputID = 7003 and InputSubID = 7 and InputInstance = %li", privateIns.insuredSSN, ticketID, privateIns.insuranceID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@', IsUploaded = 0 where ticketID = %@ and inputID = 7003 and InputSubID = 8 and InputInstance = %li", privateIns.insuredDOB, ticketID, privateIns.insuranceID];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
            }  // end synchrozize
        }  // end if (privateIns.insuranceID < instanntCount)
        else
        {
            instanntCount++;
            NSInteger privateCount = instanntCount;
            @synchronized(g_SYNCDATADB)
            {
                NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7003, 1, privateCount, @"Private Insurance", @"", privateIns.insuranceName];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7003, 2, privateCount, @"Private Insurance", @"", privateIns.subscribberID];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7003, 3, privateCount, @"Private Insurance", @"", privateIns.groupNum];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];

                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7003, 6, privateCount, @"Private Insurance", @"", privateIns.insuredName];
                
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7003, 7, privateCount, @"Private Insurance", @"", privateIns.insuredSSN];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7003, 8, privateCount, @"Private Insurance", @"", privateIns.insuredDOB];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        
        
    }
    

    for (UIView* subview in ABNContainer.subviews)
    {
        [subview removeFromSuperview];
    }
    ABNContainer.hidden = true;
    
    for (UIView* subview in PCSContainer.subviews)
    {
        [subview removeFromSuperview];
    }
    PCSContainer.hidden = true;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSelfPayClick:(UIButton *)sender {

    OtherPayerViewController *popoverView =[[OtherPayerViewController alloc] initWithNibName:@"OtherPayerViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popoverController.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popoverController.popoverContentSize = CGSizeMake(520, 656);
    popoverView.delegate = self;
    CGRect frame = sender.frame;
    frame.origin.x += 465;
    [self.popoverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
    
    
}

- (IBAction)btnFacultyClick:(UIButton *)sender {
    functionSelected = 3;
    
    PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
    if ([facultyArray count] < 1)
    {
/*        NSString* querySql = @"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 99999";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.facultyArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        } */
        self.facultyArray = [[NSMutableArray alloc] init];
        
        ClsTableKey* item1 = [[ClsTableKey alloc] init];
        item1.key = 1;
        item1.desc = @"Case Worker";
        [facultyArray addObject:item1];
        
        ClsTableKey* item2 = [[ClsTableKey alloc] init];
        item2.key = 2;
        item2.desc = @"Clerk";
        [facultyArray addObject:item2];
        
        ClsTableKey* item3 = [[ClsTableKey alloc] init];
        item3.key = 3;
        item3.desc = @"CAN";
        [facultyArray addObject:item3];
        
        ClsTableKey* item4 = [[ClsTableKey alloc] init];
        item4.key = 4;
        item4.desc = @"LPN";
        [facultyArray addObject:item4];
        
        ClsTableKey* item5 = [[ClsTableKey alloc] init];
        item5.key = 5;
        item5.desc = @"Registered Nurse";
        [facultyArray addObject:item5];
        
        ClsTableKey* item6 = [[ClsTableKey alloc] init];
        item6.key = 6;
        item6.desc = @"Nurse Practitioner";
        [facultyArray addObject:item6];
        
        ClsTableKey* item7 = [[ClsTableKey alloc] init];
        item7.key = 7;
        item7.desc = @"Physician Assistanct";
        [facultyArray addObject:item7];
        
        ClsTableKey* item8 = [[ClsTableKey alloc] init];
        item8.key = 8;
        item8.desc = @"Attending Physician";
        [facultyArray addObject:item8];
        
        ClsTableKey* item9 = [[ClsTableKey alloc] init];
        item9.key = 9;
        item9.desc = @"DO";
        [facultyArray addObject:item9];
        
    }
    
    popoverView.array = self.facultyArray;
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popoverController.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popoverController.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    CGRect frame = sender.frame;
    frame.origin.x -= 120;
    [self.popoverController presentPopoverFromRect:frame inView:self.ABNContainer4 permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}

- (IBAction)btnMainMenuClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [delegate dismissViewControl];
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


- (IBAction)btnTakePictureClick:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        newMedia = true;
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePicker.allowsEditing = NO;
        UIImageView* guideImageView = [[UIImageView alloc] init];
        guideImageView.image = [UIImage imageNamed:@"card.png"];
        guideImageView.frame = CGRectMake(260, 230, 504, 288);
        //guideImageView.frame = CGRectMake(120, 25, 800, 600);
        guideImageView.backgroundColor = [UIColor clearColor];
        guideImageView.contentMode = UIViewContentModeScaleAspectFit;
        guideImageView.alpha = 1;
        //[imagePicker.view addSubview:guideImageView];
        [self presentModalViewController:imagePicker
                                animated:YES];
    }
    else
    {
        newMedia = false;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"No Camera Detected"
                              message: @"Failed to detect camera."\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];

    }
    
    
}



- (IBAction)btnDOBClick:(UIButton*)sender {
 
    CalendarViewController *popoverView =[[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popoverController.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popoverController.popoverContentSize = CGSizeMake(400, 260);
    popoverView.delegate = self;
    CGRect frame = sender.frame;
    frame.origin.y += 120;

    [self.popoverController presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}


- (IBAction)btnMedicarePlayerClicked:(UIButton *)sender
{
    functionSelected = 1;
    
    PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
    if ([medicareArray count] < 1)
    {
        self.medicareArray = [[NSMutableArray alloc] init];
        ClsTableKey* table = [[ClsTableKey alloc] init];
        table.key = 1;
        table.desc = @"Hospice Program";
        [medicareArray addObject:table];
        ClsTableKey* table1 = [[ClsTableKey alloc] init];
        table1.key = 2;
        table1.desc = @"Medicare";
        [medicareArray addObject:table1];
        
    }
    
    
    popoverView.array = self.medicareArray;
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popoverController.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popoverController.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    CGRect frame = sender.frame;
    
    frame.origin.y -= 20;
    [self.popoverController presentPopoverFromRect:frame inView:containerView1 permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnCompanyNameClick:(id)sender;
{
    functionSelected = 2;
    if ([companyArray count] < 1)
    {
        NSString* querySql = @"select InsuranceID, 'Insurace', InsuranceName from Insurance";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.companyArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 2;
    PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
    
    popoverView.array = self.companyArray;
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popoverController =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popoverController.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popoverController.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    CGRect frame = CGRectMake(600, 80, 350, 400);

    [self.popoverController presentPopoverFromRect:frame inView:self.containerView1 permittedArrowDirections:0 animated:YES];
    
    
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

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverController dismissPopoverAnimated:true];
    self.popoverController = nil;
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(720, 625, 1218, 710));
        //CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(520, 480, 1318, 810));
       // UIImage *img = [UIImage imageWithCGImage:ref scale:1 orientation:UIImageOrientationDown];
        CGImageRelease(ref);
        imageView.image = [info
                           objectForKey:UIImagePickerControllerOriginalImage];;

        if (newMedia)
        {
            CGSize size = CGSizeMake(640, 480);
            UIImage* image1 = [self scaleToSize:image newSize:size];
            NSData* data = UIImageJPEGRepresentation(image1, 1.0f);
            NSString* imgStr = [Base64 encode:data];
            NSDate* sourceDate = [NSDate date];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString* timeAdded = [dateFormat stringFromDate:sourceDate];
            NSString* sql;
            NSInteger count ;
            NSString* ticketID1 = [g_SETTINGS objectForKey:@"currentTicketID"];
            sql = [NSString stringWithFormat:@"Select MAX(AttachmentID) from TicketAttachments where TicketID = %@", ticketID1 ];
            @synchronized(g_SYNCBLOBSDB)
            {
                count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            if (count < 7)
            {
                count = 7;
            }
            
            
            sql = [NSString stringWithFormat:@"Insert into TicketAttachments(LocalTicketID, TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded) Values(0, %@, %d, 'Photo', '%@', '%@', '%@')", ticketID1, count + 1, imgStr, @" ", timeAdded ];
            
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
          
        }
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {

    }
}


-(UIImage*)scaleToSize:(UIImage*)image newSize:(CGSize)size
{
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
}


-(void) doneOtherPayerClick
{


    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
}

- (IBAction)copyInsuredNameClicked:(id)sender
{
    NSString* patientName;
    
    NSString* ticketIDs = [g_SETTINGS objectForKey:@"currentTicketID"];
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getInsuredName:ticketIDs db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    txtInsuredName.text = patientName;
}

- (IBAction)copyInsuredDOBClicked:(id)sender
{
    NSString* DOB;
    
    NSString* ticketIDs = [g_SETTINGS objectForKey:@"currentTicketID"];
    @synchronized(g_SYNCDATADB)
    {
        DOB =  [DAO getInsuredDOB:ticketIDs db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    [btnDOB setTitle:DOB forState:UIControlStateNormal] ;
}

- (IBAction)btnValidateClick:(UIButton*)sender {
    //[self saveTab];
    ValidateViewController *popoverView =[[ValidateViewController alloc] initWithNibName:@"ValidateViewController" bundle:nil];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(540, 590);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)segmentValueChanged:(id)sender
{
    if(SegCtrl.selectedSegmentIndex == 0)
    {
        btnAddAnother.hidden = false;
        btnDelete.hidden = false;
        if (currentView == 1)
        {
            [self saveABN];
            for (UIView* subview in ABNContainer.subviews)
            {
                [subview removeFromSuperview];
            }
            ABNContainer.hidden = true;
        }
        if (currentView == 2)
        {
            [self savePCS];
            for (UIView* subview in PCSContainer.subviews)
            {
                [subview removeFromSuperview];
            }
            PCSContainer.hidden = true;
        }
        page1Container.hidden = NO;
        currentView = 0;
        //[self setViewUI];
    }
    else if(SegCtrl.selectedSegmentIndex == 1)
    {
        btnAddAnother.hidden = true;
        btnDelete.hidden = true;
        if (currentView == 2)
        {
            [self savePCS];
            for (UIView* subview in PCSContainer.subviews)
            {
                [subview removeFromSuperview];
            }
            PCSContainer.hidden = true;
        }
        
        page1Container.hidden = true;
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"InsuranceABNView" owner:self options:nil];
        ABNContainer.hidden = false;
        [ABNContainer  addSubview:nib[0]];
        [self ABNSetView];
        [self loadABN];
        if (txtPatientName.text.length < 1)
        {
            NSString *patientName;
            @synchronized(g_SYNCDATADB)
            {
                patientName =  [DAO getPatientNameFromTickeID:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
            }
            txtPatientName.text = patientName;
        }
        if (btnSSN.titleLabel.text.length < 1)
        {
            NSString *SSNnumber;
            @synchronized(g_SYNCDATADB)
            {
                SSNnumber =  [DAO getPatientSSNFromTickeID:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
            }
            [btnSSN setTitle:SSNnumber forState:UIControlStateNormal];
        }
        currentView = 1;
    }
    else
    {
        btnAddAnother.hidden = true;
        btnDelete.hidden = true;
        if (currentView == 1)
        {
            [self saveABN];
            for (UIView* subview in ABNContainer.subviews)
            {
                [subview removeFromSuperview];
            }
            ABNContainer.hidden = true;
        }
        page1Container.hidden = true;

        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"InsurancePCSView" owner:self options:nil];
        PCSContainer.hidden = false;
        [PCSContainer  addSubview:nib[0]];
        [self loadPCS];
        currentView = 2;
    }
}

- (void) loadABN
{
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FORMID = 8 and FormInputID = 10", ticketID];
    NSInteger ABNCount = 0;
    @synchronized(g_SYNCDATADB)
    {
        ABNCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    if (ABNCount > 0)
    {
        NSString* sql = [NSString stringWithFormat:@"Select * from TicketFormsInputs where TicketID = %@ and FormID = 8", ticketID];
        NSMutableArray* formInputsData;

        @synchronized(g_SYNCDATADB)
        {
            formInputsData = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }

        for (int i=0; i< [formInputsData count]; i++)
        {
            
            ClsTicketFormsInputs* input = [formInputsData objectAtIndex:i];
            if (input.formInputID == 1)
            {
                txtNotifier.text = input.formInputValue;
            }
            else if (input.formInputID == 2)
            {
                txtPatientName.text = input.formInputValue;
            }
            else if (input.formInputID == 3)
            {
                [btnSSN setTitle:[self removeNull:input.formInputValue] forState:UIControlStateNormal];
            }
            else if (input.formInputID == 4)
            {
                txtItemServices.text = input.formInputValue;
            }
            else if (input.formInputID == 5)
            {
                txtReasonNotPay.text = input.formInputValue;
            }
            else if (input.formInputID == 6)
            {
                txtEstimateCost.text = input.formInputValue;
            }
            else if (input.formInputID == 7)
            {
                NSString* option = input.formInputValue;
                if ([option isEqualToString:@"2"])
                {
                    self.abnSelectedObtion = 2;
                    btnABNObtion1.selected = NO;
                    btnABNObtion2.selected = YES;
                    btnABNObtion3.selected = NO;
                }
                else if ([option isEqualToString:@"3"])
                {
                    self.abnSelectedObtion = 3;
                    btnABNObtion1.selected = NO;
                    btnABNObtion2.selected = NO;
                    btnABNObtion3.selected = YES;
                    
                }
                else
                {
                    self.abnSelectedObtion = 1;
                    btnABNObtion1.selected = YES;
                    btnABNObtion2.selected = NO;
                    btnABNObtion3.selected = NO;
                }
            }
            else if (input.formInputID == 8)
            {
                txtAdditionalInfo.text = input.formInputValue;
            }
            else if (input.formInputID == 9)
            {
                [Base64 initialize];
                NSData* data = [Base64 decode:input.formInputValue];
                UIImage* image = [UIImage imageWithData:data];
               // self.sigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0,464, 156)];
                self.sigImageView.image = image;
                signView.hidden = true;
                sigImageView.hidden = NO;
                signView.hidden = YES;
                saveSig = 0;
            }
        }
        
    }
    
}

- (void) saveABN
{

    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FORMID = 8 and FormInputID = 10", ticketID];
    NSInteger ABNCount = 0;
    @synchronized(g_SYNCDATADB)
    {
        ABNCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    UIImage* image = [self signatureImage];
    NSData* data = UIImagePNGRepresentation(image);
    NSString *sigEncoded = [Base64 encode:data];
    if (ABNCount < 1)
    {
        NSDate* now = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:now];
        
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 8, 10, '%@', 0)", ticketID, dateString];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 8, 1, '%@', 0)", ticketID, txtNotifier.text];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 8, 2, '%@', 0)", ticketID, txtPatientName.text];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 8, 3, '%@', 0)", ticketID, btnSSN.titleLabel.text];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 8, 4, '%@', 0)", ticketID, txtItemServices.text];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 8, 5, '%@', 0)", ticketID, txtReasonNotPay.text];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
  
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 8, 6, '%@', 0)", ticketID, txtEstimateCost.text];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
 
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 8, 7, '%d', 0)", ticketID, self.abnSelectedObtion];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 8, 8, '%@', 0)", ticketID, txtAdditionalInfo.text];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 8, 9, '%@', 0)", ticketID, sigEncoded];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
    else
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 8 and FormInputID = 1", txtNotifier.text, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 8 and FormInputID = 2", txtPatientName.text, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
           
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 8 and FormInputID = 3", btnSSN.titleLabel.text, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 8 and FormInputID = 4", txtItemServices.text, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 8 and FormInputID = 5", txtReasonNotPay.text, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 8 and FormInputID = 6", txtEstimateCost.text, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%d', IsUploaded = 0 where ticketID = %@ and FormID = 8 and FormInputID = 7", self.abnSelectedObtion, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 8 and FormInputID = 8", txtAdditionalInfo.text, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            if (saveSig == 1)
            {
                sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 8 and FormInputID = 9", sigEncoded, ticketID];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }
    }

    
}

- (void) loadPCS
{
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FORMID = 2 and FormInputID = 18", ticketID];
    NSInteger PCSCount = 0;
    @synchronized(g_SYNCDATADB)
    {
        PCSCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    if (PCSCount > 0)
    {
        NSString* sql = [NSString stringWithFormat:@"Select * from TicketFormsInputs where TicketID = %@ and FormID = 2", ticketID];
        NSMutableArray* formInputsData;
        
        @synchronized(g_SYNCDATADB)
        {
            formInputsData = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
        for (int i=0; i< [formInputsData count]; i++)
        {
            
            ClsTicketFormsInputs* input = [formInputsData objectAtIndex:i];
            if (input.formInputID == 1)
            {
                segEkg.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 2)
            {
                segVentilator.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 3)
            {
                segIV.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 4)
            {
                segChemRestraint.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 5)
            {
                segEMTALA.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 6)
            {
                segSuction.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 7)
            {
                segOxygen.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 8)
            {
                segDanger.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 9)
            {
                segOrtho.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 10)
            {
                segRiskFall.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 11)
            {
                segSafety.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 12)
            {
                segFlightRisk.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 13)
            {
                segControl.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 14)
            {
                segIsolation.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 15)
            {
                segPatientSize.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 16)
            {
                segSpecHandle.selectedSegmentIndex = ([input.formInputValue isEqualToString:@"YES"]) ? 0 : 1;
            }
            
            if (input.formInputID == 17)
            {
                txtReason.text = input.formInputValue;
            }
            
            if (input.formInputID == 24 && input.formInputValue.length > 0)
            {
                [btnFaculty setTitle:input.formInputValue forState:UIControlStateNormal];
            }
            
            
        }
    }
    
}

- (void) savePCS
{
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FORMID = 2 and FormInputID = 18", ticketID];
    NSInteger PCSCount = 0;
    @synchronized(g_SYNCDATADB)
    {
        PCSCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
  //  UIImage* image = [self signatureImage];
 //   NSData* data = UIImagePNGRepresentation(image);
 //   NSString *sigEncoded = [Base64 encode:data];
    NSString* ekgStr = (segEkg.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* ventil = (segVentilator.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* ivMonitor = (segIV.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* chemRestraint = (segChemRestraint.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* emtala = (segEMTALA.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* suction = (segSuction.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* oxygen = (segOxygen.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* danger = (segDanger.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* ortho = (segOrtho.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* riskFall = (segRiskFall.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* safety = (segSafety.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* flight = (segFlightRisk.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* control = (segControl.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* isolation = (segIsolation.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* patientSize = (segPatientSize.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    NSString* specHandle = (segSpecHandle.selectedSegmentIndex == 0) ? @"YES" : @"NO";
    
    
    if (PCSCount < 1)
    {
        NSDate* now = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:now];
        
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 18, '%@', 0)", ticketID, dateString];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 1, '%@', 0)", ticketID, ekgStr];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 2, '%@', 0)", ticketID, ventil];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 3, '%@', 0)", ticketID, ivMonitor];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 4, '%@', 0)", ticketID, chemRestraint];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 5, '%@', 0)", ticketID, emtala];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 6, '%@', 0)", ticketID, suction];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 7, '%@', 0)", ticketID, oxygen];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 8, '%@', 0)", ticketID, danger];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 9, '%@', 0)", ticketID, ortho];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 10, '%@', 0)", ticketID, riskFall];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 11, '%@', 0)", ticketID, safety];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 12, '%@', 0)", ticketID, flight];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 13, '%@', 0)", ticketID, control];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 14, '%@', 0)", ticketID, isolation];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 15, '%@', 0)", ticketID, patientSize];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 16, '%@', 0)", ticketID, specHandle];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 17, '%@', 0)", ticketID, txtReason.text];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 24, '%@', 0)", ticketID, [self removeChar:btnFaculty.titleLabel.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
        }
    }
    else
    {
        @synchronized(g_SYNCDATADB)
        {
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 1", ekgStr, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 2", ventil, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 3", ivMonitor, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 4", chemRestraint, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 5", emtala, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 6", suction, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 7", oxygen, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 8", danger, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 9", ortho, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 10", riskFall, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 11", safety, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 12", flight, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 13", control, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 14", isolation, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 15", patientSize, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 16", specHandle, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 17", txtReason.text, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@', IsUploaded = 0 where ticketID = %@ and FormID = 2 and FormInputID = 24", btnFaculty.titleLabel.text, ticketID];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
        }

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


-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

        return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if(textField == txtReason)
    {
        [self setViewMovedUp:YES];
    }
    return YES;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    keyboardDown = true;
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (keyboardDown)
    {
        keyboardDown = false;
        
        if (textField == txtMedicaidPayer)
        {
            [txtMedicaidID becomeFirstResponder];
        }
        else if (textField == txtSubscriberID)
        {
            [txtGroupNum becomeFirstResponder];
        }
        else if (textField == txtGroupNum)
        {
            [txtInsuredName becomeFirstResponder];
        }

        
    }
    if(textField == txtReason)
    {
        //[textField resignFirstResponder];
        [self setViewMovedUp:NO];
    }
}




- (IBAction)btnClearSignature:(id)sender
{
      [signView clearSignature:CGRectMake(0, 0, signView.frame.size.width, signView.frame.size.height)];
    
    [signView removeFromSuperview];
    signView = nil;
    
    signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 156)];
    
    signView.backgroundColor = [UIColor whiteColor];
    [ABNContainer5 addSubview:signView];
    sigImageView.hidden = true;
    signView.hidden = false;
    saveSig = 1;
}

- (UIImage *)signatureImage
{
    UIGraphicsBeginImageContext(ABNContainer5.bounds.size);
    
    [ABNContainer5.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
    
}

- (IBAction)abnObtionBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 1)
    {
        self.abnSelectedObtion = 1;
        btnABNObtion1.selected = YES;
        btnABNObtion2.selected = NO;
        btnABNObtion3.selected = NO;
        

    }
    else if(btn.tag == 2)
    {
        self.abnSelectedObtion = 2;
        btnABNObtion1.selected = NO;
        btnABNObtion2.selected = YES;
        btnABNObtion3.selected = NO;

    }
    else if(btn.tag == 3)
    {
        self.abnSelectedObtion = 3;
        btnABNObtion1.selected = NO;
        btnABNObtion2.selected = NO;
        btnABNObtion3.selected = YES;

    }
}

- (IBAction)pcsGetFacultySignatureClicked:(UIButton *)sender
{
    functionSelected = 1;
    [sender resignFirstResponder];
    NarcoticSigViewController *signature =[[NarcoticSigViewController alloc] initWithNibName:@"NarcoticSigViewController" bundle:nil];
    signature.view.backgroundColor = [UIColor whiteColor];
    signature.view.tag = ((UIView *)sender).tag;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:signature];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(550, 500);
    signature.formID = 2;
    signature.lblTitle.text = @"     Faculty Signature";
    signature.formInputID = 20;
    signature.delegate = self;
    CGRect frame = ((UIView *)sender).frame;
    frame.origin.y+= 122;
    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)pcsGetPatientSignatureClicked:(UIButton *)sender
{
    functionSelected = 2;
    [sender resignFirstResponder];
    NarcoticSigViewController *signature =[[NarcoticSigViewController alloc] initWithNibName:@"NarcoticSigViewController" bundle:nil];
    signature.view.backgroundColor = [UIColor whiteColor];
    signature.view.tag = ((UIView *)sender).tag;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:signature];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(550, 500);
    signature.lblTitle.text = @"     Patient Signature";
    signature.formID = 2;
    signature.formInputID = 22;
    signature.delegate = self;
    CGRect frame = ((UIView *)sender).frame;
    frame.origin.y+= 122;
    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (void) doneNarcoticSigningClick
{
 /*   NarcoticSigViewController *p = (NarcoticSigViewController *) popover.contentViewController;
    
    UIImage *image = p.image;
    bool needToSave = p.needToSave;
    if (needToSave)
    {
        ClsSignatureImages* sigImage = [[ClsSignatureImages alloc] init];
        sigImage.image = p.image;
        sigImage.name = p.txtName.text;
        if (functionSelected == 1)
        {
            
            
        }
        else if (functionSelected == 2)
        {
        }
    } */
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}


#pragma mark -
#pragma mark UIPopover Delegate

-(void) didTap
{
    PopupIncidentViewController *p = (PopupIncidentViewController *)self.popoverController.contentViewController;
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
    if(functionSelected ==1)
    {
        ClsTableKey * tableKey =  [p.array objectAtIndex:p.rowSelected];
        [self.btnMedicarePlayer setTitle:tableKey.desc forState:UIControlStateNormal];
        btnMedicarePlayer.tag =  p.rowSelected;
    //btnMedicarePlayer.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [txtMedicareID becomeFirstResponder];
    }
    
    else if(functionSelected ==3 )
    {

        ClsTableKey * tableKey =  [p.array objectAtIndex:p.rowSelected];
        [self.btnFaculty setTitle:tableKey.desc forState:UIControlStateNormal];
    }
    else if(functionSelected == 2)
    {

        ClsTableKey * tableKey =  [p.array objectAtIndex:p.rowSelected];

        [self.btnInsuranceName setTitle:tableKey.desc forState:UIControlStateNormal] ;
        [txtSubscriberID becomeFirstResponder];
    }

}

#pragma mark-
#pragma mark CalenderView Delegate

-(void) doneClick
{
    CalendarViewController *p = (CalendarViewController *)self.popoverController.contentViewController;
    [btnDOB setTitle:[p.dpDate.date.description substringToIndex:10] forState:UIControlStateNormal];
    [self.popoverController dismissPopoverAnimated:YES];
    self.popoverController = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [privateInsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *simpleTableIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    ClsPrivateInsurance* privateIns =  [privateInsArray objectAtIndex:indexPath.row];
    NSString *strTempCellTect = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@", privateIns.insuranceName, privateIns.subscribberID, privateIns.groupNum, privateIns.insuredName, privateIns.insuredSSN, privateIns.insuredDOB];
    cell.textLabel.text = strTempCellTect;


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
    [self savePrivateInsurance];
    editMode = true;
    rowEdit = indexPath.row;
    ClsPrivateInsurance* ins = [privateInsArray objectAtIndex:rowEdit];

    [btnInsuranceName setTitle:ins.insuranceName forState:UIControlStateNormal];

    txtSubscriberID.text =  ins.subscribberID;
    
    
    txtGroupNum.text =  ins.groupNum;

    txtInsuredName.text =  ins.insuredName;
    
    [btnInsuredSSN setTitle:ins.insuredSSN forState:UIControlStateNormal];
    [btnDOB setTitle:ins.insuredDOB forState:UIControlStateNormal];

}

#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:@"sub_navigation_bar_bkg.png"];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    [self.containerView1.layer setCornerRadius:10.0f];
    [self.containerView1.layer setMasksToBounds:YES];
    self.containerView1.layer.borderWidth = 1;
    self.containerView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.containerView2.layer setCornerRadius:10.0f];
    [self.containerView2.layer setMasksToBounds:YES];
    self.containerView2.layer.borderWidth = 1;
    self.containerView2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.containerView3.layer setCornerRadius:10.0f];
    [self.containerView3.layer setMasksToBounds:YES];
    self.containerView3.layer.borderWidth = 1;
    self.containerView3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.containerView4.layer setCornerRadius:10.0f];
    [self.containerView4.layer setMasksToBounds:YES];
    self.containerView4.layer.borderWidth = 1;
    self.containerView4.layer.borderColor = [UIColor lightGrayColor].CGColor;
  
    tableView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    tableView1.layer.borderWidth = 1.0f;
    tableView1.layer.cornerRadius = 8.0f;
    btnOtherPayer.layer.cornerRadius = 8.0f;
    self.btnOtherPayer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnOtherPayer.layer.borderWidth = 1;
}

- (void) ABNSetView
{
    [self.ABNContainer1.layer setCornerRadius:10.0f];
    [self.ABNContainer1.layer setMasksToBounds:YES];
    self.ABNContainer1.layer.borderWidth = 1;
    self.ABNContainer1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.ABNContainer2.layer setCornerRadius:10.0f];
    [self.ABNContainer2.layer setMasksToBounds:YES];
    self.ABNContainer2.layer.borderWidth = 1;
    self.ABNContainer2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.ABNContainer3.layer setCornerRadius:10.0f];
    [self.ABNContainer3.layer setMasksToBounds:YES];
    self.ABNContainer3.layer.borderWidth = 1;
    self.ABNContainer3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.ABNContainer4.layer setCornerRadius:10.0f];
    [self.ABNContainer4.layer setMasksToBounds:YES];
    self.ABNContainer4.layer.borderWidth = 1;
    self.ABNContainer4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self.ABNContainer5.layer setCornerRadius:10.0f];
    [self.ABNContainer5.layer setMasksToBounds:YES];
    self.ABNContainer5.layer.borderWidth = 1;
    self.ABNContainer5.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,464, 156)];
    
    self.signView.backgroundColor = [UIColor whiteColor];
    [ABNContainer5 addSubview:self.signView];
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

- (IBAction)btnAddAnotherClick:(id)sender {
    if (!saved)
    {

        if (btnInsuranceName.titleLabel.text.length > 0 && txtSubscriberID.text > 0)
        {
            if (editMode == true)
            {
                ClsPrivateInsurance* privateIns = [privateInsArray objectAtIndex:rowEdit];
                privateIns.insuranceName = btnInsuranceName.titleLabel.text;
                privateIns.subscribberID = txtSubscriberID.text;
                privateIns.groupNum = txtGroupNum.text;
                privateIns.insuredName = txtInsuredName.text;
                privateIns.insuredSSN = btnInsuredSSN.titleLabel.text;
                privateIns.insuredDOB = btnDOB.titleLabel.text;
                
            }
            else
            {
                currentPrivateCount++;
                ClsPrivateInsurance* privateIns = [[ClsPrivateInsurance alloc] init];
                
                privateIns.insuranceName = btnInsuranceName.titleLabel.text;
                privateIns.subscribberID = txtSubscriberID.text;
                privateIns.groupNum = txtGroupNum.text;
                privateIns.insuredName = txtInsuredName.text;
                privateIns.insuredSSN = btnInsuredSSN.titleLabel.text;
                privateIns.insuredDOB = btnDOB.titleLabel.text;
                privateIns.insuranceID = currentPrivateCount;
                [privateInsArray addObject:privateIns];
                
                saved = false;
                [tableView1 reloadData];
            }

        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"Insurance name and subscribber ID are required fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    [self clearPrivateInsurance];
    editMode = false;
    rowEdit = -1;
}

- (IBAction)btnClearSelection:(id)sender {
    self.abnSelectedObtion = 0;
    btnABNObtion1.selected = NO;
    btnABNObtion2.selected = NO;
    btnABNObtion3.selected = NO;
    
}

- (void) clearPrivateInsurance
{
    [btnInsuranceName setTitle:@"" forState:UIControlStateNormal];
    btnInsuranceName.titleLabel.text = @"";
    txtGroupNum.text = @"";
    txtSubscriberID.text = @"";
    [btnInsuredSSN setTitle:@"" forState:UIControlStateNormal];
    txtInsuredName.text = @"";
    [btnDOB setTitle:@"" forState:UIControlStateNormal];
}

- (void) savePrivateInsurance
{
    if (!saved)
    {
        if (btnInsuranceName.titleLabel.text.length > 0 && txtSubscriberID.text > 0)
        {
            if (editMode == false)
            {
                currentPrivateCount++;
                ClsPrivateInsurance* privateIns = [[ClsPrivateInsurance alloc] init];
                
                privateIns.insuranceName = btnInsuranceName.titleLabel.text;
                privateIns.subscribberID = txtSubscriberID.text;
                privateIns.groupNum = txtGroupNum.text;
                privateIns.insuredName = txtInsuredName.text;
                privateIns.insuredSSN = btnInsuredSSN.titleLabel.text;
                privateIns.insuredDOB = btnDOB.titleLabel.text;
                privateIns.insuranceID = currentPrivateCount;
                [privateInsArray addObject:privateIns];
                
            }
            else
            {
                ClsPrivateInsurance* privateIns = [privateInsArray objectAtIndex:rowEdit];
                privateIns.insuranceName = btnInsuranceName.titleLabel.text;
                privateIns.subscribberID = txtSubscriberID.text;
                privateIns.groupNum = txtGroupNum.text;
                privateIns.insuredName = txtInsuredName.text;
                privateIns.insuredSSN = btnInsuredSSN.titleLabel.text;
                privateIns.insuredDOB = btnDOB.titleLabel.text;
                
            }
            
            
        }
        
    }
}
- (IBAction)btnIdNumClick:(UIButton*)sender
{
    NumericViewController *popoverView =[[NumericViewController alloc] initWithNibName:@"NumericViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor blackColor];
    functionSelected = 11;
    popoverView.lblTitle.text = @"ID Number";
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(430, 420);
    popoverView.delegate = self;
    CGRect rect = sender.frame;
    rect.origin.y += 40;
    [self.popover presentPopoverFromRect:rect inView:self.containerView1 permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnInsuredSSNClick:(UIButton*)sender
{
    functionSelected = 12;
    SSNNumericViewController *popoverView =[[SSNNumericViewController alloc] initWithNibName:@"SSNNumericViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor blackColor];
    popoverView.utoEnabled = true;
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(400, 400);
    popoverView.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    popoverView.lblTitle.textColor = [UIColor whiteColor];
}

- (IBAction)btnDeletePrivateInsClick:(id)sender {
    if (rowEdit < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FHMedic" message:@"Please select an insurance from the list to delete." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        rowEdit = -1;
        editMode = false;
        return;
    }
    if ( [privateInsArray count] > 0)
    {
        
        ClsPrivateInsurance* ins = [privateInsArray objectAtIndex:rowEdit];
        NSString* sqlStr;

        sqlStr = [NSString stringWithFormat:@"Update TicketInputs set Deleted = 1 where ticketID = %@ and inputID = 7003 and InputSubID  in (1, 2, 3, 4, 5, 6, 7, 8) and InputInstance = %li",  ticketID, ins.insuranceID];

        @synchronized(g_SYNCDATADB)
        {
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        [self.privateInsArray removeObjectAtIndex:rowEdit];
        
        [tableView1 reloadData];
        [self clearPrivateInsurance];
    }
    rowEdit = -1;
    editMode = false;
}


-(void) doneNumericClick
{
    NumericViewController *p = (NumericViewController *)self.popover.contentViewController;
    if (functionSelected == 11)
    {
        [btnSSN setTitle:p.displayStr forState:UIControlStateNormal];
    }

    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;


}

-(void) doneSSNClick
{
    SSNNumericViewController *p = (SSNNumericViewController *)self.popover.contentViewController;
    
    if (functionSelected == 12)
    {
        [btnInsuredSSN setTitle:p.displayStr forState:UIControlStateNormal];
    }
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

- (void) setControl
{

    [lblPrivateGroupNum setTextColor:[UIColor blackColor]];
    [lblPrivateInsuranceName setTextColor:[UIColor blackColor]];
    [lblPrivateInsuredDOB setTextColor:[UIColor blackColor]];
    [lblPrivateInsuredName setTextColor:[UIColor blackColor]];
    [lblPrivateInsuredSSN setTextColor:[UIColor blackColor]];
    [lblPrivateSubscriber setTextColor:[UIColor blackColor]];

    
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
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from Inputs where InputRequiredField = 1 and inputpage like 'Insurance' union select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = %ld" , outcomeVal, key.key];
        }
        else
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = %ld" , outcomeVal, key.key];
            
        }
        
    }

    else
    {
        sql = @"SELECT distinct i.inputid, i.inputname, i.inputpage FROM inputs i where i.inputrequiredfield = 1 and inputID in (1122, 1123, 1124, 1125, 1126, 1127)";
    }

    NSMutableArray* requiredArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        requiredArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    for (int i = 0; i < [requiredArray count]; i++)
    {
        ClsTableKey* key = [requiredArray objectAtIndex:i];

        if (key.key == 1122)
        {
            [lblPrivateInsuranceName setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1123)
        {
            [lblPrivateSubscriber setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1124)
        {
            [lblPrivateGroupNum setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1125)
        {
           [lblPrivateInsuredName setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1126)
        {
            [lblPrivateInsuredSSN setTextColor:[UIColor redColor]];
        }
        else if (key.key == 1127)
        {
            [lblPrivateInsuredDOB setTextColor:[UIColor redColor]];
        }
     }
}


@end
