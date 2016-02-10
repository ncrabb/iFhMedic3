//
//  NarcoticSigViewController.m
//  iRescueMedic
//
//  Created by admin on 6/14/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "NarcoticSigViewController.h"
#import "global.h"
#import "DAO.h"
#import "Base64.h"
#import "ClsTicketFormsInputs.h"

@interface NarcoticSigViewController ()

@end

@implementation NarcoticSigViewController
@synthesize delegate;
@synthesize needToSave;
@synthesize image;
@synthesize txtName;
@synthesize signView;
@synthesize tvDisclaimer;
@synthesize sigType;
@synthesize formInputID;
@synthesize btnsave;
@synthesize lblTitle;
@synthesize formID;

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
    needToSave = FALSE;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(37, 111, 485, 250)];
	containerView.backgroundColor = [UIColor whiteColor];
	
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.borderWidth = 2;
    containerView.layer.cornerRadius = 8;
    containerView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 250)];
    
    signView.backgroundColor = [UIColor whiteColor];
	[containerView addSubview:signView];
	[self.view addSubview:containerView];
    [self loadDisclaimer];
}

-(void) loadDisclaimer
{
    NSString* sql = [NSString stringWithFormat:@"Select DisclaimerText from SignatureTypes where SignatureType = %d", sigType];
    @synchronized(g_SYNCLOOKUPDB)
    {
        tvDisclaimer.text = [DAO executeSelectRequiredInput:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadSignature];
}

- (void) loadSignature
{
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    if (formID == 2)
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FormID = 2 and formInputID = %d", ticketID, formInputID];
        NSInteger signatureCount = 0;
        @synchronized(g_SYNCDATADB)
        {
            signatureCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (signatureCount > 0)
        {
            NSMutableArray* ticketInputData;
            if (formInputID == 20)
            {
                NSString* sql = [NSString stringWithFormat:@"Select * from TicketFormsInputs where TicketID = %@ and FormID = 2 and formInputID in (20, 21)", ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    ticketInputData = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                }
                
                for (int i=0; i< [ticketInputData count]; i++)
                {
                    ClsTicketFormsInputs* input = [ticketInputData objectAtIndex:i];
                    if (input.formInputID == 21)
                    {
                        txtName.text = input.formInputValue;
                    }
                    if (input.formInputID == 20)
                    {
                        [Base64 initialize];
                        NSData* data = [Base64 decode:input.formInputValue];
                        self.image = [UIImage imageWithData:data];
                        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 250)];
                        imageview.image = image;
                        [containerView addSubview:imageview];
                        
                        btnsave.enabled = false;
                    }
                }
            }
            if (formInputID == 22)
            {
                NSString* sql = [NSString stringWithFormat:@"Select * from TicketFormsInputs where TicketID = %@ and FormID = 2 and formInputID in (22, 23)", ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    ticketInputData = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                }
                
                for (int i=0; i< [ticketInputData count]; i++)
                {
                    ClsTicketFormsInputs* input = [ticketInputData objectAtIndex:i];
                    if (input.formInputID == 23)
                    {
                        txtName.text = input.formInputValue;
                    }
                    if (input.formInputID == 22)
                    {
                        [Base64 initialize];
                        NSData* data = [Base64 decode:input.formInputValue];
                        self.image = [UIImage imageWithData:data];
                        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 250)];
                        imageview.image = image;
                        [containerView addSubview:imageview];
                        
                        btnsave.enabled = false;
                    }
                }
            }
           
            
        }  // end if signaturecount > 0
        
    }
    else
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FormID = 3 and formInputID = %d", ticketID, formInputID];
        NSInteger signatureCount = 0;
        @synchronized(g_SYNCDATADB)
        {
            signatureCount = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        if (signatureCount > 0)
        {
            NSMutableArray* ticketInputData;
            if (formInputID == 53)
            {
                NSString* sql = [NSString stringWithFormat:@"Select * from TicketFormsInputs where TicketID = %@ and FormID = 3 and formInputID in (52, 53)", ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    ticketInputData = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                }
                
                for (int i=0; i< [ticketInputData count]; i++)
                {
                    ClsTicketFormsInputs* input = [ticketInputData objectAtIndex:i];
                    if (input.formInputID == 52)
                    {
                        txtName.text = input.formInputValue;
                    }
                    if (input.formInputID == 53)
                    {
                        [Base64 initialize];
                        NSData* data = [Base64 decode:input.formInputValue];
                        self.image = [UIImage imageWithData:data];
                        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 250)];
                        imageview.image = image;
                        [containerView addSubview:imageview];
                        
                        btnsave.enabled = false;
                    }
                }
            }
            else if (formInputID == 3)
            {
                NSString* sql = [NSString stringWithFormat:@"Select * from TicketFormsInputs where TicketID = %@ and FormID = 3 and formInputID in (3, 4)", ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    ticketInputData = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                }
                
                for (int i=0; i< [ticketInputData count]; i++)
                {
                    ClsTicketFormsInputs* input = [ticketInputData objectAtIndex:i];
                    if (input.formInputID == 3)
                    {
                        txtName.text = input.formInputValue;
                    }
                    if (input.formInputID == 4)
                    {
                        [Base64 initialize];
                        NSData* data = [Base64 decode:input.formInputValue];
                        self.image = [UIImage imageWithData:data];
                        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 250)];
                        imageview.image = image;
                        [containerView addSubview:imageview];
                        
                        btnsave.enabled = false;
                    }
                }
            }
            else if (formInputID == 1)
            {
                NSString* sql = [NSString stringWithFormat:@"Select * from TicketFormsInputs where TicketID = %@ and FormID = 3 and formInputID in (1, 2)", ticketID];
                @synchronized(g_SYNCDATADB)
                {
                    ticketInputData = [DAO executeSelectTicketFormsInputs:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
                }
                
                for (int i=0; i< [ticketInputData count]; i++)
                {
                    ClsTicketFormsInputs* input = [ticketInputData objectAtIndex:i];
                    if (input.formInputID == 1)
                    {
                        txtName.text = input.formInputValue;
                    }
                    if (input.formInputID == 2)
                    {
                        [Base64 initialize];
                        NSData* data = [Base64 decode:input.formInputValue];
                        self.image = [UIImage imageWithData:data];
                        imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 250)];
                        imageview.image = image;
                        [containerView addSubview:imageview];
                        
                        btnsave.enabled = false;
                    }
                }
            }
            
        }
    }

}

-(UIImage*) loadimage:(UIImage*) currentImageDraw
{
    UIImage* backgroundImage = currentImageDraw;
    CGSize size = containerView.bounds.size;
    UIGraphicsBeginImageContext(size);
   // [backgroundImage drawInRect:CGRectMake(37, 76, size.width, size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, CGRectMake(37, 76, size.width, size.height), backgroundImage.CGImage);
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [containerView setNeedsDisplay];

    return result;

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIImage *)signatureImage
{
    UIGraphicsBeginImageContext(containerView.bounds.size);
    
    [containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
    
}


- (void)viewDidUnload {
    [self setTxtName:nil];
    [super viewDidUnload];
}
- (IBAction)btnCancel:(id)sender {
    [self.delegate doneNarcoticSigningClick];
    needToSave = FALSE;
}

- (IBAction)btnClear:(id)sender {
    //  [signView clearSignature:CGRectMake(0, 0, signView.frame.size.width, signView.frame.size.height)];
    [imageview removeFromSuperview];
    [signView removeFromSuperview];
    btnsave.enabled = true;
    signView = nil;
    
    signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,485, 250)];
    
    signView.backgroundColor = [UIColor whiteColor];
	[containerView addSubview:signView];
    
}

- (IBAction)btnSave:(id)sender {
    needToSave = TRUE;
    //self.image = [signature glToUIImage];
    self.image = [self signatureImage];
    
    NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
    
    if (formID == 2)
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FormID = 2 and formInputID = %d", ticketID, formInputID];
        NSInteger signatureID = 0;
        @synchronized(g_SYNCDATADB)
        {
            signatureID = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        NSData* data = UIImagePNGRepresentation([self signatureImage]);
        NSString *sigEncoded = [Base64 encode:data];
        if (signatureID < 1)
        {
            if (formInputID == 20)
            {
                @synchronized(g_SYNCDATADB)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 21, '%@', 0)", ticketID, txtName.text];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 20, '%@', 0)", ticketID, sigEncoded];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                }
            }
            else if (formInputID == 22)
            {
                @synchronized(g_SYNCDATADB)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 23, '%@', 0)", ticketID, txtName.text];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 2, 22, '%@', 0)", ticketID, sigEncoded];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                }
            }
        } // end signatureID < 1
        else
        {
            if (formInputID == 20)
            {
                @synchronized(g_SYNCDATADB)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@' where TicketID = '%@' and FormID = 2 and FormInputID = 21", txtName.text, ticketID];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@' where TicketID = '%@' and FormID = 2 and FormInputID = 20", sigEncoded, ticketID];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                }
            }
            else if (formInputID == 22)
            {
                @synchronized(g_SYNCDATADB)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@' where TicketID = '%@' and FormID = 2 and FormInputID = 23", txtName.text, ticketID];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@' where TicketID = '%@' and FormID = 2 and FormInputID = 22", sigEncoded, ticketID];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                }
            }
            
        }
       
        
    }  // end formID = 2
    else
    {
        NSString* sqlStr = [NSString stringWithFormat:@"Select count(*) from TicketFormsInputs where TicketID = %@ and FormID = 3 and formInputID = %d", ticketID, formInputID];
        NSInteger signatureID = 0;
        @synchronized(g_SYNCDATADB)
        {
            signatureID = [DAO getCount:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
        }
        NSData* data = UIImagePNGRepresentation([self signatureImage]);
        NSString *sigEncoded = [Base64 encode:data];
        if (signatureID < 1)
        {
            if (formInputID == 1)
            {
                @synchronized(g_SYNCDATADB)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 1, '%@', 0)", ticketID, txtName.text];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 2, '%@', 0)", ticketID, sigEncoded];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                }
            }
            else if (formInputID == 3)
            {
                @synchronized(g_SYNCDATADB)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 3, '%@', 0)", ticketID, txtName.text];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 4, '%@', 0)", ticketID, sigEncoded];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                }
            }
            else if (formInputID == 53)
            {
                @synchronized(g_SYNCDATADB)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 53, '%@', 0)", ticketID, txtName.text];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"Insert into TicketFormsInputs(LocalTicketID, TicketID, FormID, FormInputID, FormInputValue, IsUploaded) Values(0, %@, 3, 54, '%@', 0)", ticketID, sigEncoded];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                }
            }
            
        }
        else
        {
            if (formInputID == 1)
            {
                @synchronized(g_SYNCDATADB)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@' where TicketID = '%@' and FormID = 3 and FormInputID = 1", txtName.text, ticketID];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@' where TicketID = '%@' and FormID = 3 and FormInputID = 2", sigEncoded, ticketID];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                }
            }
            else if (formInputID == 3)
            {
                @synchronized(g_SYNCDATADB)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@' where TicketID = '%@' and FormID = 3 and FormInputID = 3", txtName.text, ticketID];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@' where TicketID = '%@' and FormID = 3 and FormInputID = 4", sigEncoded, ticketID];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                }
            }
            else if (formInputID == 53)
            {
                @synchronized(g_SYNCDATADB)
                {
                    NSString* sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@' where TicketID = '%@' and FormID = 3 and FormInputID = 53", txtName.text, ticketID];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                    sqlStr = [NSString stringWithFormat:@"Update TicketFormsInputs set FormInputValue = '%@' where TicketID = '%@' and FormID = 3 and FormInputID = 54", sigEncoded, ticketID];
                    [DAO executeInsert:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
                    
                }
            }
            
        }  // end else update
        
    } // end else formID = 2
    
    NSLog(@"Exit image");
    [self.delegate doneNarcoticSigningClick];
}

@end
