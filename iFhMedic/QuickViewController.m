//
//  QuickViewController.m
//  iRescueMedic
//
//  Created by admin on 10/12/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "QuickViewController.h"
#import "DAO.h"
#import "global.h"
#import "ClsTableKey.h"

@interface QuickViewController ()

@end

@implementation QuickViewController
@synthesize btnAdult;
@synthesize btnPediatric;
@synthesize lblDrug;
@synthesize lblHeader;
@synthesize lblTreament;
@synthesize drugArray;
@synthesize treamentArray;
@synthesize tvDrug;
@synthesize tvTreatment;
@synthesize primaryComplaint;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    type = 1;
    treatmentSelected = -1;
    drugSelected = -1;
    btnPediatric.backgroundColor = [UIColor grayColor];
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and inputID in (1008)", ticketID ];
    NSMutableDictionary* ticketInputData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    if ([[ticketInputData objectForKey:@"1008:0:1"] length] > 0 && ([[ticketInputData objectForKey:@"1008:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
    {
        self.primaryComplaint = [ticketInputData objectForKey:@"1008:0:1"];
         lblHeader.text = [NSString stringWithFormat:@"Quick Buttons - %@", primaryComplaint];
        
        sql = [NSString stringWithFormat:@"Select TreatmentID, 'Treatments', treatmentDesc from Treatments t inner join quickbuttons q on t.treatmentID = q.inputID inner join chiefcomplaints c on c.ccid = q.ccid where c.ccDescription = '%@' and q.type = %d",primaryComplaint, type];
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.treamentArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
        }
        [tvTreatment reloadData];
        
        sql = [NSString stringWithFormat:@"Select DrugId, 'Drugs', DrugName from drugs d inner join quickbuttons q on q.inputID = d.drugID inner join chiefcomplaints c on c.ccid = q.ccid where c.ccDescription = '%@' and q.type = %d", primaryComplaint,  type];
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.drugArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
        }
        [tvDrug reloadData];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnDoneClick:(id)sender {
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSInteger instance = 1;
    NSString* sqlStr = [NSString stringWithFormat:@"select max(inputinstance) from ticketinputs where ticketID = %@ and inputID > 2000 and inputID < 2099", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        instance = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    instance ++;
    
    if (lblTreament.text.length > 19)
    {
        ClsTableKey* treatmentKey = [treamentArray objectAtIndex:treatmentSelected];
        
        NSString* time = [lblTreament.text substringFromIndex:(lblTreament.text.length - 19)];

        @synchronized(g_SYNCDATADB)
        {
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, treatmentKey.key, 1, instance, treatmentKey.desc, @"Time", time ];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];

  /*          else
            {
                sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputPage = %@, InputName = %@, InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d", treatmentKey.desc, @"Time",  time, ticketID, treatmentKey.key];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }  */
        }
        instance++;
    }
    
    if (lblDrug.text.length > 10)
    {
        ClsTableKey* drugKey = [drugArray objectAtIndex:drugSelected];
        
        NSString* time = [lblDrug.text substringFromIndex:(lblDrug.text.length - 19)];

        @synchronized(g_SYNCDATADB)
        {
            
                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 2011, 1, instance, @"Medication Administration", @"Time", time ];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];

                sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 2011, 2, instance, @"Medication Administration", @"Drug Name", drugKey.desc ];
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];

        /*    else
            {
                sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputPage = %@, InputName = %@, InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d and inputsubID = 1 and InputInstance = %d", drugKey.desc, @"Time",  time, ticketID, drugKey.key, instance];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                
                sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputPage = %@, InputName = %@, InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d and inputsubID = 2 and InputInstance = %d", @"Medication Administration", @"Drug Name",  drugKey.desc, ticketID, drugKey.key, instance];
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            } */
        }
    }
    [delegate doneQuickButton];
}

- (IBAction)btnAdultClick:(id)sender {
    btnAdult.backgroundColor = [UIColor lightGrayColor];
    btnPediatric.backgroundColor = [UIColor grayColor];
    type = 1;
    NSString* sql = [NSString stringWithFormat:@"Select TreatmentID, 'Treatments', treatmentDesc from Treatments t inner join quickbuttons q on t.treatmentID = q.inputID inner join chiefcomplaints c on c.ccid = q.ccid where c.ccDescription = '%@' and q.type = %d",self.primaryComplaint, type];
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        self.treamentArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    [tvTreatment reloadData];
    
    sql = [NSString stringWithFormat:@"Select DrugId, 'Drugs', DrugName from drugs d inner join quickbuttons q on q.inputID = d.drugID inner join chiefcomplaints c on c.ccid = q.ccid where c.ccDescription = '%@' and q.type = %d", self.primaryComplaint,  type];
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        self.drugArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    [tvDrug reloadData];
}

- (IBAction)btnPediatricClick:(id)sender {
    btnAdult.backgroundColor = [UIColor grayColor];
    btnPediatric.backgroundColor = [UIColor lightGrayColor];
    type = 2;
    NSString* sql = [NSString stringWithFormat:@"Select TreatmentID, 'Treatments', treatmentDesc from Treatments t inner join quickbuttons q on t.treatmentID = q.inputID inner join chiefcomplaints c on c.ccid = q.ccid where c.ccDescription = '%@' and q.type = %d",self.primaryComplaint, type];
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        self.treamentArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    [tvTreatment reloadData];
    
    sql = [NSString stringWithFormat:@"Select DrugId, 'Drugs', DrugName from drugs d inner join quickbuttons q on q.inputID = d.drugID inner join chiefcomplaints c on c.ccid = q.ccid where c.ccDescription = '%@' and q.type = %d", self.primaryComplaint,  type];
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        self.drugArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    [tvDrug reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tvTreatment)
    {
        return [treamentArray count];
    }
    else
    {
        return [drugArray count];
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView == tvTreatment)
    {
        ClsTableKey* obj = [treamentArray objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",obj.desc];
        cell.tag = obj.tableID;
    }
    else
    {
        ClsTableKey* obj = [drugArray objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@",obj.desc];
        cell.tag = obj.tableID;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    if (tableView == tvTreatment)
    {
        ClsTableKey* obj = [treamentArray objectAtIndex:indexPath.row];
        lblTreament.text = [NSString stringWithFormat:@"   Treatments - %@ administered at %@", obj.desc, dateString];
        treatmentSelected = indexPath.row;
    }
    else
    {
        ClsTableKey* obj = [drugArray objectAtIndex:indexPath.row];
        lblDrug.text = [NSString stringWithFormat:@"   Drugs - %@ administered at %@", obj.desc, dateString];
        drugSelected = indexPath.row;
    }
}


@end
