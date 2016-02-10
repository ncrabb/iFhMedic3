//
//  TreatmentsViewController.m
//  iFhMedic
//
//  Created by admin on 10/31/15.
//  Copyright © 2015 com.emergidata. All rights reserved.
//

#import "TreatmentsViewController.h"
#import "TreatmentInfoCell.h"
#import "global.h"
#import "DAO.h"
#import "ClsTreatments.h"
#import "ClsTicketInputs.h"
#import "ClsTreatmentInputs.h"
#import "DDPopoverBackgroundView.h"
#import "QAMessageViewController.h"

@interface TreatmentsViewController ()
{
    NSInteger treatmentSelected;
    int editRowSelected;
}
@property (strong, nonatomic) ClsTreatments* loadTreatment;
@property (nonatomic, copy) NSString* ticketID;
@end


@implementation TreatmentsViewController
@synthesize treatmentArray;
@synthesize toolBar;
@synthesize treatmentScrollView;
@synthesize tblTreatment;
@synthesize treatmentInputs;
@synthesize loadTreatment;
@synthesize popover;
@synthesize delegate;
@synthesize btnNameLabel;
@synthesize btnQAMessage;
@synthesize ticketID;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *toolBarIMG = [UIImage imageNamed:@"navigation_bar_bkg.png"];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }
    [self.navigationController setNavigationBarHidden:TRUE];
    self.treatmentInputs = [[NSMutableArray alloc] init];
    NSString* sql = @"Select * from Treatments where Active = 1 order by SortIndex";
    @synchronized(g_LOOKUPDB)
    {
        self.treatmentArray = [DAO executeSelectTreatments:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    
    [self loadScrollView];


}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    editRowSelected = -1;
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* patientName;
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    btnNameLabel.title = patientName;
    [btnNameLabel setTintColor:[UIColor whiteColor]];
    
    
    [self loadData];

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

- (IBAction)btnDeleteClick:(id)sender {
    if (editRowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FHMedic For iPad" message:@"Please select a treatment entry below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        NSString* Ticketid =  [g_SETTINGS objectForKey:@"currentTicketID"];
        if (treatmentArray.count > editRowSelected)
        {
            ClsTreatments* treatmentDeleted = [treatmentArray objectAtIndex:editRowSelected];
            NSString* sql = [NSString stringWithFormat:@"Select inputInstance from ticketInputs where ticketID = %@ and InputID = %d and inputValue = '%@' limit 1", Ticketid, treatmentDeleted.treatmentID, treatmentDeleted.treatmentTime];
            NSString* instance;
            @synchronized(g_SYNCDATADB)
            {
                instance = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
            }
            NSString* deletedSql = [NSString stringWithFormat:@"Update ticketInputs set deleted = 1, isUploaded = 0 where ticketID = %@ and InputID = %d and inputInstance = %@", Ticketid, treatmentDeleted.treatmentID, instance];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeDelete:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:deletedSql];
            }
            treatmentDeleted = nil;
            [treatmentArray removeObjectAtIndex:editRowSelected];
            [self sortArray];
            [tblTreatment reloadData];
        }
        editRowSelected = -1;
    }

}

- (IBAction)btnCopyClick:(id)sender {
    if (editRowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FHMedic For iPad" message:@"Please select a treatment entry below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        ClsTreatments* treatment = [treatmentInputs objectAtIndex:editRowSelected];
        ClsTreatments* newTreatment = [[ClsTreatments alloc] init];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"MM/dd/YYYY HH:mm:ss"];
        NSDate *now = [[NSDate alloc] init];
        NSString *dateString = [format stringFromDate:now];
        
        newTreatment.treatmentTime = dateString;
        newTreatment.treatmentID = treatment.treatmentID;
        newTreatment.treatmentDesc = [treatment.treatmentDesc copy];
        newTreatment.treatmentFilter = treatment.treatmentFilter;
        newTreatment.Active = treatment.Active;
        newTreatment.SortIndex = treatment.SortIndex;
        
        newTreatment.drugName = [treatment.drugName copy];
        newTreatment.unit = [treatment.unit copy];
        newTreatment.dose = [treatment.dose copy];
        newTreatment.route = [treatment.route copy];
        newTreatment.performedBy = [treatment.performedBy copy];;
        newTreatment.notes = [treatment.notes copy];
        newTreatment.attempts = [treatment.attempts copy];
        newTreatment.successful = [treatment.successful copy];
        newTreatment.complications = [treatment.complications copy];
        newTreatment.response = [treatment.response copy];
        newTreatment.arrival = [treatment.arrival copy];
        
        NSMutableArray* newArray = [[NSMutableArray alloc ] initWithArray:treatment.arrayTreatmentInputValues copyItems:YES];
        ClsTreatmentInputs* newTime = [newArray objectAtIndex:0];
        newTime.inputValue = dateString;
        newTreatment.arrayTreatmentInputValues = newArray;
        [treatmentArray addObject:newTreatment];
        
        NSString* TicketID =  [g_SETTINGS objectForKey:@"currentTicketID"];
        
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = %ld and InputSubID = 1", TicketID, treatment.treatmentID ];
        NSInteger count;
        @synchronized(g_SYNCDATADB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        count++;
        for (int i = 0; i< [newTreatment.arrayTreatmentInputValues count]; i++)
        {
            
            NSString* svname = @"";
            NSString* svinpname = @"";
            NSString* svvalue = @"";
            NSInteger treatid = 0;
            
            
            ClsTreatmentInputs* input = (ClsTreatmentInputs*)[newTreatment.arrayTreatmentInputValues objectAtIndex:i];
            treatid = input.inputID;
            svname = input.inputName;
            svinpname = input.inputName;
            
            svvalue = input.inputValue;
            
            
            
            NSString* sqlStr = @"";
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %ld, %ld, %ld, '%@', '%@', '%@')", TicketID, treatment.treatmentID, treatid, count, treatment.treatmentDesc, svinpname, [self removeNull:svvalue]];
            @synchronized(g_SYNCDATADB)
            {
                [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            
        }
        
        
        newTreatment = nil;
        [self loadData];
        editRowSelected = -1;
    }
    
    
    
}

- (IBAction)btnEditClick:(id)sender {
    if (editRowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FHMedic For iPad" message:@"Please select a treatment entry below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        [sender resignFirstResponder];
        ClsTreatments* treatment = [treatmentInputs objectAtIndex:editRowSelected];

        PopoverTreatmentInfoViewController *popoverView =[[PopoverTreatmentInfoViewController alloc] initWithNibName:@"PopoverTreatmentInfoViewController" bundle:nil];
        popoverView.bEdit = YES;
        popoverView.treatment = treatment;
        popoverView.delegate = self;
        
        popoverView.view.backgroundColor = [UIColor whiteColor];
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani

        self.popover.popoverContentSize = CGSizeMake(670, 600);
        [self.popover presentPopoverFromRect:CGRectMake(200, 150, 670, 600) inView:self.view permittedArrowDirections:0 animated:YES];
    }
    editRowSelected = -1;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [treatmentInputs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //comment
    static NSString *CellIdentifier = @"TreatmentInfoCell";
    TreatmentInfoCell *cell = (TreatmentInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TreatmentInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    ClsTreatments* treatment = [treatmentInputs objectAtIndex:indexPath.row];
    cell.lblTreatmentTime.text = treatment.treatmentDesc;
    
    NSMutableString* Str = [[NSMutableString alloc] init];
    for(int i=0;i<[treatment.arrayTreatmentInputValues count];i++)
    {
        ClsTreatmentInputs *input = [treatment.arrayTreatmentInputValues objectAtIndex:i];
        NSString *value = [self removeNull:input.inputValue];
        [Str appendString:value];
        [Str appendString:@" "];
    }
    cell.lblTreatmentName.text = Str;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    editRowSelected = indexPath.row;
    //TreatmentInfoCell *selectedCell = (TreatmentInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
}



- (void) sortArray
{
    for (int i = 0; i < [treatmentInputs count]; i++)
    {
        ClsTreatments* ass1 = [treatmentInputs objectAtIndex:i];
        NSDateFormatter* format1 = [[NSDateFormatter alloc] init];
        [format1 setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        ClsTreatmentInputs* input1 = [ass1.arrayTreatmentInputValues objectAtIndexedSubscript:0];
        NSString* temp1 = input1.inputValue;
        NSDate* date1 = [format1 dateFromString:temp1];
        
        for (int j = i + 1; j < [treatmentInputs count]; j++)
        {
            ClsTreatments* ass2 = [treatmentInputs objectAtIndex:j];
            ClsTreatmentInputs* input2 = [ass2.arrayTreatmentInputValues objectAtIndexedSubscript:0];
            NSString* temp2 = input2.inputValue;
            
            NSDate* date2 = [format1 dateFromString:temp2];
            
            
            if ([date1 compare:date2] == NSOrderedDescending)
            {
                
                [treatmentInputs insertObject:ass2 atIndex:i];
                [treatmentInputs removeObjectAtIndex:j+1];
            }
            
        }
    }
    
}

-(void) setViewUI
{

    
}


- (void)loadScrollView
{
    for (UIView * view in treatmentScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    int nLeftOffset = 10;
    int nTopOffset = 10;
    int nIconSpacingX = 20 ;
    int nIconSpacingY = 10 ;
    
    int nIconWidth = 142;
    int nIconHeight = 70;
    int nPage = 4;
    CGRect rcPosition = CGRectMake(0, 0, 0, 0);
    
    
    
    for(int i=0; i<[treatmentArray count] ; i++)
    {
        int nColumn = i % nPage;
        int nRow = i / nPage;
        rcPosition = CGRectMake(nLeftOffset + nColumn * nIconWidth, nTopOffset + nRow * nIconHeight, nIconWidth, nIconHeight);
        rcPosition.origin.x += (nColumn * nIconSpacingX);
        rcPosition.origin.y += (nRow * nIconSpacingY);
        
        ClsTreatments* treatment = [treatmentArray objectAtIndex:i];
        UIButton *btnTreatmentType = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnTreatmentType setBackgroundImage:[UIImage imageNamed:@"btn_background.png"] forState:UIControlStateNormal];
        [btnTreatmentType setTitle:treatment.treatmentDesc forState:UIControlStateNormal];
        btnTreatmentType.titleLabel. numberOfLines = 0; // Dynamic number of lines
        btnTreatmentType.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnTreatmentType.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnTreatmentType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btnTreatmentType addTarget:self action:@selector(treatmentTypeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [treatmentScrollView addSubview:btnTreatmentType];
        
        btnTreatmentType.frame = rcPosition;
        btnTreatmentType.tag = i;


    }
    
    treatmentScrollView.contentSize = CGSizeMake(670,rcPosition.origin.y+100);
    treatmentScrollView.pagingEnabled = NO;
}

-(void)treatmentTypeButtonSelected:(UIButton *)sender
{

    treatmentSelected = sender.tag;
    ClsTreatments* seltreatment = [treatmentArray objectAtIndex:treatmentSelected];

    
    PopoverTreatmentInfoViewController *popoverView =[[PopoverTreatmentInfoViewController alloc] initWithNibName:@"PopoverTreatmentInfoViewController" bundle:nil];
    popoverView.delegate = self;
    popoverView.treatment = seltreatment;
    popoverView.delegate = self;
    popoverView.view.backgroundColor = [UIColor whiteColor];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(670, 600);
    [self.popover presentPopoverFromRect:CGRectMake(200, 150, 670, 600) inView:self.view permittedArrowDirections:0 animated:YES];
}



- (void) loadData
{
    [treatmentInputs removeAllObjects];
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sql = [NSString stringWithFormat:@"Select * from TicketInputs where TicketID = %@ and InputID > 2000 and InputID < 2099 and (deleted = 0 or deleted is null) order by InputID, inputInstance, inputSubID", ticketID ];
    NSMutableArray* ticketInputsData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputsData = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSInteger inputID = 0;
    NSInteger prevInputID = 0;
    NSInteger prevInputInstance = 0;
    
    for (int i = 0; i< [ticketInputsData count]; i++)
    {
        ClsTicketInputs* ticketInput = (ClsTicketInputs*) [ticketInputsData objectAtIndex:i];
        inputID = ticketInput.inputId;
        if ((inputID != prevInputID) || ( ticketInput.inputInstance != prevInputInstance) )
        {
            if (prevInputID != 0)
            {
                [treatmentInputs addObject:loadTreatment];
            }
            self.loadTreatment = [[ClsTreatments alloc] init];
            loadTreatment.treatmentID = ticketInput.inputId;
            loadTreatment.treatmentDesc = ticketInput.inputPage;
            loadTreatment.existing = true;
            loadTreatment.instance = ticketInput.inputInstance;
            if (ticketInput.inputSubId == 1)
            {
                loadTreatment.treatmentTime = ticketInput.inputValue;
            }
            
            prevInputID = inputID;
            prevInputInstance = ticketInput.inputInstance;
            self.loadTreatment.arrayTreatmentInputValues = [[NSMutableArray alloc] init];
            ClsTreatmentInputs *input = [[ClsTreatmentInputs alloc ] init];
            input.inputID = ticketInput.inputSubId;
            input.inputName = ticketInput.inputName;
            input.inputValue = ticketInput.inputValue;
            [self.loadTreatment.arrayTreatmentInputValues addObject:input];
        }
        else
        {
            ClsTreatmentInputs *input = [[ClsTreatmentInputs alloc ] init];
            input.inputID = ticketInput.inputSubId;
            input.inputName = ticketInput.inputName;
            input.inputValue = [self removeNull:ticketInput.inputValue];
            [self.loadTreatment.arrayTreatmentInputValues addObject:input];
        }
        
        
    }
    
    if ([ticketInputsData count] > 1)
    {
        [treatmentInputs addObject:loadTreatment];
    }
    [self sortArray];
    [tblTreatment reloadData];
}

- (NSString*) removeNull:(NSString*)str
{
    if ([str length] > 0 && ([str rangeOfString:@"(null)"].location == NSNotFound))
    {
        return [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }
    else
    {
        return @" ";
    }
}

- (void) didClickOK
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [self loadData];
}


- (IBAction)btnMainMenuClick:(id)sender {
    [delegate dismissViewControl];
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

- (IBAction)btnValidateClick:(UIButton*)sender {
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

@end
