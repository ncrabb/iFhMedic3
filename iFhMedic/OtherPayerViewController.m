//
//  OtherPayerViewController.m
//  iRescueMedic
//
//  Created by Nathan on 8/19/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "OtherPayerViewController.h"
#import "DAO.h"
#import "global.h"
#import "ClsTableKey.h"
#import "DDPopoverBackgroundView.h"  // Mani


@interface OtherPayerViewController ()
{
    BOOL keyboardDown;
}
@end

@implementation OtherPayerViewController
@synthesize delegate;
@synthesize popover;
@synthesize txtAddress;
@synthesize txtCity;
@synthesize txtEmployer;
@synthesize txtFirstName;
@synthesize txtLastName;
@synthesize txtNextOfKin;
@synthesize btnRelationship;
@synthesize txtState;
@synthesize txtZip;
@synthesize btnDOB;
@synthesize stateArray;
@synthesize relationshipArray;
@synthesize cityArray;
@synthesize first;
@synthesize last;
@synthesize address;
@synthesize city;
@synthesize state;
@synthesize zip;
@synthesize relation;
@synthesize rphone;
@synthesize kin;
@synthesize kphone;
@synthesize employer;
@synthesize ephone;
@synthesize dob;
@synthesize btnEmployerPhone;
@synthesize btnNextKinPhone;
@synthesize btnPhone;
@synthesize ticketID;
@synthesize ticketInputsData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    txtEmployer.delegate = self;
    txtNextOfKin.delegate = self;
    txtFirstName.delegate = self;
    txtLastName.delegate = self;
    txtAddress.delegate = self;
    txtCity.delegate = self;
    txtState.delegate = self;
    txtZip.delegate = self;
    
    txtFirstName.text = first;
    txtLastName.text = last;
    txtAddress.text = address;
    txtCity.text = city;
    txtState.text = state;
    txtZip.text = zip;
    [btnRelationship setTitle:relation forState:UIControlStateNormal];

    txtNextOfKin.text = kin;

    txtEmployer.text = employer;

    [btnDOB setTitle:dob forState:UIControlStateNormal];
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    functionSelected = 0;
    [self loadData];
}

- (void) loadData
{
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and inputID = 7004", ticketID ];
    
    @synchronized(g_SYNCDATADB)
    {
        self.ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    if ([ticketInputsData count] > 0)
    {
        if ([[ticketInputsData objectForKey:@"7004:1:1"] length] > 0)
        {
            txtFirstName.text = [self removeNull:[ticketInputsData objectForKey:@"7004:1:1"]];
        }
        if ([[ticketInputsData objectForKey:@"7004:2:1"] length] > 0)
        {
            txtLastName.text = [self removeNull:[ticketInputsData objectForKey:@"7004:2:1"]];
        }
        if ([[ticketInputsData objectForKey:@"7004:3:1"] length] > 0)
        {
            txtAddress.text = [self removeNull:[ticketInputsData objectForKey:@"7004:3:1"]];
        }
        if ([[ticketInputsData objectForKey:@"7004:4:1"] length] > 0)
        {
            txtCity.text = [self removeNull:[ticketInputsData objectForKey:@"7004:4:1"]];
        }
        if ([[ticketInputsData objectForKey:@"7004:5:1"] length] > 0)
        {
            txtState.text = [self removeNull:[ticketInputsData objectForKey:@"7004:5:1"]];
        }
        if ([[ticketInputsData objectForKey:@"7004:6:1"] length] > 0)
        {
            txtZip.text = [self removeNull:[ticketInputsData objectForKey:@"7004:6:1"]];
        }
        if ([[ticketInputsData objectForKey:@"7004:7:1"] length] > 0)
        {
            [btnRelationship setTitle:[self removeNull:[ticketInputsData objectForKey:@"7004:7:1"]] forState:UIControlStateNormal];
        }
        if ([[ticketInputsData objectForKey:@"7004:8:1"] length] > 0)
        {
            [btnPhone setTitle:[self removeNull:[ticketInputsData objectForKey:@"7004:8:1"]] forState:UIControlStateNormal];
        }
        if ([[ticketInputsData objectForKey:@"7004:9:1"] length] > 0)
        {
            txtNextOfKin.text = [self removeNull:[ticketInputsData objectForKey:@"7004:9:1"]];
        }
        if ([[ticketInputsData objectForKey:@"7004:10:1"] length] > 0)
        {
            [btnNextKinPhone setTitle:[self removeNull:[ticketInputsData objectForKey:@"7004:10:1"]] forState:UIControlStateNormal];
        }
        
        if ([[ticketInputsData objectForKey:@"7004:11:1"] length] > 0)
        {
            txtEmployer.text = [self removeNull:[ticketInputsData objectForKey:@"7004:11:1"]];
        }
        if ([[ticketInputsData objectForKey:@"7004:12:1"] length] > 0)
        {
            [btnEmployerPhone setTitle:[self removeNull:[ticketInputsData objectForKey:@"7004:12:1"]] forState:UIControlStateNormal];
        }
        
        if ([[ticketInputsData objectForKey:@"7004:13:1"] length] > 0)
        {
            [btnDOB setTitle:[self removeNull:[ticketInputsData objectForKey:@"7004:13:1"]] forState:UIControlStateNormal];
        }
        
    }

    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == txtEmployer || textField == txtNextOfKin)
    {
        [self setViewMovedUp:YES];
    }
    keyboardDown = true;
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtEmployer || textField == txtNextOfKin)
    {
        [self setViewMovedUp:NO];
    }
    if (keyboardDown)
    {
        keyboardDown = false;
        if(textField ==  txtFirstName)
        {
            [txtLastName becomeFirstResponder];
            
        }
        if(textField ==  txtLastName)
        {
            [txtAddress becomeFirstResponder];
            
        }
        if(textField ==  txtAddress)
        {
            [txtCity becomeFirstResponder];
            
        }
        if(textField ==  txtCity)
        {
            [txtState becomeFirstResponder];
            
        }
        if(textField ==  txtState)
        {
            [txtZip becomeFirstResponder];
            
        }
        if(textField ==  txtZip)
        {
            [self btnRelationShipClick:btnRelationship];
            
        }
        if(textField ==  txtNextOfKin)
        {
            [self btnNextKinPhoneClick:btnNextKinPhone];
            
        }
        if(textField ==  txtEmployer)
        {
            [self btnEmployerPhoneClick:btnEmployerPhone];
            
        }
    }

    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    keyboardDown = true;
    [textField resignFirstResponder];
}

- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        if(rect.origin.y == 0)
            rect.origin.y = self.view.frame.origin.y - 216;
    }
    else
    {
        if(rect.origin.y < 0)
            rect.origin.y = self.view.frame.origin.y + 216;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtFirstName:nil];
    [self setTxtLastName:nil];
    [self setTxtAddress:nil];
    [self setTxtCity:nil];
    [self setTxtState:nil];
    [self setTxtZip:nil];

    [self setTxtNextOfKin:nil];

    [self setTxtEmployer:nil];

    [self setBtnDOB:nil];
    [super viewDidUnload];
}
- (IBAction)btnPhoneClick:(UIButton *)sender {
    functionSelected = 7;
    [sender resignFirstResponder];
    
    SSNNumericViewController *popoverView =[[SSNNumericViewController alloc] initWithNibName:@"SSNNumericViewController" bundle:nil];
    popoverView.phoneFormat = 1;
    popoverView.view.backgroundColor = [UIColor blackColor];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(400, 400);
    popoverView.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    popoverView.lblTitle.textColor = [UIColor whiteColor];
    
}

- (IBAction)btnNextKinPhoneClick:(UIButton*)sender {
    [txtNextOfKin resignFirstResponder];
    functionSelected = 8;
    [sender resignFirstResponder];
    
    SSNNumericViewController *popoverView =[[SSNNumericViewController alloc] initWithNibName:@"SSNNumericViewController" bundle:nil];
    popoverView.phoneFormat = 1;
    popoverView.view.backgroundColor = [UIColor blackColor];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(400, 400);
    popoverView.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    popoverView.lblTitle.textColor = [UIColor whiteColor];
}

- (IBAction)btnEmployerPhoneClick:(UIButton*)sender {
    [txtEmployer resignFirstResponder];
    functionSelected = 9;
    [sender resignFirstResponder];
    
    SSNNumericViewController *popoverView =[[SSNNumericViewController alloc] initWithNibName:@"SSNNumericViewController" bundle:nil];
    popoverView.phoneFormat = 1;
    popoverView.view.backgroundColor = [UIColor blackColor];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(400, 400);
    popoverView.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    popoverView.lblTitle.textColor = [UIColor whiteColor];
}

- (IBAction)txtCityClick:(UIButton*)sender {
    if ([cityArray count] < 1)
    {
        NSString* querySql = @"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 1004";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.cityArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 1;
    PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
    
    popoverView.array = self.cityArray;
    popoverView.view.backgroundColor = [UIColor whiteColor];

    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(250, 260);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)txtStateClick:(UIButton*)sender {
    if ([stateArray count] < 1)
    {
        NSString* querySql = @"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 1005";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.stateArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 2;
    PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
    
    popoverView.array = self.stateArray;
    popoverView.view.backgroundColor = [UIColor whiteColor];

    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(250, 260);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)txtRelationshipClick:(UIButton*)sender {
    if ([ relationshipArray count] < 1)
    {
        NSString* querySql = @"select I.InputID, 'Inputs', IL.LookupName from InsuranceInputs I inner join InsuranceInputLookup IL on I.InputID = IL.InputID where IL.InsID = 7004 and I.InputID = 7";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.relationshipArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 3;
    PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
    
    popoverView.array = self.relationshipArray;
    popoverView.view.backgroundColor = [UIColor whiteColor];

    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(250, 260);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnDOBClick:(UIButton*)sender {
    CalendarViewController *popoverView =[[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];

    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(400, 260);
    popoverView.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)btnCancelClick:(id)sender {	
    [self.delegate doneOtherPayerClick];
}

- (IBAction)btnSubmitClick:(id)sender {
  //  [self.delegate doneOtherPayerClick];
    [self saveSelfPay];
    [self.delegate doneOtherPayerClick];
}

- (IBAction)btnRelationShipClick:(UIButton *)sender {
    if ([ relationshipArray count] < 1)
    {
        NSString* querySql = @"select InputLookupID, 'Inputs', LookupName from InsuranceInputLookup  where InsID = 7004 and InputID = 7";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.relationshipArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 3;
    PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
    
    popoverView.array = self.relationshipArray;
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

-(void) doneClick
{
    CalendarViewController *p = (CalendarViewController *)self.popover.contentViewController;
    [btnDOB setTitle:[p.dpDate.date.description substringToIndex:10] forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

-(void) didTap
{
    PopupIncidentViewController *p = (PopupIncidentViewController *)self.popover.contentViewController;
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    if (functionSelected == 1)
    {
        ClsTableKey * tableKey =  [p.array objectAtIndex:p.rowSelected];
        self.txtCity.text = tableKey.desc ;
    }
    
    if (functionSelected == 2)
    {
        ClsTableKey * tableKey =  [p.array objectAtIndex:p.rowSelected];
        self.txtState.text = tableKey.desc;
    }
    
    if (functionSelected == 3)
    {
        ClsTableKey * tableKey =  [p.array objectAtIndex:p.rowSelected];
        [self.btnRelationship setTitle:tableKey.desc forState:UIControlStateNormal];
        [self btnPhoneClick:btnPhone];
    }
    
}

-(void) doneSSNClick
{
    SSNNumericViewController *p = (SSNNumericViewController *)self.popover.contentViewController;
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    if(functionSelected == 7)
    {
        [btnPhone setTitle:p.displayStr forState:UIControlStateNormal];
        [txtNextOfKin becomeFirstResponder];
    }
    else if(functionSelected == 8)
    {
        [btnNextKinPhone setTitle:p.displayStr forState:UIControlStateNormal];
        [txtEmployer becomeFirstResponder];
    }
    else if(functionSelected == 9)
    {
        [btnEmployerPhone setTitle:p.displayStr forState:UIControlStateNormal];
        [self btnDOBClick:btnDOB];
    }

}

- (void) saveSelfPay
{
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 7004", ticketID ];
    NSInteger privateCount;
    @synchronized(g_SYNCDATADB)
    {
        privateCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    if (privateCount < 1)
    {
        privateCount++;
        @synchronized(g_SYNCDATADB)
        {
            NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 1, privateCount, @"Other Payer or Self Pay", @"", [self removeNull:txtFirstName.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 2, privateCount, @"Other Payer or Self Pay", @"", [self removeNull:txtLastName.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 3, privateCount, @"Private Insurance", @"", [self removeNull:txtAddress.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 4, privateCount, @"Private Insurance", @"", [self removeNull:txtCity.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 5, privateCount, @"Private Insurance", @"", [self removeNull:txtState.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 6, privateCount, @"Private Insurance", @"", [self removeNull:txtZip.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 7, privateCount, @"Private Insurance", @"", [self removeNull:btnRelationship.titleLabel.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 8, privateCount, @"Private Insurance", @"", [self removeNull:btnPhone.titleLabel.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 9, privateCount, @"Private Insurance", @"", [self removeNull:txtNextOfKin.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
 
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 10, privateCount, @"Private Insurance", @"", [self removeNull:btnNextKinPhone.titleLabel.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 11, privateCount, @"Private Insurance", @"", [self removeNull:txtEmployer.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 12, privateCount, @"Private Insurance", @"", [self removeNull:btnEmployerPhone.titleLabel.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
  
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 7004, 13, privateCount, @"Private Insurance", @"", [self removeNull:btnDOB.titleLabel.text]];
            [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
        }
    }
    else
    {
        @synchronized(g_SYNCDATADB)
        {
            NSString* sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 1 and InputInstance = %d", [self removeNull:txtFirstName.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 2 and InputInstance = %d", [self removeNull:txtLastName.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];

            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = %@' where ticketID = %@ and inputID = 7004 and InputSubID = 3 and InputInstance = %d", [self removeNull:txtAddress.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 4 and InputInstance = %d", [self removeNull:txtCity.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 5 and InputInstance = %d", [self removeNull:txtState.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];

            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 6 and InputInstance = %d", [self removeNull:txtZip.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 7 and InputInstance = %d", [self removeNull:btnRelationship.titleLabel.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 8 and InputInstance = %d", [self removeNull:btnPhone.titleLabel.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 9 and InputInstance = %d", [self removeNull:txtNextOfKin.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 10 and InputInstance = %d", [self removeNull:btnNextKinPhone.titleLabel.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 11 and InputInstance = %d", [self removeNull:txtEmployer.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 12 and InputInstance = %d", [self removeNull:btnEmployerPhone.titleLabel.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            
            sqlStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@' where ticketID = %@ and inputID = 7004 and InputSubID = 13 and InputInstance = %d", [self removeNull:btnDOB.titleLabel.text], ticketID, 1];
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
    }
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
