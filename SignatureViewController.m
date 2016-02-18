//
//  SignatureViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/20/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 
#import "SignatureViewController.h"
#import "ClsSignatureImages.h"
#import "global.h"
#import "DAO.h"
#import "Base64.h"
#import "DDPopoverBackgroundView.h"  // Mani
#import "CustomSignatureView.h"
#import "PopoverPatientRefusalViewController.h"
#import "ClsTableKey.h"
#import "QAMessageViewController.h"
#import "ClsSignatureTypes.h"
#import "ClsUsers.h"
#import "sharedClsCommonVariables.h"

@interface SignatureViewController ()
{
    NSInteger multiSigID;
    NSString* patientName;
    bool multiPatientRefusalInSetting;
    bool multiPatientRefusalInTable;
}
@property (strong, nonatomic) OtherSigViewController* other;
@end

@implementation SignatureViewController

@synthesize sigPageControl;


@synthesize popover;
@synthesize witness;

@synthesize patient;
@synthesize party;
@synthesize refusalTrasport;
@synthesize patientRefusal;
@synthesize medic;
@synthesize other;
@synthesize unable;
@synthesize nurse;
@synthesize physician;
@synthesize guardian;

@synthesize imageArray;
@synthesize ticketID;
@synthesize delegate;
@synthesize btnNameLabel;
@synthesize medic2;
@synthesize refusalTreatment;
@synthesize signContainerView;
@synthesize guardianRefusal;
@synthesize signatureTypesArray;
@synthesize btnQAMessage;
@synthesize image1;

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
    ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    UIImage *toolBarIMG = [UIImage imageNamed:@"navigation_bar_bkg.png"];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
    NSString* ticketStatus = [g_SETTINGS objectForKey:@"TicketStatus"];
    if ([ticketStatus intValue] != 3)
    {
        self.btnQAMessage.hidden = true;
    }
    
	//[self.navigationController setNavigationBarHidden:TRUE];

    self.imageArray = [[NSMutableArray alloc] init];
  //  [self setViewUI];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    tabSaved = 0;

    signatureSeleted = -1;
    btnSelected = -1;
    signatureCount = 0;
    btnSelected = 0;
    multiSigID = -1;
    [self.imageArray removeAllObjects];
    multiPatientRefusalInTable = false;
    multiPatientRefusalInSetting = true;
    [self initializeView];
    
    
    @synchronized(g_SYNCDATADB)
    {
        patientName =  [DAO getPatientName:ticketID db:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue]];
    }
    btnNameLabel.title = patientName;
    [btnNameLabel setTintColor:[UIColor whiteColor]];
    [self loadData];
    [self setControl];
}


- (void)initializeView
{
    for (UIView* subview in self.signContainerView.subviews)
    {
        [subview removeFromSuperview];
    }
    NSString* sqlOutcome = [NSString stringWithFormat:@"select InputValue from TicketInputs where ticketID = %@ and InputID = 1401", ticketID];
    NSString* outcome;
    @synchronized(g_SYNCDATADB)
    {
        outcome = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlOutcome];
    }
    
    if ([outcome isEqualToString:@"Multi-Patient Refusal"])
    {
        NSString* disclaimerSql = @"Select SettingValue from Settings where SettingDesc = 'MPRDisclaimer'";
        NSString* disclaimer;
        @synchronized(g_SYNCLOOKUPDB)
        {
            disclaimer = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:disclaimerSql];
        }
        ClsSignatureTypes* multiType = [[ClsSignatureTypes alloc] init];
        multiType.signatureType = signatureTypesArray.count + 1;
        multiType.signatureTypeDesc = @"Multi-Patient Refusal";
        multiType.disclaimerText = disclaimer;
        multiType.signatureGroup = @"Patient Refusal";
        self.signatureTypesArray = [[NSMutableArray alloc] init];
        [self.signatureTypesArray addObject:multiType];
        multiType = nil;
 
    }
    
    else
    {
        NSString* sql = @"Select * from signatureTypes where signaturetypedesc != 'Patient unable/unwilling to sign' and signaturetypedesc != 'Multi-Patient Refusal' order by signaturetype";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.signatureTypesArray = [DAO selectSignatureTypes:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
        }
        if (multiPatientRefusalInSetting == true && multiPatientRefusalInTable == false)
        {
            NSString* disclaimerSql = @"Select SettingValue from Settings where SettingDesc = 'MPRDisclaimer'";
            NSString* disclaimer;
            @synchronized(g_SYNCLOOKUPDB)
            {
                disclaimer = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:disclaimerSql];
            }
            ClsSignatureTypes* multiType = [[ClsSignatureTypes alloc] init];
            multiType.signatureType = signatureTypesArray.count + 1;
            multiType.signatureTypeDesc = @"Multi-Patient Refusal";
            multiType.disclaimerText = disclaimer;
            multiType.signatureGroup = @"Patient Refusal";
            [self.signatureTypesArray addObject:multiType];
            multiType = nil;
            
            ClsSignatureTypes* unwilling = [[ClsSignatureTypes alloc] init];
            unwilling.signatureType = signatureTypesArray.count + 1;
            unwilling.signatureTypeDesc = @"Patient unable/unwilling to sign";
            unwilling.disclaimerText = @"My signature below indicates that, at the time of service, the patient was physically or mentally incapable of signing, and that no responsible parties were available or willing to sign on the patient's behalf.";
            unwilling.signatureGroup = @"Patient Refusal";
            [self.signatureTypesArray addObject:unwilling];
            unwilling = nil;
            
        }
    }

    signContainerView.backgroundColor = [UIColor clearColor];
    signContainerView.tag = 100;
    int nLeftOffset = 16;
	int nTopOffset = 10;
	int nIconSpacingX = 20 ;
	int nIconSpacingY = 20 ;
	
	int nIconWidth = 233;
	int nIconHeight = 152;
    int nPage = 4;
    CGRect rcPosition;
    
    
	for(int i=0; i<[signatureTypesArray count] ; i++)
	{
        ClsSignatureTypes* type = [signatureTypesArray objectAtIndex:i];
        if ([type.signatureTypeDesc containsString:@"Multi-Patient Refusal"])
        {
            multiSigID = i;
        }
		/////////////////////////////////////////////////////
		// Calculate this icons position
		int nColumn = i % nPage;
		int nRow = i / nPage;
		
		rcPosition = CGRectMake(nLeftOffset + nColumn * nIconWidth, nTopOffset + nRow * nIconHeight, nIconWidth, nIconHeight);
		rcPosition.origin.x += (nColumn * nIconSpacingX);
		rcPosition.origin.y += (nRow * nIconSpacingY);
        
        CustomSignatureView *CustomBtn = (CustomSignatureView *)[DAO getViewFromXib:@"CustomSignatureView" classname:[CustomSignatureView class]];
        CustomBtn.lblTitle.text = type.signatureTypeDesc;
 
        CustomBtn.frame = rcPosition;
        CustomBtn.tag = i;
        CustomBtn.parent = self;
        [self.signContainerView addSubview:CustomBtn];

    }
    
    signContainerView.contentSize = CGSizeMake(1024,rcPosition.origin.y+165);

}

- (void) loadData
{
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sql = [NSString stringWithFormat:@"Select * from ticketSignatures where ticketId = %@ and (deleted is null or deleted = 0)", ticketID];
    @synchronized(g_SYNCBLOBSDB)
    {
        self.imageArray = [DAO executeSelectSignatures:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
    }
    
    for (int i = 0; i< [imageArray count]; i++)
    {
        ClsSignatureImages* sig = [imageArray objectAtIndex:i];
        [Base64 initialize];
        NSData* data = [Base64 decode:sig.imageStr];
        sig.image = [UIImage imageWithData:data];

        for (int j=0; j< [signatureTypesArray count]; j++)
        {
            ClsSignatureTypes* type = [signatureTypesArray objectAtIndex:j];
            if (type.signatureType == sig.type)
            {
                sig.id = type.signatureTypeDesc;
                CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:j];
                [signButton setImage:sig.image];
            }
            
        }

    }
}


-(void) viewWillDisappear:(BOOL)animated
{
    if (tabSaved == 0)
    {
     [self saveTab];
    }
    [super viewWillDisappear:animated];
}

- (void) saveTab
{
    self.ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketSignatures where TicketID = %@", ticketID];
    NSInteger signatureID = 0;
    @synchronized(g_SYNCBLOBSDB)
    {
        signatureID = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
    }
    for (int i = 0; i < [imageArray count]; i++)
    {
        ClsSignatureImages* sigImage = [imageArray objectAtIndex:i];
        if (sigImage.type != multiSigID)
        {
            NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketSignatures where TicketID = %@ and SignatureType = %ld", ticketID, sigImage.type ];
            NSInteger count;
            @synchronized(g_SYNCBLOBSDB)
            {
                count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
            }
            if (count > 0)
            {
                newTicket = NO;
            }
            else
            {
                newTicket = YES;
            }
            
            NSData* data = UIImagePNGRepresentation(sigImage.image);
            
            [Base64 initialize];
            NSString *sigEncoded = [Base64 encode:data];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
            NSDate *now = [[NSDate alloc] init];
            NSString *dateString = [format stringFromDate:now];
            
            if (newTicket == YES)
            {
                signatureID++;
                @synchronized(g_SYNCBLOBSDB)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketSignatures(LocalTicketID, TicketID, SignatureID, SignatureType, SignatureText, SignatureString, SignatureTime) Values(0, %@, %ld, %ld, '%@', '%@', '%@')", ticketID, signatureID, sigImage.type, [self removeNull:sigImage.name ], sigEncoded, dateString];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
                }
            }
            else
            {
                @synchronized(g_SYNCBLOBSDB)
                {
                    sqlStr = [NSString stringWithFormat:@"UPDATE TicketSignatures Set signatureText = '%@', signatureString = '%@', deleted = %d, isUploaded = 0 where TicketID = %@ and signatureType = %ld", [self removeNull:sigImage.name], sigEncoded, sigImage.deleted, ticketID, sigImage.type];
                    [DAO executeUpdate:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
                }
            }
            
        }
        
        }
    tabSaved = 1;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {


    [super viewDidUnload];
}




- (void)signatureButtonPressed:(UIButton *)sender
{
    CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:((UIView *)sender).tag];
    if (signButton.selected && ((UIView *)sender).tag != multiSigID)
    {
        btnSelected = ((UIView *)sender).tag;
    }
    else
    {
        int tag = (int) ((UIView *)sender).tag;
        ClsSignatureTypes* type = [signatureTypesArray objectAtIndex:tag];
        if ( [type.signatureTypeDesc containsString:@"Person/Entity Receiving Patient"])
        {
            signatureSeleted = tag;
            [sender resignFirstResponder];
            self.nurse =[[OtherSigViewController alloc] initWithNibName:@"OtherSigViewController" bundle:nil];
            nurse.view.backgroundColor = [UIColor whiteColor];
            nurse.view.tag = ((UIView *)sender).tag;
            nurse.sigType = tag;
            nurse.labelTitle = type.signatureTypeDesc;
            self.popover =[[UIPopoverController alloc] initWithContentViewController:nurse];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(550, 500);
            nurse.delegate = self;
            CGRect frame = ((UIView *)sender).frame;
            if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 350 && frame.origin.y < 375)
            {
                frame.origin.y -= 122;
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 5 && frame.origin.y < 25)
            {
                frame.origin.y += 122;
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else
            {
                frame.origin.y+= 122;
                
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        }
        else if ([type.signatureTypeDesc containsString:@"Other"])
        {
            signatureSeleted = tag;
            [sender resignFirstResponder];
            self.nurse =[[OtherSigViewController alloc] initWithNibName:@"OtherSigViewController" bundle:nil];
            nurse.view.backgroundColor = [UIColor whiteColor];
            nurse.view.tag = ((UIView *)sender).tag;
            nurse.sigType = tag;
            nurse.labelTitle = type.signatureTypeDesc;
            self.popover =[[UIPopoverController alloc] initWithContentViewController:nurse];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(550, 500);
            nurse.delegate = self;
            CGRect frame = ((UIView *)sender).frame;
            if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 350 && frame.origin.y < 375)
            {
                frame.origin.y -= 122;
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 5 && frame.origin.y < 25)
            {
                frame.origin.y += 122;
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else
            {
                frame.origin.y+= 122;
                
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        }
        else if ( [type.signatureTypeDesc containsString:@"Patient Refused Transport"])
        {
            signatureSeleted = tag;
            [sender resignFirstResponder];
            PopoverPatientRefusalViewController *view =[[PopoverPatientRefusalViewController alloc] initWithNibName:@"PopoverPatientRefusalViewController" bundle:nil];
            view.view.backgroundColor = [UIColor whiteColor];
            view.view.tag = tag;
            refusalTag = tag;
            senderFrame = ((UIView *)sender).frame;
            self.popover =[[UIPopoverController alloc] initWithContentViewController:view];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(800, 500);
            view.delegate = self;
            CGRect frame = ((UIView *)sender).frame;
            if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 350 && frame.origin.y < 375)
            {
                frame.origin.y -= 122;
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 5 && frame.origin.y < 25)
            {
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else
            {
                frame.origin.y+= 122;
                
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
        }
        
        else if ([type.signatureTypeDesc containsString:@"unable/unwilling"])
        {
            signatureSeleted = tag;
            [sender resignFirstResponder];
            self.unable =[[PatientSigUnableViewController alloc] initWithNibName:@"PatientSigUnableViewController" bundle:nil];
            
            unable.view.backgroundColor = [UIColor whiteColor];
            unable.view.tag = ((UIView *)sender).tag;
            unable.sigType = tag;
            unable.titleStr = type.signatureTypeDesc;
            self.popover =[[UIPopoverController alloc] initWithContentViewController:unable];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(550, 480);
            unable.delegate = self;
            CGRect frame = ((UIView *)sender).frame;
            if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 350 && frame.origin.y < 375)
            {
                frame.origin.y -= 122;
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 5 && frame.origin.y < 25)
            {
                frame.origin.y += 122;
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else
            {
                frame.origin.y+= 122;
                
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
        }
        
        else if ([type.signatureTypeDesc containsString:@"Multi-Patient Refusal"])
        {
            signatureSeleted = tag;
            [sender resignFirstResponder];
            PopoverMultiPatientRefusalViewController *view =[[PopoverMultiPatientRefusalViewController alloc] initWithNibName:@"PopoverMultiPatientRefusalViewController" bundle:nil];
            view.view.backgroundColor = [UIColor whiteColor];
            view.view.tag = tag;
            
            self.popover =[[UIPopoverController alloc] initWithContentViewController:view];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(800, 500);
            view.delegate = self;
            refusalTag = tag;
         //   senderFrame = CGRectMake(sender.frame.origin.x + 50, sender.frame.origin.y - 100, sender.frame.size.width, sender.frame.size.height - 200);
          //  [self.popover presentPopoverFromRect:senderFrame inView:self.view permittedArrowDirections:0 animated:YES];
            CGRect frame = ((UIView *)sender).frame;
            if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 350 && frame.origin.y < 375)
            {
                frame.origin.y -= 122;
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 5 && frame.origin.y < 25)
            {
                frame.origin.y += 122;
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else if (frame.origin.y > 350 && frame.origin.y < 375)
            {
                   senderFrame = CGRectMake(sender.frame.origin.x + 50, sender.frame.origin.y - 100, sender.frame.size.width, sender.frame.size.height - 200);
                  [self.popover presentPopoverFromRect:senderFrame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else
            {
                frame.origin.y+= 122;
                
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            
        }
        
        else
        {
            signatureSeleted = tag;
            [sender resignFirstResponder];
            self.guardian =[[SignaturePageViewController alloc] initWithNibName:@"SignaturePageViewController" bundle:nil];
            guardian.view.backgroundColor = [UIColor whiteColor];
            guardian.view.tag = ((UIView *)sender).tag;
            guardian.sigType = tag;
            guardian.labelTitle = type.signatureTypeDesc;
            if ([type.signatureTypeDesc containsString:@"Patient"])
            {
                guardian.name = [patientName stringByReplacingOccurrencesOfString:@"Patient: " withString:@""];;
            }
            else if ([type.signatureTypeDesc containsString:@"Primary Medic"])
            {
                ClsUsers* user = [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers;
                guardian.name = [NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName];
            }
            self.popover =[[UIPopoverController alloc] initWithContentViewController:guardian];
            self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
            self.popover.popoverContentSize = CGSizeMake(550, 500);
            guardian.delegate = self;
            CGRect frame = ((UIView *)sender).frame;
            if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 350 && frame.origin.y < 375)
            {
                frame.origin.y -= 122;
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else if (frame.origin.x > 250 && frame.origin.x < 600 && frame.origin.y > 5 && frame.origin.y < 25)
            {
                frame.origin.y += 122;
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:0 animated:YES];
            }
            else
            {
                frame.origin.y+= 122;
                
                [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }

            
        }
        
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

- (IBAction)btnClearSelectedClick:(id)sender {
    if (btnSelected > -1)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic for iPad" message:@"Are you sure you want to permanently delete this signature?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = 1;
        [alert show];
    }
}

- (IBAction)btnClearAllClick:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic for iPad" message:@"Are you sure you want to permanently delete all signatures?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 2;
    [alert show];
}

-(void) cancelPatientRefusal
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

-(void) submitPatientRefusal
{
    [self.popover dismissPopoverAnimated:YES];
    signatureSeleted = 5;

    self.refusalTrasport =[[SignaturePageViewController alloc] initWithNibName:@"SignaturePageViewController" bundle:nil];
    refusalTrasport.sigType = 5;
    refusalTrasport.view.tag = refusalTag;
    refusalTrasport.view.backgroundColor = [UIColor whiteColor];
    refusalTrasport.labelTitle = @"Patient Refused Transport Signature";
    self.popover =[[UIPopoverController alloc] initWithContentViewController:refusalTrasport];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(550, 480);
    refusalTrasport.delegate = self;
    senderFrame.origin.y+= 122;
    [self.popover presentPopoverFromRect:senderFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

-(void) cancelMultiRefusal
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

-(void) submitMultiRefusal
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    PopoverMultiRefusalSignatureViewController *view =[[PopoverMultiRefusalSignatureViewController alloc] initWithNibName:@"PopoverMultiRefusalSignatureViewController" bundle:nil];
    view.view.backgroundColor = [UIColor whiteColor];
    view.view.tag = refusalTag;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:view];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(600, 500);
    view.delegate = self;
    
    [self.popover presentPopoverFromRect:senderFrame inView:self.view permittedArrowDirections:0 animated:YES];
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

- (void) cancelMultiSigRefusal
{
    PopoverMultiRefusalSignatureViewController *p = (PopoverMultiRefusalSignatureViewController *) popover.contentViewController;
    //self.image1.image = p.image;
    bool needToSave = p.needToSave;
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    if (needToSave)
    {
        signatureSeleted = 11;
        PopoverMultiPatientRefusalViewController *view =[[PopoverMultiPatientRefusalViewController alloc] initWithNibName:@"PopoverMultiPatientRefusalViewController" bundle:nil];
        view.view.backgroundColor = [UIColor whiteColor];
        view.view.tag = refusalTag;
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:view];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(800, 500);
        view.delegate = self;
        [self.popover presentPopoverFromRect:senderFrame inView:self.view permittedArrowDirections:0 animated:YES];
        
    }
    
}

- (IBAction)btnMainMenuClick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [delegate dismissViewControl];
}

- (IBAction)btnWitnessClick:(UIButton*)sender {
    signatureSeleted = 1;
    [sender resignFirstResponder];
    self.witness =[[SignaturePageViewController alloc] initWithNibName:@"SignaturePageViewController" bundle:nil];
    witness.view.backgroundColor = [UIColor whiteColor];

    self.popover =[[UIPopoverController alloc] initWithContentViewController:witness];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(550, 500);
    witness.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnPatientClick:(UIButton*)sender {
    signatureSeleted = 2;
    [sender resignFirstResponder];
    self.patient =[[SignaturePageViewController alloc] initWithNibName:@"SignaturePageViewController" bundle:nil];
    patient.view.backgroundColor = [UIColor whiteColor];

    self.popover =[[UIPopoverController alloc] initWithContentViewController:patient];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(550, 500);
    patient.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnResponsiblePartyClick:(UIButton*)sender {
    signatureSeleted = 3;
    [sender resignFirstResponder];
    self.party =[[SignaturePageViewController alloc] initWithNibName:@"SignaturePageViewController" bundle:nil];
    party.view.backgroundColor = [UIColor whiteColor];

    self.popover =[[UIPopoverController alloc] initWithContentViewController:party];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(550, 500);
    party.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)btnPatientResfusalClick:(UIButton*)sender {
/*    signatureSeleted = 4;
    [sender resignFirstResponder];
    self.refusal =[[SignaturePageViewController alloc] initWithNibName:@"SignaturePageViewController" bundle:nil];
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:refusal];
    
    self.popover.popoverContentSize = CGSizeMake(550, 400);
    refusal.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES]; */
    signatureSeleted = 4;
//    ClsSignatureImages* sigImage = [[ClsSignatureImages alloc] init];
//    sigImage.id = @"Patient Refusal";
//    sigImage.type = 6;
//    [imageArray addObject:sigImage];
}

- (IBAction)btnMedicClick:(UIButton*)sender {
    signatureSeleted = 5;
    [sender resignFirstResponder];
    self.medic =[[SignaturePageViewController alloc] initWithNibName:@"SignaturePageViewController" bundle:nil];
    medic.view.backgroundColor = [UIColor whiteColor];

    self.popover =[[UIPopoverController alloc] initWithContentViewController:medic];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(550, 500);
    medic.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnOtherClick:(UIButton*)sender {
    signatureSeleted = 6;
    [sender resignFirstResponder];
    self.other =[[OtherSigViewController alloc] initWithNibName:@"OtherSigViewController" bundle:nil];
    other.view.backgroundColor = [UIColor whiteColor];

    self.popover =[[UIPopoverController alloc] initWithContentViewController:other];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(550, 500);
    //other.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnUnableClick:(UIButton*)sender {
    signatureSeleted = 7;
    [sender resignFirstResponder];
    self.unable =[[PatientSigUnableViewController alloc] initWithNibName:@"PatientSigUnableViewController" bundle:nil];
    unable.view.backgroundColor = [UIColor whiteColor];

    self.popover =[[UIPopoverController alloc] initWithContentViewController:unable];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(550, 500);
    unable.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)btnNurseClick:(UIButton*)sender {
    signatureSeleted = 8;
    [sender resignFirstResponder];
    self.nurse =[[OtherSigViewController alloc] initWithNibName:@"OtherSigViewController" bundle:nil];
    nurse.view.backgroundColor = [UIColor whiteColor];

    self.popover =[[UIPopoverController alloc] initWithContentViewController:nurse];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(550, 500);
    nurse.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}



-(void) donePatientUnableSigningClick
{
    PatientSigUnableViewController *p = (PatientSigUnableViewController *) popover.contentViewController;
    bool needToSave = p.needToSave;
    if (needToSave)
    {
        ClsSignatureImages* sigImage = [[ClsSignatureImages alloc] init];
        sigImage.image = p.image;
        sigImage.name = p.txtName.text;
        CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:p.view.tag];
        
        [signButton setImage:p.image];
        

            sigImage.id = [NSString stringWithFormat:@"%@: No PT Signature\n%@", p.txtCrew, p.txtName];
            sigImage.type = 0;


        [imageArray addObject:sigImage];
       // [self loadImages];
    }
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}


- (void) doneOtherSigningClick
{
    OtherSigViewController* p = (OtherSigViewController *) popover.contentViewController;
    self.image1.image = p.image;
    bool needToSave = p.needToSave;
    if (needToSave)
    {
        ClsSignatureImages* sigImage = [[ClsSignatureImages alloc] init];
        sigImage.image = p.image;
        
        sigImage.name = [NSString stringWithFormat:@"%@-%@", p.txtName.text, p.btnSignature.titleLabel.text];
        
        CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:p.view.tag];
        [signButton setImage:p.image];
        
        if (signatureSeleted == 3)
        {
            sigImage.id = @"Person/Entity Receiving Patient";
            sigImage.type = 3;
        }
        else if (signatureSeleted == 8)
        {
            sigImage.id = @"Other";
            sigImage.type = 8;
        }
        
        [imageArray addObject:sigImage];
    }
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

- (void) doneSigningClick
{
    SignaturePageViewController *p = (SignaturePageViewController *) popover.contentViewController;
    
    self.image1.image = p.image;
    bool needToSave = p.needToSave;
    if (needToSave)
    {
        ClsSignatureImages* sigImage = [[ClsSignatureImages alloc] init];
        sigImage.image = p.image;

        sigImage.name = p.txtName.text;

        CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:p.view.tag];
        
        [signButton setImage:p.image];
        ClsSignatureTypes* type = [signatureTypesArray objectAtIndex:signatureSeleted];
        sigImage.id = type.signatureTypeDesc;
        sigImage.type = type.signatureType;
        

        [imageArray addObject:sigImage];
      //  [self loadImages];
    }   
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
}


- (void) setControl
{
 	for(int i=0; i<[signatureTypesArray count] ; i++)
	{
        CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:i];
        signButton.lblTitle.textColor = [UIColor blackColor];
    }
    
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
             sql = [NSString stringWithFormat:@"select SignatureType, SignatureTypeDesc, SignatureGroup from SignatureTypes st inner join OutcomeRequiredSignatures ori on st.SignatureGroup = ori.SignatureGroupID where  ori.outcomeID = %ld", key.key ];
        }
        else
        {
            sql = [NSString stringWithFormat:@"select inputID, 'Inputs', 'id' from outcomes o inner join OutcomeRequiredItems ori on o.outcomeID = ori.outcomeID where o.description = '%@' and o.outcomeID = %ld" , outcomeVal, key.key];
            
        }
        
    }
    else
    {
            sql = [NSString stringWithFormat:@"select SignatureType, SignatureTypeDesc, SignatureGroup from SignatureTypes st inner join OutcomeRequiredSignatures ori on st.SignatureGroup = ori.SignatureGroupID where  ori.outcomeID = 0" ];
    }
    NSMutableArray* requiredArray;
    @synchronized(g_SYNCLOOKUPDB)
    {
        requiredArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    for (int i = 0; i < [requiredArray count]; i++)
    {
        ClsTableKey* key = [requiredArray objectAtIndex:i];
        for (int j = 0; j < [signatureTypesArray count]; j++)
        {
            ClsSignatureTypes * type = [signatureTypesArray objectAtIndex:j];
            if (key.key == type.signatureType)
            {
                if ([key.desc isEqualToString:@"Medic"])
                {
                    if  ([[g_SETTINGS objectForKey:@"TwoMedicSigsRequired"] isEqualToString:@"1"])
                    {
                        CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:j];
                        signButton.lblTitle.textColor = [UIColor redColor];
                    }
                    else
                    {
                        if ([type.signatureTypeDesc isEqualToString:@"Primary Medic"] || [type.signatureTypeDesc isEqualToString:@"In Charge Medic"] )
                        {
                            CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:j];
                            signButton.lblTitle.textColor = [UIColor redColor];
                        }
                    }
                }
                else
                {
                    
                    CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:j];
                    signButton.lblTitle.textColor = [UIColor redColor];
                }

            }
            
        }
        
    }
    
    if  ([[g_SETTINGS objectForKey:@"MedicSignatureRequired"] isEqualToString:@"1"])
    {
        for (int j = 0; j < [signatureTypesArray count]; j++)
        {
            ClsSignatureTypes * type = [signatureTypesArray objectAtIndex:j];
            if ([type.signatureTypeDesc isEqualToString:@"Primary Medic"] || [type.signatureTypeDesc isEqualToString:@"In Charge Medic"])
            {
                CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:j];
                signButton.lblTitle.textColor = [UIColor redColor];
            }
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

- (void) donePerformedByClick
{
    
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0)
    {
        if (buttonIndex == 1)
        {
            exit(0);
        } else
        {
            
        }
    }
    else if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:btnSelected];
            [signButton clearImage];
            ClsSignatureTypes* type = [signatureTypesArray objectAtIndex:btnSelected];
            for (int i = 0; i< [imageArray count]; i++)
            {
                ClsSignatureImages* sigIm = [imageArray objectAtIndex:i];
                if (sigIm.type == type.signatureType)
                {
                    sigIm.deleted = 1;
                }
            }

            btnSelected = -1;
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            
            for (int i = 0; i< [imageArray count]; i++)
            {
                ClsSignatureImages* sigIm = [imageArray objectAtIndex:i];
                
                sigIm.deleted = 1;
                
            }
            
            for(int i=0; i<13 ; i++)
            {
                CustomSignatureView *signButton = (CustomSignatureView*)[signContainerView viewWithTag:i];
                if (signButton.selected)
                {
                    [signButton clearImage];
                    btnSelected = -1;
                }
            }
        }
    }
}
@end
