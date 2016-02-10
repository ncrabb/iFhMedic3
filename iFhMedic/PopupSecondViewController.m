//
//  PopupSecondViewController.m
//  iRescueMedic
//
//  Created by admin on 4/21/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import "PopupSecondViewController.h"
#import "ClsTableKey.h"
#import "DDPopoverBackgroundView.h"

@interface PopupSecondViewController ()

@end

@implementation PopupSecondViewController
@synthesize delegate;
@synthesize rowSelected;
@synthesize functionSelected;
@synthesize arrays;
@synthesize burnType;
@synthesize popover;
@synthesize selectedValue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrays.count;
  
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
        ClsTableKey* array = [arrays objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", array.desc];
        cell.tag  = array.key;

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
    
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.rowSelected = indexPath.row;
    

        self.burnType = [[NSMutableArray alloc] init];
        ClsTableKey* standing = [[ClsTableKey alloc] init];
        standing.key = 1;
        standing.tableName = @"Lookup";
        standing.desc = @"Thermal";
        [self.burnType addObject:standing];
        
        ClsTableKey* standing2 = [[ClsTableKey alloc] init];
        standing2.key = 2;
        standing2.tableName = @"Lookup";
        standing2.desc = @"Chemical";
        [self.burnType addObject:standing2];
        
        ClsTableKey* standing3 = [[ClsTableKey alloc] init];
        standing3.key = 3;
        standing3.tableName = @"Lookup";
        standing3.desc = @"Electrical";
        [self.burnType addObject:standing3];
        
        ClsTableKey* standing4 = [[ClsTableKey alloc] init];
        standing4.key = 4;
        standing4.tableName = @"Lookup";
        standing4.desc = @"Inhalation";
        [self.burnType addObject:standing4];
        
        PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
        
        popoverView.arrays = self.burnType;
        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.functionSelected = 4;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(280, 260);
        popoverView.delegate = self;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        CGRect frame = [cell.superview convertRect:cell.frame toView:self.view];
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];


}

- (void) didTap
{
    PopoverViewController* p = (PopoverViewController*) self.popover.contentViewController;
    ClsTableKey* key = [self.burnType objectAtIndex:p.rowSelected];
    self.selectedValue = key.desc;
    [delegate doneSecondDelegate];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

@end
