//
//  PopupDataViewController.m
//  iRescueMedic
//
//  Created by admin on 9/5/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PopupDataViewController.h"
#import "ClsTableKey.h"

@interface PopupDataViewController ()

@end

@implementation PopupDataViewController
@synthesize txtDisplay;
@synthesize array;
@synthesize delegate;

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
    [txtDisplay resignFirstResponder];
    return [array count];
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
    cell.tag = obj.tableID;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClsTableKey* key = [array objectAtIndex:indexPath.row];
 
    txtDisplay.text = key.desc;
    
}

- (IBAction)btnContinueClick:(id)sender {
    [delegate doneDataViewClick];
}
@end
