//
//  GridView.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 07/02/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "GridView.h"
#import "ChiefComplaintViewController.h"
#import "DAO.h"
#import "global.h"
#import "ClsTableKey.h"

@interface GridView ()

@end

@implementation GridView

@synthesize collectionView;
@synthesize arrDataSourse;
@synthesize parent;

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
    self.contentSizeForViewInPopover = CGSizeMake(1000, 275);//(900, 433);

  /*  self->arrDataSourse = [[NSArray alloc] initWithObjects:@"Abdominal pain / problems",
                     @"Airway instruction",
                     @"Allergic reaction",
                     @"Altered level of consciousness",
                     @"Behavioral / psychiatric disorder",
                     @"Cardiac arrest",
                     @"Cardiac rhythm disturbance",
                     @"Chest pain / discomfort",
                     @"Diabetic symptoms (hypoglycemia)",
                     @"Electrocution",
                     @"Hyperthermia",
                     @"Hypothermia",
                     @"Hypovolemia / shock",
                     @"Inhalation injury (toxic gas)",
                     @"Obvious death",
                     @"Poisoning / drug ingestion",
                     @"Pregnancy / OB delivery",
                     @"Respiratory distress",
                     @"Respiratory arrest",
                     @"Seizure",
                     @"Sexual assault / rape",
                     @"Smoke inhalation"
                     @"Stings / venomous bites",
                     @"Stroke / CVA",
                     @"Syncope / fainting",
                     @"Traumatic injury",
                     @"Vaginal hemorrhage", nil]; */
    

        NSString* sql = @"select CCID, 'ChiefComplaint', CCDescription from ChiefComplaints where CCType = 0";
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.arrDataSourse = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
        }

    
    UINib *cellNib = [UINib nibWithNibName:@"CVCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"CVCell"];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(125, 61)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    // Balraj for gride view
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UICollectionView delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
        return [self->arrDataSourse count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    //    if(section==0)
    //    {
    //        return CGSizeZero;
    //    }
    
    return CGSizeMake(320, 50);
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)CollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"CVCell";
    
    UICollectionViewCell *cell = [CollectionView dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VitalInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.tag = indexPath.row;
    }
    ClsTableKey* key = [arrDataSourse objectAtIndex:indexPath.row];
    titleLabel.text = key.desc;
    cell.backgroundColor = [UIColor whiteColor];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClsTableKey* key = [self->arrDataSourse objectAtIndex:indexPath.row];
    NSString *str = key.desc;
    [(ChiefComplaintViewController*)parent setButtonText:str onButton:self.view.tag];
}


@end
