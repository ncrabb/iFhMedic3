//
//  PopupDetailsViewController.m
//  iRescueMedic
//
//  Created by admin on 8/20/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "PopupDetailsViewController.h"
#import "ClsTableKey.h"

@interface PopupDetailsViewController ()

@end

@implementation PopupDetailsViewController
@synthesize txtDetails;
@synthesize tvDetails;
@synthesize array;
@synthesize delegate;
@synthesize textSelected;

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
    //[tvDetails setTintColor:[UIColor lightGrayColor]];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [txtDetails becomeFirstResponder];
    txtDetails.text = textSelected;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnContinueClick:(id)sender {
    textSelected = txtDetails.text;
    [delegate doneDetailsClick];
}

- (IBAction)btnClearClick:(id)sender {
    txtDetails.text = @"";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [txtDetails resignFirstResponder];
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
    
    if (txtDetails.text.length < 1)
    {
        txtDetails.text = key.desc;
    }
    else
    {
        txtDetails.text = key.desc;
    }

}



@end
