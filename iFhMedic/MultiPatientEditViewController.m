//
//  MultiPatientEditViewController.m
//  iRescueMedic
//
//  Created by admin on 12/28/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "MultiPatientEditViewController.h"
#import "SignatureTableViewCell.h"
#import "DAO.h"
#import "global.h"
#import "ClsSignatureImages.h"
#import "Base64.h"

@interface MultiPatientEditViewController ()

@end

@implementation MultiPatientEditViewController
@synthesize myTableView;
@synthesize array;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
 //   self.navigationItem.rightBarButtonItem = self.editButtonItem;
 //   [self.editButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    [backButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,nil]
                                  forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = backButton;
    [self.myTableView setEditing:YES];
}

- (void) backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sql = [NSString stringWithFormat:@"Select * from TicketSignatures where TicketID = %@ and signatureType = 999 and (deleted is null or deleted = 0)", ticketID];

    @synchronized(g_SYNCBLOBSDB)
    {
        self.array = [DAO executeSelectSignatures:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
    }
    [myTableView reloadData];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    SignatureTableViewCell* cell = (SignatureTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SignatureTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    ClsSignatureImages* sig = [array objectAtIndex:indexPath.row];
    NSArray* info = [sig.name componentsSeparatedByString:@"-"];
    for (int i=0; i< info.count; i++)
    {
        if (i == 0)
        {
            cell.lblName.text = [info objectAtIndex:i];
        }
        else if (i == 1)
        {
            cell.lblAddress1.text = [info objectAtIndex:i];
            
        }
        else if (i == 2)
        {
            cell.lblAddress2.text = [info objectAtIndex:i];
            
        }
        
        else if (i == 3)
        {
            cell.lblAddress2.text = [NSString stringWithFormat:@"%@ %@", cell.lblAddress2.text, [info objectAtIndex:i]];
            
        }
        
        else if (i == 4)
        {
            cell.lblAddress2.text = [NSString stringWithFormat:@"%@ %@", cell.lblAddress2.text, [info objectAtIndex:i]];
            
        }
        else if (i == 5)
        {
            cell.lblPhone.text = [info objectAtIndex:i];
            
        }
        else if (i == 6)
        {
            cell.lblDob.text = [info objectAtIndex:i];
            
        }
        
        
    }

    NSData* data = [Base64 decode:sig.imageStr];
    UIImage* image = [UIImage imageWithData:data];
    
    cell.myImageView.image = image;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        ClsSignatureImages* sig = [array objectAtIndex:indexPath.row];
        
        NSString* sql = [NSString stringWithFormat:@"Update TicketSignatures set Deleted = 1, isUploaded = 0 where TicketID = %@ and signatureType = 11 and signatureID = %d", ticketID, sig.signatureID];
        
        @synchronized(g_SYNCBLOBSDB)
        {
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
        }
        [array removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


@end
