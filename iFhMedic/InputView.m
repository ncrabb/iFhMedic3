//
//  InputView.m
//  iFhMedic
//
//  Created by admin on 9/7/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import "InputView.h"
#import "DAO.h"
#import "global.h"
#import "DDPopoverBackgroundView.h"
#import "ClsTableKey.h"

@implementation InputView
@synthesize lblInput;

@synthesize btnInput;
@synthesize inputType;
@synthesize popover;
@synthesize inputID;
@synthesize array;
@synthesize position;
@synthesize delegate;
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
        [[NSBundle mainBundle] loadNibNamed:@"InputView" owner:self options:nil];
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
        [[NSBundle mainBundle] loadNibNamed:@"InputView" owner:self options:nil];
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
    if (inputType == 4 && btnInput.tag == 1401)
    {
        PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];//mani
        if ([array count] < 1)
        {
            NSString* querySql = [NSString stringWithFormat:@"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = %d", inputID];
            @synchronized(g_SYNCLOOKUPDB)
            {
                self.array = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
            }
            ClsTableKey* multi = [[ClsTableKey alloc] init];
            multi.key = [self.array count] + 1;
            multi.desc = @"Multi-Patient Refusal";
            multi.tableName = @"Manual";
            [self.array addObject:multi];
        }
        popoverView.array = self.array;
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        
        self.popover.popoverContentSize =  CGSizeMake(350, 400);
        
        popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.x -= 100;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    else if (inputType == 3 || inputType == 4 || inputType == 10 ||  inputType == 5 ||  inputType == 12  ||  inputType == 13 ||  inputType == 14)
    {
        
        PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];//mani
        if ([array count] < 1)
        {
            NSString* querySql = [NSString stringWithFormat:@"select Inputs.InputID, 'Inputs', IL.ValueName from Inputs inner join InputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = %d", inputID];
            @synchronized(g_SYNCLOOKUPDB)
            {
                self.array = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
            }
        }
        popoverView.array = self.array;
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        
        self.popover.popoverContentSize =  CGSizeMake(350, 400);
        
        popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.x -= 100;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
        
    }

    else if (inputType == 1)
    {
        CalendarViewController *popoverView =[[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(400, 260);
        popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.x -= 100;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    else if (inputType == 8 )
    {
        SSNNumericViewController *popoverView =[[SSNNumericViewController alloc] initWithNibName:@"SSNNumericViewController" bundle:nil];
        popoverView.phoneFormat = 1;
        popoverView.utoEnabled = true;
        popoverView.view.backgroundColor = [UIColor blackColor];
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(400, 400);
        popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.x -= 450;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        popoverView.lblTitle.textColor = [UIColor whiteColor];
    }
    else if (inputType == 7 )
    {
        SSNNumericViewController *popoverView =[[SSNNumericViewController alloc] initWithNibName:@"SSNNumericViewController" bundle:nil];
        popoverView.utoEnabled = true;
        popoverView.view.backgroundColor = [UIColor blackColor];
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(400, 400);
        popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.x -= 450;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        popoverView.lblTitle.textColor = [UIColor whiteColor];
    }
    
    else if (inputType == 11 || inputType == 6)
    {
        DateTimeViewController *popoverView =[[DateTimeViewController alloc] initWithNibName:@"DateTimeViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor blackColor];
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(440, 440);
        popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.x -= 300;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    else if (inputType == 15 )
    {
        PopupIncidentViewController *popoverView =[[PopupIncidentViewController alloc] initWithNibName:@"PopupIncidentViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];//mani
        if ([array count] < 1)
        {
            NSString* querySql = [NSString stringWithFormat:@"select rowID, 'Inputs', ziptext from Zips"];
            @synchronized(g_SYNCLOOKUPDB)
            {
                self.array = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
            }
        }
        popoverView.array = self.array;
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        
        self.popover.popoverContentSize =  CGSizeMake(350, 400);
        
        popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.x -= 100;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    else
    {
        TextViewController *popoverView =[[TextViewController alloc] initWithNibName:@"TextViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];//mani
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        
        self.popover.popoverContentSize =  CGSizeMake(500, 200);
        
        popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.x -= 100;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
}


- (void) doneText
{
    TextViewController *p = (TextViewController *)self.popover.contentViewController;
    if (p.txtDisplay.text != nil)
    {
        [btnInput setTitle:p.txtDisplay.text forState:UIControlStateNormal];
    }

    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [delegate doneInputView:self.tag];
}

- (void) didTap
{
    PopupIncidentViewController *p = (PopupIncidentViewController *)self.popover.contentViewController;
    ClsTableKey* key = [p.array objectAtIndex:p.rowSelected];
    [btnInput setTitle:key.desc forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [delegate doneInputView:self.tag];
}

- (void) doneClick
{
    CalendarViewController *p = (CalendarViewController *)self.popover.contentViewController;
    if (p.dpDate.date && p.dpDate.date.description.length > 10)
    {
            NSDate* dateSelected = p.dpDate.date;
            NSDateFormatter* format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MM/dd/yyyy"];
            NSString* dateStr = [format stringFromDate:dateSelected];
            [btnInput setTitle:dateStr forState:UIControlStateNormal] ;
    }
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [delegate doneInputView:self.tag];
}

- (void) doneSSNClick
{
    SSNNumericViewController *p = (SSNNumericViewController *)self.popover.contentViewController;
    [btnInput setTitle:p.displayStr forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [delegate doneInputView:self.tag];
}

-(void) doneDateTimeClick
{
    DateTimeViewController *p = (DateTimeViewController *)self.popover.contentViewController;

    [btnInput setTitle:p.displayStr forState:UIControlStateNormal];
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [delegate doneInputView:self.tag];
}
@end
