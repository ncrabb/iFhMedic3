//
//  PopupAssessmentViewController.h
//  iRescueMedic
//
//  Created by admin on 8/24/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissPertinentNegDelegate <NSObject>

-(void)doneSelect;

@end

@interface PopupAssessmentViewController : UIViewController
{
    __weak id <DismissPertinentNegDelegate> delegate;
    NSMutableArray *arrSelectedData;
}


@property (nonatomic, strong) NSMutableArray* array;
@property (weak) id delegate;
@property (nonatomic, strong) NSMutableArray *arrRowSelected;
@property (nonatomic, strong) NSString *strSelectedData;
@property (strong, nonatomic) UIImage *checkImage;
@property (strong, nonatomic) UIImage *negativeImage;

-(void)setDefaultData;
- (IBAction)doneClick:(id)sender;


@end
