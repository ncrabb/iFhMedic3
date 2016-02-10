//
//  ImageGalleryViewController.m
//  iRescueMedic
//
//  Created by admin on 9/1/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "ImageGalleryViewController.h"
#import "GalleryCell.h"
#import "DAO.h"
#import "global.h"
#import "ClsTicketAttachments.h"
#import "Base64.h"

@interface ImageGalleryViewController ()
{
    NSIndexPath* prevIndexPath;
}

@end

@implementation ImageGalleryViewController
@synthesize galleryCollectionView;
@synthesize imageArray;

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
    [self.galleryCollectionView registerClass:[GalleryCell class] forCellWithReuseIdentifier:@"cell"];
    self.imageArray = [[NSMutableArray alloc] init];
    [self setViewUI];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    selectedRow = -1;
    ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];

    NSString* sql = [NSString stringWithFormat:@"Select * from TicketAttachments where TicketID = %@ and attachmentID not in (2, 4) and (deleted is null or deleted = 0)", ticketID ];
    @synchronized(g_SYNCBLOBSDB)
    {
        imageArray = [DAO executeSelectTicketAttachments:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
    }
 /*   for (int i = 0; i < [ticketInputsData count]; i++)
    {
        ClsTicketAttachments* attachment = [ticketInputsData objectAtIndex:0];
        NSString* fileStr = attachment.fileStr;
        NSData* data = [Base64 decode:fileStr];
        UIImage* image = [UIImage imageWithData:data];
        [imageArray addObject:image];
    } */
    if ([imageArray count] > 0)
    {
        [galleryCollectionView reloadData];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.imageArray = nil;
    self.galleryCollectionView = nil;
    [super viewWillDisappear:animated];
}

-(void) setViewUI
{
    
    // toolBar background image
  //  UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
//    [self.toolbar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    [self.toolbar setBackgroundColor:[UIColor blackColor]];
    [self.toolbar setBarTintColor:[UIColor blackColor]];
   // toolBarIMG = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // static NSString *cellIdentifier = @"cell";
    
    GalleryCell *cell = (GalleryCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ClsTicketAttachments* attachment = [imageArray objectAtIndex:indexPath.row];
    NSString* fileStr = attachment.fileStr;
    NSData* data = [Base64 decode:fileStr];
    cell.imageview.image = [UIImage imageWithData:data];
    cell.lblName.text = attachment.fileName;
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedRow > -1)
    {
        GalleryCell* cell = (GalleryCell*) [collectionView cellForItemAtIndexPath:prevIndexPath];
        cell.backgroundColor = [UIColor blackColor];
    }
    selectedRow = indexPath.row;
    prevIndexPath = indexPath;
    GalleryCell* cell = (GalleryCell*) [collectionView cellForItemAtIndexPath:indexPath];

    cell.backgroundColor = [UIColor grayColor];

}


- (IBAction)btnDoneClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnDeleteClick:(id)sender {
    if (selectedRow < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"Please select a photo below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"Are you sure you want to delete this image?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 1;
        [alert show];

    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            ClsTicketAttachments* attachment = [imageArray objectAtIndex:selectedRow];
            NSString* sql;
            if (attachment.attachmentID <= 6)
            {
                //  sql = [NSString stringWithFormat:@"Update ticketAttachments set Deleted = 1, isUploaded = 0 where ticketID = %@ and attachmentID in (%d, %d)", ticketID, attachment.attachmentID, attachment.attachmentID + 1];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FHMedic For iPad" message:@"This image can not be deleted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
                
            }
            else
            {
                sql = [NSString stringWithFormat:@"Update ticketAttachments set Deleted = 1, isUploaded = 0 where ticketID = %@ and attachmentID = %d", ticketID, attachment.attachmentID];
            }
            
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            [imageArray removeObjectAtIndex:selectedRow];
            [galleryCollectionView reloadData];
            prevIndexPath = nil;
            selectedRow = -1;
        } else
        {
            
        }
    }

}


@end
