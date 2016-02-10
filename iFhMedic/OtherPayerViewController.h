//
//  OtherPayerViewController.h
//  iRescueMedic
//
//  Created by Nathan on 8/19/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"
#import "PopupIncidentViewController.h"
#import "SSNNumericViewController.h"

@protocol DismissOtherPayerInsDelegate <NSObject>

-(void) doneOtherPayerClick;

@end

@interface OtherPayerViewController : UIViewController <UITextFieldDelegate, DismissCalendarDelegate, DismissSSNDelegate>
{
    __weak id <DismissOtherPayerInsDelegate> delegate;
    NSMutableArray* cityArray;
    NSMutableArray* stateArray;
    NSMutableArray* zipArray;
    NSInteger functionSelected;
}

@property (strong, nonatomic) NSString *first;
@property (strong, nonatomic) NSString *last;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *relation;
@property (strong, nonatomic) NSString *rphone;
@property (strong, nonatomic) NSString *kin;
@property (strong, nonatomic) NSString *kphone;
@property (strong, nonatomic) NSString *employer;
@property (strong, nonatomic) NSString *ephone;
@property (strong, nonatomic) NSString *dob;
@property (strong, nonatomic) NSMutableArray* cityArray;
@property (strong, nonatomic) NSMutableArray* stateArray;
@property (strong, nonatomic) NSMutableArray* relationshipArray;
@property (weak) id delegate;
@property (nonatomic, strong) UIPopoverController* popover; 
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtAddress;
@property (strong, nonatomic) IBOutlet UITextField *txtCity;
@property (strong, nonatomic) IBOutlet UITextField *txtState;
@property (strong, nonatomic) IBOutlet UITextField *txtZip;
@property (strong, nonatomic) IBOutlet UIButton *btnRelationship;


@property (strong, nonatomic) IBOutlet UITextField *txtNextOfKin;

@property (strong, nonatomic) IBOutlet UITextField *txtEmployer;

@property (strong, nonatomic) IBOutlet UIButton *btnDOB;

@property (strong, nonatomic) IBOutlet UIButton *btnPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnNextKinPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnEmployerPhone;
@property (strong, nonatomic) NSString* ticketID;
@property (strong, nonatomic) NSMutableDictionary* ticketInputsData;


- (IBAction)btnPhoneClick:(UIButton *)sender;
- (IBAction)btnNextKinPhoneClick:(id)sender;
- (IBAction)btnEmployerPhoneClick:(id)sender;


- (IBAction)txtCityClick:(id)sender;
- (IBAction)txtStateClick:(id)sender;
- (IBAction)txtRelationshipClick:(id)sender;
- (IBAction)btnDOBClick:(id)sender;
- (IBAction)btnCancelClick:(id)sender;
- (IBAction)btnSubmitClick:(id)sender;

- (IBAction)btnRelationShipClick:(UIButton *)sender;



@end
