//
//  TransferViewController.m
//  iRescueMedic
//
//  Created by admin on 4/30/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import "TransferViewController.h"
#import "DAO.h"
#import "global.h"
#import "DDPopoverBackgroundView.h"
#import "ClsUnits.h"

@interface TransferViewController ()
{
    NSInteger functionSelected;
}
@property (nonatomic, strong) NSMutableArray* unitsArray;
@property (nonatomic,strong) UIPopoverController *popOver;
@end

@implementation TransferViewController
@synthesize delegate;
@synthesize unitsArray;
@synthesize popOver;
@synthesize ticketID;
@synthesize btnUnit;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnUnitClick:(UIButton *)sender {
    functionSelected = 1;
    @synchronized(g_SYNCLOOKUPDB)
    {
       self.unitsArray = [DAO loadUnits:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Filter:@""];
    }
    NSString* currentUnit = [g_SETTINGS objectForKey:@"Unit"];
    for (int i = 0; i < self.unitsArray.count; i++)
    {
        ClsUnits* unit = [self.unitsArray objectAtIndex:i];
        if (unit.unitID == [currentUnit intValue])
        {
            [self.unitsArray removeObjectAtIndex:i];
        }
    }
    PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    popoverView.arrayUnits = self.unitsArray;
    popoverView.functionSelected = 0;
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popOver.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popOver.popoverContentSize = CGSizeMake(280, 305);
    popoverView.delegate = self;
    
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnCancelClick:(id)sender {
    [delegate cancelTransfer];
}

- (IBAction)btnTransferClick:(UIButton *)sender {
    if (btnUnit.titleLabel.text.length > 0)
    {
        NSString* currentUnit = [g_SETTINGS objectForKey:@"UnitName"];
        NSString* sqlCount = [NSString stringWithFormat:@"Select count(*) from ticketInputs where inputID = 9102 and TicketID = %ld", self.ticketID];
        NSInteger count;
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlCount];
        }
        
        if (count < 1)
        {
            NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %ld, %d, %d, %d, '%@', '%@', '%@')", self.ticketID, 9102, 0, 1, @"", @"", currentUnit];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
            
        }
        else
        {
            NSString* sqlTicketInputs = [NSString stringWithFormat:@"Update ticketInputs set InputValue = '%@', isUploaded = 0 where InputID = 9102 and ticketID = %ld", currentUnit, self.ticketID];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlTicketInputs];
            }
        }
        
        NSString* sqlTicketInputs = [NSString stringWithFormat:@"Update tickets set TicketStatus = 4, ticketOwner = 999, TICKETUNITNUMBER = %ld, isUploaded = 0 where ticketID = %ld", btnUnit.tag, self.ticketID];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlTicketInputs];
        }
        
        [delegate doneTransfer];
    }

}

- (void) didTap
{
    PopoverViewController *p = (PopoverViewController *)self.popOver.contentViewController;

    ClsUnits* unit =  [p.arrayUnits objectAtIndex:p.rowSelected];

    [btnUnit setTitle:unit.unitDescription forState:UIControlStateNormal];
    btnUnit.tag =  unit.unitID;
    btnUnit.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.popOver dismissPopoverAnimated:YES];
    self.popOver = nil;
}
@end
