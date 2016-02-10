//
//  PopOverWithSearchViewController.m
//  iRescueMedic
//
//  Created by admin on 2/27/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import "PopOverWithSearchViewController.h"
#import "ClsUsers.h"
#import "global.h"
#import "DAO.h"

@interface PopOverWithSearchViewController ()

@end

@implementation PopOverWithSearchViewController
@synthesize delegate;
@synthesize functionSelected;
@synthesize arrayUsers;
@synthesize searchbar;
@synthesize tableview1;
@synthesize unitSelectedID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    searchbar.delegate = self;
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
    

    if (functionSelected == 1)
    {
        return self.arrayUsers.count;
    }
    else
    {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    

    if (functionSelected == 1)
    {
        ClsUsers* user = [arrayUsers objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@ - %@", user.userFirstName, user.userLastName, user.userIDNumber];
    }
 
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.rowSelected = indexPath.row;
    
    [delegate doneSearchUserTap];
}


- (void) viewWillDisappear:(BOOL)animated
{
    self.arrayUsers = nil;
    
    [super viewWillDisappear:animated];
}


#pragma mark-
#pragma UISearchBar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    searchBar.autocapitalizationType = UITextAutocorrectionTypeNo;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  //  if([searchText length] != 0) {
        [self search:searchText];
   // }
   // else {

   // }
    // [self.tblContentList reloadData];
}

-(void)searchBarTextDidEndEditing:(UISearchBar*) mysearchBar
{
    mysearchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
       [self search:searchbar.text];
}

- (void) search:(NSString*) searchText
{
    NSString* sql;
    if([searchText length] != 0)
    {
        sql = [NSString stringWithFormat:@"Select u.UserID, u.UserFirstname, u.UserLastName, u.UserAddress, u.UserCity, u.UserState, u.UserZip, u.UserAge, u.UserUnit, u.UserActive, u.UserCertification, u.UserCertStart, u.UserCertEnd, u.UserCertNum, u.UserPassword, u.UserGroup, UserIDNumber from users u left join certification c on u.UserCertification = c.CertUID where UserActive = %d and (u.userFirstName like '%%%@%%' or u.userLastName like '%%%@%%')", 1, searchbar.text, searchbar.text];
    }
    else
    {
        sql = [NSString stringWithFormat:@"Select u.UserID, u.UserFirstname, u.UserLastName, u.UserAddress, u.UserCity, u.UserState, u.UserZip, u.UserAge, u.UserUnit, u.UserActive, u.UserCertification, u.UserCertStart, u.UserCertEnd, u.UserCertNum, u.UserPassword, u.UserGroup, UserIDNumber from users u left join certification c on u.UserCertification = c.CertUID where UserActive = %d", 1];
    }
    self.arrayUsers = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];

    [self.tableview1 reloadData];
    
}


@end
