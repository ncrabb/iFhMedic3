//
//  ProtocolsViewController.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 12/03/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "ProtocolsViewController.h"
#import "DAO.h"
#import "global.h"
#import "ClsTableKey.h"
#import "DDPopoverBackgroundView.h"
#import "QAMessageViewController.h"
#import "Base64.h"

@interface ProtocolsViewController ()
{
    NSInteger buttonSelected;
}
@end

@implementation ProtocolsViewController

@synthesize delegate;
@synthesize searchBar;
@synthesize protocolScrollView;
@synthesize btnNameLabel;
@synthesize arrProtocols;
@synthesize popover;
@synthesize arrProtocolGroups;
@synthesize groupScrollView;
@synthesize fileURL;
@synthesize btnQAMessage;
@synthesize groupScrollView2;

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
    // Do any additional setup after loading the view.
    self.groupScrollView.hidden = true;
    self.groupScrollView2.hidden = true;
    self.protocolScrollView.hidden = false;
    [self setViewUI];
    
    [self.navigationController setNavigationBarHidden:TRUE];
    
    [self loadProtocolData];
    ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    
    searchBar.delegate = self;
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString* patientName;
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    btnNameLabel.title = patientName;
    [btnNameLabel setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) didTap
{
}

-(void)didClickOK
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

- (void) loadProtocolData
{
    NSInteger count = 0;
    NSString* sqlCount = @"Select count(*) from xInputTables where IT_TableName = 'ProtocolGroups'";
    @synchronized(g_LOOKUPDB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlCount];
    }
    if (count > 0)
    {
        NSString* sqlGroup = @"Select ProtocolGroupID, 'Input', ProtocolGroupDesc from ProtocolGroups";
        @synchronized(g_LOOKUPDB)
        {
            self.arrProtocolGroups = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlGroup WithExtraInfo:NO];
        }
        if (self.arrProtocolGroups.count > 0)
        {
            ClsTableKey* key = [[ClsTableKey alloc] init];
            key.tableID = 999999;
            key.tableName = @"ALL";
            key.key = 999999;
            key.desc = @"ALL";
            
            [self.arrProtocolGroups addObject:key];
            self.protocolScrollView.hidden = true;
            
            if (self.arrProtocolGroups.count > 8)
            {
                self.groupScrollView2.hidden = false;
                [self loadGroupView2];
            }
            else
            {
                self.groupScrollView.hidden = false;
                [self loadGroupView];
            }
        }
        else
        {
            NSString* sql = @"Select ProtocolID, ProtocolButtonText, ProtocolFileName from ProtocolFiles order by SortIndex, ProtocolFileName";

            @synchronized(g_LOOKUPDB)
            {
                self.arrProtocols = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
            }
            
            [self loadProtocolInScrollView];
        }
    }
    else
    {
        NSString* sql = @"Select ProtocolID, ProtocolButtonText, ProtocolFileName from ProtocolFiles order by SortIndex, ProtocolFileName";

        @synchronized(g_LOOKUPDB)
        {
            self.arrProtocols = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
        }
        
        [self loadProtocolInScrollView];
    }
    
}

- (void)loadGroupView2
{
    for (UIView * view in self.view.subviews)
    {
        if ((view.tag > 10000 && view.tag < 10025) || view.tag == 999999)
        {
            [view removeFromSuperview];
        }
    }
    
    int rowOffset = 0;
    int xpos = 25;
    int buttonSize = 118;
    for(int i=0; i<[arrProtocolGroups count] ; i++)
    {
        
        ClsTableKey* key = [arrProtocolGroups objectAtIndex:i];
        CGRect rect = CGRectMake(xpos , searchBar.frame.origin.y + 50 + rowOffset, buttonSize, 60);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0)
        {
            [button setBackgroundColor:[UIColor grayColor]];
        }
        else
        {
            button.backgroundColor = [UIColor blackColor];
        }
        button.frame = rect;
        button.tag = key.key + 10000;
        button.titleLabel. numberOfLines = 0; // Dynamic number of lines
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:key.desc forState:UIControlStateNormal];
        [button addTarget:self action:@selector(groupButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        xpos += 143;
        if (xpos > 900)
        {
            rowOffset += 75;
            xpos = 25;
        }
    }
    
    buttonSelected = 10001;
    NSString* sql = [NSString stringWithFormat:@"Select ProtocolID, ProtocolButtonText, ProtocolFileName from ProtocolFiles where ProtocolGroup = %ld order by SortIndex", buttonSelected - 10000];
    @synchronized(g_LOOKUPDB)
    {
        self.arrProtocols = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    [self loadProtocolInGroupView2];
}


- (void)loadGroupView
{
    for (UIView * view in self.view.subviews)
    {
        if ((view.tag > 10000 && view.tag < 10025) || view.tag == 999999)
        {
            [view removeFromSuperview];
        }
    }
    int nLeftOffset = 25;
    int rowOffset = 0;
    int xpos = 0;
    int buttonSize = 118;
    for(int i=0; i<[arrProtocolGroups count] ; i++)
    {
        
        ClsTableKey* key = [arrProtocolGroups objectAtIndex:i];
        CGRect rect = CGRectMake(nLeftOffset + xpos * buttonSize , searchBar.frame.origin.y + 50 + rowOffset, buttonSize, 60);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0)
        {
            [button setBackgroundColor:[UIColor grayColor]];
        }
        else
        {
            button.backgroundColor = [UIColor blackColor];
        }
        button.frame = rect;
        button.tag = key.key + 10000;
        button.titleLabel. numberOfLines = 0; // Dynamic number of lines
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:key.desc forState:UIControlStateNormal];
        [button addTarget:self action:@selector(groupButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        nLeftOffset += 5;
        xpos++;
        if (nLeftOffset > 120)
        {
            rowOffset += 20;
            nLeftOffset = 0;
            xpos = 0;
        }
    }
    
    buttonSelected = 10001;
    NSString* sql = [NSString stringWithFormat:@"Select ProtocolID, ProtocolButtonText, ProtocolFileName from ProtocolFiles where ProtocolGroup = %ld order by SortIndex", buttonSelected - 10000];
    @synchronized(g_LOOKUPDB)
    {
        self.arrProtocols = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    [self loadProtocolInGroupView];
}

-(IBAction)groupButtonSelected:(UIButton *)sender
{
    UIButton* button = (UIButton*) [self.view viewWithTag:buttonSelected];
    [button setBackgroundColor:[UIColor blackColor]];
    buttonSelected = sender.tag;
    [sender setBackgroundColor:[UIColor grayColor]];
    NSString* sql;
    if (buttonSelected == 1009999)
    {
        sql = [NSString stringWithFormat:@"Select ProtocolID, ProtocolButtonText, ProtocolFileName from ProtocolFiles order by SortIndex, ProtocolFileName"];
    }
    else
    {
        sql = [NSString stringWithFormat:@"Select ProtocolID, ProtocolButtonText, ProtocolFileName from ProtocolFiles where ProtocolGroup = %ld", buttonSelected - 10000];
    }
    @synchronized(g_LOOKUPDB)
    {
        self.arrProtocols = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    if (self.arrProtocolGroups.count > 8)
    {
        [self loadProtocolInGroupView2];
    }
    else
    {
        [self loadProtocolInGroupView];
    }
}

- (void)loadProtocolInGroupView2
{
    for (UIView * view in self.groupScrollView2.subviews)
    {
        [view removeFromSuperview];
    }
    int nLeftOffset = 8;
    int nTopOffset = 8;
    int nIconSpacingX = 8 ;
    int nIconSpacingY = 8 ;
    
    int nIconWidth = 156;
    int nIconHeight = 70;
    int nPage = 6;
    CGRect rcPosition = CGRectMake(0, 0, 0 , 0);
    
    for(int i=0; i<[arrProtocols count] ; i++)
    {
        /////////////////////////////////////////////////////
        // Calculate this icons position
        int nColumn = i % nPage;
        int nRow = i / nPage;
        //nPage = i / 4;
        
        rcPosition = CGRectMake(nLeftOffset + nColumn * nIconWidth, nTopOffset + nRow * nIconHeight, nIconWidth, nIconHeight);
        rcPosition.origin.x += (nColumn * nIconSpacingX);
        rcPosition.origin.y += (nRow * nIconSpacingY);
        
        ClsTableKey* med = [arrProtocols objectAtIndex:i];
        UIButton *btnDrug = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDrug setBackgroundImage:[UIImage imageNamed:@"btn_background.png"] forState:UIControlStateNormal];
        [btnDrug setTitle:med.tableName forState:UIControlStateNormal];
        btnDrug.titleLabel. numberOfLines = 0; // Dynamic number of lines
        btnDrug.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnDrug.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnDrug setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btnDrug addTarget:self action:@selector(protocolButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.groupScrollView2 addSubview:btnDrug];
        
        btnDrug.frame = rcPosition;
        btnDrug.tag = i;
    }
    
    self.groupScrollView2.contentSize = CGSizeMake(990,rcPosition.origin.y+80);
    
}


- (void)loadProtocolInGroupView
{
    for (UIView * view in self.groupScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    int nLeftOffset = 8;
    int nTopOffset = 8;
    int nIconSpacingX = 8 ;
    int nIconSpacingY = 8 ;
    
    int nIconWidth = 156;
    int nIconHeight = 70;
    int nPage = 6;
    CGRect rcPosition = CGRectMake(0, 0, 0 , 0);
    
    for(int i=0; i<[arrProtocols count] ; i++)
    {
        /////////////////////////////////////////////////////
        // Calculate this icons position
        int nColumn = i % nPage;
        int nRow = i / nPage;
        //nPage = i / 4;
        
        rcPosition = CGRectMake(nLeftOffset + nColumn * nIconWidth, nTopOffset + nRow * nIconHeight, nIconWidth, nIconHeight);
        rcPosition.origin.x += (nColumn * nIconSpacingX);
        rcPosition.origin.y += (nRow * nIconSpacingY);
        
        ClsTableKey* med = [arrProtocols objectAtIndex:i];
        UIButton *btnDrug = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDrug setBackgroundImage:[UIImage imageNamed:@"btn_background.png"] forState:UIControlStateNormal];
        [btnDrug setTitle:med.tableName forState:UIControlStateNormal];
        btnDrug.titleLabel. numberOfLines = 0; // Dynamic number of lines
        btnDrug.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnDrug.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnDrug setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btnDrug addTarget:self action:@selector(protocolButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.groupScrollView addSubview:btnDrug];
        
        btnDrug.frame = rcPosition;
        btnDrug.tag = i;
    }
    
    self.groupScrollView.contentSize = CGSizeMake(990,rcPosition.origin.y+80);
    
}

- (void)loadProtocolInScrollView
{
    for (UIView * view in protocolScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    int nLeftOffset = 8;
    int nTopOffset = 8;
    int nIconSpacingX = 8 ;
    int nIconSpacingY = 8 ;
    
    int nIconWidth = 156;
    int nIconHeight = 70;
    int nPage = 6;
    CGRect rcPosition = CGRectMake(0, 0, 0 , 0);
    
    for(int i=0; i<[arrProtocols count] ; i++)
    {
        /////////////////////////////////////////////////////
        // Calculate this icons position
        int nColumn = i % nPage;
        int nRow = i / nPage;
        //nPage = i / 4;
        
        rcPosition = CGRectMake(nLeftOffset + nColumn * nIconWidth, nTopOffset + nRow * nIconHeight, nIconWidth, nIconHeight);
        rcPosition.origin.x += (nColumn * nIconSpacingX);
        rcPosition.origin.y += (nRow * nIconSpacingY);
        
        ClsTableKey* med = [arrProtocols objectAtIndex:i];
        UIButton *btnDrug = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDrug setBackgroundImage:[UIImage imageNamed:@"btn_background.png"] forState:UIControlStateNormal];
        [btnDrug setTitle:med.tableName forState:UIControlStateNormal];
        btnDrug.titleLabel. numberOfLines = 0; // Dynamic number of lines
        btnDrug.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btnDrug.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btnDrug setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btnDrug addTarget:self action:@selector(protocolButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        [protocolScrollView addSubview:btnDrug];
        
        btnDrug.frame = rcPosition;
        btnDrug.tag = i;
    }
    
    protocolScrollView.contentSize = CGSizeMake(990,rcPosition.origin.y+80);
    
}

#pragma mark-
#pragma mark UIControls Callback Functions

- (IBAction)btnMainMenuClick:(id)sender {
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [delegate dismissViewControl];
}

- (IBAction)btnValidateClick:(UIButton*)sender {
    //[self saveTab];
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
    
    if (p.ticketComplete)
    {
        [delegate dismissViewControl];
    }
    
    else if (p.tagID >= 0)
    {
        [self.delegate dismissViewControlAndStartNew:p.tagID];
    }
}



-(IBAction)protocolButtonSelected:(UIButton *)sender
{
    
    ClsTableKey * key = [arrProtocols objectAtIndex:sender.tag];
    NSString* sqlStr = [NSString stringWithFormat:@"Select ProtocolFileString from ProtocolFiles where ProtocolID = %ld", key.key];
    NSString* dataStr;
    @synchronized(g_LOOKUPDB)
    {
        dataStr = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
    }
    
    NSString* str = [NSString stringWithFormat:@"Select max(inputInstance) from TicketInputs where TicketID = %@ and InputID = %d", ticketID, key.key ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:str];
    }
    count++;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/YYYY HH:mm:ss"];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [format stringFromDate:now];
    NSString* insertSql = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %ld, %ld, %ld, '%@', '%@', '%@')", ticketID, key.key, 0, count, @"Protocols", key.tableName, dateString];
    @synchronized(g_SYNCDATADB)
    {
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:insertSql];
    }
    
    
    // [Base64 initialize];
    NSData* data = [Base64 decode:dataStr];
    //   [webView loadData:data MIMEType:@"application/pdf" textEncodingName:@"Base64" baseURL:nil];
    //  data = nil;
    //  NSString *appFile = [tempDir stringByAppendingPathComponent:@"pfdDateFile"];
    
    NSString *appFile = [NSTemporaryDirectory() stringByAppendingPathComponent:@"Protocol.pdf"];
    self.fileURL = [[NSURL alloc] initFileURLWithPath:appFile];
    [data writeToFile:appFile atomically:YES];
    
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    previewController.currentPreviewItemIndex = 0;
    [self presentViewController:previewController animated:NO completion:nil];
    previewController = nil;
    
    
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return self.fileURL;
}

#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    [self.searchBar setBackgroundImage:[[UIImage alloc] init]];
    
}

#pragma mark-
#pragma UISearchBar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    searchBar.showsCancelButton = YES;
    searchBar.autocapitalizationType = UITextAutocorrectionTypeNo;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Text change - %d",isSearching);
    
    //Remove all objects first.
    // [filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        isSearching = YES;
        [self search:searchText];
    }
    else {
        isSearching = NO;
    }
    // [self.tblContentList reloadData];
}

-(void)searchBarTextDidEndEditing:(UISearchBar*) mysearchBar
{
    mysearchBar.showsCancelButton = NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self searchScrollView];
}

- (void) search:(NSString*) searchText
{
    NSString* sql = [NSString stringWithFormat:@"Select ProtocolID, ProtocolButtonText, ProtocolFileName from ProtocolFiles where ProtocolButtonText like '%%%@%%' ", searchText];
    @synchronized(g_LOOKUPDB)
    {
        self.arrProtocols = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    
    [self loadProtocolInScrollView];
}

- (void)searchScrollView
{
    if(isSearching)
    {
        BOOL bFound = NO;
        int i;
        for(i=0;i<[arrProtocols count] ; i++)
        {
            ClsTableKey* med = [arrProtocols objectAtIndex:i];
            
            NSRange range = [med.tableName rangeOfString:searchBar.text options: NSCaseInsensitiveSearch| NSAnchoredSearch];
            if ((range.location != NSNotFound) &&(range.location == 0))
            {
                bFound = YES;
                break;
            }
        }
        if(bFound)
        {
            UIButton *btn = (UIButton *)[protocolScrollView viewWithTag:i];
            NSLog(@"%@", NSStringFromCGRect(btn.frame));
            protocolScrollView.contentOffset = CGPointMake(0, btn.frame.origin.y);
            
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
