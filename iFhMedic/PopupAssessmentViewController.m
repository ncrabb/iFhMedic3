//
//  PopupAssessmentViewController.m
//  iRescueMedic
//
//  Created by admin on 8/24/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PopupAssessmentViewController.h"
#import "ClsTableKey.h"
#import "PopupAssessCell.h"



@interface PopupAssessmentViewController ()

@end

@implementation PopupAssessmentViewController
@synthesize array;
@synthesize delegate;
@synthesize arrRowSelected;
@synthesize strSelectedData;
@synthesize checkImage;
@synthesize negativeImage;

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
    arrRowSelected = [[NSMutableArray alloc] init];
    self.checkImage = [UIImage imageNamed:@"check_indicator.png"];
    self.negativeImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

-(void)setDefaultData
{
    arrSelectedData = [[NSMutableArray alloc] initWithArray:[strSelectedData componentsSeparatedByString:@","]];
    
    
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
    static NSString *simpleTableIdentifier = @"PopupAssessCell";
    
    PopupAssessCell *cell = (PopupAssessCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PopupAssessCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    ClsTableKey* obj = [array objectAtIndex:indexPath.row];
    cell.lblLabel.text=[NSString stringWithFormat:@"%@",obj.desc];
    cell.tag = 0;
    // Configure the cell...
    for(int i=0;i<[arrSelectedData count] ; i++)
    {
        NSString *str = (NSString *)[arrSelectedData objectAtIndex:i];
        
        if ([str rangeOfString:@"NO"].location == NSNotFound)
        {
            if([str caseInsensitiveCompare:obj.desc] == NSOrderedSame)
            {
                cell.imageview.image = checkImage;
                cell.tag = 1;
                ClsTableKey* key = [array objectAtIndex:indexPath.row];
                key.tableID = 1;
            }
        }
        else
        {
            str = [str substringFromIndex:3];
            if([str caseInsensitiveCompare:obj.desc] == NSOrderedSame)
            {
                cell.imageview.image = negativeImage;
                cell.tag = 2;
                ClsTableKey* key = [array objectAtIndex:indexPath.row];
                key.tableID = 2;
            }
        }
            
            
      /*  if([str caseInsensitiveCompare:obj.desc] == NSOrderedSame)
        {
            if ([str rangeOfString:@"NO"].location == NSNotFound) {
                cell.imageview.image = checkImage;
                cell.tag = 1;
            } else {
                cell.imageview.image = negativeImage;
                cell.tag = 2;
            }

        [arrRowSelected addObject:[NSNumber numberWithInt:indexPath.row]];
            
            
        } */
    }

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
    PopupAssessCell *selectedCell = (PopupAssessCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell.tag == 0) {
        selectedCell.tag = 1;
        selectedCell.imageview.image = checkImage;
        ClsTableKey* key = [array objectAtIndex:indexPath.row];
        key.tableID = selectedCell.tag;
    } else if (selectedCell.tag == 1)
    {
        selectedCell.tag = 2;
        selectedCell.imageview.image = negativeImage;
        ClsTableKey* key = [array objectAtIndex:indexPath.row];
        key.tableID = selectedCell.tag;
    }
    else
    {
        selectedCell.tag = 0;
        selectedCell.imageview.image = nil;
        ClsTableKey* key = [array objectAtIndex:indexPath.row];
        key.tableID = selectedCell.tag;
    }
    
}

- (IBAction)doneClick:(id)sender {
   [delegate doneSelect];
}
@end
