//
//  TabBarButton.m
//  TestMem1
//
//  Created by Tony Nguyen on 08/04/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import "TabBarButton.h"

@interface TabBarButton()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TabBarButton

+ (instancetype) buttonWithTitle:(NSString*)title image:(UIImage*)image
{
    return [self buttonWithTitle:title image:image selectedImage:nil];
}

+ (instancetype) buttonWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    TabBarButton *button = [[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:nil options:nil][0];
    button.title = title;
    button.image = image;
    button.selectedImage = selectedImage;
    return button;
}

#pragma mark - get/set

- (void) setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    _iconView.highlighted = selected;
    _titleLabel.highlighted = selected;
}

- (void) setTitle:(NSString*)title
{
    _title = title;
    _titleLabel.text = title;
}

- (void) setTitleColor:(UIColor*)titleColor
{
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
}

- (void) setTitleSelectedColor:(UIColor*)titleSelectedColor
{
    _titleSelectedColor = titleSelectedColor;
    _titleLabel.highlightedTextColor = titleSelectedColor;
}

- (void) setImage:(UIImage*)image
{
    _image = image;
    _iconView.image = image;
}

- (void) setSelectedImage:(UIImage*)selectedImage
{
    _selectedImage = selectedImage;
    _iconView.highlightedImage = selectedImage;
}

@end
