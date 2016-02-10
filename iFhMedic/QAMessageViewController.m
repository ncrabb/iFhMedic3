//
//  QAMessageViewController.m
//  iRescueMedic
//
//  Created by admin on 10/30/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "QAMessageViewController.h"
#import "DAO.h"
#import "global.h"
#import "ClsTableKey.h"

@interface QAMessageViewController ()

@end

@implementation QAMessageViewController
@synthesize adminNotes;
@synthesize tvNote;
@synthesize txtMessage;
@synthesize ticketID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString* sqlStr = [NSString stringWithFormat:@"Select NoteUID, NoteTime, Note from TicketNotes where TicketID = %d order by notetime desc", self.ticketID ];
    NSMutableArray* histArray;
    @synchronized(g_SYNCDATADB)
    {
         histArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr WithExtraInfo:NO];
    }
    NSMutableString* str = [[NSMutableString alloc] init];
    for (int i = 0; i < [histArray count]; i++)
    {
        ClsTableKey* key = [histArray objectAtIndex:i];
        [str appendString:[NSString stringWithFormat:@"%@   %@\n", key.tableName, key.desc]];
        
    }
    tvNote.text = str;
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

- (IBAction)btnDoneClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnSendClick:(id)sender {
    
    if (txtMessage.text.length > 1)
    {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [format stringFromDate:now];
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketNotes where TicketID = %d", self.ticketID ];
        NSInteger count;
        NSString* username = [g_SETTINGS objectForKey:@"UserName"];
        
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        count++;

        sqlStr = [NSString stringWithFormat:@"Insert into TicketNotes(LocalTicketID, TicketID, NoteUID, Note, UserID, NoteTime, NoteRead, ForAdmin, IsUploaded) Values(0, %d, %d, '%@', '%@', '%@', %d, %d, 0)", self.ticketID, count, [self removeNull:txtMessage.text], username, dateString, 0,1];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sent" message:@"Your message has been sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"Please enter the message to be sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (NSString*) removeNull:(NSString*)str
{
    if ([str length] > 0 && ([str rangeOfString:@"(null)"].location == NSNotFound))
    {
        return [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }
    else
    {
        return @"";
    }
}


@end
