//
//  InputVIewCalltime.m
//  iFhMedic
//
//  Created by admin on 2/2/16.
//  Copyright © 2016 com.emergidata. All rights reserved.
//

#import "InputVIewCalltime.h"
#import "DAO.h"
#import "global.h"
#import "DDPopoverBackgroundView.h"
#import "ClsTableKey.h"

@implementation InputVIewCalltime
@synthesize inputType;
@synthesize popover;
@synthesize inputID;
@synthesize array;
@synthesize position;
@synthesize delegate;
@synthesize tabPage;
@synthesize btnDisplay;
@synthesize txtInput;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id) initWithInput:(NSInteger) input
{
    self=[super init];
    if (self)
    {
        if (input == 1060 || input == 1061 || input == 9050 || input == 1067 || input == 1066)
        {
            btnDisplay.hidden = false;
            txtInput.hidden = true;
        }
        else
        {
            btnDisplay.hidden = true;
            txtInput.hidden = false;
            displayStr = [[NSMutableString alloc] init];
            self.txtInput.delegate = self;
            keypad = [[Keypad alloc] init];
            keypad.delegate = self;
            self.txtInput.inputView = keypad;
            self.txtInput.inputAccessoryView.hidden = YES;
            savedtag = 0;
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"InputVIewCalltime" owner:self options:nil];
        self.bounds = self.view.bounds;
        self.txtInput.inputAccessoryView.hidden = YES;
        [self addSubview:self.view];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"InputVIewCalltime" owner:self options:nil];
        [self addSubview:self.view];

    }
    return self;
}

-(void) setLabelText: (NSString*) labelText dataType:(NSInteger) type inputRequired:(NSInteger) required
{

    [self.btnInput setTitle:labelText forState:UIControlStateNormal];
    if (required == 1)
    {
        [self.btnInput setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

-(void) setBtnText: (NSString*) btnText
{
    self.txtInput.text = btnText;
    [btnDisplay setTitle:btnText forState:UIControlStateNormal];
}

- (IBAction)btnDisplayClick:(UIButton*)sender {
    NumericViewController *popoverView =[[NumericViewController alloc] initWithNibName:@"NumericViewController" bundle:nil];
    popoverView.view.backgroundColor = [UIColor blackColor];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
    self.popover.popoverContentSize = CGSizeMake(400, 400);
    popoverView.utoEnabled = true;
    popoverView.unhide = 1;
    popoverView.utoEnabled = true;
    
    popoverView.delegate = self;
    CGRect frame = sender.frame;
    frame.origin.x -= 400;
    popoverView.lblTitle.textColor = [UIColor blackColor];
    [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnInputClick:(UIButton *)sender {
    if (self.inputID == 1060 || self.inputID == 1061 || self.inputID == 9050 || self.inputID == 1067 || self.inputID == 1066)
    {
        NumericViewController *popoverView =[[NumericViewController alloc] initWithNibName:@"NumericViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor blackColor];
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(400, 400);
        popoverView.utoEnabled = true;
        popoverView.unhide = 1;
        popoverView.utoEnabled = true;
        
        popoverView.delegate = self;
        CGRect frame = sender.frame;
     //   frame.origin.x += 100;
        popoverView.lblTitle.textColor = [UIColor blackColor];
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];

    }
    else
    {
        NSDate *currDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:currDate];
        self.txtInput.text = dateString;
    }
    
}


- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    if ( textField.inputView != nil)
    {
        if ( [textField.inputView isKindOfClass:[Keypad class]] )
        {
            ((Keypad*)textField.inputView).target = textField;
        }
        float y = [[textField superview] superview].frame.origin.y;
        
        if (y  > 350)
        {
            savedtag = [[textField superview] superview].tag;
            [self setViewMovedUp:YES];
        }
    }
    
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if (textField.inputView != nil)
    {     // if ( [textField.inputView isKindOfClass:[CustomKeypad class]] )
        ((Keypad*)textField.inputView).target = nil;
        int tag = [[textField superview] superview].tag;
        
        if (tag == savedtag)
        {
            [self setViewMovedUp:NO];
        }
    }
}

- (void)setViewMovedUp:(BOOL)movedUp
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = [self.view superview].frame;
    if (movedUp)
    {
        yCoord = rect.origin.y;
        rect.origin.y = 0.0;

    }
    else
    {
        
        rect.origin.y = yCoord;
    }
    [self.view superview].frame = rect;
    [UIView commitAnimations];
}


- (void) doneButtonTapped: (NSInteger) ASCIICode withTarget: target
{
    if (ASCIICode == 10)
    {
        ASCIICode = 0;
    }
    if (target == self.txtInput)
    {
        
        if (ASCIICode >= 0 && ASCIICode <= 9)
        {
            if([self validateText:self.txtInput])
            {
                if([self.txtInput.text length]<19)
                {
                    NSString* temp = [NSString stringWithFormat:@"%d", ASCIICode];
                    [self.txtInput insertText:temp];
                }
            }
            
        }
        else if (ASCIICode == 11) // Now
        {
            NSDate *currDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
            NSString *dateString = [dateFormatter stringFromDate:currDate];
            
            self.txtInput.text = dateString;
            
        }
        else if (ASCIICode == 12) // +1 min
        {
            if (self.txtInput.text.length != 19)
            {
                self.txtInput.text = [self settime:0];
            }
            @try {
                [displayStr setString:self.txtInput.text];
                NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
                dateFormater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
                NSDate* currDate = [dateFormater dateFromString:displayStr];
                NSDate* newDate = [currDate dateByAddingTimeInterval:60];
                NSString *dateString = [dateFormater stringFromDate:newDate];
                self.txtInput.text = dateString;
                
            }
            @catch (NSException *exception) {
                self.txtInput.text = [self settime:60];
                
            }
            @finally {
                
            }
            
        }
        else if (ASCIICode == 13) // -5 min
        {
            if (self.txtInput.text.length != 19)
            {
                self.txtInput.text = [self settime:0];
            }
            @try {
                [displayStr setString:self.txtInput.text];
                NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
                dateFormater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
                NSDate* currDate = [dateFormater dateFromString:displayStr];
                NSDate* newDate = [currDate dateByAddingTimeInterval:-300];
                NSString *dateString = [dateFormater stringFromDate:newDate];
                self.txtInput.text = dateString;
                
            }
            @catch (NSException *exception) {
                self.txtInput.text = [self settime:-300];
                
            }
            @finally {
                
            }
            
        }
        else if (ASCIICode == 14) // -1 min
        {
            if (self.txtInput.text.length != 19)
            {
                self.txtInput.text = [self settime:0];
            }
            @try {
                [displayStr setString:self.txtInput.text];
                NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
                dateFormater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
                NSDate* currDate = [dateFormater dateFromString:displayStr];
                NSDate* newDate = [currDate dateByAddingTimeInterval:-60];
                NSString *dateString = [dateFormater stringFromDate:newDate];
                self.txtInput.text = dateString;
                
            }
            @catch (NSException *exception) {
                self.txtInput.text = [self settime:-60];
                
            }
            @finally {
                
            }
            
        }
        
        else if (ASCIICode == 15) // delete
        {
            [self.txtInput deleteBackward];
            
        }
        
        else if (ASCIICode == 16) // 1 day
        {
            if (self.txtInput.text.length != 19)
            {
                self.txtInput.text = [self settime:0];
            }
            @try {
                [displayStr setString:self.txtInput.text];
                NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
                dateFormater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
                NSDate* currDate = [dateFormater dateFromString:displayStr];
                NSDate* newDate = [currDate dateByAddingTimeInterval:86400];
                NSString *dateString = [dateFormater stringFromDate:newDate];
                self.txtInput.text = dateString;
                
            }
            @catch (NSException *exception) {
                self.txtInput.text = [self settime:86400];
                
            }
            @finally {
                
            }
            
        }
        
        else if (ASCIICode == 17) // -1 day
        {
            if (self.txtInput.text.length != 19)
            {
                self.txtInput.text = [self settime:0];
            }
            @try {
                [displayStr setString:self.txtInput.text];
                NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
                dateFormater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
                NSDate* currDate = [dateFormater dateFromString:displayStr];
                NSDate* newDate = [currDate dateByAddingTimeInterval:-86400];
                NSString *dateString = [dateFormater stringFromDate:newDate];
                self.txtInput.text = dateString;
                
            }
            @catch (NSException *exception) {
                self.txtInput.text = [self settime:-86400];
                
            }
            @finally {
                
            }
            
        }
        
        else if (ASCIICode == 18) // Clear
        {
            self.txtInput.text = @"";
            
        }
        else if (ASCIICode == 19)
        {
            [self.txtInput resignFirstResponder];
            [delegate doneInputViewCalltime:self.tag];
        }
    }
}


- (NSString*) settime:(NSInteger) value
{
    NSDate* currDate = [NSDate date];
    NSDate* newDate = [currDate dateByAddingTimeInterval:value];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:newDate];
    return dateString;
}

- (BOOL)validateText:(UITextField *)textfield
{
    
    if([textfield.text length]>18)
    {
        return NO;
    }
    
    UITextRange *selRange = textfield.selectedTextRange;
    UITextPosition *selStartPos = selRange.start;
    NSInteger idx = [textfield offsetFromPosition:textfield.beginningOfDocument toPosition:selStartPos];
    
    
    if((idx == 2) || (idx == 5))
    {
        [textfield insertText:@"/"];
    }
    
    if((idx == 13) || (idx == 16))
    {
        [textfield insertText:@":"];
    }
    
    if(idx == 10)
    {
        [textfield insertText:@" "];
    }
    
    return YES;
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
    [btnDisplay setTitle:p.displayStr forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [delegate doneInputView:self.tag];
}

@end
