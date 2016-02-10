//
//  FaxViewController.m
//  iRescueMedic
//
//  Created by admin on 12/18/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "FaxViewController.h"
#import "DAO.h"
#import "global.h"
#import "ClsTableKey.h"

@interface FaxViewController ()
{
    NSMutableData * webData;
    NSURLConnection* conn;
}
@end

@implementation FaxViewController
@synthesize lblHeader;
@synthesize txtFaxNum;
@synthesize array;
@synthesize activityIndicator;
@synthesize form;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    activityIndicator.hidden = true;
    NSString* sql = @"Select locationID, LocationName, LocationFax from locations where locationfax != ''";
    @synchronized(g_LOOKUPDB)
    {
        self.array = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }

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

- (IBAction)btnSendClick:(id)sender {
    if (txtFaxNum.text.length < 7)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"Please check the phone number and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([form isEqualToString:@"PCR"])
    {
        [self sendFax2];
    }
    else
    {
        [self faxPDF];
    }

}

- (IBAction)btnCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) sendFax
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* customerID = [g_SETTINGS objectForKey:@"CustomerID"];
    NSString *soapMsg = [NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body>" "<FaxDocument xmlns=\"http://RescueMedicReports/\">" "<TicketID>%@</TicketID>" "<CustomerID>%@</CustomerID>" "<PhoneNumber>%@</PhoneNumber>" "</FaxDocument>" "</soap:Body>" "</soap:Envelope>", ticketID,  customerID, txtFaxNum.text];

    
    NSURL *url = [NSURL URLWithString:FAX_SERVICE];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //---set the headers---
    NSString *msgLength = [NSString stringWithFormat:@"%d",
                           [soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://RescueMedicReports/FaxDocument" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    activityIndicator.hidden = false;
    [activityIndicator startAnimating];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

- (void) sendFax21
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* customerID = [g_SETTINGS objectForKey:@"CustomerID"];
    NSString *soapMsg = [NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">" "<soap12:Body>" "<FaxDocumentWithDocType xmlns=\"http://RescueMedicReports/\">" "<TicketID>%@</TicketID>" "<CustomerID>%@</CustomerID>" "<sWhich>PCR</sWhich>" "<PhoneNumber>%@</PhoneNumber>" "</FaxDocumentWithDocType>" "</soap12:Body>" "</soap12:Envelope>", ticketID,  customerID, txtFaxNum.text];
    
    
    NSURL *url = [NSURL URLWithString:FAX_SERVICE];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //---set the headers---
    NSString *msgLength = [NSString stringWithFormat:@"%d",
                           [soapMsg length]];
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
  //  [req addValue:@"http://RescueMedicReports/FaxDocumentWithDocType" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    activityIndicator.hidden = false;
    [activityIndicator startAnimating];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

- (void) sendFax2
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* customerID = [g_SETTINGS objectForKey:@"CustomerID"];
    NSString *soapMsg = [NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body>" "<FaxDocumentWithDocType xmlns=\"http://RescueMedicReports/\">" "<TicketID>%@</TicketID>" "<CustomerID>%@</CustomerID>" "<sWhich>PCR</sWhich>" "<PhoneNumber>%@</PhoneNumber>" "</FaxDocumentWithDocType>" "</soap:Body>" "</soap:Envelope>", ticketID,  customerID, txtFaxNum.text];
    
    
    NSURL *url = [NSURL URLWithString:FAX_SERVICE];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //---set the headers---
    NSString *msgLength = [NSString stringWithFormat:@"%d",
                           [soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://RescueMedicReports/FaxDocumentWithDocType" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    activityIndicator.hidden = false;
    [activityIndicator startAnimating];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}

- (void) faxPDF
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* customerID = [g_SETTINGS objectForKey:@"CustomerID"];
    NSString *soapMsg = [NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>" "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" "<soap:Body>" "<FaxPDF xmlns=\"http://RescueMedicReports/\">" "<TicketID>%@</TicketID>" "<CustomerID>%@</CustomerID>" "<PhoneNumber>%@</PhoneNumber>"  "<sWhich>%@</sWhich>" "</FaxPDF>" "</soap:Body>" "</soap:Envelope>", ticketID,  customerID, txtFaxNum.text, form];
    
    
    NSURL *url = [NSURL URLWithString:FAX_SERVICE];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    //---set the headers---
    NSString *msgLength = [NSString stringWithFormat:@"%d",
                           [soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:@"http://RescueMedicReports/FaxPDF" forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    //---set the HTTP method and body---
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    activityIndicator.hidden = false;
    [activityIndicator startAnimating];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        webData = [NSMutableData data];
    }
}


-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response
{
    [webData setLength: 0];
}

-(void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data
{
    [webData appendData:data];
}


-(void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error
{
    [activityIndicator stopAnimating];
    activityIndicator.hidden = true;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"Failed sending fax. Please check the number and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    [activityIndicator stopAnimating ];
    activityIndicator.hidden = true;
//    NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
 //   NSLog(theXML);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"Fax sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

    
    
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ClsTableKey* key = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = key.tableName;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClsTableKey* selectKey = [array objectAtIndex:indexPath.row];
    lblHeader.text = selectKey.tableName;
    txtFaxNum.text = selectKey.desc;
}
@end
