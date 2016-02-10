//
//  PopupGCSViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/19/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "PopupGCSViewController.h"
#import "ClsTableKey.h"
#import "DAO.h"
#import "global.h"
#import "ClsTicketInputs.h"
#import "ClsUnits.h"
#import "ClsUsers.h"
#import "ClsTicketChanges.h"
#import "ClsSignatureImages.h"
#import "ClsSignatureTypes.h"
#import "FormsViewController.h"

@interface PopupGCSViewController ()

@end

@implementation PopupGCSViewController
@synthesize array;
@synthesize delegate;
@synthesize rowSelected;

@synthesize lblTitle;
@synthesize btnPrint;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    rowSelected = -1;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![lblTitle.text isEqualToString:@"Print"])
    {
        btnPrint.hidden = true;
        lblTitle.hidden = false;
        rowSelected = 0;
    }
    else
    {
        lblTitle.hidden = true;
        btnPrint.hidden = false;
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

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ClsTableKey* obj = [array objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",obj.desc];
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    rowSelected = indexPath.row;
    if ([lblTitle.text isEqualToString:@"Print"])
    {
        
    }
    else
    {
        [delegate didTap];
    }
}



- (IBAction)btnPrintClick:(id)sender {
    if (rowSelected > -1)
    {
        NSString* sql;
        if ( rowSelected > 1 && rowSelected < 5)
        {
            NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            NSInteger count = 0;
            if (rowSelected == 3)
            {
                sql = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FORMID = 8 and FormInputID = 10", ticketID];
            }
            else if (rowSelected == 4)
            {
               sql = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FORMID = 2 and FormInputID = 18", ticketID]; 
            }
            else if (rowSelected == 2)
            {
                sql = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and  formID = 3 and formInputID = 7", ticketID];
            }
            @synchronized(g_SYNCDATADB)
            {
                count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            if (count > 0)
            {
                // [self dismissViewControllerAnimated:YES completion:nil];
                FormsViewController* form = [[FormsViewController alloc] initWithNibName:@"FormsViewController" bundle:nil];
                form.formType = rowSelected + 1;
                [self presentViewController:form animated:YES completion:nil];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"This report is not available since no data was entered." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
        }
        else
        {
            FormsViewController* form = [[FormsViewController alloc] initWithNibName:@"FormsViewController" bundle:nil];
            form.formType = rowSelected + 1;
            [self presentViewController:form animated:YES completion:nil];
        }

        
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"Please select a form to print." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
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


@end
