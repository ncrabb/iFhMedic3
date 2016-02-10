//
//  MedsViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/20/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 
#import "MedsViewController.h"
#import "global.h"
#import "DAO.h"
#import "ClsTableKey.h"
#import "ClsMed.h"
#import "MedInfoCell.h"
#import "DDPopoverBackgroundView.h"  // Mani
#import "QAMessageViewController.h"

@interface MedsViewController ()
@property (nonatomic, copy) NSString* ticketID;
@end

@implementation MedsViewController
@synthesize tvDrugs;
@synthesize tvDrugSelected;
@synthesize drugs;
@synthesize drugSelected;
@synthesize txtDrug;
@synthesize popover;
@synthesize newTicket;
@synthesize delegate;
@synthesize searchBar;
@synthesize drugScrollView;
@synthesize btnNameLabel;

@synthesize customAlphaView;
@synthesize lblSelectMed;
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

    UIImage *toolBarIMG = [UIImage imageNamed:@"navigation_bar_bkg.png"];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }
    customAlphaView = (CustomAlphaView *)[DAO getViewFromXib:@"CustomAlphaView" classname:[CustomAlphaView class]];
    customAlphaView.parent = self;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        customAlphaView.frame = CGRectMake(986, 100, 30, 645);
    }
    else
    {
        customAlphaView.frame = CGRectMake(986, 100, 30, 845);
    }

    [self.view addSubview:customAlphaView];
    
    
    
    tvDrugs.layer.borderColor = [UIColor cyanColor].CGColor;
    tvDrugs.layer.borderWidth = 5.0f;
    drugScrollView.tag = -1;
    
    if ([tvDrugSelected respondsToSelector:@selector(setSeparatorInset:)]) {
        [tvDrugSelected setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [self loadMedData];

  }

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString* patientName;
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    btnNameLabel.title = patientName;
    [btnNameLabel setTintColor:[UIColor whiteColor]];

    
    
    drugRowSelected = -1;
    drugButtonSelected = -1;
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatus:) name:@"UpdateStatus" object:nil];
    [self loadData];
    [self setViewUI];
    [self setControl];
}


- (void) loadData
{
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1433", ticketID ];
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];        
    }
    if (count > 0)
    {
        self.newTicket = NO;
    }
    else
    {
        self.newTicket = YES;
    }
    if (!self.newTicket)
    {

        NSMutableDictionary* ticketInputsData;
        @synchronized(g_SYNCDATADB)
        {
            self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and InputID = 1433", ticketID ];
            ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        NSString* medStr = [ticketInputsData objectForKey:@"1433:0:1"];
        if ([medStr length] > 0 )
        {
            if (self.drugSelected == nil)
            {
                self.drugSelected = [[NSMutableArray alloc] init];
            }
            else
            {
                [self.drugSelected removeAllObjects];
            }
            
            @try {
                NSArray* array = [medStr componentsSeparatedByString:@"|"];
                for (int i = 0; i < [array count] - 1; i++)
                {
                    ClsMed* med = [[ClsMed alloc] init];
                    @try {
                        if ([array objectAtIndex:i] != nil)
                        {
                            
                            NSArray* medRow = [[array objectAtIndex:i] componentsSeparatedByString:@","];
                            if ([medRow objectAtIndex:0] != nil && ([[medRow objectAtIndex:0] rangeOfString:@"(null)"].location == NSNotFound))
                            {
                                med.drugName = [medRow objectAtIndex:0];
                            }
                            if ([medRow count] > 1)
                            {
                                
                                NSString* medDataStr = [medRow objectAtIndex:1];
                                if (medDataStr.length > 0)
                                {
                                    medDataStr = [medDataStr substringFromIndex:1];
                                    NSArray* medData = [medDataStr componentsSeparatedByString:@" "];
                                    
                                    for (int j=0; j<[medData count]; j++)
                                    {
                                        if (j== 0)
                                        {
                                            NSString* amoutUnitStr = [medData objectAtIndex:j];
                                            if (amoutUnitStr.length > 0)
                                            {
                                                NSRange range = [amoutUnitStr rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
                                                if (range.location != NSNotFound)
                                                {
                                                    med.amount = [amoutUnitStr substringToIndex:range.location];
                                                    med.amountUnit = [amoutUnitStr substringFromIndex:range.location];
                                                }
                                            }
                                        }
                                        if (j == 1)
                                        {
                                            med.freq = [medData objectAtIndex:j];
                                        }
                                        if (j == 2)
                                        {
                                            med.freqUnit = [medData objectAtIndex:j];
                                        }
                                        if (j == 3)
                                        {
                                            med.freqUnit = [NSString stringWithFormat:@"%@ %@", med.freqUnit, [medData objectAtIndex:j]];
                                        }
                                        
                                        
                                    }  // end for loop j
                                }  // end if (medDataStr.length > 0)
                               
                            } //if ([medRow count] > 1)
                            
                            
                            [drugSelected addObject:med];
                        }  // end for loop i
                    }
                    @catch (NSException *exception) {
                        
                    }
                    @finally {
                        
                    }
                    
                }
            }
            @catch (NSException *exception) {

            }
            @finally {

            }
 
            [tvDrugSelected reloadData];
        }
    }
}

- (void) loadMedData
{
    NSString* sql = @"Select MedicationID, 'Medications', MedicationName from Medications";
    @synchronized(g_LOOKUPDB)
    {
        self.drugs = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    //[tvDrugs reloadData];
    
    ClsTableKey* none = [[ClsTableKey alloc] init];
    none.tableID = [self.drugs count] + 2;
    none.desc = @"NONE";
    none.tableName = @"Medications";
    [self.drugs insertObject:none atIndex:0];
    
    ClsTableKey* other = [[ClsTableKey alloc] init];
    other.tableID = [self.drugs count] + 3;
    other.desc = @"Other";
    other.tableName = @"Medications";
    [self.drugs insertObject:other atIndex:1];
    
    ClsTableKey* unknown = [[ClsTableKey alloc] init];
    unknown.tableID = [self.drugs count] + 1;
    unknown.desc = @"Unknown";
    unknown.tableName = @"Medications";
    [self.drugs insertObject:unknown atIndex:2];
    [self loadDrugsInScrollView];
}

- (void)loadDrugsInScrollView
{
    for (UIView * view in drugScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    int nLeftOffset = 5;
	int nTopOffset = 10;
	int nIconSpacingX = 5 ;
	int nIconSpacingY = 10 ;
	
	int nIconWidth = 160;
	int nIconHeight = 70;
    int nPage = 4;
    CGRect rcPosition = CGRectMake(0, 0, 0, 0);
    
	for(int i=0; i<[drugs count] ; i++)
	{
		/////////////////////////////////////////////////////
		// Calculate this icons position
		int nColumn = i % nPage;
		int nRow = i / nPage;
		//nPage = i / 4;
		
		rcPosition = CGRectMake(nLeftOffset + nColumn * nIconWidth, nTopOffset + nRow * nIconHeight, nIconWidth, nIconHeight);
		rcPosition.origin.x += (nColumn * nIconSpacingX);
		rcPosition.origin.y += (nRow * nIconSpacingY);
        
        
        UIButton *btnDrug = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDrug setBackgroundImage:[UIImage imageNamed:@"btn_background.png"] forState:UIControlStateNormal];

 /*       if(i== [drugs count])
        {
            [btnDrug setTitle:@"None" forState:UIControlStateNormal];

        }
        else if(i == [drugs count]+1)
        {
            [btnDrug setTitle:@"Other" forState:UIControlStateNormal];

        }
        else */
        {
            ClsTableKey* med = [drugs objectAtIndex:i];
            [btnDrug setTitle:med.desc forState:UIControlStateNormal];
        }
        btnDrug.titleLabel. numberOfLines = 0; // Dynamic number of lines
        btnDrug.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnDrug.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnDrug setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [btnDrug addTarget:self action:@selector(drugButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [drugScrollView addSubview:btnDrug];
        
        btnDrug.frame = rcPosition;
        btnDrug.tag = i;
    }
    
    drugScrollView.contentSize = CGSizeMake(670,rcPosition.origin.y+80);

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnMainMenuClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [delegate dismissViewControl];
}


- (IBAction)btnAddClick:(UIButton*)sender {
    if (drugButtonSelected >= 0)
    {
        DrugViewController *popoverView =[[DrugViewController alloc] initWithNibName:@"DrugViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];

        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(730, 550);
        popoverView.delegate = self;
        ClsTableKey* med = [drugs objectAtIndex:drugButtonSelected];

        
        popoverView.lblTitle.text = med.desc;
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Drug" message:@"Please enter or select a drug from the list below." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)btnDeleteClick:(id)sender {
    if (drugRowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Drug Selected" message:@"Please select a drug from the list to delete." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [drugSelected removeObjectAtIndex:drugRowSelected];
    [tvDrugSelected reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            exit(0);
        } else
        {
            
        }
    }
    else if(alertView.tag == 999)
    {
        if(buttonIndex == 0)
        {
            NSString *text = [alertView textFieldAtIndex:0].text;
            DrugViewController *popoverView =[[DrugViewController alloc] initWithNibName:@"DrugViewController" bundle:nil];
            popoverView.view.backgroundColor = [UIColor whiteColor];
            
            self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(730, 550);
            popoverView.delegate = self;
            
            
            popoverView.lblTitle.text = text;
            [self.popover presentPopoverFromRect:CGRectMake(200, 100, 750, 500) inView:self.view permittedArrowDirections:0 animated:YES];
        }
    }
}


-(void) continueClick:(BOOL)edit
{
    DrugViewController *p = (DrugViewController *)self.popover.contentViewController;
    
    ClsMed* med = [[ClsMed alloc] init];
    if(drugButtonSelected == [drugs count]+1)
    {
        med.drugName = p.lblTitle.text;
    }
    else
    {
    ClsTableKey* medSelected = [drugs objectAtIndex:drugButtonSelected];
    med.drugName = medSelected.desc;
    }
    if ([p.btnAount.titleLabel.text length] > 0)
    {
        med.amount = p.btnAount.titleLabel.text;
        med.amountUnit = p.amountUnit;        
    }
    if ([p.btnFreq.titleLabel.text length] > 0)
    {
        med.freq = p.btnFreq.titleLabel.text;
        med.freqUnit = p.freqUnit;       
    }


    if (self.drugSelected == nil)
    {
        self.drugSelected = [[NSMutableArray alloc] init];
    }
    if(edit)
    {
        [self.drugSelected replaceObjectAtIndex:drugRowSelected withObject:med];
    }
    else
    {
        [self.drugSelected addObject:med];
    }
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    txtDrug.text = @"";
    [tvDrugSelected reloadData];
}


- (void)viewDidUnload {
    [self setTvDrugSelected:nil];
    [self setTvDrugs:nil];
    [self setTxtDrug:nil];
    [super viewDidUnload];
}


-(void) viewWillDisappear:(BOOL)animated
{
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self saveTab];
    [super viewWillDisappear:animated];
}

- (void) saveTab
{
    NSMutableString* drugInput = [[NSMutableString alloc] init];
    for (int i = 0; i < [drugSelected count]; i++)
    {
        ClsMed* med = [drugSelected objectAtIndex:i];
        
        [drugInput appendFormat:@"%@, %@%@ %@ %@|", med.drugName, [self removeNull:med.amount], [self removeNull:med.amountUnit], [self removeNull:med.freq], [self removeNull:med.freqUnit]];
    }
    @synchronized(g_SYNCDATADB)
    {
            self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1433, 0, 1, @"", @"", drugInput];

            NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1433", drugInput, ticketID];
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
            

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

- (BOOL)medAlreadySaved:(NSString *)title
{
    for(int i=0; i<[self.drugSelected count]; i++)
    {
        ClsMed* med = [drugSelected objectAtIndex:i];
        
        if([med.drugName isEqualToString:title])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark-
#pragma UIControl callback Functions

-(IBAction)drugButtonSelected:(id)sender
{
    UIButton *btn = (id)sender;
    drugButtonSelected = btn.tag;
   // [self selectButton:btn.tag];
    
    if (drugButtonSelected >= 0)
    {
        if([self medAlreadySaved:btn.titleLabel.text])
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Drug" message:@"Medicine already saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        else
        {
            if(btn.tag == [drugs count])
            {
                return;
            }
            else if(btn.tag == [drugs count]+1)
            {
                UIAlertView *inputalert = [[UIAlertView alloc] initWithTitle:@"Medicine" message:@"Enter name of the Medicine" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
                inputalert.delegate =self;
                inputalert.tag = 999;
                inputalert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [inputalert show];
            }
            else
            {
                if (btn.tag < 2)
                {
                    
                    if (btn.tag == 1)
                    {
                        //med.drugName = @"Other";
                        PopupMedViewController *popoverView =[[PopupMedViewController alloc] initWithNibName:@"PopupMedViewController" bundle:nil];
                        popoverView.view.backgroundColor = [UIColor whiteColor];
                        
                        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                        self.popover.popoverContentSize = CGSizeMake(540, 250);
                        popoverView.delegate = self;

                        [self.popover presentPopoverFromRect:CGRectMake(200, 100, 750, 500) inView:self.view permittedArrowDirections:0 animated:YES];
                    }
                    else
                    {
                        ClsMed* med = [[ClsMed alloc] init];
                        med.drugName = @"NONE";
                        if (self.drugSelected == nil)
                        {
                            self.drugSelected = [[NSMutableArray alloc] init];
                        }
                        
                        [self.drugSelected addObject:med];
                        [tvDrugSelected reloadData];
                    }

                }
                else
                {
                    DrugViewController *popoverView =[[DrugViewController alloc] initWithNibName:@"DrugViewController" bundle:nil];
                    popoverView.view.backgroundColor = [UIColor whiteColor];
                
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(730, 550);
                    popoverView.delegate = self;
                    ClsTableKey* med = [drugs objectAtIndex:drugButtonSelected];
                
                
                    popoverView.lblTitle.text = med.desc;
                    [self.popover presentPopoverFromRect:CGRectMake(200, 100, 750, 500) inView:self.view permittedArrowDirections:0 animated:YES];
                }
            }
        }
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Drug" message:@"Please enter or select a drug from the list below." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)editButtonPressed:(UIButton*)sender
{
    if(drugRowSelected>=0)
    {
        ClsMed* med = [self.drugSelected objectAtIndex:drugRowSelected];
         //[self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //DrugViewController *p = (DrugViewController *)self.popover.contentViewController;
        //[p setValueOfSelectedRow:med];
        
        DrugViewController *popoverView =[[DrugViewController alloc] initWithNibName:@"DrugViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(730, 550);
        popoverView.delegate = self;
        //ClsTableKey* med = [drugs objectAtIndex:drugButtonSelected];
        [popoverView setValueOfSelectedRow:med];

        
        [self.popover presentPopoverFromRect:CGRectMake(200, 100, 750, 500) inView:self.view permittedArrowDirections:0 animated:YES];

        
        
    }
}

- (void) doneMedClick
{
    PopupMedViewController* p = (PopupMedViewController*) popover.contentViewController;
    if (p.buttonClicked == 1)
    {
        ClsMed* med = [[ClsMed alloc] init];
        med.drugName = p.txtDrugName.text;
        if (self.drugSelected == nil)
        {
            self.drugSelected = [[NSMutableArray alloc] init];
        }
        
        [self.drugSelected addObject:med];
        [tvDrugSelected reloadData];
        
    }
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tvDrugSelected)
    {
        return 55;
    }
    else
        return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tvDrugs)
    {
        return [drugs count];
    }
    else
    {
        return [drugSelected count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tvDrugs)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        ClsTableKey* med = [drugs objectAtIndex:indexPath.row];
        cell.textLabel.text = med.desc;
        
        return cell;
    }
    else
    {

        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            
        }
        ClsMed* med = [drugSelected objectAtIndex:indexPath.row];
        cell.textLabel.text = med.drugName;
        NSString *subtitle = @"";
        if ([med.amount length] > 0)
            subtitle = [NSString stringWithFormat:@"%@ %@", med.amount, med.amountUnit];
        if ([med.freq length] > 0)
        {
            if([subtitle length] >0)
            {
                subtitle = [subtitle stringByAppendingString:@", "];
            }
            subtitle = [subtitle stringByAppendingFormat:@"%@ %@",med.freq, med.freqUnit];
        }
        cell.detailTextLabel.text = subtitle;
        
        return cell;
        
        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == tvDrugs)
    {
        ClsTableKey* med = [drugs objectAtIndex:indexPath.row];
        txtDrug.text = med.desc;
    }
    else
    { 
        drugRowSelected = indexPath.row;
    }
}

#pragma mark- UI controls adjustments
-(void) setViewUI
{
    
    [self.searchBar setBackgroundImage:[[UIImage alloc] init]];


}

- (void)selectButton:(int)nTag
{
    if(nTag == [drugs count])
    {
        drugButtonSelected = [drugs count];
        return;
    }
    else if(nTag == [drugs count]+1)
    {
        drugButtonSelected = [drugs count]+1;
        return;
    }
    for(int i=0; i<[drugs count]; i++)
    {
        UIButton *btn = (UIButton*)[drugScrollView viewWithTag:i];
        if(btn.tag == nTag)
        {
            // selected button
           // [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            drugButtonSelected = btn.tag;

        }
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


#pragma mark-
#pragma UISearchBar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Text change - %d",isSearching);
    
    //Remove all objects first.
   // [filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self searchScrollView:searchBar.text];
    }
    else {
        isSearching = NO;
        drugScrollView.contentOffset = CGPointMake(0, 0);
    }
    // [self.tblContentList reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchScrollView:searchBar.text];
}

- (void)searchScrollView:(NSString *)searchText
{
    if(isSearching)
    {
        BOOL bFound = NO;
        int i;
        for(i=0;i<[drugs count] ; i++)
        {
            ClsTableKey* med = [drugs objectAtIndex:i];
            
            NSRange range = [med.desc rangeOfString:searchText options: NSCaseInsensitiveSearch| NSAnchoredSearch];
            if ((range.location != NSNotFound) &&(range.location == 0))
            {
                bFound = YES;
                break;
            }
        }
        if(bFound)
        {
            UIButton *btn = (UIButton *)[drugScrollView viewWithTag:i];
            NSLog(@"%@", NSStringFromCGRect(btn.frame));
            drugScrollView.contentOffset = CGPointMake(0, btn.frame.origin.y);
            
        }
    }
}

- (void)searchAlphaOnScroll:(NSString *)alpha
{
    NSLog(@"Text change - %d",isSearching);
    
    //Remove all objects first.
    // [filteredContentList removeAllObjects];
    
    if([alpha length] != 0) {
        isSearching = YES;
        [self searchScrollView:alpha];
    }
    else {
        isSearching = NO;
        drugScrollView.contentOffset = CGPointMake(0, 0);
    }

}

- (IBAction)btnValidateClick:(UIButton*)sender {
    [self saveTab];
    ValidateViewController *popoverView =[[ValidateViewController alloc] initWithNibName:@"ValidateViewController" bundle:nil];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(540, 590);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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

- (void) setControl
{
    
    [lblSelectMed setTextColor:[UIColor blackColor]];
    
    
    NSString* outcomeVal;
    NSString* sqlOutcome = [NSString stringWithFormat:@"select InputValue from TicketInputs where ticketID = %@ and InputID = 1401", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        outcomeVal = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlOutcome];
    }
    
    
    NSString* outcomeTypeSql = [NSString stringWithFormat:@"SELECT outcomeID, Description, outcomeTypeDesc FROM Outcomes o inner join OutcomeTypes d on d.OutcomeTypeID = o.transportType where description = '%@'", outcomeVal];
    
    NSMutableArray* outcomeTypeArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        outcomeTypeArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:outcomeTypeSql WithExtraInfo:NO];
    }
    NSString* sql;
    if (outcomeTypeArray.count > 0)
    {
        ClsTableKey* key = [outcomeTypeArray objectAtIndex:0];
        if ([key.desc isEqualToString:@"Transport"])
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from Inputs where InputRequiredField = 1 and inputpage like 'Meds' union select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = %ld" , outcomeVal, key.key];
        }
        else
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = %ld" , outcomeVal, key.key];
            
        }
        
    }
    else
    {
        sql = @"SELECT distinct i.inputid, i.inputname, i.inputpage FROM inputs i where i.inputrequiredfield = 1 and i.inputpage like 'Meds%'";
    }
    NSMutableArray* requiredArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        requiredArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    for (int i = 0; i < [requiredArray count]; i++)
    {
        ClsTableKey* key = [requiredArray objectAtIndex:i];
        if (key.key == 1433)
        {
            [lblSelectMed setTextColor:[UIColor redColor]];
        }

    }
}

- (IBAction)btnQuickClick:(UIButton*)sender {
    QuickViewController *popoverView =[[QuickViewController alloc] initWithNibName:@"QuickViewController" bundle:nil];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];
    self.popover.popoverContentSize = CGSizeMake(540, 580);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (void) doneQuickButton
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
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

@end
