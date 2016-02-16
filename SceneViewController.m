//
//  SceneViewController.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 03/03/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "SceneViewController.h"
#import "AppDelegate.h"
#import "global.h"
#import "DAO.h"
#import "MapAnnotation.h"
#import "ClsTableKey.h"
#import "CalendarViewController.h"

#import "DDPopoverBackgroundView.h"
#import "QAMessageViewController.h"
#import "ClsInputs.h"
#import "ClsTicketInputs.h"

@interface SceneViewController ()
{
    bool keybaordDown;
    bool coordSet;
    bool viewUp;
    NSInteger lastPageCount;
    NSMutableString* pageInputID;
    int labelCount;
    NSInteger start;
    int pageArray[10];
    NSInteger NumOfGroup;
}

@property(nonatomic, copy)  NSString* ticketID;
@end

@implementation SceneViewController

@synthesize btnNameLabel;

@synthesize delegate;
@synthesize popover;

@synthesize mapView;

@synthesize btnCurrentLocation;
@synthesize page2Container;
@synthesize SegmentControl;
@synthesize page2Container1;
@synthesize page2Container2;

@synthesize currentLocation;

@synthesize btnDOS;
@synthesize btnQAMessage;

@synthesize incidentInput;
@synthesize inputContainer;
@synthesize ticketInputData;
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
    [self.mapView.layer setCornerRadius:10.0f];
    [self.mapView.layer setMasksToBounds:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onKeyboardHide:(NSNotification *)notification
{
    if (viewUp)
    {
        [self setViewMovedUp:NO];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
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
    [btnNameLabel setTitle:patientName];
    [btnNameLabel setTintColor:[UIColor whiteColor]];
    manualPress = false;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cadUpdateNeeded) name:@"CADUPDATE" object:NULL];
    [self runMapLocator];
}

-(void) runMapLocator
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    MKCoordinateRegion region;
    
    region.center.latitude = appdelegate.dblCurrentLatitude;
    region.center.longitude =  appdelegate.dblCurrentLongitude;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.0009;
    span.longitudeDelta = 0.0009;
    region.span = span;
    
    [mapView setRegion:region animated:YES];
}

- (void) loadDefault
{
    NSString* sql = @"Select inputID, 'Inputs', InputDefault from Inputs where inputPage like 'Incident%' and (inputDefault != '')";
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
            InputView* inputView = (InputView*)[inputContainer viewWithTag:i+1];
            if (inputView.btnInput.tag == key.key)
            {
                [inputView.btnInput setTitle:key.desc forState:UIControlStateNormal];
            }
        }
        
    }
    
    

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString* sqlStr = [NSString stringWithFormat:@"Select TicketStatus from Tickets where TicketID = %@", ticketID];
    NSString* status;
    @synchronized(g_SYNCDATADB)
    {
        status = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    [g_SETTINGS setObject:status forKey:@"TicketStatus"];
    if ([status intValue] == 3)
    {
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
        CGRect rect = CGRectMake(25, 18, 90, 45);
        [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        self.btnQAMessage.hidden = false;
    }
    else
    {
        self.btnQAMessage.hidden = true;
    }
    [self setTabColor:@""];
}

- (void) cadUpdateNeeded
{
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@", ticketID ];
    
    @synchronized(g_SYNCDATADB)
    {
        self.ticketInputData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    [self loadData];
    
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
            InputView* inputView = (InputView*)[inputContainer viewWithTag:i+1];
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

    @synchronized(g_SYNCDATADB)
    {
        self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
        for (NSInteger i =  start ; i < self.incidentInput.count && i < (lastPageCount + 1)* 13; i++)
        {
            InputView* inputView = (InputView*)[inputContainer viewWithTag:i+1];
            NSString* inputValue = [self removeNull:inputView.btnInput.titleLabel.text];
            
            sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %ld, %d, %d, '%@', '%@', '%@')", ticketID, inputView.btnInput.tag, 0, 1, @"", @"", inputValue];
            NSString* updateStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = %ld", inputValue, ticketID, inputView.btnInput.tag];
            [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
            if (inputView.btnInput.tag == 1001)
            {
                sqlStr = [NSString stringWithFormat:@"Update Tickets set TicketIncidentNumber = '%@', isUploaded = 0 where TicketID = %@", inputValue, ticketID];
                
                [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
        }
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self saveTab];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"CADUPDATE"
                                                  object:nil];
    [super viewWillDisappear:animated];
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


#pragma mark-
#pragma mark Class Methods



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
        InputView* inputView = (InputView*)[inputContainer viewWithTag:i+1];
        NSString* value = [ticketInputData objectForKey:inputStr];
        if (value != nil || value.length > 0)
        {
            [inputView setBtnText:value];
        }
    }
}



- (void)Setcenter:(CLLocationCoordinate2D)Clocation;
{
    
    MKCoordinateRegion region;
    //39.1547426, -77.2405153
    //39.032798, -76.962642
    region.center.latitude = Clocation.latitude;
    region.center.longitude =  Clocation.longitude;
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.0001;
    span.longitudeDelta = 0.0001;
    region.span = span;
    
    [mapView setRegion:region animated:YES];
   

    
    [self loadMarkers:Clocation];
}

- (void)loadMarkers:(CLLocationCoordinate2D)Clocation;
{
	NSMutableArray *annots = [[NSMutableArray alloc] init];
    
    
    // Add markers
    currentLocation = Clocation;
    
    MapAnnotation* place_marker = [[MapAnnotation alloc] initWithCoordinate:Clocation title:@"You" annotationType:MapAnnotationTypePin];
    
    [annots addObject:place_marker];
    
    place_marker = nil;
    [mapView removeAnnotations:mapView.annotations];
    [mapView addAnnotations:annots];
}





- (CLLocationCoordinate2D) geoCodeUsingAddress: (NSString *) address
{
    CLLocationCoordinate2D myLocation;
    @try {
        NSString *esc_addr = [address stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSString *req = [NSString stringWithFormat: @"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
        
        NSString *strResult = [NSString stringWithContentsOfURL: [NSURL URLWithString: req] encoding: NSUTF8StringEncoding error: NULL];
        NSDictionary *googleResponse = [NSJSONSerialization JSONObjectWithData:[strResult dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        NSDictionary *resultsDict = [googleResponse valueForKey:  @"results"];
        NSDictionary *geometryDict = [resultsDict valueForKey: @"geometry"];
        NSDictionary *locationDict = [geometryDict valueForKey: @"location"];
        NSArray *latArray = [locationDict valueForKey: @"lat"]; NSString *latString = [latArray lastObject];
        NSArray *lngArray = [locationDict valueForKey: @"lng"]; NSString *lngString = [lngArray lastObject];
        
        myLocation.latitude = [latString doubleValue];
        myLocation.longitude = [lngString doubleValue];
        
        NSLog(@"lat: %f\tlon:%f", myLocation.latitude, myLocation.longitude);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

    return myLocation;
}

#pragma mark -
#pragma mark MKMapViewDelegate Methods

- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
	// starting the load, start animating activity indicator
	([UIApplication sharedApplication]).networkActivityIndicatorVisible = YES;
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
	// finished loading, stop animating activity indicator
	([UIApplication sharedApplication]).networkActivityIndicatorVisible = NO;
    
}


- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation:(id<MKAnnotation>) annotation
{
    MKAnnotationView *pin = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier: @"VoteSpotPin"];
    if (pin == nil)
    {
        pin = [[MKAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"TestPin"];
    }
    else
    {
        pin.annotation = annotation;
    }
    
    [pin setImage:[UIImage imageNamed:@"green_map_pin.png"]];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return pin;
}


#pragma mark-
#pragma mark UIControls Callback Functions


- (IBAction)btnMainMenuClick:(id)sender {
    [delegate dismissViewControl];
}

- (IBAction)btnCurrentLocationPressed:(id)sender
{

    if(isCurrentLocation)
    {
        isCurrentLocation = NO;
        [btnCurrentLocation setTitle:@"Current Location On" forState:UIControlStateNormal];
    }
    else
    {
        isCurrentLocation = YES;
        [btnCurrentLocation setTitle:@"Current Location Off" forState:UIControlStateNormal];
    }
  
   // [self populateAddress];
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



- (void)updateAddressAccordingToCurrentLocation
{
    if(isCurrentLocation)
    {
    }
    else
    {
        
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
    else
    {
       [self.delegate dismissViewControlAndStartNew:0];
    }
}

- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        if(rect.origin.y == 0)
            rect.origin.y = self.view.frame.origin.y - 256;
    }
    else
    {
        if(rect.origin.y < 0)
            rect.origin.y = self.view.frame.origin.y + 256;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag > 6)
    {
        [self setViewMovedUp:YES];
        viewUp = true;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    keybaordDown = true;
    if ([textField isFirstResponder])
    {
        [textField resignFirstResponder];
    }
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag > 6)
    {
        [self setViewMovedUp:NO];
        viewUp = false;
    }
    if (keybaordDown)
    {
        keybaordDown = false;

        
    }
    else
    {
    }
    [textField resignFirstResponder];
    
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
        NSString* sqlGroup = @"SELECT count (distinct InputGroup) FROM inputs where inputpage = 'Incident' or inputpage = 'NFIRS'";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            NumOfGroup = [DAO getCount:[[g_SETTINGS objectForKey:@"lookupDB"]pointerValue] Sql:sqlGroup];
        }
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
        NSString* querySql = @"select InputID, InputName, InputDataType, InputGroup, InputRequiredField  from Inputs where InputPage = 'Incident' or inputPage = 'NFIRS' order by inputGroup, InputIndex";
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
            if (lastGroup == nil && i != 0)
            {
                if (self.pageControl.currentPage >= lastPageCount)
                {
                    NumOfGroup++;
                    int numOfPage = ((int) (self.incidentInput.count + NumOfGroup)/13) + 1;
                    self.pageControl.numberOfPages = numOfPage;
                }
                else
                {
                    NumOfGroup--;
                }
            }
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
            if (ypos > 555)
            {
                break;
            }
        }

        InputView* inputView = [[InputView alloc] init];
        inputView.backgroundColor = [UIColor whiteColor];
        inputView.frame = CGRectMake(0, ypos, 605, 44);
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
            self.popover.popoverContentSize = CGSizeMake(502, 520);
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

- (void) doneInputView:(NSInteger) tag
{
    if (tag < self.incidentInput.count && tag < (self.pageControl.currentPage + 1)*12)
    {
        InputView* inputView = (InputView*)[inputContainer viewWithTag:tag + 1];
        [inputView btnInputClick:inputView.btnInput];
    }
}



- (void) setTabColor:(NSString*) outcomeVal
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    if ([outcomeVal isEqualToString:@"Multi-Patient Refusal"])
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (999)", ticketID];
        NSInteger count;
        @synchronized(g_SYNCBLOBSDB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
        }
        NSInteger completed = 0;
        if (count < 1)
        {
            completed = 1;
        }
        [array addObject:@"17"];
        [delegate setTabsRequired:array];
        
        return;
    }
    if ([outcomeVal rangeOfString:@"Refus"].location != NSNotFound)
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Select signaturetype from SignatureTypes where SignatureGroup = 'Patient Refusal'"];
        NSString* sigTypeStr;
        @synchronized(g_SYNCLOOKUPDB)
        {
            sigTypeStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
        }
        sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (%@)", ticketID, sigTypeStr];
        NSInteger count;
        @synchronized(g_SYNCBLOBSDB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
        }
        if (count < 1)
        {
            [array addObject:@"17"];
        }
        
        if ([[g_SETTINGS objectForKey:@"WitnessSignatureRequiredOnRefusal"] isEqualToString:@"1"])
        {
            sqlStr = [NSString stringWithFormat:@"Select signaturetype from SignatureTypes where SignatureGroup = 'Witness'"];
            NSString* sigTypeStr;
            @synchronized(g_SYNCLOOKUPDB)
            {
                sigTypeStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
            }
            sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (%@)", ticketID, sigTypeStr];
            NSInteger count;
            @synchronized(g_SYNCBLOBSDB)
            {
                count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
            }
            if (count < 1)
            {
                [array addObject:@"17"];
            }
        }
        
    }   // end refusal
    
    NSString* sql;
    if ([outcomeVal length] > 1 && ([outcomeVal rangeOfString:@"(null)"].location == NSNotFound))
    {
        if ([outcomeVal isEqualToString:@"Patient Transported"])
        {
            sql = [NSString stringWithFormat:@"select inputID from Inputs where InputRequiredField = 1 union select inputID from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@'" , outcomeVal];
        }
        else
        {
            sql = [NSString stringWithFormat:@"select inputID from Inputs where InputRequiredField = 1 and inputPage = 'Incident' union select inputID from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@'" , outcomeVal];
        }
        
    }
    else
    {
        sql = @"select inputID from Inputs where InputRequiredField = 1";
    }
    NSString* requiredID;
    @synchronized(g_SYNCLOOKUPDB)
    {
        requiredID = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    
    sql = [NSString stringWithFormat:@"select InputID, InputValue from ticketInputs where TicketID = %@ and InputID in (%@) and (inputValue is not null) and inputValue NOT like '%@(null)%@' and inputValue != ''", ticketID, requiredID, @"%", @"%"];
    NSMutableDictionary* ticketInputIds;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputIds = [DAO executeSelectInputValue:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSMutableString* missingIDs = [[NSMutableString alloc] init];
    
    NSArray* requiredIDArray = [requiredID componentsSeparatedByString:@","];
    for (int i=0; i < [requiredIDArray count]; i++)
    {
        NSString* testStr = [ticketInputIds objectForKey:[requiredIDArray objectAtIndex:i]];
        if ([testStr length] > 0 && ([testStr rangeOfString:@"(null)"].location == NSNotFound))
        {
            
        }
        else
        {
            [missingIDs appendString:[requiredIDArray objectAtIndex:i]];
            [missingIDs appendString:@","];
        }
    }
    
    
    
    if ([missingIDs length] > 1)
    {
        [missingIDs deleteCharactersInRange:NSMakeRange([missingIDs length]-1, 1)];
    }
    
    NSString* requiredPage;
    sql = [NSString stringWithFormat:@"select distinct InputPage from Inputs where InputID in (%@)", missingIDs];
    @synchronized(g_SYNCLOOKUPDB)
    {
        requiredPage = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    NSArray* missingPageArray = [requiredPage componentsSeparatedByString:@","];
    for (int i = 0; i< missingPageArray.count; i++)
    {
        NSString* page = [missingPageArray objectAtIndex:i];
        if ([page isEqualToString:@"Incident"])
        {
            [array addObject:@"0"];
        }
        else if ([page isEqualToString:@"Call Times"])
        {
            [array addObject:@"1"];
        }
        else if ([page isEqualToString:@"Personal"])
        {
            [array addObject:@"2"];
        }
        else if ([page isEqualToString:@"Impression"])
        {
            [array addObject:@"3"];
        }
        else if ([page isEqualToString:@"Assessment"] || [page isEqualToString:@"MultiAssessment"])
        {
            [array addObject:@"4"];
        }
        else if ([page isEqualToString:@"History"])
        {
            [array addObject:@"7"];
        }
        else if ([page isEqualToString:@"Meds"])
        {
            [array addObject:@"8"];
        }
        else if ([page isEqualToString:@"Allergies"])
        {
            [array addObject:@"9"];
        }
        else if ([page isEqualToString:@"Symptoms"])
        {
            [array addObject:@"10"];
        }
        else if ([page isEqualToString:@"OPQRST"])
        {
            [array addObject:@"11"];
        }
        else if ([page isEqualToString:@"Injury"])
        {
            [array addObject:@"12"];
        }
        else if ([page isEqualToString:@"Diagram"])
        {
            [array addObject:@"13"];
        }
        else if ([page isEqualToString:@"Comments"])
        {
            [array addObject:@"14"];
        }
        else if ([page isEqualToString:@"Outcome"])
        {
            [array addObject:@"15"];
        }
        else if ([page isEqualToString:@"Insurance"])
        {
            [array addObject:@"16"];
        }
        
        else if ([page isEqualToString:@"Protocols"])
        {
            [array addObject:@"18"];
        }
        else if ([page isEqualToString:@"CPR"])
        {
            [array addObject:@"19"];
        }
    }
    
    if ([outcomeVal length] > 0 && ([outcomeVal rangeOfString:@"(null)"].location == NSNotFound))
    {
        if  ([[g_SETTINGS objectForKey:@"MedicSignatureRequired"] isEqualToString:@"1"])
        {
            NSString* sqlStr = [NSString stringWithFormat:@"Select signaturetype from SignatureTypes where SignatureTypeDesc = 'In Charge Medic' or SignatureTypeDesc = 'Primary Medic'"];
            NSString* sigTypeStr;
            @synchronized(g_SYNCLOOKUPDB)
            {
                sigTypeStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
            }
            sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (%@)", ticketID, sigTypeStr];
            NSInteger count;
            @synchronized(g_SYNCBLOBSDB)
            {
                count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
            }
            if (count < 1)
            {
                [array addObject:@"17"];
            }
        }  // end medic1
        
        if  ([[g_SETTINGS objectForKey:@"TwoMedicSigsRequired"] isEqualToString:@"1"])
        {
            NSString* sqlStr = [NSString stringWithFormat:@"Select signaturetype from SignatureTypes where SignatureTypeDesc = 'Secondary Medic'"];
            NSString* sigTypeStr;
            @synchronized(g_SYNCLOOKUPDB)
            {
                sigTypeStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
            }
            sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketSignatures where ticketID = %@ and SignatureType in (%@)", ticketID, sigTypeStr];
            NSInteger count;
            @synchronized(g_SYNCBLOBSDB)
            {
                count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
            }
            if (count < 1)
            {
                [array addObject:@"17"];
            }
        }  // end medic1
    }
    
    int vitalCount = 0;
    NSString* vitalOnNonTrans = [g_SETTINGS objectForKey:@"RequireVitalsOnNonTransports"];
    if (![vitalOnNonTrans isEqualToString:@""])
    {
        if ([outcomeVal containsString:@"Patient Refused Transport"] ||  [outcomeVal containsString:@"Patient Transferred"] || [outcomeVal containsString:@"Treatment No Transport"] || [outcomeVal containsString:@"Guardian Refusal"])
        {
            vitalCount = [[g_SETTINGS objectForKey:@"RequireVitalsOnNonTransports"] integerValue];
        }
        else if ([outcomeVal containsString:@"Patient Transport"] || [outcomeVal containsString:@"Non Emergency Transfer"])
        {
            vitalCount = [[g_SETTINGS objectForKey:@"VitalSetsRequired"] integerValue];
        }
    }
    else
    {
        if ([outcomeVal containsString:@"Patient Transport"] || [outcomeVal containsString:@"Non Emergency Transfer"])
        {
            vitalCount = [[g_SETTINGS objectForKey:@"VitalSetsRequired"] integerValue];
        }
    }
    
    NSString* currentVitalCountStr = [NSString stringWithFormat:@"select count(*) from (Select * from ticketInputs where ticketID = %@ and inputID = 3001 and  ( (deleted is null)) UNION Select * from ticketInputs where ticketID = %@ and inputID = 3001 and deleted = 0) as temp1", ticketID, ticketID];
    NSInteger enteredVitalCount = 0;
    @synchronized(g_SYNCDATADB)
    {
        enteredVitalCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:currentVitalCountStr];
    }
    if (vitalCount > 0)
    {
        if (vitalCount > enteredVitalCount)
        {
            [array addObject:@"5"];
        }
        else
        {
            for (int i = 1; i <= enteredVitalCount; i++)
            {
                NSString* result = [self checkVitals:i];
                if (result.length > 0)
                {
                    [array addObject:@"5"];
                }
                
            }
        }
        
    }
    
    bool treatmentNeeded;
    NSString* treatmentRequired = [g_SETTINGS objectForKey:@"TreatmentsRequired"];
    if ([treatmentRequired isEqualToString:@"1"])
    {
        if ([outcomeVal containsString:@"Patient Transport"] || [outcomeVal containsString:@"Non Emergency Transfer"])
        {
            treatmentNeeded = true;
        }
        else
        {
            treatmentNeeded = false;
        }
        
        if (treatmentNeeded)
        {
            NSString* treatmentSql = [NSString stringWithFormat:@"Select count(*) from (select * from ticketInputs where ticketID = %@ and inputID > 1999 and inputID < 3000 and inputSubID = 1 and Deleted is NULL Union select * from ticketInputs where ticketID = %@ and inputID > 1999 and inputID < 3000 and inputSubID = 1 and Deleted = 0) as temp1", ticketID, ticketID];
            NSInteger treatmentDone = 0;
            @synchronized(g_SYNCDATADB)
            {
                treatmentDone = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:treatmentSql];
            }
            if (treatmentDone < 1)
            {
                [array addObject:@"6"];
            }
            else
            {
                NSString* treatmentSql = [NSString stringWithFormat:@"Select distinct * from ticketInputs where ticketID = %@ and inputID > 1999 and inputID < 3000 and inputSubID = 1 and ( Deleted is NULL) Union Select distinct * from ticketInputs where ticketID = %@ and inputID > 1999 and inputID < 3000 and inputSubID = 1 and ( Deleted = 0)", ticketID, ticketID];
                NSMutableArray* treatmentArray1;
                @synchronized(g_SYNCDATADB)
                {
                    treatmentArray1 = [DAO executeSelectTicketInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:treatmentSql];
                }
                
                for (int i = 0; i < [treatmentArray1 count]; i++)
                {
                    ClsTicketInputs* input = [treatmentArray1 objectAtIndex:i];
                    NSString* treamtemtRequiredSql = [NSString stringWithFormat:@"Select InputID, 'treatmentRequired', InputName from TreatmentInputs where TreatmentID = %d and active = 1 and inputRequired = 1", input.inputId];
                    NSMutableArray* requiredTreatmentArray;
                    @synchronized(g_LOOKUPDB)
                    {
                        requiredTreatmentArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:treamtemtRequiredSql WithExtraInfo:NO];
                    }
                    NSMutableString* msg = [[NSMutableString alloc] init];
                    bool displayStr = false;
                    for (int j = 0; j < [requiredTreatmentArray count]; j++)
                    {
                        ClsTableKey* key = [requiredTreatmentArray objectAtIndex:j];
                        NSString* treatmentEnteredSql = [NSString stringWithFormat:@"Select count(*) from ticketInputs where ticketID = %@ and InputID = %d and inputSubID = %d and (inputValue != '(null)' and inputValue is not null and inputvalue != '' and InputValue != ' ')", ticketID, input.inputId, key.key];
                        NSInteger requiredDone;
                        @synchronized(g_SYNCDATADB)
                        {
                            requiredDone = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:treatmentEnteredSql];
                        }
                        if (requiredDone < 1)
                        {
                            [msg appendString:key.desc];
                            [msg appendString:@" "];
                            displayStr = true;
                        }
                    }
                    if (displayStr)
                    {
                        [array addObject:@"6"];
                    }
                }
                
            }
        }
    }  // end if treatment == 1
    
    int assessmentNeeded = 0;
    if ([outcomeVal isEqualToString:@"Patient Transported"])
    {
        NSString* assessmentRequired = [g_SETTINGS objectForKey:@"RequiredAssessmentCount"];
        if ([assessmentRequired intValue] > 0)
        {
            NSString* assSql = [NSString stringWithFormat:@"Select count(distinct inputInstance) from TicketInputs where TicketID = %@ and inputID = 1800 and (deleted is null or deleted = 0)", ticketID];
            NSInteger asscount;
            @synchronized(g_SYNCDATADB)
            {
                asscount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:assSql];
            }
            assessmentNeeded = [assessmentRequired intValue] - asscount;
            if (assessmentNeeded > 0)
            {
                [array addObject:@"4"];
            }
            else
            {
                for (int i = 1; i <= asscount; i++)
                {
                    NSString* result = [self checkAssessment:i];
                    if (result.length > 0)
                    {
                        [array addObject:@"4"];
                        
                    }
                    
                }
            }
            
        }
    }
    
    
    
    NSString* sqlStr = @"Select drugname from drugs where narcotic = 1";
    NSString* narcotics;
    @synchronized(g_SYNCLOOKUPDB)
    {
        narcotics = [DAO executeSelectNarcoticInput:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sqlStr];
    }
    sqlStr = [NSString stringWithFormat:@"Select count(*) from ticketInputs where ticketID = %@ and inputID = 2011 and InputValue in (%@)", ticketID, narcotics];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    NSInteger narcoticCount = 0;
    if (count > 0)
    {
        NSInteger narcoticEnteredCount = 0;
        sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FormID = 3 and FormInputID = 7", ticketID ];
        @synchronized(g_SYNCDATADB)
        {
            narcoticEnteredCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (narcoticEnteredCount < 1)
        {
            [array addObject:@"20"];
        }
        
    }
    [delegate setTabsRequired:array];
}


- (NSMutableString*) checkVitals:(NSInteger) vitalCount
{
    NSMutableString* msg = [[NSMutableString alloc] init];
    NSString* vitalsRequiredIds = [[NSMutableString alloc] init];
    //[vitalsRequiredIds appendString:@"3001, 3002, 3003, 3004, 3005, 3006, 3018, 3019, 3020, 3011"];
    NSString *sql = @"select inputID from Vitals where VitalRequired = 1";
    
    @synchronized(g_SYNCLOOKUPDB)
    {
        vitalsRequiredIds = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    
    
    NSString* vitalsEntrySql = [NSString stringWithFormat:@"Select inputID from ticketInputs where ticketID = %@ and inputInstance = %d and inputID in (%@) and (deleted is null or deleted = 0) and (inputValue == '(null)' or inputValue is null or inputvalue = '' or InputValue = ' ')", ticketID, vitalCount, vitalsRequiredIds];
    NSString *requiredVitalNotPerformed;
    @synchronized(g_SYNCDATADB)
    {
        requiredVitalNotPerformed = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:vitalsEntrySql];
    }
    
    
    if (requiredVitalNotPerformed.length > 1)
    {
        
        NSArray* requiredVitalArray =  [requiredVitalNotPerformed componentsSeparatedByString:@","];
        NSString* inputID;
        for (inputID in requiredVitalArray)
        {
            if ([inputID isEqualToString:@"3001"])
            {
                [msg appendString:@"Vital Time "];
            }
            else if ([inputID isEqualToString:@"3002"])
            {
                [msg appendString:@"Systolic BP "];
            }
            else if ([inputID isEqualToString:@"3003"])
            {
                [msg appendString:@"Diastolic BP "];
            }
            else if ([inputID isEqualToString:@"3004"])
            {
                [msg appendString:@"Heart Rate "];
            }
            else if ([inputID isEqualToString:@"3005"])
            {
                [msg appendString:@"Resp Rate "];
            }
            else if ([inputID isEqualToString:@"3006"])
            {
                [msg appendString:@"SPO2% "];
                
            }
            else if ([inputID isEqualToString:@"3018"])
            {
                [msg appendString:@"GCS Eyes "];
            }
            else if ([inputID isEqualToString:@"3019"])
            {
                [msg appendString:@"GCS Verbal "];
            }
            else if ([inputID isEqualToString:@"3020"])
            {
                [msg appendString:@"GCS Motor "];
            }
            else if ([inputID isEqualToString:@"3011"])
            {
                [msg appendString:@"GCS Total "];
            }
            else if ([inputID isEqualToString:@"3029"])
            {
                [msg appendString:@"Pain Scale "];
            }
            else if ([inputID isEqualToString:@"3034"])
            {
                [msg appendString:@"SPCO "];
            }
            else if ([inputID isEqualToString:@"3042"])
            {
                [msg appendString:@"Stroke Scale "];
            }
            
            else if ([inputID isEqualToString:@"3050"])
            {
                [msg appendString:@"Prior To Arrival "];
            }
            else if ([inputID isEqualToString:@"3012"])
            {
                [msg appendString:@"Position "];
            }
            else if ([inputID isEqualToString:@"3015"])
            {
                [msg appendString:@"EKG "];
            }
        }
    }
    
    
    return msg;
    
    
}


- (NSMutableString*) checkAssessment:(NSInteger) assCount
{
    NSMutableString* msg = [[NSMutableString alloc] init];
    NSString* outcomeVal;
    NSString* sqlOutcome = [NSString stringWithFormat:@"select InputValue from TicketInputs where ticketID = %@ and InputID = 1401", ticketID];
    @synchronized(g_SYNCDATADB)
    {
        outcomeVal = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlOutcome];
    }
    
    NSString* sql;
    if ([outcomeVal length] > 0 && ([outcomeVal rangeOfString:@"(null)"].location == NSNotFound))
    {
        if ([outcomeVal isEqualToString:@"Patient Transported"])
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from Inputs where InputRequiredField = 1 and inputpage like 'MultiAssessment%%' union select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 1" , outcomeVal];
            
        }
        else if ( ([outcomeVal rangeOfString:@"Guardian Refusal"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 2" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"Patient Transferred"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 3" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"Disregarded"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 4" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"No Patient Contact"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 5" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"False Alarm"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 7" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"DOA"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 9" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"Treatment No Transport"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 10" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"Patient Tranferred to other Service"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 11" , outcomeVal];
        }
        else if ( ([outcomeVal rangeOfString:@"Did not Perform Medical Care"]).location != NSNotFound)
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = 12" , outcomeVal];
        }
        else
        {
            sql = @"SELECT distinct i.inputid, i.inputname, i.inputpage FROM inputs i where i.inputrequiredfield = 1 and i.inputpage like 'Personal%'";
        }
        
    }
    else
    {
        sql = @"SELECT distinct i.inputid, i.inputname, i.inputpage FROM inputs i where i.inputrequiredfield = 1 and i.inputpage like 'MultiAssessment%'";
    }
    NSMutableArray* requiredArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        requiredArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    
    
    NSMutableString* assessmentMsg = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [requiredArray count]; i++)
    {
        ClsTableKey* key = [requiredArray objectAtIndex:i];
        if (key.key == 1801)
        {
            [assessmentMsg appendString:@"1801,"];
        }
        else if (key.key == 1802)
        {
            [assessmentMsg appendString:@"1802,"];
        }
        else if (key.key == 1803)
        {
            [assessmentMsg appendString:@"1803,"];
        }
        else if (key.key == 1804)
        {
            [assessmentMsg appendString:@"1804,"];
        }
        else if (key.key == 1805)
        {
            [assessmentMsg appendString:@"1805,"];
        }
        else if (key.key == 1806)
        {
            [assessmentMsg appendString:@"1806,"];
        }
        else if (key.key == 1807)
        {
            [assessmentMsg appendString:@"1807,"];
        }
        else if (key.key == 1808)
        {
            [assessmentMsg appendString:@"1808,"];
        }
        else if (key.key == 1809)
        {
            [assessmentMsg appendString:@"1809,"];
        }
        else if (key.key == 1810)
        {
            [assessmentMsg appendString:@"1810,"];
        }
        else if (key.key == 1811)
        {
            [assessmentMsg appendString:@"1811,"];
        }
        else if (key.key == 1812)
        {
            [assessmentMsg appendString:@"1812,"];
        }
        else if (key.key == 1813)
        {
            [assessmentMsg appendString:@"1813,"];
        }
        else if (key.key == 1814)
        {
            [assessmentMsg appendString:@"1814,"];
        }
        else if (key.key == 1815)
        {
            [assessmentMsg appendString:@"1815,"];
        }
        else if (key.key == 1816)
        {
            [assessmentMsg appendString:@"1816,"];
        }
        else if (key.key == 1817)
        {
            [assessmentMsg appendString:@"1817,"];
        }
        else if (key.key == 1818)
        {
            [assessmentMsg appendString:@"1818,"];
        }
        else if (key.key == 1819)
        {
            [assessmentMsg appendString:@"1819,"];
        }
        else if (key.key == 1820)
        {
            [assessmentMsg appendString:@"1820,"];
        }
        else if (key.key == 1821)
        {
            [assessmentMsg appendString:@"1821,"];
        }
    }
    
    NSString* assessmentStr;
    if (assessmentMsg.length > 1)
    {
        
        assessmentStr = [assessmentMsg substringToIndex:[assessmentMsg length] - 1];
        
    }
    
    
    NSString* assentrySql = [NSString stringWithFormat:@"Select inputID from ticketInputs where ticketID = %@ and inputID in (%@) and inputInstance = %d and (deleted is null or deleted = 0) and (inputValue == '(null)' or inputValue is null or inputvalue = '' or inputValue = ' ')", ticketID, assessmentStr, assCount];
    NSString *requiredAssStr;
    @synchronized(g_SYNCDATADB)
    {
        requiredAssStr = [DAO executeSelectInputIds:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:assentrySql];
    }
    
    
    if (requiredAssStr.length > 1)
    {
        
        NSArray* requiredAssessmentArray =  [requiredAssStr componentsSeparatedByString:@","];
        NSString* inputID;
        for (inputID in requiredAssessmentArray)
        {
            if ([inputID isEqualToString:@"1801"])
            {
                [msg appendString:@"Skin "];
            }
            else if ([inputID isEqualToString:@"1802"])
            {
                [msg appendString:@"Head/Face "];
            }
            else if ([inputID isEqualToString:@"1803"])
            {
                [msg appendString:@"Neck "];
            }
            else if ([inputID isEqualToString:@"1804"])
            {
                [msg appendString:@"Chest/Lungs "];
            }
            else if ([inputID isEqualToString:@"1805"])
            {
                [msg appendString:@"Heart "];
            }
            else if ([inputID isEqualToString:@"1806"])
            {
                [msg appendString:@"LU Abdomen "];
            }
            
            else if ([inputID isEqualToString:@"1807"])
            {
                [msg appendString:@"LL Abdomen "];
            }
            else if ([inputID isEqualToString:@"1808"])
            {
                [msg appendString:@"RU Abdomen "];
            }
            
            else if ([inputID isEqualToString:@"1809"])
            {
                [msg appendString:@"RL Abdomen "];
            }
            else if ([inputID isEqualToString:@"1810"])
            {
                [msg appendString:@"GU "];
            }
            
            else if ([inputID isEqualToString:@"1811"])
            {
                [msg appendString:@"Back Cervical "];
            }
            else if ([inputID isEqualToString:@"1812"])
            {
                [msg appendString:@"Back Thoracic "];
            }
            
            else if ([inputID isEqualToString:@"1813"])
            {
                [msg appendString:@"Back Lumbar/Sacral "];
            }
            else if ([inputID isEqualToString:@"1814"])
            {
                [msg appendString:@"RU Extremities "];
            }
            else if ([inputID isEqualToString:@"1815"])
            {
                [msg appendString:@"RL Extremities "];
            }
            else if ([inputID isEqualToString:@"1816"])
            {
                [msg appendString:@"LU Extremities "];
            }
            else if ([inputID isEqualToString:@"1817"])
            {
                [msg appendString:@"LL Extremities "];
            }
            else if ([inputID isEqualToString:@"1818"])
            {
                [msg appendString:@"Left Eye "];
            }
            else if ([inputID isEqualToString:@"1819"])
            {
                [msg appendString:@"Right Eye "];
            }
            else if ([inputID isEqualToString:@"1820"])
            {
                [msg appendString:@"Mental Status "];
            }
            
            else if ([inputID isEqualToString:@"1821"])
            {
                [msg appendString:@"Neurological "];
            }
        }
    }
    
    
    return msg;
    
}


@end
