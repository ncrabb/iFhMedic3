//
//  GalleryCell.m
//  iRescueMedic
//
//  Created by admin on 9/1/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "GalleryCell.h"
#import "DAO.h"
#import "global.h"
#import "ClsUnits.h"
#import "ClsUsers.h"

static char base64EncodingTable[64] = {
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

@implementation GalleryCell
@synthesize imageview;
@synthesize lblName;
@synthesize printSelected;
@synthesize btnPrint;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray* arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"GalleryCell" owner:self options:nil];
        if ([arrayOfViews count] < 1)
            return nil;
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
            return nil;
        self = [arrayOfViews objectAtIndex:0];
        printSelected = false;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)btnPrintClick:(UIButton*)sender {
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketUnitNumber, TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and (deleted is null or deleted = 0)", ticketID ];
    
    NSMutableDictionary* ticketInputsData;
    NSMutableArray* crewData;
    NSMutableArray* unitData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSString* crewIds = [[ticketInputsData objectForKey:@"TicketCrew"] stringByReplacingOccurrencesOfString:@"|" withString:@","];
    NSString* crewIDStr;
    if (crewIds.length > 1)
    {
        if ([[crewIds substringFromIndex:(crewIds.length - 1)] isEqualToString:@","])
        {
            crewIDStr = [crewIds substringToIndex:[crewIds length] - 1];
        }
        else
        {
            crewIDStr = crewIds;
        }
    }
    sql = [NSString stringWithFormat:@"Select * from users where userID in (%@)", crewIDStr ];
    @synchronized(g_SYNCLOOKUPDB)
    {
        crewData = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    sql = [NSString stringWithFormat:@"UnitID = %@", [ticketInputsData objectForKey:@"TicketID"] ];
    @synchronized(g_SYNCLOOKUPDB)
    {
        unitData = [DAO loadUnits:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Filter:sql];
    }
    
    NSMutableString* crewList = [[NSMutableString alloc] init];
    for (int i =0; i< [crewData count]; i++)
    {
        ClsUsers* user = [crewData objectAtIndex:i];
        if (i == [crewData count] - 1)
        {
            [crewList appendString:[NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName]];
        }
        else
        {
            [crewList appendString:[NSString stringWithFormat:@"%@ %@ | ", user.userFirstName, user.userLastName]];
        }
        
    }
    
    NSMutableString* unitList = [[NSMutableString alloc] init];
    for (int i =0; i< [unitData count]; i++)
    {
        ClsUnits* unit = [unitData objectAtIndex:i];
        if (i == [crewData count] - 1)
        {
            [unitList appendString:[NSString stringWithFormat:@"%@", unit.unitDescription]];
        }
        else
        {
            [unitList appendString:[NSString stringWithFormat:@"%@ | ", unit.unitDescription]];
        }
        
    }
    
    UIWebView* webView1 = [[UIWebView alloc] init];
    NSString* logoStr = @"Select FileString from customerContent where FileType = 'Logo'";
    NSString* logo;
    @synchronized(g_SYNCLOOKUPDB)
    {
        logo =  [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:logoStr];
    }
    NSMutableString*     htmlString = [NSMutableString stringWithString:@"<html><head><title>PCR Report</title>"];
    [htmlString appendString:@"<style type=\"text/css\">"];
    [htmlString appendString:@"BODY{ font-family:sans-serif; font-size: 16px;}"];
    [htmlString appendString:@"#header { clear: both; position: relative; height: 10em; margin: 0 auto;}"];
    [htmlString appendString:@"#header img {position: absolute; top: 4%; right: 10px; height: 80%;}"];
    [htmlString appendString:@"#SubHeader {position: relative; top: 0%; left: 25px}"];
    [htmlString appendString:@"#SectionTitle { clear: both; position: relative; height: 1em; margin: 0 auto; background-color: #CDD2E5;}"];
    [htmlString appendString:@"#PatientInfo { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Insurance { clear: both; position: relative;}"];
    [htmlString appendString:@"#PatientAssessment { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Vitals { clear: both; position: relative; height: auto; margin: 5px auto; font-size: 14px; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Treatments { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Protocols { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Comments { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#IncidentInformation { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#CallTimes { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Signatures { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Amendments { clear: both; position: relative; height: auto; margin: 5px auto; border: 2px solid #48525B}"];
    [htmlString appendString:@"#Provider { clear: both; position: relative; height: auto; margin: 5px auto; font-size: 12px;}"];
    [htmlString appendString:@"#Footer { clear: both; position: relative; height: auto; margin: 5px auto; border-top: 2px solid #48525B}"];
    [htmlString appendString:@"</style>"];
    
    [htmlString appendString:@"</head>"];
    [htmlString appendString:@"<body style=\"background:transparent;\">"];
    [htmlString appendString:@"<div id=\"header\" class=\"width100\">"];
    // [htmlString appendString:[NSString stringWithFormat:@"<img src=\"file://%@\" alt=\"\" border=\"0\">", path]];
    [htmlString appendString:[NSString stringWithFormat:@"<img src=\"data:image/png;base64,%@\">", logo]];
    [htmlString appendString:@"</img>"];
    NSString* patientName;
    
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    
    [htmlString appendString:@"<div id=\"SubHeader\" class=\"width100\">"];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Patient Name:</b> %@ <br>", patientName]];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Incident Number:</b> %@ <br>", [self removeNull:[ticketInputsData objectForKey:@"1001:0:1"]]]];
    [htmlString appendString:[NSString stringWithFormat:@"<b>Ticket DOS:</b> %@ <br>", [self removeNull:[ticketInputsData objectForKey:@"1002:0:1"]]]];
    
    [htmlString appendString:[NSString stringWithFormat:@"<b>Chief Complaint:</b> %@ <br>", [self removeNull:[ticketInputsData objectForKey:@"1008:0:1"]]]];
    
    
    [htmlString appendString:[NSString stringWithFormat:@"<b>Unit/Crew:</b> %@ - %@ <br>", unitList, crewList]];
    [htmlString appendString:@"</div>"];
    [htmlString appendString:@"</div>"];
    
    NSData* imageData = UIImagePNGRepresentation(imageview.image);
    NSString *str = [self base64StringFromData:imageData length:[imageData length]];
    
    [htmlString appendString:[NSString stringWithFormat:@"<center><img src=\"data:image/png;base64,%@\">", str]];
    [htmlString appendString:@"</img></center>"];
    [htmlString appendString:@"</body></html>"];


    [webView1 loadHTMLString:htmlString baseURL:nil];
    UIPrintInteractionController *pc = [UIPrintInteractionController
                                        sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Image";
    pc.printInfo = printInfo;
    pc.showsPageRange = YES;
    UIViewPrintFormatter *formatter = [webView1 viewPrintFormatter];
    pc.printFormatter = formatter;
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed,
      NSError *error) {
        if(!completed && error){
            NSLog(@"Print failed - domain: %@ error code %u", error.domain,
                  error.code);
        }
    };
   // [pc presentFromBarButtonItem:self.btnBarPrint animated:YES  completionHandler:completionHandler];
    CGRect rect = sender.frame;
    [pc presentFromRect:rect inView:self animated:YES completionHandler:completionHandler];
    
}

-(NSString *) base64StringFromData: (NSData *)data length: (int)length {
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}


- (NSString*) removeNull:(NSString*)str
{
    if ([str length] > 0 && ([str rangeOfString:@"(null)"].location == NSNotFound))
    {
        return str;
    }
    else
    {
        return @"";
    }
}
@end
