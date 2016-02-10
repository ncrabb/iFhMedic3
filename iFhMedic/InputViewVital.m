//
//  InputViewVital.m
//  iFhMedic
//
//  Created by admin on 1/24/16.
//  Copyright © 2016 com.emergidata. All rights reserved.
//

#import "InputViewVital.h"
#import "DAO.h"
#import "global.h"
#import "DDPopoverBackgroundView.h"
#import "ClsTableKey.h"

@implementation InputViewVital

@synthesize lblInput;
@synthesize btnInput;
@synthesize inputType;
@synthesize popover;
@synthesize inputID;
@synthesize array;
@synthesize position;
@synthesize delegate;
@synthesize tabPage;
@synthesize lblDetail;

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"InputViewVital" owner:self options:nil];
        self.bounds = self.view.bounds;
        
        [self addSubview:self.view];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"InputViewVital" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}

-(void) setLabelText: (NSString*) labelText dataType:(NSInteger) type inputRequired:(NSInteger) required
{
    lblInput.text = labelText;
    if (required == 1)
    {
        lblInput.textColor = [UIColor redColor];
    }
}

-(void) setBtnText: (NSString*) btnText
{
    [btnInput setTitle:btnText forState:UIControlStateNormal];
    
}

- (IBAction)btnInputClick:(UIButton *)sender {

    if (inputType == 11 || inputType == 6)
    {
        DateTimeViewController *popoverView =[[DateTimeViewController alloc] initWithNibName:@"DateTimeViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor blackColor];
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(450, 450);
        popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.x -= 300;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    else if (inputType == 17)
    {
        PerformedByViewController *popoverView =[[PerformedByViewController alloc] initWithNibName:@"PerformedByViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(500, 346);
        popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.x -= 300;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    else
    {
        UIButton* button = (UIButton*) sender;
        
        NumericViewController *popoverView =[[NumericViewController alloc] initWithNibName:@"NumericViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor blackColor];
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(400, 400);
        popoverView.utoEnabled = true;
        popoverView.utoEnabled = true;
        if ( (button.tag >= 3001 && button.tag <= 3008) || button.tag == 3010)
        {
            popoverView.unhide = 1;
            popoverView.vitalSelected = button.tag;
        }
        popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.x -= 400;
        popoverView.lblTitle.textColor = [UIColor blackColor];
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
    }
    
}


-(void) donePerformedByClick
{
    PerformedByViewController *p = (PerformedByViewController *) self.popover.contentViewController;
    [btnInput setTitle:p.txtName.text forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [delegate doneInputViewVital:self.tag];
}

-(void) doneDateTimeClick
{
    DateTimeViewController *p = (DateTimeViewController *)self.popover.contentViewController;
    
    [btnInput setTitle:p.displayStr forState:UIControlStateNormal];
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [delegate doneInputViewVital:self.tag];
}

-(void) doneNumericClick
{
    NumericViewController *p = (NumericViewController *)self.popover.contentViewController;
    if ([p isKindOfClass:[NumericViewController class]])
    {
        if (p.detailsSet)
        {
            if (p.vitalSelected == 1)
            {
                // lblSystolic.text = p.detailsText;
            }
        }
    }
    [btnInput setTitle:p.displayStr forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [delegate doneInputViewVital:self.tag];
}

-(void) doneDetailClick
{
    NumericViewController *p = (NumericViewController *)self.popover.contentViewController;

    lblDetail.text = p.detailsText;
}


@end
