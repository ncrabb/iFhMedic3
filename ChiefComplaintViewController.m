//
//  ChiefComplaintViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/20/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "ChiefComplaintViewController.h"
#import "global.h"
#import "DAO.h"
#import "ClsChiefComplaints.h"
#import "ClsTickets.h"
#import "CVCell.h" // Balraj gride view
#import "GridView.h"//mani for popover
#import <QuartzCore/QuartzCore.h>
#import "DDPopoverBackgroundView.h"
#import "ClsTableKey.h"
#import "QAMessageViewController.h"
//#import "GridView.h"

@interface ChiefComplaintViewController ()
@property (nonatomic, copy) NSString* ticketID;
@end

@implementation ChiefComplaintViewController
@synthesize primaryComplaint;
@synthesize secondaryComplaint;
@synthesize segmentedControl;
@synthesize medical;
@synthesize trauma;
@synthesize newTicket;
@synthesize delegate;
@synthesize btnPrimaryImpression;
@synthesize btnSecondaryImpression;
@synthesize txtComplaint;
@synthesize btnNameLabel;
@synthesize popover;
@synthesize lblChiefComplaint;
@synthesize iv1;
@synthesize iv2;
@synthesize collectionview;
@synthesize arrDataSourse;
@synthesize ticketInputsData;
@synthesize segControl;
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
    
    arrDataSourse = [[NSMutableArray alloc] init];
    UINib *cellNib = [UINib nibWithNibName:@"CVCell" bundle:nil];
    [self.collectionview registerNib:cellNib forCellWithReuseIdentifier:@"CVCell"];
    if (arrDataSourse.count < 1)
    {
        NSString* sql = @"select CCID, 'ChiefComplaint', CCDescription from ChiefComplaints where CCType = 0 and CCActive = 1";
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.medical = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
        }
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(125, 61)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionview setCollectionViewLayout:flowLayout];
    
    
    [self.btnPrimaryImpression setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnSecondaryImpression setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    self.btnPrimaryImpression.titleLabel.adjustsFontSizeToFitWidth = TRUE;
    self.btnSecondaryImpression.titleLabel.adjustsFontSizeToFitWidth = TRUE;
    
    txtComplaint.font =  [UIFont fontWithName:@"ZegoeUI" size:18];
    
    
    NSString* traumaSql = @"Select CCID, 'ChiefComplaint', CCDescription from ChiefComplaints where CCType = 1 and CCActive = 1";
    @synchronized(g_SYNCLOOKUPDB)
    {
        self.trauma = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:traumaSql WithExtraInfo:NO];
    }
    self.arrDataSourse = self.medical;
 
    // Balraj
    //collectionView.hidden = true;
    [self setViewUI];
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }
}



- (void) loadData
{

    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1008", ticketID ];
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
        
        @synchronized(g_SYNCDATADB)
        {
            self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and InputID in (1008, 1010, 1013)", ticketID ];
            ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
        if ([[ticketInputsData objectForKey:@"1008:0:1"] length] > 0 && ([[ticketInputsData objectForKey:@"1008:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [segmentedControl setTitle:[NSString stringWithFormat:@"Primary Impression: %@", [ticketInputsData objectForKey:@"1008:0:1"]] forSegmentAtIndex:0];
            primaryComplaint = [ticketInputsData objectForKey:@"1008:0:1"];
            [btnPrimaryImpression setTitle:[NSString stringWithFormat:@"Primary Impression:%@",primaryComplaint] forState:UIControlStateNormal];
        }
        if ([[ticketInputsData objectForKey:@"1010:0:1"] length] > 0 && ([[ticketInputsData objectForKey:@"1010:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [segmentedControl setTitle:[NSString stringWithFormat:@"Secondary Impression: %@", [ticketInputsData objectForKey:@"1010:0:1"]] forSegmentAtIndex:1];
            secondaryComplaint = [ticketInputsData objectForKey:@"1010:0:1"];
            [btnSecondaryImpression setTitle:[NSString stringWithFormat:@"Secondary Impression:%@",secondaryComplaint] forState:UIControlStateNormal];
        }
        if ([[ticketInputsData objectForKey:@"1013:0:1"] length] > 0 && ([[ticketInputsData objectForKey:@"1013:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            txtComplaint.text = [ticketInputsData objectForKey:@"1013:0:1"];
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


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    primarySelected = true;
    iv2.hidden = true;
    iv1.hidden = false;
    NSString* patientName;
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    [self loadData];
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    btnNameLabel.title = patientName;
    [btnNameLabel setTintColor:[UIColor whiteColor]];
    
    [self setControl];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSegmentedControl:nil];
    //[self setcollectionView:nil];
    [self setBtnQueue:nil];
    [self setBtnQueue:nil];
    [super viewDidUnload];
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

- (IBAction)btnMainMenuClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [delegate dismissViewControl];
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

- (void) viewWillDisappear:(BOOL)animated
{

    [self saveTab];
    [super viewWillDisappear:animated];
}

- (void) saveTab
{
    NSString* sqlStr;
    NSInteger count;
    
    NSString* status = [g_SETTINGS objectForKey:@"TicketStatus"];
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSArray* primaryArray = [btnPrimaryImpression.titleLabel.text componentsSeparatedByString:@":"];
    NSArray* secondArray = [btnSecondaryImpression.titleLabel.text componentsSeparatedByString:@":"];
    //NSArray* ptcomplaintArray = [txtComplaint.text componentsSeparatedByString:@":"];
    
    NSString* primaryComplaintl = @"";
    NSString* secondaryComplaintl = @"";
    NSString* ptComplaint = txtComplaint.text;
    
    if (primaryArray.count > 1) {
        primaryComplaintl = [primaryArray objectAtIndex:1];
    }
    if (secondArray.count > 1) {
        secondaryComplaintl = [secondArray objectAtIndex:1];
    }
    
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
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
        NSString* timeAdded = [dateFormat stringFromDate:sourceDate];
        
        if ((primaryComplaintl != nil) &&  ![primaryComplaintl isEqualToString:[ticketInputsData objectForKey:@"1008:0:1"]])
        {
            count++;
            sqlStr = [NSString stringWithFormat:@"Insert into TicketChanges(LocalTicketID, TicketID, ChangeID, ChangeMade, ChangeTime, ModifiedBy, ChangeInputID, OriginalValue) Values(0, %@, %d, 'Input changed from %@ to %@', '%@', %@, 1008, '%@')", ticketID, count , [ticketInputsData objectForKey:@"1008:0:1"] ,[self removeNull:primaryComplaintl], timeAdded, userID, [ticketInputsData objectForKey:@"1008:0:1"]];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }
        if ((secondaryComplaintl != nil) &&  ![secondaryComplaintl isEqualToString:[ticketInputsData objectForKey:@"1010:0:1"]])
        {
            count++;
            sqlStr = [NSString stringWithFormat:@"Insert into TicketChanges(LocalTicketID, TicketID, ChangeID, ChangeMade, ChangeTime, ModifiedBy, ChangeInputID, OriginalValue) Values(0, %@, %d, 'Input changed from %@ to %@', '%@', %@, 1010, '%@')", ticketID, count , [ticketInputsData objectForKey:@"1010:0:1"] ,[self removeNull:secondaryComplaintl], timeAdded, userID, [ticketInputsData objectForKey:@"1010:0:1"]];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }
        if ((ptComplaint != nil) &&  ![ptComplaint isEqualToString:[ticketInputsData objectForKey:@"1013:0:1"]])
        {
            count++;
            sqlStr = [NSString stringWithFormat:@"Insert into TicketChanges(LocalTicketID, TicketID, ChangeID, ChangeMade, ChangeTime, ModifiedBy, ChangeInputID, OriginalValue) Values(0, %@, %d, 'Input changed from %@ to %@', '%@', %@, 1013, '%@')", ticketID, count , [ticketInputsData objectForKey:@"1013:0:1"] ,[self removeNull:ptComplaint], timeAdded, userID, [ticketInputsData objectForKey:@"1013:0:1"]];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }
    }
    
    
    NSString* updateStr;
    
    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1008", primaryComplaintl, ticketID];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1008, 0, 1, @"", @"", primaryComplaintl];
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    

    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1010", secondaryComplaintl, ticketID];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1010, 0, 1, @"", @"", secondaryComplaintl ];
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }

    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1013", ptComplaint, ticketID];
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1013, 0, 1, @"", @"", ptComplaint];
        [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
    }
    

    
    NSMutableArray* ticketsInfo;
    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        sqlStr = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.ticketIncidentNumber, T.ticketDesc, T.ticketDOS, t.TicketStatus, T.TicketOwner, T.ticketCreator, T.ticketUnitNumber, T.ticketFinalized, T.ticketDateFinalized, T.ticketCrew, T.ticketPractice, T.ticketCreatedTime, T.TicketShift, T.ticketLocked, T.ticketReviewed, T.ticketAccount, T.TicketAdminNotes from Tickets T where TicketID = %@", ticketID];
        ticketsInfo = [DAO executeSelectTickets:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    if ( (ticketsInfo != nil) && (ticketsInfo.count > 0) )
    {
        ClsTickets* ticketInfo = [ticketsInfo objectAtIndex:0];
        NSString* desc = ticketInfo.ticketDesc;
        if ([desc length] > 0 && ([desc rangeOfString:@"(null)"].location == NSNotFound))
        {
            if ([desc rangeOfString:@"Practice:"].location == NSNotFound)   // part after practice
            {
                if ([desc rangeOfString:@","].location == NSNotFound)   // part after practice
                {
                    desc = [NSString stringWithFormat:@"%@,%@", primaryComplaintl, ticketInfo.ticketDesc];
                }
                else
                {
                    NSRange startRange = [ticketInfo.ticketDesc rangeOfString:@","];
                    desc = [NSString stringWithFormat:@"%@,%@", primaryComplaintl , [ticketInfo.ticketDesc substringFromIndex:startRange.location+ 1]];
                }
            }
            else
            {
                NSRange startRange = [ticketInfo.ticketDesc rangeOfString:@":"];
                if ([desc rangeOfString:@"."].location == NSNotFound)   // part after practice
                {
                    desc = [NSString stringWithFormat:@"%@ %@,%@", [ticketInfo.ticketDesc substringToIndex:startRange.location +1], primaryComplaintl, [ticketInfo.ticketDesc substringFromIndex:startRange.location+ 1]];
                }
                else
                {
                    NSRange endRange = [ticketInfo.ticketDesc rangeOfString:@", "];
                    desc = [NSString stringWithFormat:@"%@ %@,%@", [ticketInfo.ticketDesc substringToIndex:startRange.location +1], primaryComplaintl, [ticketInfo.ticketDesc substringFromIndex:endRange.location+ 1]];
                }
                
            }
        }
        else
        {
            desc = [NSString stringWithFormat:@"%@,", primaryComplaintl];
        }

        @synchronized(g_SYNCDATADB)
        {
            self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            sqlStr = [NSString stringWithFormat:@"UPDATE Tickets Set TicketDesc = '%@', isUploaded = 0 where TicketID = %@", desc, ticketID];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
    }
    
    
}



- (IBAction)btnSegControlClick:(id)sender {
    
    if (segControl.selectedSegmentIndex == 0)
    {
        self.arrDataSourse = self.medical;
    }
    else
    {
        self.arrDataSourse = self.trauma;
    }
    [collectionview reloadData];
}


- (void)setButtonText:(NSString *)text onButton:(NSInteger)tag
{
    if(tag == 1)
    {
        NSString *str = [NSString stringWithFormat:@"Primary Impression:%@", text];
        [self.btnPrimaryImpression setTitle:str forState:UIControlStateNormal];
        primaryComplaint = text;
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"Secondary Impression:%@", text];
        
        [self.btnSecondaryImpression setTitle:str forState:UIControlStateNormal];
        secondaryComplaint = text;
    }
}


- (IBAction)btnPrimarySecondaryClick:(id)sender {
    UIButton *btnTemp = (UIButton *) sender;
    if (btnTemp == self.btnPrimaryImpression)
    {
        primarySelected = true;
        iv1.hidden = false;
        iv2.hidden = true;
        
    }
    else
    {
        primarySelected = false;
        iv1.hidden = true;
        iv2.hidden = false;
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

#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
}



- (void) setControl
{
    
    [lblChiefComplaint setTextColor:[UIColor blackColor]];
    
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
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from Inputs where InputRequiredField = 1 and inputpage like 'Impression' union select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = %ld" , outcomeVal, key.key];
        }
        else
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = %ld" , outcomeVal, key.key];
            
        }
        
    }
    else
    {
        sql = @"SELECT distinct i.inputid, i.inputname, i.inputpage FROM inputs i where i.inputrequiredfield = 1 and inputID in (1008, 1013)";
    }
    NSMutableArray* requiredArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        requiredArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    for (int i = 0; i < [requiredArray count]; i++)
    {
        ClsTableKey* key = [requiredArray objectAtIndex:i];
        if (key.key == 1008)
        {
            [btnPrimaryImpression setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        if (key.key == 1013)
        {
            [lblChiefComplaint setTextColor:[UIColor redColor]];
        }
    }
}

- (void) doneQuickButton
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

#pragma mark- UICollectionView delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.arrDataSourse count];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    return CGSizeMake(320, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView*) collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)CollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"CVCell";
    
    UICollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    
    /*    if (cell == nil) {
     NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VitalInfoCell" owner:self options:nil];
     cell = [nib objectAtIndex:0];
     cell.tag = indexPath.row;
     }  */
    
    ClsTableKey* key = [self.arrDataSourse objectAtIndex:indexPath.row];
    titleLabel.text = key.desc;
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClsTableKey* key = [self->arrDataSourse objectAtIndex:indexPath.row];
    NSString *str = key.desc;
    if (primarySelected == true)
    {
        [self setButtonText:str onButton:1];
    }
    else
    {
        [self setButtonText:str onButton:0];
    }
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

- (IBAction)btnCopyImpressionClick:(id)sender {
    NSArray* primaryArray = [btnPrimaryImpression.titleLabel.text componentsSeparatedByString:@":"];
    if ((primaryArray.count > 1) && [[primaryArray objectAtIndex:1] length] > 0)
    {
        txtComplaint.text = [primaryArray objectAtIndex:1];
    }
    
}

@end
