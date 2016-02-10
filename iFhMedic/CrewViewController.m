//
//  CrewViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/26/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CrewViewController.h"
#import "DAO.h"
#import "global.h"
#import "ClsUsers.h"
#import "ClsCrewInfo.h"
#import "CrewInfoCell.h"
#import "DDPopoverBackgroundView.h"  // Mani
#import "ClsTableKey.h"


@interface CrewViewController ()
{
    NSInteger incidentRowSelected;
}

@end

@implementation CrewViewController
@synthesize txtName;
@synthesize txtID;
@synthesize btnCrewType;
@synthesize btnAdd;
@synthesize usersArray;
@synthesize arrayActiveUsers;
@synthesize typeArray;
@synthesize popOver;
@synthesize primaryUser;
@synthesize primaryUserId;
@synthesize viewLabel;
@synthesize lblName;
@synthesize lblCertification;
@synthesize lblID;
@synthesize btnSelectCrew;
@synthesize lblType;
@synthesize tvCrew;
@synthesize btnPrimaryUser;
@synthesize arrayUnitUsers;
@synthesize table;
@synthesize shiftArray;
@synthesize containerView3;
@synthesize btnSelectShift;
@synthesize affectCurrentTicket;
@synthesize segmentControl;
@synthesize searchbar;
@synthesize ticketCrewArray;

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
    txtName.enabled = false;
    txtID.enabled = false;
    btnCrewType.enabled = false;
    btnAdd.enabled = false;
    self.primaryUserId = [g_SETTINGS objectForKey:@"UserID"];
    btnCrewType.hidden = YES;
    txtName.hidden = YES;
    txtID.hidden = YES;
    btnAdd.hidden = YES;
    lblName.hidden = YES;
    lblID.hidden = YES;
    lblType.hidden = YES;
    txtName.delegate = self;
    txtID.delegate = self;
    cellSelected = -1;
    
    tvCrew.layer.borderColor = [UIColor blackColor].CGColor;
    tvCrew.layer.borderWidth = 5.0f;
    unitSelected = true;
    [self setViewUI];
    NSString* unit = [g_SETTINGS objectForKey:@"UnitName" ];
    [self.btnAllUnits setTitle:unit forState:UIControlStateNormal];
    crewRowSelected = -1;
    userRowSelected = -1;
    searchbar.delegate = self;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (affectCurrentTicket == 1)
    {
        self.ticketCrewArray = [[NSMutableArray alloc] init];
        [self loadTicketCrew];
        [self setValues];
    }
    else
    {
        ticketCrewArray = g_CREWARRAY;
        [self setValues];
    }
}


- (void) prepareView
{
    /*    for (UIView *view in [scrollview subviews])
     {
     [view removeFromSuperview];
     }
     int i = 0;
     float step = 40;
     
     while (i<=6) {
     
     UIView *views = [[UIView alloc]
     initWithFrame:CGRectMake(0, 0 + step*i,
     821, 40)];
     views.backgroundColor=[UIColor cyanColor];
     views.layer.borderWidth = 1;
     [views setTag:i];
     [scrollview addSubview:views];
     i++;
     } */
    
    /*    for (int j = 0; j < [g_CREWARRAY count]; j++)
     {
     ClsUsers* user = [g_CREWARRAY objectAtIndex:j];
     for (UIView *view in [scrollview subviews])
     {
     if (view.tag == j )
     {
     
     UILabel* primary = [[UILabel alloc] init];
     primary.frame = CGRectMake(10, 1 + 40*j, 100, 38);
     primary.backgroundColor =[UIColor cyanColor];
     if (j == 0)
     {
     primary.text = @"Primary";
     }
     else
     {
     primary.text = @"Secondary";
     }
     [view addSubview:primary];
     
     UILabel* name = [[UILabel alloc] init];
     name.frame = CGRectMake(210, 1 + 40*j, 120, 38);
     name.backgroundColor =[UIColor cyanColor];
     name.text = [NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName];
     [view addSubview:name];
     
     UILabel* id = [[UILabel alloc] init];
     id.frame = CGRectMake(490, 1 + 40*j, 120, 38);
     id.backgroundColor =[UIColor cyanColor];
     id.text = [NSString stringWithFormat:@"%@", user.userIDNumber];
     [view addSubview:id];
     
     }
     }
     }
     for (int j = 0; j < [g_CREWARRAY count]; j++)
     {
     ClsUsers* user = [g_CREWARRAY objectAtIndex:j];
     
     UILabel* primary = [[UILabel alloc] init];
     primary.frame = CGRectMake(10, 1 + 40*j, 100, 38);
     primary.backgroundColor =[UIColor cyanColor];
     if (j == 0)
     {
     primary.text = @"Primary";
     }
     else
     {
     primary.text = @"Additional Crew";
     }
     [primary sizeToFit];
     [scrollview addSubview:primary];
     
     UILabel* name = [[UILabel alloc] init];
     name.frame = CGRectMake(210, 1 + 40*j, 120, 38);
     name.backgroundColor =[UIColor cyanColor];
     name.text = [NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName];
     [name sizeToFit];
     [scrollview addSubview:name];
     
     UILabel* id = [[UILabel alloc] init];
     id.frame = CGRectMake(490, 1 + 40*j, 120, 38);
     id.backgroundColor =[UIColor cyanColor];
     id.text = [NSString stringWithFormat:@"%d", user.userID];
     [id sizeToFit];
     [scrollview addSubview:id];
     
     UILabel* cert = [[UILabel alloc] init];
     cert.frame = CGRectMake(620, 1 + 40*j, 120, 38);
     cert.backgroundColor =[UIColor cyanColor];
     cert.text = [NSString stringWithFormat:@"%@", user.userIDNumber];
     [cert sizeToFit];
     [scrollview addSubview:cert];
     
     
     } */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSegmentControlClick:(id)sender {
    if (segmentControl.selectedSegmentIndex == 0)
    {
        //  NSString* unit = [g_SETTINGS objectForKey:@"UnitName" ];
        
        //  NSString* unitStr = [NSString stringWithFormat:@"%@", unit ];
        // [self.btnAllUnits setTitle:unitStr forState:UIControlStateNormal];
        showUsers = ALL_USERS_FROM_CURRENT_UNIT;
        self.usersArray = self.arrayUnitUsers;
        [self.table reloadData];
        unitSelected = true;
    }
    else
    {
        // [self.btnAllUnits setTitle:@"All Users" forState:UIControlStateNormal];
        showUsers = ALL_ACTIVE_USERS_FROM_ALL_UNITS;
        self.usersArray = self.arrayActiveUsers;
        [self.table reloadData];
        unitSelected = false;
    }
}

- (IBAction)btnAllUnits:(id)sender {
    
    // self.usersArray
    // self.arrayAllUsers
    // self.arrayActiveUsers
    
    if (unitSelected) {
        
        [self.btnAllUnits setTitle:@"All Users" forState:UIControlStateNormal];
        showUsers = ALL_ACTIVE_USERS_FROM_ALL_UNITS;
        self.usersArray = self.arrayActiveUsers;
        [self.table reloadData];
        unitSelected = false;
    }
    else {
        NSString* unit = [g_SETTINGS objectForKey:@"UnitName" ];
        
        NSString* unitStr = [NSString stringWithFormat:@"%@", unit ];
        [self.btnAllUnits setTitle:unitStr forState:UIControlStateNormal];
        showUsers = ALL_USERS_FROM_CURRENT_UNIT;
        self.usersArray = self.arrayUnitUsers;
        [self.table reloadData];
        unitSelected = true;
    }
    
}

- (IBAction)btnDoneClick:(id)sender {
    affectCurrentTicket = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)selectCrewClick:(UIButton*)sender {
    
    functionSelected = 1;
    txtID.text = @"";
    txtName.text = @"";
    [btnCrewType setTitle:@"" forState:UIControlStateNormal];
    PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
    
    NSString* sql = @"Select u.UserID, u.UserFirstname, u.UserLastName, u.UserAddress, u.UserCity, u.UserState, u.UserZip, u.UserAge, u.UserUnit, u.UserActive, u.UserCertification, u.UserCertStart, u.UserCertEnd, u.UserCertNum, u.UserPassword, u.UserGroup, c.CertName as UserIDNumber from users u left join certification c on u.UserCertification = c.CertUID";
    @synchronized(g_SYNCLOOKUPDB)
    {
        self.usersArray = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    ClsUsers* user = [[ClsUsers alloc] init];
    user.userID = 0;
    user.userFirstName = @"Other";
    user.userLastName = @" ";
    user.userUnit = 0;
    user.userPassword = @" ";
    user.userIDNumber = @" ";
    [usersArray addObject:user];
    popoverView.arrayUsers = self.usersArray;
    popoverView.functionSelected = 1;
    
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popOver.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popOver.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}

- (IBAction)selectCrewTypeClick:(UIButton*)sender {
    functionSelected = 2;
    PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    if ([typeArray count] < 1)
    {
        self.typeArray = [[NSMutableArray alloc] init];
        ClsUsers* user = [[ClsUsers alloc] init];
        user.userID = 0;
        user.userFirstName = @"Student/Intern";
        user.userLastName = @" ";
        user.userUnit = 0;
        user.userPassword = @" ";
        user.userIDNumber = @"Student/Intern";
        [self.typeArray addObject:user];
        ClsUsers* user1 = [[ClsUsers alloc] init];
        user1.userID = 0;
        user1.userFirstName = @"Ride";
        user1.userLastName = @"Along";
        user1.userUnit = 0;
        user1.userPassword = @" ";
        user1.userIDNumber = @"Ride Along";
        [self.typeArray addObject:user1];
        ClsUsers* user2 = [[ClsUsers alloc] init];
        user2.userID = 0;
        user2.userFirstName = @"Police ";
        user2.userLastName = @"Officer";
        user2.userUnit = 0;
        user2.userPassword = @" ";
        user2.userIDNumber = @"Police Officer";
        [self.typeArray addObject:user2];
        ClsUsers* user3 = [[ClsUsers alloc] init];
        user3.userID = 0;
        user3.userFirstName = @"FireFighter";
        user3.userLastName = @" ";
        user3.userUnit = 0;
        user3.userPassword = @" ";
        user3.userIDNumber = @"FireFighter";
        [self.typeArray addObject:user3];
        ClsUsers* user4 = [[ClsUsers alloc] init];
        user4.userID = 0;
        user4.userFirstName = @"Precept";
        user4.userLastName = @" ";
        user4.userUnit = 0;
        user4.userPassword = @" ";
        user4.userIDNumber = @"Precept";
        [self.typeArray addObject:user4];
    }
    
    
    popoverView.arrayUsers = self.typeArray;
    popoverView.functionSelected = 1;
    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
    
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popOver.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popOver.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
    
}

- (IBAction)btnAddClick:(id)sender {
    NSArray* userNameArray = [txtName.text componentsSeparatedByString: @" "];
    if ([userNameArray count] < 2)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Enter Name" message:@"Please enter crew first name and last name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    ClsCrewInfo* crew = [[ClsCrewInfo alloc] init];
    
    @try {
        if ([txtID.text length] < 1)
        {
            crew.id = 0;
        }
        else
        {
            crew.id = [NSString stringWithFormat:@"%@", txtID.text ];
        }
    }
    @catch (NSException *exception) {
        crew.id = 0;
    }
    @finally {
        
    }
    crew.name = [NSString stringWithFormat:@"%@, %@", [userNameArray objectAtIndex:1], [userNameArray objectAtIndex:0] ];
    crew.certification = btnCrewType.titleLabel.text;
    crew.role = @"Additional Crew";
    if (affectCurrentTicket == 1)
    {
        [ticketCrewArray addObject:crew];
    }
    else
    {
        [ticketCrewArray addObject:crew];
    }
    [tvCrew reloadData];
}

- (IBAction)btnLogoutClick:(id)sender {
}

- (IBAction)btnAddCrew:(id)sender {
    if (crewRowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Select Crew" message:@"Please select a crew below for this function." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if (usersArray.count > crewRowSelected)
        {
            ClsUsers* user = [usersArray objectAtIndex:crewRowSelected];
            bool found = false;
            for (int i = 0; i < [ticketCrewArray count]; i++)
            {
                ClsCrewInfo* info = [ticketCrewArray objectAtIndex:i];
                if (user.userID == [info.id intValue])
                {
                    found = true;
                    
                }
            }
            
            if (!found)
            {
                
                ClsCrewInfo* crew = [[ClsCrewInfo alloc] init];
                
                crew.name = [NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName ];
                if (user.userID != 0)
                {
                    crew.id = [NSString stringWithFormat:@"%d", user.userID];
                }
                else
                {
                    crew.id = user.userIDNumber;
                }
                
                if (affectCurrentTicket == 1)
                {
                    [ticketCrewArray addObject:crew];
                }
                else
                {
                    [ticketCrewArray addObject:crew];
                }
                [tvCrew reloadData];
            }
            else
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Crew Already Added" message:@"Crew already added." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                crewRowSelected = -1;
                return;
            }
            crewRowSelected = -1;
            
            if (affectCurrentTicket == 1)
            {
                NSMutableString* crewIds = [[NSMutableString alloc] init];
                for (int i =0; i<[ticketCrewArray count]; i++)
                {
                    ClsCrewInfo* crew = [ticketCrewArray objectAtIndex:i];
                    
                    if (i == [ticketCrewArray count] - 1)
                    {
                        [crewIds appendString:[NSString stringWithFormat:@"%@", crew.id]];
                    }
                    else
                    {
                        [crewIds appendString:[NSString stringWithFormat:@"%@|", crew.id]];
                    }
                }
                NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
                NSString* sql = [NSString stringWithFormat:@"Update tickets set ticketCrew = '%@', isUploaded = 0 where ticketID = %@", crewIds, ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                    
                }
            }
            
        }  // end if (userarray.count > userselected)
        
    }
    
}

- (IBAction)btnAddMember:(UIButton*)sender {
    
    CustomCrewViewController *popoverView =[[CustomCrewViewController alloc] initWithNibName:@"CustomCrewViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
    
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popOver.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popOver.popoverContentSize = CGSizeMake(600, 600);
    popoverView.delegate = self;
    
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
}

- (IBAction)btnDeleteClick:(id)sender {
    if (userRowSelected < 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Select Crew" message:@"Please select a crew below for this function." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        [ticketCrewArray removeObjectAtIndex:userRowSelected];
        userRowSelected = -1;
        [tvCrew reloadData];
    }
}

- (IBAction)btnSelectShiftClick:(UIButton *)sender {
    functionSelected = 3;
    
    PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
    
    NSString* sql = @"Select shiftID, 'Shifts', ShiftName from Shifts";
    @synchronized(g_SYNCLOOKUPDB)
    {
        self.shiftArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
    }
    
    popoverView.arrays = self.shiftArray;
    popoverView.functionSelected = 4;
    
    self.popOver =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popOver.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popOver.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}

- (IBAction)btnPrimaryClick:(UIButton*)sender {
    
    if (userRowSelected >= 0)
    {
        int userID = 0;
        ClsUsers* user = [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers;
        
        if (unitSelected)
        {
            ClsCrewInfo* crew = [ticketCrewArray objectAtIndex:userRowSelected];
            user.userID = [crew.id intValue];
            userID = user.userID;
        }
        
        else
        {
            if (arrayUnitUsers == nil || arrayUnitUsers.count < 1)
            {
                NSString* sql = [NSString stringWithFormat:@"Select UserID, UserFirstname, UserLastName, UserUnit, UserActive from users where UserActive = 1"];
                @synchronized(g_SYNCLOOKUPDB)
                {
                    self.arrayUnitUsers = [DAO loadAllUsersFromUnit:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
                }
            }
            ClsUsers* u = [arrayUnitUsers objectAtIndex:userRowSelected];
            user = u;
            userID = user.userID;
        }
        
        PasswordViewController* popoverView = [[PasswordViewController alloc] initWithNibName:@"PasswordViewController" bundle:nil];
        popoverView.userId = userID;
        self.popOver =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popOver.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popOver.popoverContentSize = CGSizeMake(400, 200);
        popoverView.delegate = self;
        
        [self.popOver presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Crew not selected" message:@"Please select a crew member." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
}

- (void) donePasswordClick
{
    PasswordViewController *p = (PasswordViewController *)self.popOver.contentViewController;
    if (p.pass)
    {
        ClsUsers* user = [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers;
        if (unitSelected)
        {
            ClsCrewInfo* crew = [ticketCrewArray objectAtIndex:userRowSelected];
            user.userID = [crew.id intValue];
            NSArray* nameArray = [crew.name componentsSeparatedByString:@" "];
            if ([nameArray count] > 1)
            {
                user.userLastName = [nameArray objectAtIndex:0];
                user.userFirstName= [nameArray objectAtIndex:1];
            }
            else if ([nameArray count] > 0)
            {
                user.userLastName = [nameArray objectAtIndex:0];
            }
            NSString* strTempPrimaryUser = [NSString stringWithFormat:@"Primary: %@.%@", user.userLastName, user.userFirstName];
            
            [self.btnPrimaryUser setTitle:strTempPrimaryUser forState:UIControlStateNormal];
            
        }
        else
        {
            ClsUsers* u = [arrayUnitUsers objectAtIndex:userRowSelected];
            user = u;
            NSString* strTempPrimaryUser = [NSString stringWithFormat:@"Primary: %@.%@", user.userLastName, user.userFirstName];
            
            [self.btnPrimaryUser setTitle:strTempPrimaryUser forState:UIControlStateNormal];
        }
    }
    [self.popOver dismissPopoverAnimated:YES];
    self.popOver = nil;
    
}


- (void) doneCustomCrew
{
    CustomCrewViewController *p = (CustomCrewViewController *)popOver.contentViewController;
    if (p.save)
    {
        ClsUsers* user = [[ClsUsers alloc] init];
        //user.userID = [arrayAllUsers count] + 1;
        user.userID = 0;
        user.userIDNumber = p.txtId.text;
        user.userCertNum = p.cert;
        user.userCertification = 0;
        [arrayUnitUsers addObject:user];
        // user.userID = [arrayActiveUsers count] + 1;
        user.userID = 0;
        user.userLastName = p.txtLastName.text;
        user.userFirstName = p.txtName.text;
        [arrayActiveUsers addObject:user];
    }
    [self.popOver dismissPopoverAnimated:YES];
    self.popOver = nil;
    if (unitSelected) {
        self.usersArray = self.arrayActiveUsers;
        [self.table reloadData];
    }
    else {
        self.usersArray = self.arrayUnitUsers;
        [self.table reloadData];
    }
}

-(void)didTap
{
    btnAdd.enabled = true;
    PopoverViewController *p = (PopoverViewController *)popOver.contentViewController;
    if (functionSelected == 1)
    {
        userSelected = p.rowSelected;
        NSString* nameSelected = ((ClsUsers*)[usersArray objectAtIndex:userSelected]).userFirstName;
        [btnSelectCrew setTitle:nameSelected forState:UIControlStateNormal];
        btnCrewType.hidden = NO;
        txtName.hidden = NO;
        txtID.hidden = NO;
        btnAdd.hidden = NO;
        lblName.hidden = NO;
        lblID.hidden = NO;
        lblType.hidden = NO;
        
        if ([nameSelected rangeOfString:@"Other"].location == NSNotFound)
        {
            txtName.enabled = NO;
            txtID.enabled = NO;
            btnCrewType.enabled = NO;
            btnAdd.enabled = true;
            txtName.text = [NSString stringWithFormat:@"%@ %@",((ClsUsers*)[usersArray objectAtIndex:userSelected]).userFirstName, ((ClsUsers*)[usersArray objectAtIndex:userSelected]).userLastName];
            txtID.text = [NSString stringWithFormat:@"%d",((ClsUsers*)[usersArray objectAtIndex:userSelected]).userID];
            
            [btnCrewType setTitle:((ClsUsers*)[usersArray objectAtIndex:userSelected]).userIDNumber forState:UIControlStateNormal];
        }
        else
        {
            txtName.enabled = true;
            txtID.enabled = true;
            btnCrewType.enabled = true;
            btnAdd.enabled = true;
        }
    }
    if (functionSelected == 2)
    {
        typeSelected = p.rowSelected;
        [btnCrewType setTitle:((ClsUsers*)[typeArray objectAtIndex:typeSelected]).userIDNumber forState:UIControlStateNormal];
    }
    
    if (functionSelected == 3)
    {
        typeSelected = p.rowSelected;
        NSString* shift = ((ClsTableKey *)[shiftArray objectAtIndex:typeSelected]).desc;
        [btnSelectShift setTitle:shift forState:UIControlStateNormal];
        if (shift.length > 0)
            [g_SETTINGS setObject:shift forKey:@"Shift"];
    }
    
    [self.popOver dismissPopoverAnimated:YES];
    self.popOver = nil;
}

- (void)setViewMovedUp:(BOOL)movedUp
{
    // [self.popOver dismissPopoverAnimated:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        if(rect.origin.x >= 0)
            rect.origin.x = self.view.frame.origin.x - 216;
    }
    else
    {
        if(rect.origin.x < 0)
            rect.origin.x = self.view.frame.origin.x + 216;
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self setViewMovedUp:YES];
    return TRUE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setViewMovedUp:NO];
    
}


- (void)viewDidUnload {
    [self setViewLabel:nil];
    [self setLblName:nil];
    [self setLblID:nil];
    [self setLblCertification:nil];
    [self setBtnSelectCrew:nil];
    [self setLblName:nil];
    [self setLblID:nil];
    [self setLblType:nil];
    [self setTvCrew:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1)
    {
        return [self.usersArray count];
    }
    else
    {
        
        return [ticketCrewArray count];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (tableView.tag == 1)
    {
        ClsUsers* user =  [self.usersArray objectAtIndex:indexPath.row];
        NSString *strTempCellTect = [NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName];
        cell.textLabel.text = strTempCellTect;
    }
    else
    {
        ClsCrewInfo* crew = [ticketCrewArray objectAtIndex:indexPath.row];
        cell.textLabel.text = crew.name;
        
    }
    
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
    cellSelected = indexPath.row;
    if (tableView.tag == 1)
    {
        crewRowSelected = indexPath.row;
    }
    else
    {
        userRowSelected =indexPath.row;
    }
    
}


#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    
    // tvCrew corner round and border.
    self.tvCrew.layer.borderWidth = 1;
    self.tvCrew.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.tvCrew.layer setCornerRadius:10.0f];
    [self.tvCrew.layer setMasksToBounds:YES];
    
    toolBarIMG = nil;
    
    [self.containerView3.layer setCornerRadius:10.0f];
    [self.containerView3.layer setMasksToBounds:YES];
    self.containerView3.layer.borderWidth = 1;
    self.containerView3.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark- Values for different controls
-(void) setValues
{
    [self loadUsersFromUnit];
    [self loadAllActiveUsers];
}


- (void) loadUsersFromUnit
{
    
    ClsUsers* user = [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers;
    NSString* strTempPrimaryUser = [NSString stringWithFormat:@"Primary: %@.%@", user.userLastName, user.userFirstName];
    [self.btnPrimaryUser setTitle:strTempPrimaryUser forState:UIControlStateNormal];
    
    self->_unitName = [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUnit.unitDescription;
    NSInteger unitSelect = [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUnit.unitID;
    //    NSString* sql = [NSString stringWithFormat:@"Select u.UserID, u.UserFirstname, u.UserLastName, u.UserAddress, u.UserCity, u.UserState, u.UserZip, u.UserAge, u.UserUnit, u.UserActive, u.UserCertification, u.UserCertStart, u.UserCertEnd, u.UserCertNum, u.UserPassword, u.UserGroup, c.CertName as UserIDNumber from users u left join certification c on u.UserCertification = c.CertUID where UserUnit = %d", unitSelected];
    NSString* sql = [NSString stringWithFormat:@"Select UserID, UserFirstname, UserLastName, UserUnit, UserActive from users where UserUnit = %d and UserActive = 1", unitSelect];
    @synchronized(g_SYNCLOOKUPDB)
    {
        self.arrayUnitUsers = [DAO loadAllUsersFromUnit:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    self.usersArray = self.arrayUnitUsers;
    user = nil;
    strTempPrimaryUser = nil;
}

- (void) loadAllActiveUsers
{
    
    ClsUsers* user = [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUsers;
    NSString* strTempPrimaryUser = [NSString stringWithFormat:@"Primary: %@.%@", user.userLastName, user.userFirstName];
    [self.btnPrimaryUser setTitle:strTempPrimaryUser forState:UIControlStateNormal];
    
    self->_unitName = [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUnit.unitDescription;
    NSInteger activeState = 1;
    NSString* sql = [NSString stringWithFormat:@"Select UserID, UserFirstname, UserLastName, UserUnit, UserActive from users where UserActive = %d", activeState];
    @synchronized(g_SYNCLOOKUPDB)
    {
        self.arrayActiveUsers = [DAO loadActiveUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    user = nil;
    strTempPrimaryUser = nil;
    
}

- (void) loadTicketCrew // call from within ticket
{
    
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketUnitNumber, TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and (deleted is null or deleted = 0)", ticketID ];
    
    NSMutableDictionary* ticketInputsData;
    NSMutableArray* crewData;
    NSMutableArray* unitData;
    @synchronized(g_SYNCDATADB)
    {
        ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
    }
    
    NSString* crewIds = [[ticketInputsData objectForKey:@"TicketCrew"] stringByReplacingOccurrencesOfString:@"|" withString:@","];
    NSString* crewIDStr;
    if (crewIds.length >= 1)
    {
        if ([[crewIds substringFromIndex:(crewIds.length - 1)] isEqualToString:@","])
        {
            crewIDStr = [crewIds substringToIndex:[crewIds length] - 1];
        }
        else
        {
            crewIDStr = crewIds;
        }
    }
    sql = [NSString stringWithFormat:@"Select * from users where userID in (%@)", crewIDStr ];
    @synchronized(g_SYNCLOOKUPDB)
    {
        crewData = [DAO loadUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    
    
    
    for (int i =0; i< [crewData count]; i++)
    {
        ClsUsers* user = [crewData objectAtIndex:i];
        ClsCrewInfo* crew = [[ClsCrewInfo alloc] init];
        if (i == 0)
        {
            crew.role = @"Primary";
        }
        else
        {
            crew.role = @"Secondary";
        }
        crew.id = [NSString stringWithFormat:@"%ld", user.userID ];
        crew.name = [NSString stringWithFormat:@"%@ %@", user.userFirstName, user.userLastName ];
        // [g_SETTINGS setObject:crew.name forKey:@"UserName"];
        crew.certification = [NSString stringWithFormat:@"%@", user.userIDNumber];
        [ticketCrewArray addObject:crew];
        
    }
    
    
    
}


#pragma mark-
#pragma UISearchBar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    searchBar.autocapitalizationType = UITextAutocorrectionTypeNo;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //  if([searchText length] != 0) {
    [self search:searchText];
    //  }
    //  else {
    
    // }
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
    [self search:searchBar.text];
}

- (void) search:(NSString*) searchText
{
    if (segmentControl.selectedSegmentIndex == 0)
    {
        NSString* sql;
        NSInteger unitSelect = [sharedClsCommonVariables sharedInstanceCommonVariables].objClsUnit.unitID;
        if([searchText length] != 0) {
            sql = [NSString stringWithFormat:@"Select UserID, UserFirstname, UserLastName, UserUnit, UserActive from users where UserUnit = %d and UserActive = 1  and userFirstName like '%%%@%%' or userLastName like '%%%@%%'", unitSelect, searchbar.text, searchbar.text];
        }
        else
        {
            sql = [NSString stringWithFormat:@"Select UserID, UserFirstname, UserLastName, UserUnit, UserActive from users where UserUnit = %d and UserActive = 1", unitSelect];
        }
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.arrayUnitUsers = [DAO loadAllUsersFromUnit:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
        }
        self.usersArray = self.arrayUnitUsers;
        
    }
    
    else
    {
        NSString* sql;
        if([searchText length] != 0) {
            sql = [NSString stringWithFormat:@"Select UserID, UserFirstname, UserLastName, UserUnit, UserActive from users where UserActive = %d and userFirstName like '%%%@%%' or userLastName like '%%%@%%'", 1 , searchbar.text, searchbar.text];
        }
        else
        {
            sql = [NSString stringWithFormat:@"Select UserID, UserFirstname, UserLastName, UserUnit, UserActive from users where UserActive = %d", 1];
        }
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.arrayActiveUsers = [DAO loadActiveUsers:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
        }
        
        self.usersArray = self.arrayActiveUsers;
    }
    
    [self.table reloadData];
    
}


@end
