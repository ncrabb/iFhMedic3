//
//  TabBarButton.h
//  TestMem1
//
//  Created by Tony Nguyen on 08/04/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarButton : UIControl

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *titleSelectedColor;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *selectedImage;

+ (instancetype) buttonWithTitle:(NSString*)title image:(UIImage*)image;
+ (instancetype) buttonWithTitle:(NSString*)title image:(UIImage*)image selectedImage:(UIImage*)selectedImage;

@end
