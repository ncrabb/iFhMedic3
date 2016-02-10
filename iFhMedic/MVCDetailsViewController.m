//
//  MVCDetailsViewController.m
//  iRescueMedic
//
//  Created by admin on 3/30/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "MVCDetailsViewController.h"
#import "DAO.h"
#import "global.h"
//#import "PopoverViewController.h"
#import "DDPopoverBackgroundView.h"
#import "ClsTableKey.h"
#import "ClsInjuryType.h"
#import "Base64.h"
#import "ClsTicketAttachments.h"

#define Sedan_Driver_x1 693
#define Sedan_Driver_x2 737
#define Sedan_Driver_y1 261
#define Sedan_Driver_y2 296

#define Sedan_Passenger_x1 756
#define Sedan_Passenger_x2 803
#define Sedan_Passenger_y1 258
#define Sedan_Passenger_y2 298

#define Sedan_LeftBackSeat_x1 689
#define Sedan_LeftBackSeat_x2 730
#define Sedan_LeftBackSeat_y1 338
#define Sedan_LeftBackSeat_y2 368

#define Sedan_MiddleBackSeat_x1 732
#define Sedan_MiddleBackSeat_x2 766
#define Sedan_MiddleBackSeat_y1 339
#define Sedan_MiddleBackSeat_y2 368

#define Sedan_RightBackSeat_x1 767
#define Sedan_RightBackSeat_x2 805
#define Sedan_RightBackSeat_y1 339
#define Sedan_RightBackSeat_y2 368

#define Sport_Driver_x1 684
#define Sport_Driver_x2 730
#define Sport_Driver_y1 295
#define Sport_Driver_y2 327

#define Sport_Passenger_x1 764
#define Sport_Passenger_x2 807
#define Sport_Passenger_y1 295
#define Sport_Passenger_y2 327

#define Sport_LeftBackSeat_x1 687
#define Sport_LeftBackSeat_x2 722
#define Sport_LeftBackSeat_y1 352
#define Sport_LeftBackSeat_y2 369

#define Sport_MidBackSeat_x1 725
#define Sport_MidBackSeat_x2 768
#define Sport_MidBackSeat_y1 349
#define Sport_MidBackSeat_y2 369

#define Sport_RightBackSeat_x1 771
#define Sport_RightBackSeat_x2 806
#define Sport_RightBackSeat_y1 349
#define Sport_RightBackSeat_y2 369

#define Truck_Driver_x1 702
#define Truck_Driver_x2 736
#define Truck_Driver_y1 254
#define Truck_Driver_y2 284
#define Truck_Passenger_x1 759
#define Truck_Passenger_x2 795
#define Truck_Passenger_y1 254
#define Truck_Passenger_y2 284
#define Truck_LeftBackSeat_x1 697
#define Truck_LeftBackSeat_x2 728
#define Truck_LeftBackSeat_y1 302
#define Truck_LeftBackSeat_y2 322
#define Truck_MidBackSeat_x1 729
#define Truck_MidBackSeat_x2 762
#define Truck_MidBackSeat_y1 302
#define Truck_MidBackSeat_y2 322
#define Truck_RightBackSeat_x1 763
#define Truck_RightBackSeat_x2 795
#define Truck_RightBackSeat_y1 302
#define Truck_RightBackSeat_y2 322
#define Truck_Bed_x1 696
#define Truck_Bed_x2 796
#define Truck_Bed_y1 340
#define Truck_Bed_y2 462

#define SUV_Driver_x1 698
#define SUV_Driver_x2 737
#define SUV_Driver_y1 256
#define SUV_Driver_y2 292
#define SUV_Passenger_x1 760
#define SUV_Passenger_x2 799
#define SUV_Passenger_y1 256
#define SUV_Passenger_y2 292
#define SUV_LeftBackSeat_x1 692
#define SUV_LeftBackSeat_x2 732
#define SUV_LeftBackSeat_y1 331
#define SUV_LeftBackSeat_y2 365
#define SUV_MidBackSeat_x1 730
#define SUV_MidBackSeat_x2 761
#define SUV_MidBackSeat_y1 331
#define SUV_MidBackSeat_y2 365
#define SUV_RightBackSeat_x1 764
#define SUV_RightBackSeat_x2 802
#define SUV_RightBackSeat_y1 331
#define SUV_RightBackSeat_y2 365
#define SUV_Back_x1 704
#define SUV_Back_x2 796
#define SUV_Back_y1 387
#define SUV_Back_y2 448

#define SEMI_DriverSide_x1 706
#define SEMI_DriverSide_x2 734
#define SEMI_DriverSide_y1 196
#define SEMI_DriverSide_y2 213
#define SEMI_RightFrontSeat_x1 767
#define SEMI_RightFrontSeat_x2 796
#define SEMI_RightFrontSeat_y1 196
#define SEMI_RightFrontSeat_y2 213
#define SEMI_BackOfCab_x1 706
#define SEMI_BackOfCab_x2 796
#define SEMI_BackOfCab_y1 233
#define SEMI_BackOfCab_y2 252

#define Bike_FrontSeat_x1 723
#define Bike_FrontSeat_x2 757
#define Bike_FrontSeat_y1 333
#define Bike_FrontSeat_y2 387
#define Bike_BackSeat_x1 725
#define Bike_BackSeat_x2 756
#define Bike_BackSeat_y1 402
#define Bike_BackSeat_y2 442

#define ATV_FrontSeat_x1 715
#define ATV_FrontSeat_x2 781
#define ATV_FrontSeat_y1 288
#define ATV_FrontSeat_y2 362
#define ATV_BackSeat_x1 712
#define ATV_BackSeat_x2 786
#define ATV_BackSeat_y1 366
#define ATV_BackSeat_y2 467

#define BUS_Driver_x1 713
#define BUS_Driver_x2 734
#define BUS_Driver_y1 138
#define BUS_Driver_y2 159

#define BUS_LeftRow1_x1 709
#define BUS_LeftRow1_x2 739
#define BUS_LeftRow1_y1 188
#define BUS_LeftRow1_y2 201

#define BUS_LeftRow2_x1 709
#define BUS_LeftRow2_x2 739
#define BUS_LeftRow2_y1 214
#define BUS_LeftRow2_y2 228

#define BUS_LeftRow3_x1 709
#define BUS_LeftRow3_x2 739
#define BUS_LeftRow3_y1 244
#define BUS_LeftRow3_y2 256

#define BUS_LeftRow4_x1 709
#define BUS_LeftRow4_x2 739
#define BUS_LeftRow4_y1 270
#define BUS_LeftRow4_y2 282

#define BUS_LeftRow5_x1 709
#define BUS_LeftRow5_x2 739
#define BUS_LeftRow5_y1 303
#define BUS_LeftRow5_y2 317

#define BUS_LeftRow6_x1 709
#define BUS_LeftRow6_x2 739
#define BUS_LeftRow6_y1 331
#define BUS_LeftRow6_y2 343

#define BUS_LeftRow7_x1 709
#define BUS_LeftRow7_x2 739
#define BUS_LeftRow7_y1 361
#define BUS_LeftRow7_y2 374

#define BUS_LeftRow8_x1 709
#define BUS_LeftRow8_x2 739
#define BUS_LeftRow8_y1 388
#define BUS_LeftRow8_y2 402

#define BUS_LeftRow9_x1 709
#define BUS_LeftRow9_x2 739
#define BUS_LeftRow9_y1 420
#define BUS_LeftRow9_y2 433

#define BUS_LeftRow10_x1 709
#define BUS_LeftRow10_x2 739
#define BUS_LeftRow10_y1 446
#define BUS_LeftRow10_y2 460


#define BUS_RightRow1_x1 755
#define BUS_RightRow1_x2 785
#define BUS_RightRow1_y1 188
#define BUS_RightRow1_y2 201

#define BUS_RightRow2_x1 755
#define BUS_RightRow2_x2 785
#define BUS_RightRow2_y1 214
#define BUS_RightRow2_y2 228

#define BUS_RightRow3_x1 755
#define BUS_RightRow3_x2 785
#define BUS_RightRow3_y1 244
#define BUS_RightRow3_y2 256

#define BUS_RightRow6_x1 755
#define BUS_RightRow6_x2 785
#define BUS_RightRow6_y1 331
#define BUS_RightRow6_y2 343


#define BUS_RightRow7_x1 755
#define BUS_RightRow7_x2 785
#define BUS_RightRow7_y1 361
#define BUS_RightRow7_y2 374

#define BUS_RightRow8_x1 755
#define BUS_RightRow8_x2 785
#define BUS_RightRow8_y1 388
#define BUS_RightRow8_y2 402

#define BUS_RightRow9_x1 755
#define BUS_RightRow9_x2 785
#define BUS_RightRow9_y1 420
#define BUS_RightRow9_y2 433

#define BUS_RightRow10_x1 735
#define BUS_RightRow10_x2 785
#define BUS_RightRow10_y1 446
#define BUS_RightRow10_y2 460

#define VAN_Driver_x1 691
#define VAN_Driver_x2 732
#define VAN_Driver_y1 228
#define VAN_Driver_y2 260
#define VAN_Passenger_x1 765
#define VAN_Passenger_x2 803
#define VAN_Passenger_y1 227
#define VAN_Passenger_y2 260

#define VAN_LeftMiddleSeat_x1 693
#define VAN_LeftMiddleSeat_x2 731
#define VAN_LeftMiddleSeat_y1 312
#define VAN_LeftMiddleSeat_y2 345

#define VAN_RightMiddleSeat_x1 747
#define VAN_RightMiddleSeat_x2 786
#define VAN_RightMiddleSeat_y1 312
#define VAN_RightMiddleSeat_y2 345

#define VAN_LeftBackSeat_x1 691
#define VAN_LeftBackSeat_x2 724
#define VAN_LeftBackSeat_y1 393
#define VAN_LeftBackSeat_y2 427
#define VAN_MidBackSeat_x1 732
#define VAN_MidBackSeat_x2 765
#define VAN_MidBackSeat_y1 393
#define VAN_MidBackSeat_y2 427
#define VAN_RightBackSeat_x1 771
#define VAN_RightBackSeat_x2 803
#define VAN_RightBackSeat_y1 393
#define VAN_RightBackSeat_y2 427


#define BOAT_Driver_x1 688
#define BOAT_Driver_x2 724
#define BOAT_Driver_y1 291
#define BOAT_Driver_y2 316
#define BOAT_Passenger_x1 769
#define BOAT_Passenger_x2 805
#define BOAT_Passenger_y1 291
#define BOAT_Passenger_y2 316

#define BOAT_LeftMiddleSeat_x1 687
#define BOAT_LeftMiddleSeat_x2 724
#define BOAT_LeftMiddleSeat_y1 351
#define BOAT_LeftMiddleSeat_y2 372

#define BOAT_RightMiddleSeat_x1 769
#define BOAT_RightMiddleSeat_x2 806
#define BOAT_RightMiddleSeat_y1 351
#define BOAT_RightMiddleSeat_y2 373

#define BOAT_LeftBackSeat_x1 687
#define BOAT_LeftBackSeat_x2 725
#define BOAT_LeftBackSeat_y1 410
#define BOAT_LeftBackSeat_y2 430
#define BOAT_MidBackSeat_x1 728
#define BOAT_MidBackSeat_x2 766
#define BOAT_MidBackSeat_y1 410
#define BOAT_MidBackSeat_y2 430
#define BOAT_RightBackSeat_x1 770
#define BOAT_RightBackSeat_x2 804
#define BOAT_RightBackSeat_y1 410
#define BOAT_RightBackSeat_y2 430


#define JetSki_Driver_x1 704
#define JetSki_Driver_x2 787
#define JetSki_Driver_y1 256
#define JetSki_Driver_y2 331

#define JetSki_Passenger_x1 704
#define JetSki_Passenger_x2 787
#define JetSki_Passenger_y1 347
#define JetSki_Passenger_y2 402

@interface MVCDetailsViewController ()

@end

@implementation MVCDetailsViewController
@synthesize currentImage;
@synthesize btnVehicle;
@synthesize imageView;
@synthesize carArray;
@synthesize popover;
@synthesize btnClearDraw;
@synthesize btnPosition;
@synthesize location;
@synthesize lblMVCPosition;
@synthesize mvcArray;
@synthesize equipmentArray;
@synthesize btnEject;
@synthesize btnEquipment;
@synthesize btnExtrication;
@synthesize ejectedArray;
@synthesize extricationArray;
@synthesize deploymentArray;
@synthesize indicatorArray;
@synthesize collisionArray;
@synthesize impactArray;
@synthesize btnCollision;
@synthesize btnImpact;
@synthesize btnDeploy;
@synthesize btnIndicators;
@synthesize currentDrawImage;
@synthesize containView1;
@synthesize delegate;

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
    // Do any additional setup after loading the view from its nib.
    isDrawing = false;
    currentCarType = -1;
    [btnPosition setTitle:@"Free Drawing" forState:UIControlStateNormal];

    btnClearDraw.enabled = false;
    self.mvcArray = [[NSMutableArray alloc] init];
    
    [self loadData];
    [self setViewUI];
}


- (void) loadData
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1221", ticketID ];
    NSInteger count;
    @synchronized(g_SYNCDATADB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    
    if (count > 0)
    {

        NSString* sql = [NSString stringWithFormat:@"Select T.LocalTicketID, T.TicketID, T.TicketGUID, T.TicketCrew, T.TicketIncidentNumber, T.TicketDesc,  T.TicketDOS, T.TicketPractice, TI.* from Tickets T inner join TicketInputs TI on T.TicketID = TI.TicketID where T.TicketID = %@ and InputID in (1221, 1251, 1252, 1255, 1258, 1263, 1264)", ticketID ];
        NSMutableDictionary* ticketInputsData;
        @synchronized(g_SYNCDATADB)
        {
            ticketInputsData = [DAO executeSelectTicketInputsData:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        
        if ([[ticketInputsData objectForKey:@"1221:0:1"] length] > 0 && ([[ticketInputsData objectForKey:@"1221:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [self.btnEquipment setTitle:[ticketInputsData objectForKey:@"1221:0:1"] forState:UIControlStateNormal];
        }
        
        if ([[ticketInputsData objectForKey:@"1251:0:1"] length] > 0 && ([[ticketInputsData objectForKey:@"1251:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [self.btnExtrication setTitle:[ticketInputsData objectForKey:@"1251:0:1"] forState:UIControlStateNormal];
        }
        
        if ([[ticketInputsData objectForKey:@"1252:0:1"] length] > 0 && ([[ticketInputsData objectForKey:@"1252:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [self.btnEject setTitle:[ticketInputsData objectForKey:@"1252:0:1"] forState:UIControlStateNormal];
        }
        
        if ([[ticketInputsData objectForKey:@"1255:0:1"] length] > 0 && ([[ticketInputsData objectForKey:@"1255:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [self.btnCollision setTitle:[ticketInputsData objectForKey:@"1255:0:1"] forState:UIControlStateNormal];
        }
  
        if ([[ticketInputsData objectForKey:@"1258:0:1"] length] > 0 && ([[ticketInputsData objectForKey:@"1258:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [self.btnImpact setTitle:[ticketInputsData objectForKey:@"1258:0:1"] forState:UIControlStateNormal];
        }
        
        if ([[ticketInputsData objectForKey:@"1263:0:1"] length] > 0 && ([[ticketInputsData objectForKey:@"1263:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [self.btnDeploy setTitle:[ticketInputsData objectForKey:@"1263:0:1"] forState:UIControlStateNormal];
        }
        
        if ([[ticketInputsData objectForKey:@"1264:0:1"] length] > 0 && ([[ticketInputsData objectForKey:@"1264:0:1"] rangeOfString:@"(null)"].location == NSNotFound))
        {
            [self.btnIndicators setTitle:[ticketInputsData objectForKey:@"1264:0:1"] forState:UIControlStateNormal];
        }
        
    }
    sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketAttachments where TicketID = %@ and AttachmentID = 5", ticketID ];
    @synchronized(g_SYNCBLOBSDB)
    {
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sqlStr];
    }
    if (count > 0)
    {
        NSMutableArray* ticketInputsData;
        NSString* sql = [NSString stringWithFormat:@"Select * from TicketAttachments where TicketID = %@ and AttachmentID = 5", ticketID ];
        @synchronized(g_SYNCBLOBSDB)
        {
            ticketInputsData = [DAO executeSelectTicketAttachments:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
        }
        ClsTicketAttachments* attachment = [ticketInputsData objectAtIndex:0];
        NSString* fileStr = attachment.fileStr;
        NSData* data = [Base64 decode:fileStr];
        currentImage = [UIImage imageWithData:data];
        [imageView setImage:currentImage];
        
    }
    else
    {
        currentCarType = 0;
        currentImage = [UIImage imageNamed:@"AutoSedan.JPG"];
        [imageView setImage:currentImage];
    }

}

- (void) viewWillDisappear:(BOOL)animated
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    currentDrawImage = imageView.image;
    if (currentDrawImage != nil)
    {
        NSData* data = UIImageJPEGRepresentation(currentDrawImage, 1.0f);
        NSString* imgStr = [Base64 encode:data];
        NSDate* sourceDate = [NSDate date];
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString* timeAdded = [dateFormat stringFromDate:sourceDate];
        NSString* sql;
        NSInteger count ;

        sql = [NSString stringWithFormat:@"Select count(*) from TicketAttachments where TicketID = %@ and AttachmentID = 5", ticketID ];
        @synchronized(g_SYNCBLOBSDB)
        {
            count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
        }
        
        if (count > 0)
        {
            sql = [NSString stringWithFormat:@"Update TicketAttachments set FileStr = '%@' where TicketID = %@ and AttachmentID = 5",imgStr, ticketID];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            sql = [NSString stringWithFormat:@"Update TicketAttachments set FileStr = '%@' where TicketID = %@ and AttachmentID = 6",imgStr, ticketID];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
        }
        else
        {
            sql = [NSString stringWithFormat:@"Insert into TicketAttachments(LocalTicketID, TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded) Values(0, %@, %d, 'MVCImage', '%@', '%@', '%@')", ticketID, 5, imgStr, @" ", timeAdded ];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            
            sql = [NSString stringWithFormat:@"Insert into TicketAttachments(LocalTicketID, TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded) Values(0, %@, %d, 'MVCDrawImage', '%@', '%@', '%@')", ticketID, 6, imgStr, @" ", timeAdded ];
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
        }

            
    }
    
    NSString* sqlStr;
    NSInteger count ;
    @synchronized(g_SYNCDATADB)
    {
        sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketInputs where TicketID = %@ and InputID = 1221", ticketID ];
        count = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    if (count > 0)
    {
        sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1221", btnEquipment.titleLabel.text, ticketID];
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1251", btnExtrication.titleLabel.text, ticketID];
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1252", btnEject.titleLabel.text, ticketID];
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1255", btnCollision.titleLabel.text, ticketID];
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
   
        sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1258", btnImpact.titleLabel.text, ticketID];
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];

        sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1263", btnDeploy.titleLabel.text, ticketID];
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"UPDATE TicketInputs Set InputValue = '%@', isUploaded = 0 where TicketID = %@ and InputID = 1264", btnIndicators.titleLabel.text, ticketID];
        [DAO executeUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    else
    {
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1221, 0, 1, @"", @"", btnEquipment.titleLabel.text];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1251, 0, 1, @"", @"", btnExtrication.titleLabel.text];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1252, 0, 1, @"", @"", btnEject.titleLabel.text];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1255, 0, 1, @"", @"", btnCollision.titleLabel.text];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1258, 0, 1, @"", @"", btnImpact.titleLabel.text];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];

        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1263, 0, 1, @"", @"", btnDeploy.titleLabel.text];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        
        sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %d, '%@', '%@', '%@')", ticketID, 1264, 0, 1, @"", @"", btnIndicators.titleLabel.text];
        [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnImpactClick:(UIButton*)sender {
    if ([impactArray count] < 1)
    {
        NSString* querySql = @"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 1258";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.impactArray  = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 8;
    PopupMultIncidentViewController *popoverView =[[PopupMultIncidentViewController alloc]initWithNibName:@"PopupMultIncidentViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    popoverView.strSelectedData = btnImpact.titleLabel.text;
    [popoverView setDefaultData];
    popoverView.array = self.impactArray;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:containView1 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnCollisionClick:(UIButton*)sender {
    if ([collisionArray count] < 1)
    {
        NSString* querySql = @"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 1255";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.collisionArray  = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 7;
    PopupMultIncidentViewController *popoverView =[[PopupMultIncidentViewController alloc]initWithNibName:@"PopupMultIncidentViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    popoverView.strSelectedData = btnCollision.titleLabel.text;
    [popoverView setDefaultData];    popoverView.array = self.collisionArray ;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:containView1 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnIndicatorClick:(UIButton*)sender {
    if ([indicatorArray count] < 1)
    {
        NSString* querySql = @"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 1264";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.indicatorArray  = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 6;
    PopupMultIncidentViewController *popoverView =[[PopupMultIncidentViewController alloc]initWithNibName:@"PopupMultIncidentViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    popoverView.strSelectedData = btnIndicators.titleLabel.text;
    [popoverView setDefaultData];    popoverView.array = self.indicatorArray ;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:containView1 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnDeployClick:(UIButton*)sender {
    if ([deploymentArray count] < 1)
    {
        NSString* querySql = @"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 1263";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.deploymentArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 5;
    PopupMultIncidentViewController *popoverView =[[PopupMultIncidentViewController alloc]initWithNibName:@"PopupMultIncidentViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    popoverView.strSelectedData = btnDeploy.titleLabel.text;
    [popoverView setDefaultData];
    
    popoverView.array = self.deploymentArray;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:containView1 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

- (IBAction)btnMVCClick:(UIButton*)sender {
}

- (IBAction)btnSafetyClick:(UIButton*)sender {
    if ([equipmentArray count] < 1)
    {
        NSString* querySql = @"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 1221";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.equipmentArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 2;
    PopupMultIncidentViewController *popoverView =[[PopupMultIncidentViewController alloc]initWithNibName:@"PopupMultIncidentViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    popoverView.strSelectedData = btnEquipment.titleLabel.text;
    [popoverView setDefaultData];    popoverView.array = self.equipmentArray;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:containView1 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (IBAction)btnExtricationClick:(UIButton*)sender {
    if ([extricationArray count] < 1)
    {
        NSString* querySql = @"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 1251";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.extricationArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 3;
    PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc]initWithNibName:@"PopupIncidentViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    
    popoverView.array = self.extricationArray;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:containView1 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnEjectClick:(UIButton*)sender {
    if ([ejectedArray count] < 1)
    {
        NSString* querySql = @"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = 1252";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.ejectedArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }
    functionSelected = 4;
    PopupMultIncidentViewController *popoverView =[[PopupMultIncidentViewController alloc]initWithNibName:@"PopupMultIncidentViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];
    popoverView.strSelectedData = btnEject.titleLabel.text;
    [popoverView setDefaultData];    popoverView.array = self.ejectedArray;
    
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(350, 400);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:containView1 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnFreeDrawClick:(id)sender {
    if (isDrawing)
    {
        isDrawing = false;
        [btnPosition setTitle:@"Free Drawing" forState:UIControlStateNormal];
        btnClearDraw.enabled = false;
    }
    else
    {
        isDrawing = true;
        [btnPosition setTitle:@"Position" forState:UIControlStateNormal];
        btnClearDraw.enabled = true;
    }
    
}

- (IBAction)btnClearDrawClick:(id)sender {
    [imageView setImage:currentImage];
    if ([mvcArray count] > 0)
    {
        UIImage* backgroundImage = currentImage;
        CGSize size = CGSizeMake(360, 450);
        UIGraphicsBeginImageContext(size);
        [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
        
        UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
        ClsInjuryType* temp = [mvcArray objectAtIndex:0];
        [watermarkImage drawInRect:CGRectMake(temp.location.x - 581, temp.location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
        
        
        UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [imageView setImage:result];
    }
}

- (IBAction)btnVehicleClick:(UIButton*)sender {
    if ([carArray count] < 1)
    {
        NSString* querySql = @"select AutoTypeID, 'AutoType', Type from AutoType";
        
        @synchronized(g_SYNCLOOKUPDB)
        {
            self.carArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
        }
    }

    PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor whiteColor];//mani
    popoverView.array = self.carArray;
    functionSelected = 1;
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(350, 440);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    
}

-(void) didTap
{
    
    if (functionSelected == 1)
    {
        PopupIncidentViewController *p = (PopupIncidentViewController *)self.popover.contentViewController;
        if (p.rowSelected != currentCarType)
        {
            // ClsTableKey * tableKey =  [carArray objectAtIndex:p.rowSelected];
            if (p.rowSelected == 0)
            {
                self.currentImage = [UIImage imageNamed:@"AutoSedan.JPG"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: Sedan" forState:UIControlStateNormal];
            }
            else if (p.rowSelected == 1)
            {
                self.currentImage = [UIImage imageNamed:@"AutoTwoSeater.JPG"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: Sports" forState:UIControlStateNormal];
            }
            else if (p.rowSelected == 2)
            {
                self.currentImage = [UIImage imageNamed:@"AutoPickup.JPG"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: Truck" forState:UIControlStateNormal];
            }
            else if (p.rowSelected == 3)
            {
                self.currentImage = [UIImage imageNamed:@"AutoSUV.JPG"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: SUV" forState:UIControlStateNormal];
            }
            else if (p.rowSelected == 4)
            {
                self.currentImage = [UIImage imageNamed:@"AutoDiesel.JPG"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: Semi" forState:UIControlStateNormal];
            }
            else if (p.rowSelected == 5)
            {
                self.currentImage = [UIImage imageNamed:@"AutoMotorcycle.jpg"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: Bike" forState:UIControlStateNormal];
            }
            else if (p.rowSelected == 6)
            {
                self.currentImage = [UIImage imageNamed:@"AutoATV.JPG"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: ATV" forState:UIControlStateNormal];
            }
            else if (p.rowSelected == 7)
            {
                self.currentImage = [UIImage imageNamed:@"AutoBus.jpg"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: Bus" forState:UIControlStateNormal];
            }
            else if (p.rowSelected == 8)
            {
                self.currentImage = [UIImage imageNamed:@"AutoVan.jpg"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: Van" forState:UIControlStateNormal];
            }
            else if (p.rowSelected == 9)
            {
                self.currentImage = [UIImage imageNamed:@"AutoBoat.jpg"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: Boat" forState:UIControlStateNormal];
            }
            else if (p.rowSelected == 10)
            {
                self.currentImage = [UIImage imageNamed:@"AutoJetSki.jpg"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: JetSki" forState:UIControlStateNormal];
            }
            else if (p.rowSelected == 11)
            {
                self.currentImage = [UIImage imageNamed:@"AutoBlank.jpg"];
                self.imageView.image = currentImage;
                [self.btnVehicle setTitle:@"Vehicle Type: Other" forState:UIControlStateNormal];
            }
            // [self.btnMOI setTitle:tableKey.desc forState:UIControlStateNormal];
            btnVehicle.tag =  p.rowSelected;
            btnVehicle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
        currentCarType = p.rowSelected;
        [self.popover dismissPopoverAnimated:YES];
        self.popover = nil;
    }
    else
    {
        if(functionSelected == 2)
        {
            PopupMultIncidentViewController *p = (PopupMultIncidentViewController *)self.popover.contentViewController;
            [self.popover dismissPopoverAnimated:YES];
            self.popover = nil;
            NSString *strResult;
            if([p.arrRowSelected count] == 0)
            {
                strResult = @" ";
            }
            else
            {
                ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:0] integerValue]];
                strResult = tableKey.desc;
                for(int i=1;i<[p.arrRowSelected count];i++)
                {
                    ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:i] integerValue]];
                    strResult = [strResult stringByAppendingFormat:@",%@", tableKey.desc];
                }
            }

            
            [self.btnEquipment setTitle:strResult forState:UIControlStateNormal];
            btnEquipment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;            
            [self btnExtricationClick:btnExtrication];

        }
        else if(functionSelected == 3)
        {
            PopupIncidentViewController *p = (PopupIncidentViewController *)self.popover.contentViewController;
            [self.popover dismissPopoverAnimated:YES];
            self.popover = nil;
            ClsTableKey * tableKey =  [p.array objectAtIndex:p.rowSelected];
            [self.btnExtrication setTitle:tableKey.desc forState:UIControlStateNormal];
            btnExtrication.tag =  p.rowSelected;
            [self btnEjectClick:btnEject];
        }
        else if(functionSelected == 4)
        {
            PopupMultIncidentViewController *p = (PopupMultIncidentViewController *)self.popover.contentViewController;
            [self.popover dismissPopoverAnimated:YES];
            self.popover = nil;
            NSString *strResult;
            if([p.arrRowSelected count] == 0)
            {
                strResult = @" ";
            }
            else
            {
                ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:0] integerValue]];
                strResult = tableKey.desc;
                for(int i=1;i<[p.arrRowSelected count];i++)
                {
                    ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:i] integerValue]];
                    strResult = [strResult stringByAppendingFormat:@",%@", tableKey.desc];
                }
            }

            [self.btnEject setTitle:strResult forState:UIControlStateNormal];
            btnEject.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self btnDeployClick:btnDeploy];
        }
        else if(functionSelected == 5)
        {
            PopupMultIncidentViewController *p = (PopupMultIncidentViewController *)self.popover.contentViewController;
            [self.popover dismissPopoverAnimated:YES];
            self.popover = nil;
            NSString *strResult;
            if([p.arrRowSelected count] == 0)
            {
                strResult = @" ";
            }
            else
            {
                ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:0] integerValue]];
                strResult = tableKey.desc;
                for(int i=1;i<[p.arrRowSelected count];i++)
                {
                    ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:i] integerValue]];
                    strResult = [strResult stringByAppendingFormat:@",%@", tableKey.desc];
                }
            }

            [self.btnDeploy setTitle:strResult forState:UIControlStateNormal];
            btnDeploy.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self btnIndicatorClick:btnIndicators];

        }
        else if(functionSelected == 6)
        {
            PopupMultIncidentViewController *p = (PopupMultIncidentViewController *)self.popover.contentViewController;
            [self.popover dismissPopoverAnimated:YES];
            self.popover = nil;
            NSString *strResult;
            if([p.arrRowSelected count] == 0)
            {
                strResult = @" ";
            }
            else
            {
                ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:0] integerValue]];
                strResult = tableKey.desc;
                for(int i=1;i<[p.arrRowSelected count];i++)
                {
                    ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:i] integerValue]];
                    strResult = [strResult stringByAppendingFormat:@",%@", tableKey.desc];
                }
            }

            [self.btnIndicators setTitle:strResult forState:UIControlStateNormal];
            btnIndicators.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self btnCollisionClick:btnCollision];

        }
        else if(functionSelected == 7)
        {
            PopupMultIncidentViewController *p = (PopupMultIncidentViewController *)self.popover.contentViewController;
            [self.popover dismissPopoverAnimated:YES];
            self.popover = nil;
            NSString *strResult;
            if([p.arrRowSelected count] == 0)
            {
                strResult = @" ";
            }
            else
            {
                ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:0] integerValue]];
                strResult = tableKey.desc;
                for(int i=1;i<[p.arrRowSelected count];i++)
                {
                    ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:i] integerValue]];
                    strResult = [strResult stringByAppendingFormat:@",%@", tableKey.desc];
                }
            }

            [self.btnCollision setTitle:strResult forState:UIControlStateNormal];
            btnCollision.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self btnImpactClick:btnImpact];

        }
        else if(functionSelected == 8)
        {
            PopupMultIncidentViewController *p = (PopupMultIncidentViewController *)self.popover.contentViewController;
            [self.popover dismissPopoverAnimated:YES];
            self.popover = nil;
            NSString *strResult;
            if([p.arrRowSelected count] == 0)
            {
                strResult = @" ";
            }
            else
            {
                ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:0] integerValue]];
                strResult = tableKey.desc;
                for(int i=1;i<[p.arrRowSelected count];i++)
                {
                    ClsTableKey * tableKey =  [p.array objectAtIndex:[[p.arrRowSelected objectAtIndex:i] integerValue]];
                    strResult = [strResult stringByAppendingFormat:@",%@", tableKey.desc];
                }
            }

            [self.btnImpact setTitle:strResult forState:UIControlStateNormal];
            btnImpact.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }
        
    }

}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isDrawing)
    {
        UITouch *touch = [touches anyObject];
        self.location = [touch locationInView:self.imageView];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isDrawing)
    {
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:self.imageView];
        
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineWidth(ctx, 5.0);
        CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, location.x, location.y);
        CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
        CGContextStrokePath(ctx);
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        location = currentLocation;
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isDrawing)
    {
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:self.imageView];
        
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
        
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineWidth(ctx, 5.0);
        CGContextSetRGBStrokeColor(ctx, 1.0, 0.0, 0.0, 1.0);
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, location.x, location.y);
        CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y);
        CGContextStrokePath(ctx);
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
 
      //  self.currentImage = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();
        
        location = currentLocation;
    }
    
    else
    {
        
        UITouch* touch  = [[event allTouches] anyObject];
        self.location = [touch locationInView:self.view];
        NSLog(@"%f, %f", location.x, location.y );
        if (currentCarType == 0)
        {
            if ( (location.x > Sedan_Driver_x1) && (location.x < Sedan_Driver_x2) && (location.y > Sedan_Driver_y1) && (location.y < Sedan_Driver_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];

                    UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                    [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                    

                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Driver Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Driver Seat";
                selected.type = @"Driver Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > Sedan_Passenger_x1) && (location.x < Sedan_Passenger_x2) && (location.y > Sedan_Passenger_y1) && (location.y < Sedan_Passenger_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Passenger Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Passenger Seat";
                selected.type = @"Passenger Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }

            if ( (location.x > Sedan_LeftBackSeat_x1) && (location.x < Sedan_LeftBackSeat_x2) && (location.y > Sedan_LeftBackSeat_y1) && (location.y < Sedan_LeftBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Back Seat";
                selected.type = @"Left Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            if ( (location.x > Sedan_MiddleBackSeat_x1) && (location.x < Sedan_MiddleBackSeat_x2) && (location.y > Sedan_MiddleBackSeat_y1) && (location.y < Sedan_MiddleBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Middle Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Middle Back Seat";
                selected.type = @"Middle Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            if ( (location.x > Sedan_RightBackSeat_x1) && (location.x < Sedan_RightBackSeat_x2) && (location.y > Sedan_RightBackSeat_y1) && (location.y < Sedan_RightBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Back Seat";
                selected.type = @"Right Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
        }
 
        else if (currentCarType == 1)
        {
            if ( (location.x > Sport_Driver_x1) && (location.x < Sport_Driver_x2) && (location.y > Sport_Driver_y1) && (location.y < Sport_Driver_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Driver Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Driver Seat";
                selected.type = @"Driver Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > Sport_Passenger_x1) && (location.x < Sport_Passenger_x2) && (location.y > Sport_Passenger_y1) && (location.y < Sport_Passenger_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Passenger Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Passenger Seat";
                selected.type = @"Passenger Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > Sport_LeftBackSeat_x1) && (location.x < Sport_LeftBackSeat_x2) && (location.y > Sport_LeftBackSeat_y1) && (location.y < Sport_LeftBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Back Seat";
                selected.type = @"Left Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }

            if ( (location.x > Sport_MidBackSeat_x1) && (location.x < Sport_MidBackSeat_x2) && (location.y > Sport_MidBackSeat_y1) && (location.y < Sport_MidBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Middle Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Middle Back Seat";
                selected.type = @"Middle Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > Sport_RightBackSeat_x1) && (location.x < Sport_RightBackSeat_x2) && (location.y > Sport_RightBackSeat_y1) && (location.y < Sport_RightBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Back Seat";
                selected.type = @"Right Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
        }
        else if (currentCarType == 2)
        {
            if ( (location.x > Truck_Driver_x1) && (location.x < Truck_Driver_x2) && (location.y > Truck_Driver_y1) && (location.y < Truck_Driver_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Driver Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Driver Seat";
                selected.type = @"Driver Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > Truck_Passenger_x1) && (location.x < Truck_Passenger_x2) && (location.y > Truck_Passenger_y1) && (location.y < Truck_Passenger_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Passenger Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Passenger Seat";
                selected.type = @"Passenger Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > Truck_LeftBackSeat_x1) && (location.x < Truck_LeftBackSeat_x2) && (location.y > Truck_LeftBackSeat_y1) && (location.y < Truck_LeftBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Back Seat";
                selected.type = @"Left Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > Truck_MidBackSeat_x1) && (location.x < Truck_MidBackSeat_x2) && (location.y > Truck_MidBackSeat_y1) && (location.y < Truck_MidBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Middle Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Middle Back Seat";
                selected.type = @"Middle Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > Truck_RightBackSeat_x1) && (location.x < Truck_RightBackSeat_x2) && (location.y > Truck_RightBackSeat_y1) && (location.y < Truck_RightBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Back Seat";
                selected.type = @"Right Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > Truck_Bed_x1) && (location.x < Truck_Bed_x2) && (location.y > Truck_Bed_y1) && (location.y < Truck_Bed_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Bed of Truck";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Bed of Truck";
                selected.type = @"Bed of Truck";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
        }
        else if (currentCarType == 3)
        {
            if ( (location.x > SUV_Driver_x1) && (location.x < SUV_Driver_x2) && (location.y > SUV_Driver_y1) && (location.y < SUV_Driver_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Driver Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Driver Seat";
                selected.type = @"Driver Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > SUV_Passenger_x1) && (location.x < SUV_Passenger_x2) && (location.y > SUV_Passenger_y1) && (location.y < SUV_Passenger_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Passenger Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Passenger Seat";
                selected.type = @"Passenger Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > SUV_LeftBackSeat_x1) && (location.x < SUV_LeftBackSeat_x2) && (location.y > SUV_LeftBackSeat_y1) && (location.y < SUV_LeftBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Back Seat";
                selected.type = @"Left Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > SUV_MidBackSeat_x1) && (location.x < SUV_MidBackSeat_x2) && (location.y > SUV_MidBackSeat_y1) && (location.y < SUV_MidBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Middle Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Middle Back Seat";
                selected.type = @"Middle Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > SUV_RightBackSeat_x1) && (location.x < SUV_RightBackSeat_x2) && (location.y > SUV_RightBackSeat_y1) && (location.y < SUV_RightBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Back Seat";
                selected.type = @"Right Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > SUV_Back_x1) && (location.x < SUV_Back_x2) && (location.y > SUV_Back_y1) && (location.y < SUV_Back_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Back of SUV";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Back of SUV";
                selected.type = @"Back of SUV";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
        }

        else if (currentCarType == 4)
        {
            if ( (location.x > SEMI_DriverSide_x1) && (location.x < SEMI_DriverSide_x2) && (location.y > SEMI_DriverSide_y1) && (location.y < SEMI_DriverSide_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Driver Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Driver Seat";
                selected.type = @"Driver Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > SEMI_RightFrontSeat_x1) && (location.x < SEMI_RightFrontSeat_x2) && (location.y > SEMI_RightFrontSeat_y1) && (location.y < SEMI_RightFrontSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Front Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Front Seat";
                selected.type = @"Right Front Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > SEMI_BackOfCab_x1) && (location.x < SEMI_BackOfCab_x2) && (location.y > SEMI_BackOfCab_y1) && (location.y < SEMI_BackOfCab_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Back of Cab";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Back of Cab";
                selected.type = @"Back of Cab";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
        }
        else if (currentCarType == 5)
        {
            if ( (location.x > Bike_FrontSeat_x1) && (location.x < Bike_FrontSeat_x2) && (location.y > Bike_FrontSeat_y1) && (location.y < Bike_FrontSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Front Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Front Seat";
                selected.type = @"Front Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > Bike_BackSeat_x1) && (location.x < Bike_BackSeat_x2) && (location.y > Bike_BackSeat_y1) && (location.y < Bike_BackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Back Seat";
                selected.type = @"Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
        }
        else if (currentCarType == 6)
        {
            if ( (location.x > ATV_FrontSeat_x1) && (location.x < ATV_FrontSeat_x2) && (location.y > ATV_FrontSeat_y1) && (location.y < ATV_FrontSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Front Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Front Seat";
                selected.type = @"Front Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > ATV_BackSeat_x1) && (location.x < ATV_BackSeat_x2) && (location.y > ATV_BackSeat_y1) && (location.y < ATV_BackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Back Seat";
                selected.type = @"Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
        }
        else if (currentCarType == 7)
        {
            if ( (location.x > BUS_Driver_x1) && (location.x < BUS_Driver_x2) && (location.y > BUS_Driver_y1) && (location.y < BUS_Driver_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Driver";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Driver";
                selected.type = @"Driver";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_LeftRow1_x1) && (location.x < BUS_LeftRow1_x2) && (location.y > BUS_LeftRow1_y1) && (location.y < BUS_LeftRow1_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Row 1";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Row 1";
                selected.type = @"Left Row 1";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_LeftRow2_x1) && (location.x < BUS_LeftRow2_x2) && (location.y > BUS_LeftRow2_y1) && (location.y < BUS_LeftRow2_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Row 2";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Row 2";
                selected.type = @"Left Row 2";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_LeftRow3_x1) && (location.x < BUS_LeftRow3_x2) && (location.y > BUS_LeftRow3_y1) && (location.y < BUS_LeftRow3_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Row 3";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Row 3";
                selected.type = @"Left Row 3";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_LeftRow4_x1) && (location.x < BUS_LeftRow4_x2) && (location.y > BUS_LeftRow4_y1) && (location.y < BUS_LeftRow4_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Row 4";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Row 4";
                selected.type = @"Left Row 4";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_LeftRow5_x1) && (location.x < BUS_LeftRow5_x2) && (location.y > BUS_LeftRow5_y1) && (location.y < BUS_LeftRow5_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Row 5";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Row 5";
                selected.type = @"Left Row 5";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_LeftRow6_x1) && (location.x < BUS_LeftRow6_x2) && (location.y > BUS_LeftRow6_y1) && (location.y < BUS_LeftRow6_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Row 6";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Row 6";
                selected.type = @"Left Row 6";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_LeftRow7_x1) && (location.x < BUS_LeftRow7_x2) && (location.y > BUS_LeftRow7_y1) && (location.y < BUS_LeftRow7_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Row 7";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Row 7";
                selected.type = @"Left Row 7";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_LeftRow8_x1) && (location.x < BUS_LeftRow8_x2) && (location.y > BUS_LeftRow8_y1) && (location.y < BUS_LeftRow8_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Row 8";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Row 8";
                selected.type = @"Left Row 8";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_LeftRow9_x1) && (location.x < BUS_LeftRow9_x2) && (location.y > BUS_LeftRow9_y1) && (location.y < BUS_LeftRow9_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Row 9";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Row 9";
                selected.type = @"Left Row 9";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_LeftRow10_x1) && (location.x < BUS_LeftRow10_x2) && (location.y > BUS_LeftRow10_y1) && (location.y < BUS_LeftRow10_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Row 10";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Row 10";
                selected.type = @"Left Row 10";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }

            
            if ( (location.x > BUS_RightRow1_x1) && (location.x < BUS_RightRow1_x2) && (location.y > BUS_RightRow1_y1) && (location.y < BUS_RightRow1_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];

                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Row 1";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Row 1";
                selected.type = @"Right Row 1";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            if ( (location.x > BUS_RightRow2_x1) && (location.x < BUS_RightRow2_x2) && (location.y > BUS_RightRow2_y1) && (location.y < BUS_RightRow2_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Row 2";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Row 2";
                selected.type = @"Right Row 2";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_RightRow3_x1) && (location.x < BUS_RightRow3_x2) && (location.y > BUS_RightRow3_y1) && (location.y < BUS_RightRow3_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Row 3";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Row 3";
                selected.type = @"Right Row 3";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_RightRow6_x1) && (location.x < BUS_RightRow6_x2) && (location.y > BUS_RightRow6_y1) && (location.y < BUS_RightRow6_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Row 6";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Row 4";
                selected.type = @"Right Row 4";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_RightRow7_x1) && (location.x < BUS_RightRow7_x2) && (location.y > BUS_RightRow7_y1) && (location.y < BUS_RightRow7_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Row 7";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Row 7";
                selected.type = @"Right Row 7";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_RightRow8_x1) && (location.x < BUS_RightRow8_x2) && (location.y > BUS_RightRow8_y1) && (location.y < BUS_RightRow8_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Row 8";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Row 8";
                selected.type = @"Right Row 8";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_RightRow9_x1) && (location.x < BUS_RightRow9_x2) && (location.y > BUS_RightRow9_y1) && (location.y < BUS_RightRow9_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Row 9";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Row 9";
                selected.type = @"Right Row 9";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            if ( (location.x > BUS_RightRow10_x1) && (location.x < BUS_RightRow10_x2) && (location.y > BUS_RightRow10_y1) && (location.y < BUS_RightRow10_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Row 10";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Row 10";
                selected.type = @"Right Row 10";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
        }
        else if (currentCarType == 8)
        {
            if ( (location.x > VAN_Driver_x1) && (location.x < VAN_Driver_x2) && (location.y > VAN_Driver_y1) && (location.y < VAN_Driver_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Driver Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Driver Seat";
                selected.type = @"Driver Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            else if ( (location.x > VAN_Passenger_x1) && (location.x < VAN_Passenger_x2) && (location.y > VAN_Passenger_y1) && (location.y < VAN_Passenger_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Passenger Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Passenger Seat";
                selected.type = @"Passenger Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            else if ( (location.x > VAN_LeftBackSeat_x1) && (location.x < VAN_LeftBackSeat_x2) && (location.y > VAN_LeftBackSeat_y1) && (location.y < VAN_LeftBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Back Seat";
                selected.type = @"Left Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            else if ( (location.x > VAN_MidBackSeat_x1) && (location.x < VAN_MidBackSeat_x2) && (location.y > VAN_MidBackSeat_y1) && (location.y < VAN_MidBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Middle Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Middle Back Seat";
                selected.type = @"Middle Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            else if ( (location.x > VAN_RightBackSeat_x1) && (location.x < VAN_RightBackSeat_x2) && (location.y > VAN_RightBackSeat_y1) && (location.y < VAN_RightBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Back Seat";
                selected.type = @"Right Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            else if ( (location.x > VAN_LeftMiddleSeat_x1) && (location.x < VAN_LeftMiddleSeat_x2) && (location.y > VAN_LeftMiddleSeat_y1) && (location.y < VAN_LeftMiddleSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Middle Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Middle Seat";
                selected.type = @"Left Middle Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            else if ( (location.x > VAN_RightMiddleSeat_x1) && (location.x < VAN_RightMiddleSeat_x2) && (location.y > VAN_RightMiddleSeat_y1) && (location.y < VAN_RightMiddleSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Middle Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Middle Seat";
                selected.type = @"Right Middle Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
        }

        else if (currentCarType == 9)
        {
            if ( (location.x > BOAT_Driver_x1) && (location.x < BOAT_Driver_x2) && (location.y > BOAT_Driver_y1) && (location.y < BOAT_Driver_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Driver Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Driver Seat";
                selected.type = @"Driver Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            else if ( (location.x > BOAT_Passenger_x1) && (location.x < BOAT_Passenger_x2) && (location.y > BOAT_Passenger_y1) && (location.y < BOAT_Passenger_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Passenger Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Passenger Seat";
                selected.type = @"Passenger Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            else if ( (location.x > BOAT_LeftMiddleSeat_x1) && (location.x < BOAT_LeftMiddleSeat_x2) && (location.y > BOAT_LeftMiddleSeat_y1) && (location.y < BOAT_LeftMiddleSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Middle Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Middle Seat";
                selected.type = @"Left Middle Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            else if ( (location.x > BOAT_RightMiddleSeat_x1) && (location.x < BOAT_RightMiddleSeat_x2) && (location.y > BOAT_RightMiddleSeat_y1) && (location.y < BOAT_RightMiddleSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Middle Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Middle Seat";
                selected.type = @"Right Middle Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            else if ( (location.x > BOAT_LeftBackSeat_x1) && (location.x < BOAT_LeftBackSeat_x2) && (location.y > BOAT_LeftBackSeat_y1) && (location.y < BOAT_LeftBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Left Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Left Back Seat";
                selected.type = @"Left Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            else if ( (location.x > BOAT_MidBackSeat_x1) && (location.x < BOAT_MidBackSeat_x2) && (location.y > BOAT_MidBackSeat_y1) && (location.y < BOAT_MidBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Middle Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Middle Back Seat";
                selected.type = @"Middle Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            else if ( (location.x > BOAT_RightBackSeat_x1) && (location.x < BOAT_RightBackSeat_x2) && (location.y > BOAT_RightBackSeat_y1) && (location.y < BOAT_RightBackSeat_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Right Back Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Right Back Seat";
                selected.type = @"Right Back Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
        }
        else if (currentCarType == 10)
        {
            if ( (location.x > JetSki_Driver_x1) && (location.x < JetSki_Driver_x2) && (location.y > JetSki_Driver_y1) && (location.y < JetSki_Driver_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Driver Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Driver Seat";
                selected.type = @"Driver Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            else if ( (location.x > JetSki_Passenger_x1) && (location.x < JetSki_Passenger_x2) && (location.y > JetSki_Passenger_y1) && (location.y < JetSki_Passenger_y2) )
            {
                UIImage* backgroundImage = currentImage;
                CGSize size = CGSizeMake(360, 450);
                UIGraphicsBeginImageContext(size);
                [backgroundImage drawInRect:CGRectMake(0, 0, 360, 450)];
                
                UIImage* watermarkImage = [UIImage imageNamed:@"Symbol Delete 32.png"];
                [watermarkImage drawInRect:CGRectMake(location.x - 581, location.y - 90, watermarkImage.size.width, watermarkImage.size.height)];
                
                UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                //self.currentImage = result;
                [imageView setImage:result];
                lblMVCPosition.Text = @"Passenger Seat";
                [mvcArray removeAllObjects];
                ClsInjuryType* selected = [[ClsInjuryType alloc] init];
                selected.area = @"Passenger Seat";
                selected.type = @"Passenger Seat";
                selected.location = self.location;
                [mvcArray addObject:selected];
            }
            
            
        }
    }
    self.currentDrawImage = imageView.image;
}

- (IBAction)btnContinueClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [delegate doneMvcDetailsClick];
}

-(void) setViewUI
{
    [self.containView1.layer setCornerRadius:10.0f];
    [self.containView1.layer setMasksToBounds:YES];
    self.containView1.layer.borderWidth = 1;
    self.containView1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
}

@end
