//
//  PopupGCSViewController.h
//  iRescueMedic
//
//  Created by Nathan on 6/19/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissGCSDelegate <NSObject>

-(void)didTap;

@end

@interface PopupGCSViewController : UIViewController
{
    __weak id <DismissGCSDelegate> delegate;
}


@property (nonatomic, strong) NSMutableArray* array;
@property (weak) id delegate;
@property (nonatomic) NSInteger rowSelected;

@property (nonatomic, strong) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnPrint;

- (IBAction)btnPrintClick:(id)sender;


@end
