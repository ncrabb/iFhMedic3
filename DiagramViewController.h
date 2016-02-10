//
//  DiagramViewController.h
//  iRescueMedic
//
//  Created by Nathan on 8/26/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupInjuryTypeViewController.h"
#import "ValidateViewController.h"
#import "QuickViewController.h"

@protocol DismissDiagramDelegate <NSObject>

-(void)dismissViewControl;
-(void)dismissViewControlAndStartNew:(NSInteger)tag;
@end

@interface DiagramViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DismissInjuryTypeDelegate, DismissValidateControl, DismissQuickbuttonDelegate>
{
    __weak id <DismissDiagramDelegate> delegate;
    bool isDrawing;
    CGPoint location;
    bool frontView;
    int rowSelected;
    bool frontDraw;
    bool backDraw;
    NSInteger age;
    NSString* sex;
    NSInteger ageSex;
    bool frontImageTouch;
    bool backImageTouch;
}


@property (strong, nonatomic) IBOutlet UIImage *defaultImage;
@property (strong, nonatomic) IBOutlet UIImage *defaultImageBack;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnNameLabel;
@property (strong, nonatomic) IBOutlet UIImage *currentImageDraw;
@property (strong, nonatomic) IBOutlet UIImage *currentImageDrawBack;
@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImage *currentImage;
@property (strong, nonatomic) IBOutlet UIImage *currentImageBack;
@property (nonatomic, strong) UIPopoverController* popover;
@property (strong, nonatomic) NSMutableArray* injuryArray;
@property (strong, nonatomic) NSMutableArray* injurySelectedBack;
@property (strong, nonatomic) NSMutableArray* injurySelected;
@property (strong, nonatomic) NSMutableArray* injurySelectedAll;
@property (strong, nonatomic) IBOutlet UITableView *tvInjury;

@property (assign, nonatomic) CGPoint location;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIButton *btnFreeDrawing;
@property (strong, nonatomic) IBOutlet UIButton *btnClear;
@property (strong, nonatomic) IBOutlet UIButton *btnShowBack;
@property (strong, nonatomic) IBOutlet UIButton *btnQAMessage;


- (IBAction)btnMainMenuClick:(id)sender;
- (IBAction)btnFreeDrawingClick:(id)sender;
- (IBAction)btnClearClick:(id)sender;
- (IBAction)btnInternalInjuries:(id)sender;
- (IBAction)btnTraumaClick:(id)sender;
- (IBAction)btnRemoveInjuryClick:(id)sender;
- (IBAction)btnShowBackClick:(id)sender;
- (IBAction)btnValidateClick:(UIButton *)sender;

- (IBAction)btnQuickClick:(id)sender;
- (IBAction)btnQAMessageClick:(UIButton *)sender;
@end
