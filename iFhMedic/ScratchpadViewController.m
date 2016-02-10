//
//  ScratchpadViewController.m
//  iRescueMedic
//
//  Created by admin on 5/2/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import "ScratchpadViewController.h"
#import "Base64.h"
#import "DAO.h"
#import "global.h"

@interface ScratchpadViewController ()

@end

@implementation ScratchpadViewController
@synthesize signView;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    needToSave = FALSE;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 650, 500)];
    containerView.backgroundColor = [UIColor whiteColor];
    
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.borderWidth = 2;
    containerView.layer.cornerRadius = 8;
    containerView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,650, 500)];
    
    self.signView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:self.signView];
    [self.view addSubview:containerView];

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

- (UIImage *)signatureImage
{
    UIGraphicsBeginImageContext(containerView.bounds.size);
    
    [containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
    
}

- (IBAction)btnSave:(id)sender {
    needToSave = TRUE;

    UIImage* image = [self signatureImage];
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    NSString* imgStr = [Base64 encode:data];
    NSDate* sourceDate = [NSDate date];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString* timeAdded = [dateFormat stringFromDate:sourceDate];
    NSString* sql;
    NSInteger count ;
    NSString* ticketID1 = [g_SETTINGS objectForKey:@"currentTicketID"];
    sql = [NSString stringWithFormat:@"Select MAX(AttachmentID) from TicketAttachments where TicketID = %@", ticketID1 ];
    @synchronized(g_SYNCBLOBSDB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
    }
    if (count < 7)
    {
        count = 7;
    }
    
    
    sql = [NSString stringWithFormat:@"Insert into TicketAttachments(LocalTicketID, TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded) Values(0, %@, %d, 'ScratchPad', '%@', '%@', '%@')", ticketID1, count + 1, imgStr, @" ", timeAdded ];
    
    @synchronized(g_SYNCBLOBSDB)
    {
        [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
    }
 

    [delegate doneScratchpad];
}

- (IBAction)btnCancel:(id)sender {
    [delegate caenelScratchpad];
}
@end
