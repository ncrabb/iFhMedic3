//
//  GalleryCell.h
//  iRescueMedic
//
//  Created by admin on 9/1/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UIButton *btnPrint;
@property (assign, nonatomic) bool printSelected;

- (IBAction)btnPrintClick:(id)sender;

@end
