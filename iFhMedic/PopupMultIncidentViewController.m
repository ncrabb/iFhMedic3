//
//  PopupMultIncidentViewController.m
//  iRescueMedic
//
//  Created by admin on 10/24/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PopupMultIncidentViewController.h"
#import "ClsTableKey.h"

@interface PopupMultIncidentViewController ()

@end

@implementation PopupMultIncidentViewController
@synthesize array;
@synthesize delegate;
@synthesize arrRowSelected;
@synthesize strSelectedData;


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
   arrRowSelected = [[NSMutableArray alloc] init];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDefaultData
{
    arrSelectedData = [[NSMutableArray alloc] initWithArray:[strSelectedData componentsSeparatedByString:@","]];
    
    
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
    //static NSString *CellIdentifier = @"Cell";
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ClsTableKey* obj = [array objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",obj.desc];
    // Configure the cell...
    for(int i=0;i<[arrSelectedData count] ; i++)
    {
        NSString *str = (NSString *)[arrSelectedData objectAtIndex:i];
        if([str caseInsensitiveCompare:obj.desc] == NSOrderedSame)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            NSLog(@"%@   %@", str, obj.desc);
            [arrRowSelected addObject:[NSNumber numberWithInt:indexPath.row]];

        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([selectedCell accessoryType] == UITableViewCellAccessoryNone) {
        [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [arrRowSelected addObject:[NSNumber numberWithInt:indexPath.row]];
    } else {
        [selectedCell setAccessoryType:UITableViewCellAccessoryNone];
        [arrRowSelected removeObject:[NSNumber numberWithInt:indexPath.row]];
    }
    
    
}

- (IBAction)doneClicked:(id)sender
{
    [delegate doneMultipleIncident];
}

@end
