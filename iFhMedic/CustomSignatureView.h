//
//  CustomSignatureView.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 10/03/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSignatureView : UIView


@property (nonatomic, assign) bool selected;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UIImageView *signImage;
@property (nonatomic, retain) IBOutlet UIButton *btnSign;

@property (nonatomic, assign) id parent;

- (IBAction)ButtonClicked:(id)sender;

- (void)setImage:(UIImage*)image;
- (void)clearImage;

@end
