//
//  NumericViewController.m
//  iRescueMedic
//
//  Created by Nathan on 7/1/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "NumericViewController.h"
#import "DDPopoverBackgroundView.h"
#import "ClsTableKey.h"
#import "DAO.h"
#import "global.h"

@interface NumericViewController ()
{
    bool isKg;
}

@end

@implementation NumericViewController
@synthesize displayStr;
@synthesize lblWeight;
@synthesize btnWeight;
@synthesize txtDisplay;
@synthesize lblTitle;
@synthesize btnUTO;
@synthesize utoEnabled;
@synthesize delegate;
@synthesize btnDetails;
@synthesize unhide;
@synthesize popover;
@synthesize vitalSelected;
@synthesize detailsArray;
@synthesize detailsText;
@synthesize detailsSet;

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
    self.displayStr = [[NSMutableString alloc] init];
    self.detailsArray = [[NSMutableArray alloc] init];
    isKg = false;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (unhide == 1)
    {
        btnDetails.hidden = NO;
    }
    if (utoEnabled)
    {
        btnUTO.hidden = false;
    }
    else
    {
        btnUTO.hidden = true;
    }
    lblTitle.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtDisplay:nil];
    [super viewDidUnload];
}
- (IBAction)btn1Click:(id)sender {
    [displayStr appendString:@"1"];
    txtDisplay.text = displayStr;
}

- (IBAction)btn2Click:(id)sender {
    [displayStr appendString:@"2"];
    txtDisplay.text = displayStr;    
}

- (IBAction)btn3Click:(id)sender {
    [displayStr appendString:@"3"];
    txtDisplay.text = displayStr;    
}

- (IBAction)btn4Click:(id)sender {
    [displayStr appendString:@"4"];
    txtDisplay.text = displayStr;    
}

- (IBAction)btn5Click:(id)sender {
    [displayStr appendString:@"5"];
    txtDisplay.text = displayStr;    
}

- (IBAction)btn6Click:(id)sender {
    [displayStr appendString:@"6"];
    txtDisplay.text = displayStr;    
}

- (IBAction)btn7Click:(id)sender {
    [displayStr appendString:@"7"];
    txtDisplay.text = displayStr;    
}

- (IBAction)btn8Click:(id)sender {
    [displayStr appendString:@"8"];
    txtDisplay.text = displayStr;    
}

- (IBAction)btn9Click:(id)sender {
    [displayStr appendString:@"9"];
    txtDisplay.text = displayStr;    
}

- (IBAction)btn0Click:(id)sender {
  //  if ([displayStr length] > 0)
    {
        [displayStr appendString:@"0"];
        txtDisplay.text = displayStr;        
    }
}

- (IBAction)lbsToKgPressed:(id)sender
{
    if (isKg)
    {
        isKg = false;
        CGFloat value = [displayStr floatValue];
        if (value != 0)
        {
            CGFloat valueKG = value*2.20462262;
            displayStr = [NSMutableString stringWithFormat:@"%.2f", valueKG];
            txtDisplay.text = displayStr;
        }
        lblWeight.text = @"Lbs";
        [btnWeight setTitle:@"Pound to Kg" forState:UIControlStateNormal];
    }
    else
    {
        isKg = true;
        CGFloat value = [displayStr floatValue];
        if (value != 0)
        {
            CGFloat valueKG = value*0.45359237;
            displayStr = [NSMutableString stringWithFormat:@"%.2f", valueKG];
            txtDisplay.text = displayStr;
        }
        lblWeight.text = @"Kg";
        [btnWeight setTitle:@"Kg to Lbs" forState:UIControlStateNormal];
    }

}

- (IBAction)btnDetails:(UIButton*)sender {

    [detailsArray removeAllObjects];
    if (vitalSelected == 3002)
    {
        NSString* querySql = @"select VitalInputID, 'Inputs', VitalInputDesc from VitalInputLookup  where VitalInputID = 3102";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.detailsArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
        PopupDetailsViewController *popoverView =[[PopupDetailsViewController alloc] initWithNibName:@"PopupDetailsViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.array = detailsArray;
        popoverView.textSelected = self.detailsText;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(600, 350);
        popoverView.delegate = self;
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else if (vitalSelected == 3003)
    {
        NSString* querySql = @"select VitalInputID, 'Inputs', VitalInputDesc from VitalInputLookup  where VitalInputID = 3103";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.detailsArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
        PopupDetailsViewController *popoverView =[[PopupDetailsViewController alloc] initWithNibName:@"PopupDetailsViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.array = detailsArray;
        popoverView.textSelected = self.detailsText;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(600, 350);
        popoverView.delegate = self;
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else if (vitalSelected == 3004)
    {
        NSString* querySql = @"select VitalInputID, 'Inputs', VitalInputDesc from VitalInputLookup  where VitalInputID = 3104";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.detailsArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
        PopupDetailsViewController *popoverView =[[PopupDetailsViewController alloc] initWithNibName:@"PopupDetailsViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.array = detailsArray;
        popoverView.textSelected = self.detailsText;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(600, 350);
        popoverView.delegate = self;
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }
    else if (vitalSelected == 3005)
    {
        NSString* querySql = @"select VitalInputID, 'Inputs', VitalInputDesc from VitalInputLookup  where VitalInputID = 3105";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.detailsArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
        PopupDetailsViewController *popoverView =[[PopupDetailsViewController alloc] initWithNibName:@"PopupDetailsViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.array = detailsArray;
        popoverView.textSelected = self.detailsText;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(600, 350);
        popoverView.delegate = self;
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }
    else if (vitalSelected == 3006)
    {
        NSString* querySql = @"select VitalInputID, 'Inputs', VitalInputDesc from VitalInputLookup  where VitalInputID = 3106";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.detailsArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
        PopupDetailsViewController *popoverView =[[PopupDetailsViewController alloc] initWithNibName:@"PopupDetailsViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.array = detailsArray;
        popoverView.textSelected = self.detailsText;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(600, 350);
        popoverView.delegate = self;
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else if (vitalSelected == 3007)
    {
        NSString* querySql = @"select VitalInputID, 'Inputs', VitalInputDesc from VitalInputLookup  where VitalInputID = 3107";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.detailsArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
        PopupDetailsViewController *popoverView =[[PopupDetailsViewController alloc] initWithNibName:@"PopupDetailsViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.array = detailsArray;
        popoverView.textSelected = self.detailsText;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(600, 350);
        popoverView.delegate = self;
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }
    else if (vitalSelected == 3008)
    {
        NSString* querySql = @"select VitalInputID, 'Inputs', VitalInputDesc from VitalInputLookup  where VitalInputID = 3108";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.detailsArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
        PopupDetailsViewController *popoverView =[[PopupDetailsViewController alloc] initWithNibName:@"PopupDetailsViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.array = detailsArray;
        popoverView.textSelected = self.detailsText;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(600, 350);
        popoverView.delegate = self;
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
    }
    else if (vitalSelected == 3010)
    {
        NSString* querySql = @"select VitalInputID, 'Inputs', VitalInputDesc from VitalInputLookup  where VitalInputID = 3110";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.detailsArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
        PopupDetailsViewController *popoverView =[[PopupDetailsViewController alloc] initWithNibName:@"PopupDetailsViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.array = detailsArray;
        popoverView.textSelected = self.detailsText;        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(600, 350);
        popoverView.delegate = self;
        [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }

    
}

- (IBAction)btnBackClick:(id)sender {

    if ( ([displayStr length] == 2 ) && ([[displayStr substringToIndex:1] isEqualToString:@"0"]))
    {
        [displayStr setString:[displayStr substringToIndex:[displayStr length] - 2]];
    }
    else
    {
        if ([displayStr length] > 0)
        {
            [displayStr setString:[displayStr substringToIndex:[displayStr length] - 1]];
        }
    }
    txtDisplay.text = displayStr;
}

- (IBAction)btnClearClick:(id)sender {
    [displayStr setString:@""];
    txtDisplay.text = displayStr;
    
    lblWeight.text = @"Lbs";
    isKg = false;
    [btnWeight setTitle:@"Pound to Kg" forState:UIControlStateNormal];
}

- (IBAction)btnUTOClick:(id)sender
{
    [displayStr setString:@"UTO"];
    txtDisplay.text = displayStr;
}

- (IBAction)btnEnterClick:(id)sender {
    [delegate doneNumericClick];
}

- (IBAction)btnDecimalClick:(id)sender {
    if ([displayStr length] > 0)
    {
        [displayStr appendString:@"."];
        txtDisplay.text = displayStr;
    }
    else
    {
        [displayStr appendString:@"0."];
        txtDisplay.text = displayStr;
    }
}

- (void) doneDetailsClick
{
    PopupDetailsViewController *p = (PopupDetailsViewController *) self.popover.contentViewController;
    self.detailsText = p.textSelected;
    detailsSet = true;
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [delegate doneDetailClick];
}
@end
