//
//  GridView.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 07/02/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVCell.h" // Balraj gride view
#import "ClsChiefComplaints.h" // Balraj gride view

@interface GridView : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *arrDataSourse;
@property (nonatomic, assign) id parent;

@end
