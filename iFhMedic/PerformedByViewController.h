//
//  PerformedByViewController.h
//  iRescueMedic
//
//  Created by Nathan on 7/2/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DismissPerformedByDelegate <NSObject>

-(void) donePerformedByClick;

@end

@interface PerformedByViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString* name;
    __weak id <DismissPerformedByDelegate> delegate;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet NSMutableArray *crewArray;
@property (strong, nonatomic) IBOutlet UITableView *tableview1;
@property (assign, nonatomic) bool allCrew;


- (IBAction)btnDoneClick:(id)sender;
- (IBAction)btnSearchClick:(id)sender;
@end
