//
//  QuickViewController.h
//  iRescueMedic
//
//  Created by admin on 10/12/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DismissQuickbuttonDelegate <NSObject>

-(void)doneQuickButton;


@end

@interface QuickViewController : UIViewController
{
    NSInteger type;
    NSInteger drugSelected;
    NSInteger treatmentSelected;
   __weak id <DismissQuickbuttonDelegate> delegate;
}

@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UIButton *btnAdult;
@property (strong, nonatomic) IBOutlet UIButton *btnPediatric;
@property (strong, nonatomic) IBOutlet UILabel *lblTreament;
@property (strong, nonatomic) IBOutlet UILabel *lblDrug;

@property (strong, nonatomic) IBOutlet UITableView *tvTreatment;
@property (strong, nonatomic) IBOutlet UITableView *tvDrug;
@property (strong, nonatomic) NSMutableArray* drugArray;
@property (strong, nonatomic) NSString* primaryComplaint;

@property (strong, nonatomic) NSMutableArray* treamentArray;

- (IBAction)btnDoneClick:(id)sender;
- (IBAction)btnAdultClick:(id)sender;
- (IBAction)btnPediatricClick:(id)sender;



@end
