//
//  PopupInjuryTypeViewController.m
//  iRescueMedic
//
//  Created by Nathan on 8/27/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "PopupInjuryTypeViewController.h"
#import "ClsTableKey.h"
#import "DDPopoverBackgroundView.h"
#import "PopupSecondViewController.h"

@interface PopupInjuryTypeViewController ()

@end

@implementation PopupInjuryTypeViewController
@synthesize array;
@synthesize delegate;
@synthesize rowSelected;
@synthesize lblTitle;
@synthesize area;
@synthesize burnType;
@synthesize popover;
@synthesize burnDegree;

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
    lblTitle.text = [NSString stringWithFormat:@"   %@: Select injury type...", area];
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



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    rowSelected = indexPath.row;
    if (rowSelected == 9)
    {
        if ([self.burnType count] < 1)
        {
            self.burnType = [[NSMutableArray alloc] init];

            ClsTableKey* standing = [[ClsTableKey alloc] init];
            standing.key = 1;
            standing.tableName = @"Lookup";
            standing.desc = @"1st Degree";
            [self.burnType addObject:standing];
            
            ClsTableKey* standing2 = [[ClsTableKey alloc] init];
            standing2.key = 2;
            standing2.tableName = @"Lookup";
            standing2.desc = @"2nd Degree";
            [self.burnType addObject:standing2];
            
            ClsTableKey* standing3 = [[ClsTableKey alloc] init];
            standing3.key = 3;
            standing3.tableName = @"Lookup";
            standing3.desc = @"3rd Degree";
            [self.burnType addObject:standing3];
            
         /*   PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
            
            popoverView.array = self.burnType;
            popoverView.view.backgroundColor = [UIColor whiteColor];
            
            self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(240, 160);
            popoverView.delegate = self;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CGRect frame = [cell.superview convertRect:cell.frame toView:self.view];
            [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES]; */
            
            PopupSecondViewController *popoverView =[[PopupSecondViewController alloc] initWithNibName:@"PopupSecondViewController" bundle:nil];
            popoverView.arrays = self.burnType;
            popoverView.view.backgroundColor = [UIColor whiteColor];

            self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];

            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani

            self.popover.popoverContentSize = CGSizeMake(240, 160);
            popoverView.delegate = self;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CGRect frame = [cell.superview convertRect:cell.frame toView:self.view];
            [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            
        }
        
    }
    else
    {
        [delegate doneSelected];
    }
}

- (void) doneSecondDelegate
{
    PopupSecondViewController *p = (PopupSecondViewController *)self.popover.contentViewController;
    NSString* type = p.selectedValue;
    
    if (p.rowSelected == 0)
    {
        burnDegree = [NSString stringWithFormat:@"1st Degree %@", type];
    }
    if (p.rowSelected == 1)
    {
        burnDegree = [NSString stringWithFormat:@"2nd Degree %@", type];
    }
    if (p.rowSelected == 2)
    {
        burnDegree = [NSString stringWithFormat:@"3rd Degree %@", type];
    }
    //  [self.delegate doneMvcClick];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [delegate doneSelected];
}

- (void) didTap
{
    PopupIncidentViewController *p = (PopupIncidentViewController *)self.popover.contentViewController;
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    if (p.rowSelected == 0)
    {
        burnDegree = @"1st Degree";
    }
    if (p.rowSelected == 1)
    {
        burnDegree = @"2nd Degree";
    }
    if (p.rowSelected == 2)
    {
        burnDegree = @"3rd Degree";
    }
    [delegate doneSelected];
}


- (void)viewDidUnload {
    [self setLblTitle:nil];
    [super viewDidUnload];
}
@end
