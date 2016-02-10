//
//  FormsViewController.h
//  iRescueMedic
//
//  Created by admin on 12/22/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClsTreatments.h"
#import <WebKit/WebKit.h>

@interface FormsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) NSMutableString* htmlString;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnBarPrint;
@property (nonatomic) NSInteger formType;
@property (strong, nonatomic) UIPopoverController* popover;
@property (strong, nonatomic) IBOutlet UIButton *btnFax;
@property (strong, nonatomic) ClsTreatments* loadTreatment;

- (NSString*) removeNull:(NSString*)str;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnPrintClick:(id)sender;
- (IBAction)btnFaxClick:(UIButton *)sender;



@end
