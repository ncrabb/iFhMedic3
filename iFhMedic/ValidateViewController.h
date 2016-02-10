//
//  ValidateViewController.h
//  iRescueMedic
//
//  Created by admin on 5/15/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissValidateControl <NSObject>
-(void) doneSelectValidate;
@end


@interface ValidateViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString* requiredID;
    __weak id <DismissValidateControl> delegate;
}


@property (strong, nonatomic) IBOutlet UILabel *lblComplete;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;


@property (weak)  id <DismissValidateControl> delegate;
@property (strong, nonatomic)  NSString* requiredID;
@property (strong, nonatomic)  NSMutableArray* missingInputIDs;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign)  NSInteger tagID;
@property (strong, nonatomic)  NSString* outcomeVal;
@property (assign)  bool ticketComplete;

- (IBAction)btnCancelClick:(id)sender;


@end
