//
//  PopupMvcViewController.m
//  iRescueMedic
//
//  Created by admin on 10/16/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PopupMvcViewController.h"
#import "ClsTableKey.h"
#import "DDPopoverBackgroundView.h"

@interface PopupMvcViewController ()

@end

@implementation PopupMvcViewController
@synthesize array;
@synthesize delegate;
@synthesize rowSelected;
@synthesize burnType;
@synthesize popover;
@synthesize burnDegree;
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
    for(int i=0;i<[arrSelectedData count] ; i++)
    {
        NSString *str = (NSString *)[arrSelectedData objectAtIndex:i];
        if([str caseInsensitiveCompare:obj.desc] == NSOrderedSame)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            NSLog(@"%@   %@", str, obj.desc);
            [arrRowSelected addObject:[NSNumber numberWithInt:indexPath.row]];
            
        }
        else if ([str containsString:@"Burns"] && [obj.desc isEqualToString:@"Burns"])
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

            [arrRowSelected addObject:[NSNumber numberWithInt:indexPath.row]];
        }
        
    }

    
    return cell;
}

- (void) doneMvcDetailsClick
 {
    // [self.delegate doneMvcClick];
 }

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"MVC"])
    {
        if ([cell accessoryType] == UITableViewCellAccessoryNone) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [arrRowSelected addObject:[NSNumber numberWithInt:indexPath.row]];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [arrRowSelected removeObject:[NSNumber numberWithInt:indexPath.row]];
        }
        rowSelected = indexPath.row;
        MVCDetailsViewController* mvcControl = [[MVCDetailsViewController alloc] initWithNibName:@"MVCDetailsViewController" bundle:nil];
        mvcControl.delegate = self;
        [self presentViewController:mvcControl animated:YES completion:nil];
    }
    else if ([cell.textLabel.text containsString:@"Burns"])
    {
        if ([cell accessoryType] == UITableViewCellAccessoryNone) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [arrRowSelected addObject:[NSNumber numberWithInt:indexPath.row]];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [arrRowSelected removeObject:[NSNumber numberWithInt:indexPath.row]];
        }
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
            
            PopupSecondViewController *popoverView =[[PopupSecondViewController alloc] initWithNibName:@"PopupSecondViewController" bundle:nil];
            
            popoverView.arrays = self.burnType;
            popoverView.view.backgroundColor = [UIColor whiteColor];
            
            self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(240, 160);
            popoverView.delegate = self;
          //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CGRect frame = [cell.superview convertRect:cell.frame toView:self.view];
            [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
            rowSelected = indexPath.row;
        }
    }
    else
    {
        if ([cell accessoryType] == UITableViewCellAccessoryNone) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [arrRowSelected addObject:[NSNumber numberWithInt:indexPath.row]];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [arrRowSelected removeObject:[NSNumber numberWithInt:indexPath.row]];
        }
        rowSelected = indexPath.row;

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
    
}

-(void)setDefaultData
{
    arrSelectedData = [[NSMutableArray alloc] initWithArray:[strSelectedData componentsSeparatedByString:@","]];
    
    
}

- (IBAction)btnDoneClick:(id)sender {
        [self.delegate doneMvcClick];
}
@end
