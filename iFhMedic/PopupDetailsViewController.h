//
//  PopupDetailsViewController.h
//  iRescueMedic
//
//  Created by admin on 8/20/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissDetailsDelegate <NSObject>

-(void)doneDetailsClick;

@end

@interface PopupDetailsViewController : UIViewController
{
    __weak id <DismissDetailsDelegate> delegate;
}


@property (nonatomic, strong) NSMutableArray* array;
@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtDetails;
@property (strong, nonatomic) NSString* textSelected;

- (IBAction)btnContinueClick:(id)sender;
- (IBAction)btnClearClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tvDetails;

@end
