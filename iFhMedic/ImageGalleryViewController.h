//
//  ImageGalleryViewController.h
//  iRescueMedic
//
//  Created by admin on 9/1/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageGalleryViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger selectedRow;
    NSString* ticketID ;
}
@property (strong, nonatomic) IBOutlet UICollectionView *galleryCollectionView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) NSMutableArray* imageArray;
- (IBAction)btnDoneClick:(id)sender;
- (IBAction)btnDeleteClick:(id)sender;


@end
