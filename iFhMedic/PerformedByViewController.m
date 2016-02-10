//
//  PerformedByViewController.m
//  iRescueMedic
//
//  Created by Nathan on 7/2/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 
#import "PerformedByViewController.h"
#import "global.h"
#import "ClsUsers.h"
#import "ClsCrewInfo.h"
#import "DAO.h"

@interface PerformedByViewController ()
@property (nonatomic, strong) NSMutableArray* crewData;

@end

@implementation PerformedByViewController
@synthesize txtName;
@synthesize tableview1;
@synthesize delegate;
@synthesize crewArray;
@synthesize allCrew;
@synthesize crewData;

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
    tableview1.layer.borderColor = [UIColor blackColor].CGColor;
    tableview1.layer.borderWidth = 5.0f;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (allCrew)
    {
        NSString* sql = [NSString stringWithFormat:@"Select u.UserID, u.UserFirstname, u.UserLastName, u.UserAddress, u.UserCity, u.UserState, u.UserZip, u.UserAge, u.UserUnit, u.UserActive, u.UserCertification, u.UserCertStart, u.UserCertEnd, u.UserCertNum, u.UserPassword, u.UserGroup, c.CertName as UserIDNumber from users u left join certification c on u.UserCertification = c.CertUID where UserActive = %d order by u.userfirstname, u.userlastname", 1];
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.crewArray = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
        }
    }
    else
    {
        NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketUnitNumber, ticketShift as TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and (deleted is null or deleted = 0) limit 1", ticketID ];
        
        NSMutableDictionary* ticketInputsData;
        
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
            self.crewData = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
        }
        
        
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtName:nil];
    [self setTableview1:nil];
    [super viewDidUnload];
}
- (IBAction)btnDoneClick:(id)sender {
    [delegate donePerformedByClick];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (allCrew)
    {
        return [crewArray count];
    }
    else
    {
        return crewData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (allCrew)
    {
        ClsUsers* user = [crewArray objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName];
    }
    else
    {
        ClsUsers* user = [crewData objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName];

    }
    return cell;
}

	
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    txtName.text = cell.textLabel.text;
}

- (IBAction)btnSearchClick:(id)sender
{
    if (txtName.text.length < 1)
    {
        return;
    }
    else
    {
        allCrew = true;
        NSString*  sql = [NSString stringWithFormat:@"Select u.UserID, u.UserFirstname, u.UserLastName, u.UserAddress, u.UserCity, u.UserState, u.UserZip, u.UserAge, u.UserUnit, u.UserActive, u.UserCertification, u.UserCertStart, u.UserCertEnd, u.UserCertNum, u.UserPassword, u.UserGroup, UserIDNumber from users u left join certification c on u.UserCertification = c.CertUID where UserActive = %d and (u.userFirstName like '%%%@%%' or u.userLastName like '%%%@%%')", 1, txtName.text, txtName.text];

        @synchronized(g_SYNCLOOKUPDB)
        {
            self.crewArray = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
        }
        [tableview1 reloadData];
    }
}
@end
