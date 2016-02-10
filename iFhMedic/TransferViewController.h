//
//  TransferViewController.h
//  iRescueMedic
//
//  Created by admin on 4/30/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverViewController.h"

@protocol DismissTransferViewDelegate <NSObject>

-(void)doneTransfer;
-(void)cancelTransfer;

@end


@interface TransferViewController : UIViewController <DismissDelegate>
{
    __weak id <DismissTransferViewDelegate> delegate;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UIButton *btnUnit;
@property (nonatomic, assign) NSInteger ticketID;

- (IBAction)btnUnitClick:(UIButton *)sender;

- (IBAction)btnCancelClick:(id)sender;

- (IBAction)btnTransferClick:(UIButton *)sender;

@end
