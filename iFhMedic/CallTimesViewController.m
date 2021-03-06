//
//  CallTimesViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "CallTimesViewController.h"
#import "DAO.h"
#import "global.h"
#import "DDPopoverBackgroundView.h"  // Mani
#import "ClsTableKey.h"
#import "DateTimeViewController.h"
#import "QAMessageViewController.h"
#import "ClsInputs.h"

@interface CallTimesViewController ()
{
    NSInteger lastPageCount;
    NSMutableString* pageInputID;
    int labelCount;
    NSInteger start;
    int pageArray[10];
    NSInteger NumOfGroup;
}

@property (nonatomic, copy) NSString* ticketID;

@end

@implementation CallTimesViewController

@synthesize ticketInputData;
@synthesize popover;
@synthesize newTicket;
@synthesize delegate;
@synthesize btnNameLabel;
@synthesize incidentInput;
@synthesize inputContainer;
@synthesize btnQAMessage;
@synthesize ticketID;

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
    pageInputID = [[NSMutableString alloc] init];
    UIImage *toolBarIMG = [UIImage imageNamed:@"navigation_bar_bkg.png"];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    lastPageCount = 0;
    labelCount = 0;
    start = 0;
    NumOfGroup = 0;
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    [self setViewUI:0];
    NSString* patientName;

    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    btnNameLabel.title = patientName;
    [btnNameLabel setTintColor:[UIColor whiteColor]];

}

-(void) loadData
{
    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@", ticketID ];
        
        self.ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }


    for (NSInteger i =start; i < incidentInput.count && i <(self.pageControl.currentPage + 1)*13; i++)
    {
        ClsInputs* input = [incidentInput objectAtIndex:i];
        
        NSString* inputStr = [NSString stringWithFormat:@"%ld:0:1", input.inputID];
        InputVIewCalltime* inputView = (InputVIewCalltime*)[inputContainer viewWithTag:i+1];
        NSString* value = [ticketInputData objectForKey:inputStr];
        if (value != nil || value.length > 0)
        {
            [inputView setBtnText:value];
        }
    }
    
}

- (void) loadDefault
{

    NSString* sql = @"Select inputID, 'Inputs', InputDefault from Inputs where (InputPage = 'Call Times' or InputPage = 'NFIRS') and (inputDefault != '')";
    NSMutableArray* defaultArray;
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        defaultArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }

    for (NSInteger i =start; i < incidentInput.count && i <(self.pageControl.currentPage + 1)*13; i++)
    {
        for (int j = 0; j < defaultArray.count; j++)
        {
            ClsTableKey* key = [defaultArray objectAtIndex:j];
            InputVIewCalltime* inputView = (InputVIewCalltime*)[inputContainer viewWithTag:i+1];
            if (inputView.btnInput.tag == key.key)
            {
                inputView.txtInput = key.desc;
            }
        }
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)btnMainMenuClick:(id)sender {
        [delegate dismissViewControl];
}



- (IBAction)btnValidateClick:(UIButton *)sender {
    [self saveTab];
    ValidateViewController *popoverView =[[ValidateViewController alloc] initWithNibName:@"ValidateViewController" bundle:nil];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(540, 590);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            exit(0);
        } 
    }
}



-(void) viewWillDisappear:(BOOL)animated
{

    [self saveTab];
    [super viewWillDisappear:animated];
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

- (void) saveTab
{
    
    NSString* sqlStr;
    NSInteger count;
    
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* status = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ( [status isEqualToString:@"3"] || [status isEqualToString:@"5"])
    {
        NSString* userID = [g_SETTINGS objectForKey:@"UserID"];
        sqlStr = [NSString stringWithFormat:@"Select max(ChangeID) from TicketChanges where TicketID = %@", ticketID ];
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getInstance:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        NSDate* sourceDate = [NSDate date];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
        NSString* timeAdded = [dateFormat stringFromDate:sourceDate];
        for (NSInteger i =  start ; i < self.incidentInput.count && i < (lastPageCount + 1)* 13; i++)
        {
            InputVIewCalltime* inputView = (InputVIewCalltime*)[inputContainer viewWithTag:i+1];
            NSString* inputValue;
            
            if (inputView.btnInput.tag == 1060 || inputView.btnInput.tag == 1061 || inputView.btnInput.tag == 9050 || inputView.btnInput.tag == 1067 || inputView.btnInput.tag == 1066)
            {
                 inputValue = [self removeNull:inputView.btnDisplay.titleLabel.text];
            }
            else
            {
                inputValue = [self removeNull:inputView.txtInput.text];
            }
            NSString* inputKey = [NSString stringWithFormat:@"%d:0:1", inputView.btnInput.tag];
            if ( (inputValue != nil) && !([inputValue isEqualToString:[ticketInputData objectForKey:inputKey]]) )
            {
                count++;
                sqlStr = [NSString stringWithFormat:@"Insert into TicketChanges(LocalTicketID, TicketID, ChangeID, ChangeMade, ChangeTime, ModifiedBy, ChangeInputID, OriginalValue) Values(0, %@, %d, 'Input changed from %@ to %@', '%@', %@, %d, '%@')", ticketID, count , [ticketInputData objectForKey:inputKey] ,inputValue, timeAdded, userID, inputView.btnInput.tag, [ticketInputData objectForKey:inputKey]];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                }
            }
            
        }
        
    }
    

    for (NSInteger i =  start ; i < self.incidentInput.count && i < (lastPageCount + 1)* 13; i++)
    {
        InputVIewCalltime* inputView = (InputVIewCalltime*)[inputContainer viewWithTag:i+1];
        NSString* inputValue;
        if (inputView.btnInput.tag == 1060 || inputView.btnInput.tag == 1061 || inputView.btnInput.tag == 9050 || inputView.btnInput.tag == 1067 || inputView.btnInput.tag == 1066)
        {
            inputValue = [self removeNull:inputView.btnDisplay.titleLabel.text];
        }
        else
        {
            inputValue = [self removeNull:inputView.txtInput.text];
        }
        
        @synchronized(g_SYNCDATADB)
        {
            self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %ld, %d, %d, '%@', '%@', '%@')", ticketID, inputView.btnInput.tag, 0, 1, @"", @"CallTimes", inputValue];
            
            NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %ld", inputValue, ticketID, inputView.btnInput.tag];
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
        }
    }


}


- (void)viewDidUnload {

    [super viewDidUnload];
}

- (void) doneInputView:(NSInteger) tag
{
    if (tag < self.incidentInput.count && tag < (self.pageControl.currentPage + 1)*12)
    {
        InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:tag + 1];
      //  [inputView btnInputClick:inputView.btnInput];
    }
}


- (void) doneSelectValidate
{
    ValidateViewController *p = (ValidateViewController *)self.popover.contentViewController;
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    if (p.ticketComplete)
    {
        [delegate dismissViewControl];
    }
    
    else if (p.tagID >= 0)
    {
        [self.delegate dismissViewControlAndStartNew:p.tagID];
    }
}

#pragma mark- UI controls adjustments
-(void) setViewUI:(NSInteger)page
{
    for (UIView* subview in self.inputContainer.subviews)
    {
        [subview removeFromSuperview];
    }
    if (page == 0)
    {
        labelCount = 0;
    }
    NSString* sqlGroup = @"SELECT count (distinct InputGroup) FROM inputs where inputpage = 'Call Times'";
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        NumOfGroup = [DAO getCount:[[g_SETTINGS objectForKey:@"lookupDB"]pointerValue] Sql:sqlGroup];
    }
    if (self.pageControl.currentPage >= lastPageCount)
    {
        start = (int) (page * 13) - labelCount;
    }
    else
    {
        if (page == 0)
        {
            start = 0;
        }
        else
        {
            start = (int) (page * 13) - pageArray[self.pageControl.currentPage - 1];
            labelCount = pageArray[self.pageControl.currentPage - 1];            
        }
    }

    if (self.incidentInput == nil)
    {
        NSString* querySql = @"select InputID, InputName, InputDataType, InputGroup, InputRequiredField, inputIndex  from Inputs where InputPage = 'Call Times' order by inputGroup, InputIndex";
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.incidentInput = [DAO selectInputs:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql];
        }
        int numOfPage = ((int) (self.incidentInput.count + NumOfGroup)/13) + 1;
        self.pageControl.numberOfPages = numOfPage;
    }
    
    NSInteger ypos = 5;

    NSString* lastGroup;
    for (int i = start; i < incidentInput.count; i++)
    {
        ClsInputs* input = [incidentInput objectAtIndex:i];
        if (lastGroup == nil || ![lastGroup isEqualToString:input.inputGroup])
        {
            UILabel* label = [[UILabel alloc] init];
            label.frame = CGRectMake(0, ypos, 1024, 44);
            label.text = [NSString stringWithFormat:@"   %@", input.inputGroup];
            label.textAlignment = NSTextAlignmentLeft;
            [label setFont:[UIFont boldSystemFontOfSize:18]];
            [self.inputContainer addSubview:label];
            ypos += 45;
            lastGroup = input.inputGroup;
            labelCount++;
            pageArray[self.pageControl.currentPage] = labelCount;
        }

        InputVIewCalltime* inputView = [[InputVIewCalltime alloc] initWithInput:input.inputID];
        inputView.backgroundColor = [UIColor whiteColor];
        inputView.frame = CGRectMake(0, ypos, 1024, 44);
        inputView.inputType = input.inputDataType;
        inputView.inputID = input.inputID;
        inputView.delegate = self;
        inputView.tag = i + 1;
        inputView.btnInput.tag = input.inputID;
        [self.inputContainer addSubview:inputView];
        [inputView setLabelText:input.inputName dataType:input.inputDataType inputRequired:input.inputRequiredField];

        ypos += 45;

        if (ypos > 555)
        {
            break;
        }
    }
    
    [pageInputID setString:@""];
    
    for (int i = start; i < incidentInput.count; i++)
    {
        ClsInputs* input = [incidentInput objectAtIndex:i];
        [pageInputID appendString:[NSString stringWithFormat:@"%ld", input.inputID]];
        if (i < incidentInput.count - 1)
        {
            [pageInputID appendString:@","];
        }
        
    }
    NSString* defaultStr = [NSString stringWithFormat:@"Select count(*) from ticketInputs where ticketID = %@ and inputID in (%@)", ticketID, pageInputID];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count =  [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:defaultStr];
    }
    
    if (count > 0)
    {
        [self loadData];
    }
    else
    {
        [self loadDefault];
    }
    
}


- (void) removeToolBarItems
{
    
    NSArray *items = [self.toolBar items];
    for (UIBarButtonItem *barButton in items) {
        //do something with button
    }
    
    NSMutableArray *toolbarButtons = [[self.toolBar items] mutableCopy];
    [toolbarButtons removeObjectAtIndex:4];
    [toolbarButtons removeObjectAtIndex:5];
    [toolbarButtons removeObjectAtIndex:6];
    [toolbarButtons removeObjectAtIndex:7];
    [self.toolBar setItems:toolbarButtons animated:YES];
    
}



- (IBAction)btnQAMessageClick:(UIButton *)sender {
    
    NSString* sql = [NSString stringWithFormat:@"Select ticketAdminNotes from Tickets where TicketID = %@", ticketID ];
    NSString* notes;
    @synchronized(g_SYNCDATADB)
    {
        notes = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    QAMessageViewController* popoverView = [[QAMessageViewController alloc] initWithNibName:@"QAMessageViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    popoverView.adminNotes = notes;
    popoverView.ticketID = [ticketID intValue];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    
    if (notes.length > 1)
    {
            self.popover.popoverContentSize = CGSizeMake(502, 455);
    }
    else
    {
        self.popover.popoverContentSize = CGSizeMake(502, 355);
    }
    CGRect rect = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + 16, sender.frame.size.width, sender.frame.size.height);
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (IBAction)btnPageControlClick:(id)sender {
    
    [self saveTab];
    [self setViewUI:self.pageControl.currentPage];
    lastPageCount = self.pageControl.currentPage;
}

- (void) doneInputViewCalltime:(NSInteger) tag
{
    if (tag < self.incidentInput.count && tag < (self.pageControl.currentPage + 1)*12)
    {
        InputVIewCalltime* inputView = (InputVIewCalltime*)[inputContainer viewWithTag:tag + 1];
       // [inputView.txtInput becomeFirstResponder];
    }
}

- (IBAction)btnRightClick:(id)sender {
    if (lastPageCount < self.pageControl.numberOfPages - 1)
    {
        [self saveTab];
        self.pageControl.currentPage = lastPageCount + 1;
        [self setViewUI:self.pageControl.currentPage];
        lastPageCount = self.pageControl.currentPage;
    }
}

- (IBAction)btnLeftClick:(id)sender {
    if (lastPageCount > 0)
    {
        [self saveTab];
        self.pageControl.currentPage = lastPageCount - 1;
        [self setViewUI:self.pageControl.currentPage];
        lastPageCount = self.pageControl.currentPage;
    }
}
@end
