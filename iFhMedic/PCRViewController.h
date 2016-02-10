//
//  PCRViewController.h
//  iRescueMedic
//
//  Created by Nathan on 7/3/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PCRViewController : UIViewController
{
    NSMutableString* htmlString;
}

@property (strong, nonatomic) NSMutableString* htmlString;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIButton *btnPrint;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnBarPrint;
@property (strong, nonatomic) UIPopoverController* popover;


- (NSString*) removeNull:(NSString*)str;
- (IBAction)btnDelete:(id)sender;
- (IBAction)btnPrintClick:(UIButton*)sender;
- (IBAction)btnFaxPressed:(UIButton*)sender;


@end
