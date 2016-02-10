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
        [[NSBundle mainBundle] loadNibNamed:@"InputVIewCalltime" owner:self options:nil];
        self.bounds = self.view.bounds;
        
        [self addSubview:self.view];
        displayStr = [[NSMutableString alloc] init];
        self.txtInput.delegate = self;
        keypad = [[Keypad alloc] init];
        keypad.delegate = self;
        self.txtInput.inputView = keypad;
        self.txtInput.inputAccessoryView.hidden = YES;
        self.txtInput.inputAccessoryView = nil;
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
        displayStr = [[NSMutableString alloc] init];
        self.txtInput.delegate = self;
        keypad = [[Keypad alloc] init];
        keypad.delegate = self;
        self.txtInput.inputView = keypad;
        self.txtInput.inputAccessoryView.hidden = YES;
        self.txtInput.inputAccessoryView = nil;
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

    
}

- (IBAction)btnInputClick:(UIButton *)sender {
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    self.txtInput.text = dateString;
    
}


- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    if ( textField.inputView != nil)
        // if ( [textField.inputView isKindOfClass:[CustomKeypad class]] )
        ((Keypad*)textField.inputView).target = textField;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if (textField.inputView != nil)
        // if ( [textField.inputView isKindOfClass:[CustomKeypad class]] )
        ((Keypad*)textField.inputView).target = nil;
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

- (void) doneNumericClick
{
    
}

@end
