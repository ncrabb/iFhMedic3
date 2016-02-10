//
//  AssessmentViewController.m
//  iFhMedic
//
//  Created by admin on 10/11/15.
//  Copyright © 2015 com.emergidata. All rights reserved.
//

#import "AssessmentViewController.h"
#import "global.h"
#import "DAO.h"
#import "DDPopoverBackgroundView.h"
#import "ClsInputs.h"
#import "ClsTableKey.h"
#import "AssessmentCell.h"
#import "ClsAssesment.h"
#import "ClsVitalArray.h"

@interface AssessmentViewController ()
{
    NSInteger lastPageCount;
    NSMutableString* pageInputID;
    int labelCount;
    NSInteger start;
    int pageArray[10];
    NSInteger NumOfGroup;
    NSInteger rowSelected;
    bool editMode;
    NSInteger deletedCount;
    NSInteger currentInstance;
    NSInteger maxInstance;
    bool newAssessment;
}

@property (nonatomic, copy) NSString* ticketID;
@property (strong, nonatomic) AssessmentCell *selectedCell;
@property (strong, nonatomic) NSMutableArray*  dbArray;
@property (strong, nonatomic) NSMutableDictionary* ticketInputsData;
@property (strong, nonatomic) NSMutableArray* ticketInputsArray;
@property (nonatomic, strong) NSMutableArray* assessmentArray;
@end

@implementation AssessmentViewController
@synthesize delegate;
@synthesize inputContainer;
@synthesize incidentInput;
@synthesize pageControl;
@synthesize ticketInputData;
@synthesize popover;
@synthesize newTicket;
@synthesize btnNameLabel;
@synthesize btnQAMessage;
@synthesize toolBar;
@synthesize assessmentArray;
@synthesize selectedCell;
@synthesize dbArray;
@synthesize ticketInputsArray;
@synthesize ticketInputsData;
@synthesize tvAssessment;
@synthesize ticketID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pageInputID = [[NSMutableString alloc] init];
    UIImage *toolBarIMG = [UIImage imageNamed:@"navigation_bar_bkg.png"];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }
    currentInstance = -1;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    newAssessment = false;
    currentInstance = 1;
    lastPageCount = 0;
    labelCount = 0;
    start = 0;
    NumOfGroup = 0;
    deletedCount = 0;
    rowSelected = -1;
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    [self.pageControl setCurrentPage:0];
    self.assessmentArray = [[NSMutableArray alloc] init];
    self.dbArray = [[NSMutableArray alloc] init];
    self.ticketInputsArray = [[NSMutableArray alloc] init];
    editMode = false;
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

    [assessmentArray removeAllObjects];
    [dbArray removeAllObjects];
    [ticketInputsArray removeAllObjects];

    
    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        NSString* sql = [NSString stringWithFormat:@"Select MAX(inputInstance) from TicketInputs where TicketID = %@ and InputID in (1800)", ticketID];
        
        maxInstance = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSInteger NumOfVitals = maxInstance;
    
    for (int i = 1; i<= NumOfVitals; i++)
    {
        ClsAssesment* assessment1 = [[ClsAssesment alloc] init];

        @synchronized(g_SYNCDATADB)
        {
            self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            NSString* sql = [NSString stringWithFormat:@"Select * from TicketInputs where TicketID = %@ and (inputPage = 'Assessment' or inputpage = 'Assesment') and inputInstance = %d", ticketID, i];
            ticketInputsData = [DAO selectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
        if ([[ticketInputsData objectForKey:@"Deleted"] length] > 0 && ([[ticketInputsData objectForKey:@"Deleted"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.deleted = [ticketInputsData objectForKey:@"Deleted"];
            if ([assessment1.deleted isEqualToString:@"1"])
            {
                deletedCount++;
            }
            else
            {
                ClsVitalArray* inputarray = [[ClsVitalArray alloc] init];
                inputarray.inputData = ticketInputsData;
                inputarray.instance = i;
                [self.ticketInputsArray addObject:inputarray];
            }
        }
        else
        {
            ClsVitalArray* inputarray = [[ClsVitalArray alloc] init];
            inputarray.inputData = ticketInputsData;
            inputarray.instance = i;
            [self.ticketInputsArray addObject:inputarray];
        }
        
        if ([[ticketInputsData objectForKey:@"1800"] length] > 0 && ([[ticketInputsData objectForKey:@"1800"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.time = [ticketInputsData objectForKey:@"1800"];
        }
        
        if ([[ticketInputsData objectForKey:@"1801"] length] > 0 && ([[ticketInputsData objectForKey:@"1801"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.skin = [ticketInputsData objectForKey:@"1801"];
        }
        
        if ([[ticketInputsData objectForKey:@"1802"] length] > 0 && ([[ticketInputsData objectForKey:@"1802"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.head = [ticketInputsData objectForKey:@"1802"];
        }
        
        if ([[ticketInputsData objectForKey:@"1803"] length] > 0 && ([[ticketInputsData objectForKey:@"1803"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.neck = [ticketInputsData objectForKey:@"1803"];
        }
        
        if ([[ticketInputsData objectForKey:@"1804"] length] > 0 && ([[ticketInputsData objectForKey:@"1804"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.chest = [ticketInputsData objectForKey:@"1804"];
        }
        
        if ([[ticketInputsData objectForKey:@"1805"] length] > 0 && ([[ticketInputsData objectForKey:@"1805"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.heart = [ticketInputsData objectForKey:@"1805"];
        }
        
        if ([[ticketInputsData objectForKey:@"1806"] length] > 0 && ([[ticketInputsData objectForKey:@"1806"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.abdomen = [ticketInputsData objectForKey:@"1806"];
        }
        
        if ([[ticketInputsData objectForKey:@"1810"] length] > 0 && ([[ticketInputsData objectForKey:@"1810"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.pelvis = [ticketInputsData objectForKey:@"1810"];
        }
        
        if ([[ticketInputsData objectForKey:@"1811"] length] > 0 && ([[ticketInputsData objectForKey:@"1811"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.back = [ticketInputsData objectForKey:@"1811"];
        }
        
        
        
        if ([[ticketInputsData objectForKey:@"1814"] length] > 0 && ([[ticketInputsData objectForKey:@"1814"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.extremity = [ticketInputsData objectForKey:@"1814"];
        }
        
        if ([[ticketInputsData objectForKey:@"1818"] length] > 0 && ([[ticketInputsData objectForKey:@"1818"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.eye = [ticketInputsData objectForKey:@"1818"];
        }
        
        if ([[ticketInputsData objectForKey:@"1820"] length] > 0 && ([[ticketInputsData objectForKey:@"1820"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.mentalStatus = [ticketInputsData objectForKey:@"1820"];
        }
        
        
        if ([[ticketInputsData objectForKey:@"1821"] length] > 0 && ([[ticketInputsData objectForKey:@"1821"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.neurological = [ticketInputsData objectForKey:@"1821"];
        }
        
        if ([[ticketInputsData objectForKey:@"1825"] length] > 0 && ([[ticketInputsData objectForKey:@"1825"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.face = [ticketInputsData objectForKey:@"1825"];
        }
        
        if ([[ticketInputsData objectForKey:@"1826"] length] > 0 && ([[ticketInputsData objectForKey:@"1826"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.abdomenLoc = [ticketInputsData objectForKey:@"1826"];
        }
        
        if ([[ticketInputsData objectForKey:@"1827"] length] > 0 && ([[ticketInputsData objectForKey:@"1827"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.backLoc = [ticketInputsData objectForKey:@"1827"];
        }
        if ([[ticketInputsData objectForKey:@"1828"] length] > 0 && ([[ticketInputsData objectForKey:@"1828"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.extremityLoc = [ticketInputsData objectForKey:@"1828"];
        }
        if ([[ticketInputsData objectForKey:@"1829"] length] > 0 && ([[ticketInputsData objectForKey:@"1829"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.eyeLoc = [ticketInputsData objectForKey:@"1829"];
        }
        if ([[ticketInputsData objectForKey:@"1818"] length] > 0 && ([[ticketInputsData objectForKey:@"1818"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.leftEye = [ticketInputsData objectForKey:@"1818"];
        }
        if ([[ticketInputsData objectForKey:@"1819"] length] > 0 && ([[ticketInputsData objectForKey:@"1819"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.rightEye = [ticketInputsData objectForKey:@"1819"];
        }
        
        [self.dbArray addObject:assessment1];
        
    }
    
    for (int i = 0; i<dbArray.count; i++)
    {
        ClsAssesment* assess = [dbArray objectAtIndex:i];
        
        if (![assess.deleted isEqualToString:@"1"])
        {
            [self.assessmentArray addObject:assess];
        }
    }
    
    if (rowSelected == -1)
    {
        if(self.assessmentArray.count > 0)
        {
            rowSelected = assessmentArray.count - 1;
            ClsVitalArray* assessToLoad = [ticketInputsArray objectAtIndex:rowSelected];
            currentInstance = assessToLoad.instance;
            NSMutableDictionary* dict = assessToLoad.inputData;
            currentInstance = assessToLoad.instance;

            for (NSInteger i =start; i < incidentInput.count && i <(self.pageControl.currentPage + 1)*8; i++)
            {
                InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
                NSString* value = [dict objectForKey:[NSString stringWithFormat:@"%li", inputView.btnInput.tag]];
                if (value != nil || value.length > 0)
                {
                    [inputView setBtnText:value];
                }
            }
        }
        else
        {
            currentInstance = maxInstance + 1;
        }
        
    }
    else
    {
        ClsVitalArray* assessToLoad = [ticketInputsArray objectAtIndex:rowSelected];
        NSMutableDictionary* dict = assessToLoad.inputData;
        currentInstance = assessToLoad.instance;
        currentInstance = assessToLoad.instance;
        for (NSInteger i =start; i < incidentInput.count && i <(self.pageControl.currentPage + 1)*8; i++)
        {
            InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
            NSString* value = [dict objectForKey:[NSString stringWithFormat:@"%li", inputView.btnInput.tag]];
            if (value != nil || value.length > 0)
            {
                [inputView setBtnText:value];
            }
        }
        
        
        
    }
    [tvAssessment reloadData];

}

- (void) loadDefault
{
    
    NSString* sql = @"Select inputID, 'Inputs', InputDefault from Inputs where (InputPage = 'MultiAssessment') and (inputDefault != '')";
    NSMutableArray* defaultArray;
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        defaultArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    
    for (NSInteger i =start; i < incidentInput.count && i <(self.pageControl.currentPage + 1)*8; i++)
    {
        for (int j = 0; j < defaultArray.count; j++)
        {
            ClsTableKey* key = [defaultArray objectAtIndex:j];
            InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
            if (inputView.btnInput.tag == key.key)
            {
                [inputView.btnInput setTitle:key.desc forState:UIControlStateNormal];
            }
        }
        
    }
    
    
}


- (void) loadTableView
{
    [assessmentArray removeAllObjects];
    [dbArray removeAllObjects];
    [ticketInputsArray removeAllObjects];
    
    
    NSString* sql = [NSString stringWithFormat:@"Select MAX(inputInstance) from TicketInputs where TicketID = %@ and InputID in (1800)", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        maxInstance = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSInteger NumOfVitals = maxInstance;
    
    for (int i = 1; i<= NumOfVitals; i++)
    {
        ClsAssesment* assessment1 = [[ClsAssesment alloc] init];
        sql = [NSString stringWithFormat:@"Select * from TicketInputs where TicketID = %@ and (inputPage = 'Assessment' or inputpage = 'Assesment') and inputInstance = %d", ticketID, i];
        @synchronized(g_SYNCDATADB)
        {
            ticketInputsData = [DAO selectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
        if ([[ticketInputsData objectForKey:@"Deleted"] length] > 0 && ([[ticketInputsData objectForKey:@"Deleted"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.deleted = [ticketInputsData objectForKey:@"Deleted"];
            if ([assessment1.deleted isEqualToString:@"1"])
            {
                deletedCount++;
            }
            else
            {
                ClsVitalArray* inputarray = [[ClsVitalArray alloc] init];
                inputarray.inputData = ticketInputsData;
                inputarray.instance = i;
                [self.ticketInputsArray addObject:inputarray];
            }
        }
        else
        {
            ClsVitalArray* inputarray = [[ClsVitalArray alloc] init];
            inputarray.inputData = ticketInputsData;
            inputarray.instance = i;
            [self.ticketInputsArray addObject:inputarray];
        }
        
        if ([[ticketInputsData objectForKey:@"1800"] length] > 0 && ([[ticketInputsData objectForKey:@"1800"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.time = [ticketInputsData objectForKey:@"1800"];
        }
        
        if ([[ticketInputsData objectForKey:@"1801"] length] > 0 && ([[ticketInputsData objectForKey:@"1801"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.skin = [ticketInputsData objectForKey:@"1801"];
        }
        
        if ([[ticketInputsData objectForKey:@"1802"] length] > 0 && ([[ticketInputsData objectForKey:@"1802"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.head = [ticketInputsData objectForKey:@"1802"];
        }
        
        if ([[ticketInputsData objectForKey:@"1803"] length] > 0 && ([[ticketInputsData objectForKey:@"1803"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.neck = [ticketInputsData objectForKey:@"1803"];
        }
        
        if ([[ticketInputsData objectForKey:@"1804"] length] > 0 && ([[ticketInputsData objectForKey:@"1804"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.chest = [ticketInputsData objectForKey:@"1804"];
        }
        
        if ([[ticketInputsData objectForKey:@"1805"] length] > 0 && ([[ticketInputsData objectForKey:@"1805"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.heart = [ticketInputsData objectForKey:@"1805"];
        }
        
        if ([[ticketInputsData objectForKey:@"1806"] length] > 0 && ([[ticketInputsData objectForKey:@"1806"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.abdomen = [ticketInputsData objectForKey:@"1806"];
        }
        
        if ([[ticketInputsData objectForKey:@"1810"] length] > 0 && ([[ticketInputsData objectForKey:@"1810"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.pelvis = [ticketInputsData objectForKey:@"1810"];
        }
        
        if ([[ticketInputsData objectForKey:@"1811"] length] > 0 && ([[ticketInputsData objectForKey:@"1811"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.back = [ticketInputsData objectForKey:@"1811"];
        }
        
        
        
        if ([[ticketInputsData objectForKey:@"1814"] length] > 0 && ([[ticketInputsData objectForKey:@"1814"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.extremity = [ticketInputsData objectForKey:@"1814"];
        }
        
        if ([[ticketInputsData objectForKey:@"1818"] length] > 0 && ([[ticketInputsData objectForKey:@"1818"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.eye = [ticketInputsData objectForKey:@"1818"];
        }
        
        if ([[ticketInputsData objectForKey:@"1820"] length] > 0 && ([[ticketInputsData objectForKey:@"1820"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.mentalStatus = [ticketInputsData objectForKey:@"1820"];
        }
        
        
        if ([[ticketInputsData objectForKey:@"1821"] length] > 0 && ([[ticketInputsData objectForKey:@"1821"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.neurological = [ticketInputsData objectForKey:@"1821"];
        }
        
        if ([[ticketInputsData objectForKey:@"1825"] length] > 0 && ([[ticketInputsData objectForKey:@"1825"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.face = [ticketInputsData objectForKey:@"1825"];
        }
        
        if ([[ticketInputsData objectForKey:@"1826"] length] > 0 && ([[ticketInputsData objectForKey:@"1826"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.abdomenLoc = [ticketInputsData objectForKey:@"1826"];
        }
        
        if ([[ticketInputsData objectForKey:@"1827"] length] > 0 && ([[ticketInputsData objectForKey:@"1827"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.backLoc = [ticketInputsData objectForKey:@"1827"];
        }
        if ([[ticketInputsData objectForKey:@"1828"] length] > 0 && ([[ticketInputsData objectForKey:@"1828"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.extremityLoc = [ticketInputsData objectForKey:@"1828"];
        }
        if ([[ticketInputsData objectForKey:@"1829"] length] > 0 && ([[ticketInputsData objectForKey:@"1829"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.eyeLoc = [ticketInputsData objectForKey:@"1829"];
        }
        if ([[ticketInputsData objectForKey:@"1818"] length] > 0 && ([[ticketInputsData objectForKey:@"1818"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.leftEye = [ticketInputsData objectForKey:@"1818"];
        }
        if ([[ticketInputsData objectForKey:@"1819"] length] > 0 && ([[ticketInputsData objectForKey:@"1819"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            assessment1.rightEye = [ticketInputsData objectForKey:@"1819"];
        }
        
        [self.dbArray addObject:assessment1];
        
    }
    
    for (int i = 0; i<dbArray.count; i++)
    {
        ClsAssesment* assess = [dbArray objectAtIndex:i];
        
        if (![assess.deleted isEqualToString:@"1"])
        {
            [self.assessmentArray addObject:assess];
        }
    }
    
    [tvAssessment reloadData];
}


     
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
    NSString* sqlGroup = @"SELECT count (distinct InputGroup) FROM inputs where inputpage = 'MultiAssessment'";
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        NumOfGroup = [DAO getCount:[[g_SETTINGS objectForKey:@"lookupDB"]pointerValue] Sql:sqlGroup];
    }
    if (self.pageControl.currentPage >= lastPageCount)
    {
        start = (int) (page * 8) - labelCount;
    }
    else
    {
        if (page == 0)
        {
            start = 0;
        }
        else
        {
            start = (int) (page * 8) - pageArray[self.pageControl.currentPage - 1];
            labelCount = pageArray[self.pageControl.currentPage - 1];
        }
    }    
    
    if (self.incidentInput == nil)
    {
        NSString* querySql = @"select InputID, InputName, InputDataType, InputGroup, InputRequiredField  from Inputs where InputPage = 'MultiAssessment' order by inputGroup, InputIndex";
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.incidentInput = [DAO selectInputs:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql];
        }
        int numOfPage = ((int) (self.incidentInput.count + NumOfGroup)/8) + 1;
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
        
        InputViewFull* inputView = [[InputViewFull alloc] init];
        inputView.backgroundColor = [UIColor whiteColor];
        inputView.tabPage = 4;
        inputView.frame = CGRectMake(0, ypos, 1024, 44);
        inputView.inputType = input.inputDataType;
        inputView.inputID = input.inputID;
        inputView.delegate = self;
        inputView.tag = i + 1;
        inputView.btnInput.tag = input.inputID;
        [self.inputContainer addSubview:inputView];
        [inputView setLabelText:input.inputName dataType:input.inputDataType inputRequired:input.inputRequiredField];
        ypos += 45;
        
        if (ypos > 330)
        {
            break;
        }
    }
    
    [pageInputID setString:@""];
    
    for (int i = start; i < incidentInput.count; i++)
    {
        ClsInputs* input = [incidentInput objectAtIndex:i];
        [pageInputID appendString:[NSString stringWithFormat:@"%d", input.inputID]];
        if (i < incidentInput.count - 1)
        {
            [pageInputID appendString:@","];
        }
        
    }
    NSString* defaultStr = [NSString stringWithFormat:@"Select count(*) from ticketInputs where ticketID = %@ and inputID in (%@) and inputInstance = %d", ticketID, pageInputID, currentInstance];
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
        if (!newAssessment)
        {
            [self loadData];
        }
    }
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self saveTab];
    self.assessmentArray = nil;
    self.incidentInput = nil;
    self.dbArray = nil;
    [super viewWillDisappear:animated];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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

- (void) saveTab
{
    NSString* sqlStr;
    NSInteger count;
    
    newAssessment = false;
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
        for (NSInteger i =  start ; i < self.incidentInput.count && i < (lastPageCount + 1)* 8; i++)
        {
            InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
            NSString* inputValue = [self removeNull:inputView.btnInput.titleLabel.text];
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
    
    for (NSInteger i =  start ; i < self.incidentInput.count && i < (lastPageCount + 1)* 8; i++)
        
    {
        ClsInputs* input1 = [incidentInput objectAtIndex:i];
        InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
        NSString* inputValue = [self removeNull:inputView.btnInput.titleLabel.text];
        
        @synchronized(g_SYNCDATADB)
        {
            self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, inputView.btnInput.tag, 0, currentInstance, @"Assessment", input1.inputName, inputValue];
            NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d and inputInstance = %d", inputValue, ticketID, inputView.btnInput.tag, currentInstance];
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
        }
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

- (IBAction)btnPageControlClick:(id)sender {
    
    [self saveTab];
    [self setViewUI:self.pageControl.currentPage];
    lastPageCount = self.pageControl.currentPage;
}


- (void) doneInputView:(NSInteger) tag
{
    if (tag < self.incidentInput.count && tag < (self.pageControl.currentPage + 1)*12)
    {
        InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:tag + 1];
        [inputView btnInputClick:inputView.btnInput];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return assessmentArray.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"Time                              Skin                       Head/Face            Neck                     Chest/Lungs       Left Eye                Right Eye   ";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"AssessmentCell";
    
    AssessmentCell *cell = (AssessmentCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AssessmentCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    ClsAssesment* assessCell = [assessmentArray objectAtIndex:indexPath.row];

    cell.lblTime.text = assessCell.time;
    cell.lblSkin.text = assessCell.skin;
    cell.lblhead.text = assessCell.head;
    cell.lblNeck.text = assessCell.neck;
    cell.lblChest.text = assessCell.chest;
    cell.lblLeft.text = assessCell.leftEye;
    cell.lblRight.text = assessCell.rightEye;
    return cell;
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
    
    //    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    rowSelected = indexPath.row;
    // self.selectedCell = (VitalInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    
}

- (IBAction)btnNewAssessment:(id)sender {
    [self saveTab];
    [self.pageControl setCurrentPage:0];
    lastPageCount = self.pageControl.currentPage;
    maxInstance++;
    currentInstance = maxInstance;
    newAssessment = true;
    [self setViewUI:0];
    [self loadTableView];
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:1];
    [inputView setBtnText:dateString];
    rowSelected = ticketInputsArray.count;
}

- (IBAction)btnEditCllick:(id)sender {
    if (rowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic For iPad" message:@"Please select a vital entry below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        [self saveTab];
        [self.pageControl setCurrentPage:0];
        lastPageCount = self.pageControl.currentPage;
        [self setViewUI:self.pageControl.currentPage];
        
    }
}

- (IBAction)btnDeleteClick:(id)sender {
    if (rowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic For iPad" message:@"Please select a vital entry below before continuing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        [self saveTab];
        ClsVitalArray* vitalToLoad = [ticketInputsArray objectAtIndex:rowSelected];
        NSInteger instanceSelected = vitalToLoad.instance;
        NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set Deleted = 1, isUploaded = 0 where TicketID = %@ and inputPage = 'Assessment' and inputInstance = %ld", ticketID, instanceSelected];
        @synchronized(g_SYNCDATADB)
        {
            [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:updateStr];
        }
        
        rowSelected = -1;
        currentInstance = -1;
        lastPageCount = 0;
        [self setViewUI:0];
    }
}

- (IBAction)btnClearClick:(id)sender {
    if (currentInstance > 0)
    {
        for (NSInteger i =  0 ; i < self.incidentInput.count; i++)
        {
            ClsInputs* input1 = [incidentInput objectAtIndex:i];
            if (input1.inputID != 1800)
            {
                NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, input1.inputID, 0, currentInstance, @"Assessment", input1.inputName, @" "];
                NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d and inputInstance = %d", @" ", ticketID, input1.inputID, currentInstance];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
                }
            }
        }
        [self loadData];
    }
}

- (IBAction)btnNormalClick:(id)sender {
    if (currentInstance > 0)
    {
        for (NSInteger i =  0 ; i < self.incidentInput.count; i++)
        {
            ClsInputs* input1 = [incidentInput objectAtIndex:i];
            
            if (input1.inputID != 1800)
            {

                @synchronized(g_SYNCDATADB)
                {
                   self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
                    NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, input1.inputID, 0, currentInstance, @"Assessment", input1.inputName, @"Normal"];
                    NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d and inputInstance = %d", @"Normal", ticketID, input1.inputID, currentInstance];
                    [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
                }
            }
            else
            {
                InputViewFull* inputView = (InputViewFull*)[inputContainer viewWithTag:i+1];
                NSString* inputValue = [self removeNull:inputView.btnInput.titleLabel.text];
                if (inputValue.length < 2)
                {
                    NSDate* sourceDate = [NSDate date];
                    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"MM/dd/yyyy hh:mm:ss"];
                    inputValue = [dateFormat stringFromDate:sourceDate];
                    [inputView.btnInput setTitle:inputView forState:UIControlStateNormal];
                    
                }
                @synchronized(g_SYNCDATADB)
                {
                    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
                    NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, inputView.btnInput.tag, 0, currentInstance, @"Assessment", input1.inputName, inputValue];
                    NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %d and inputInstance = %d", inputValue, ticketID, inputView.btnInput.tag, currentInstance];
                    [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
                }
            }
        }
        [self loadData];
    }
}

- (IBAction)btnMainMenuCick:(id)sender
{
   [delegate dismissViewControl];
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
