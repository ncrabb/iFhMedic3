//
//  DateTimeViewController.m
//  iRescueMedic
//
//  Created by admin on 3/22/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "DateTimeViewController.h"

@interface DateTimeViewController ()

@end

@implementation DateTimeViewController
@synthesize displayStr;
@synthesize txtDisplay;
@synthesize delegate;
@synthesize lblTtle;

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
    self.displayStr = [[NSMutableString alloc] init];
    [displayStr appendString:@"__/__/____ __:__:__"];
    txtDisplay.text = displayStr;
    charCount = 0;
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    [displayStr setString:dateString];
    txtDisplay.text = displayStr;
    charCount = 19;
}

- (void)setDate:(NSString *)dateString
{
    previousDate = dateString;
    
    if([dateString length] >5)
    {
        [displayStr setString:dateString];
        txtDisplay.text = displayStr;
        charCount = 16;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtDisplay:nil];
    [super viewDidUnload];
}
- (IBAction)btn1Click:(id)sender {
    if (charCount < 19)
    {
        NSRange temprange=NSMakeRange(charCount, 1);
        [displayStr replaceCharactersInRange:temprange withString:@"1"];
        txtDisplay.text = displayStr;
        if ( (charCount == 1) || (charCount == 4) || (charCount == 9) || (charCount == 12) || (charCount == 15))
        {
            charCount +=  2;
        }
        else
        {
            charCount++;
        }
        
        [self validate];
    }
}

- (IBAction)btn2Click:(id)sender {
    if (charCount < 19)
    {
        NSRange temprange=NSMakeRange(charCount, 1);
        [displayStr replaceCharactersInRange:temprange withString:@"2"];
        txtDisplay.text = displayStr;
        if ( (charCount == 1) || (charCount == 4) || (charCount == 9) || (charCount == 12) || (charCount == 15))
        {
            charCount +=  2;
        }
        else
        {
            charCount++;
        }
        [self validate];

    }
}

- (IBAction)btn3Click:(id)sender {
    if (charCount < 19)
    {
        NSRange temprange=NSMakeRange(charCount, 1);
        [displayStr replaceCharactersInRange:temprange withString:@"3"];
        txtDisplay.text = displayStr;
        if ( (charCount == 1) || (charCount == 4) || (charCount == 9) || (charCount == 12) || (charCount == 15))
        {
            charCount +=  2;
        }
        else
        {
            charCount++;
        }
        [self validate];

    }
}

- (IBAction)btn4Click:(id)sender {
    if (charCount < 19)
    {
        NSRange temprange=NSMakeRange(charCount, 1);
        [displayStr replaceCharactersInRange:temprange withString:@"4"];
        txtDisplay.text = displayStr;
        if ( (charCount == 1) || (charCount == 4) || (charCount == 9) || (charCount == 12) || (charCount == 15))
        {
            charCount +=  2;
        }
        else
        {
            charCount++;
        }
        [self validate];

    }
}

- (IBAction)btn5Click:(id)sender {
    if (charCount < 19)
    {
        NSRange temprange=NSMakeRange(charCount, 1);
        [displayStr replaceCharactersInRange:temprange withString:@"5"];
        txtDisplay.text = displayStr;
        if ( (charCount == 1) || (charCount == 4) || (charCount == 9) || (charCount == 12) || (charCount == 15))
        {
            charCount +=  2;
        }
        else
        {
            charCount++;
        }
        [self validate];

    }
}

- (IBAction)btn6Click:(id)sender {
    if (charCount < 19)
    {
        NSRange temprange=NSMakeRange(charCount, 1);
        [displayStr replaceCharactersInRange:temprange withString:@"6"];
        txtDisplay.text = displayStr;
        if ( (charCount == 1) || (charCount == 4) || (charCount == 9) || (charCount == 12) || (charCount == 15))
        {
            charCount +=  2;
        }
        else
        {
            charCount++;
        }
        [self validate];

    }
}

- (IBAction)btn7Click:(id)sender {
    if (charCount < 19)
    {
        NSRange temprange=NSMakeRange(charCount, 1);
        [displayStr replaceCharactersInRange:temprange withString:@"7"];
        txtDisplay.text = displayStr;
        if ( (charCount == 1) || (charCount == 4) || (charCount == 9) || (charCount == 12) || (charCount == 15))
        {
            charCount +=  2;
        }
        else
        {
            charCount++;
        }
        [self validate];

    }
}

- (IBAction)btn8Click:(id)sender {
    if (charCount < 19)
    {
        NSRange temprange=NSMakeRange(charCount, 1);
        [displayStr replaceCharactersInRange:temprange withString:@"8"];
        txtDisplay.text = displayStr;
        if ( (charCount == 1) || (charCount == 4) || (charCount == 9) || (charCount == 12) || (charCount == 15))
        {
            charCount +=  2;
        }
        else
        {
            charCount++;
        }
        [self validate];

    }
}

- (IBAction)btn9Click:(id)sender {
    if (charCount < 19)
    {
        NSRange temprange=NSMakeRange(charCount, 1);
        [displayStr replaceCharactersInRange:temprange withString:@"9"];
        txtDisplay.text = displayStr;
        if ( (charCount == 1) || (charCount == 4) || (charCount == 9) || (charCount == 12) || (charCount == 15))
        {
            charCount +=  2;
        }
        else
        {
            charCount++;
        }
        
        [self validate];
    }
}

- (IBAction)btn0Click:(id)sender {
    if ([displayStr length] > 0)
    {
        if (charCount < 19)
        {
            NSRange temprange=NSMakeRange(charCount, 1);
            [displayStr replaceCharactersInRange:temprange withString:@"0"];
            txtDisplay.text = displayStr;
            if ( (charCount == 1) || (charCount == 4) || (charCount == 9) || (charCount == 12) || (charCount == 15))
            {
                charCount +=  2;
            }
            else
            {
                charCount++;
            }
        }
        [self validate];
    }
}

- (IBAction)btnBackClick:(id)sender {
    
/*    if ( ([displayStr length] == 2 ) && ([[displayStr substringToIndex:1] isEqualToString:@"0"]))
    {
        [displayStr setString:[displayStr substringToIndex:[displayStr length] - 2]];
    }
    else
    {
        if ([displayStr length] > 0)
        {
            [displayStr setString:[displayStr substringToIndex:[displayStr length] - 1]];
        }
    } */
    
    if (charCount > 0)
    {
        if ( (charCount == 3) || (charCount == 6) || (charCount == 11) || (charCount == 14) || (charCount == 17))
        {
            charCount -=  2;
        }
        else
        {
            charCount--;
        }
        NSRange temprange=NSMakeRange(charCount, 1);
        [displayStr replaceCharactersInRange:temprange withString:@"_"];
        txtDisplay.text = displayStr;
    }
    
    txtDisplay.text = displayStr;
    
}

- (IBAction)btnClearClick:(id)sender {
    [displayStr setString:@"__/__/____ __:__:__"];
    txtDisplay.text = displayStr;
    charCount = 0;
}

- (IBAction)btnUTOClick:(id)sender {
}

- (IBAction)btnEnterClick:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *Pdate = [dateFormatter dateFromString:previousDate];
    NSDate *CDate = [dateFormatter dateFromString:txtDisplay.text];
    
    if ([CDate compare:Pdate] == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Date" message:@"Please enter date which is greater or equal to previous date" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        return;
    }
    else
    {
        [delegate doneDateTimeClick];
    }
}

- (IBAction)btnNowClick:(id)sender {
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];

    [displayStr setString:dateString];
    txtDisplay.text = displayStr;
    charCount = 16;
}

- (IBAction)btn5Ago:(id)sender {
    @try {
        NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        NSDate* currDate = [dateFormater dateFromString:displayStr];
        NSDate* newDate = [currDate dateByAddingTimeInterval:-300];
        NSString *dateString = [dateFormater stringFromDate:newDate];
        [displayStr setString:dateString];
        txtDisplay.text = displayStr;
        charCount = 16;
    }
    @catch (NSException *exception) {
        NSDate* currDate = [NSDate date];
        NSDate* newDate = [currDate dateByAddingTimeInterval:-300];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:newDate];

        [displayStr setString:dateString];
        txtDisplay.text = displayStr;
        charCount = 16;
    }
    @finally {

    }
}

- (IBAction)btn1Fwd:(id)sender {
    @try {
        NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        NSDate* currDate = [dateFormater dateFromString:displayStr];
        NSDate* newDate = [currDate dateByAddingTimeInterval:60];
        NSString *dateString = [dateFormater stringFromDate:newDate];
        [displayStr setString:dateString];
        txtDisplay.text = displayStr;
        charCount = 16;
    }
    @catch (NSException *exception) {
        NSDate* currDate = [NSDate date];
        NSDate* newDate = [currDate dateByAddingTimeInterval:60];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:newDate];
        
        [displayStr setString:dateString];
        txtDisplay.text = displayStr;
        charCount = 16;
    }
    @finally {
        
    }
}

- (IBAction)btn1Ago:(id)sender {
    @try {
        NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        NSDate* currDate = [dateFormater dateFromString:displayStr];
        NSDate* newDate = [currDate dateByAddingTimeInterval:-60];
        NSString *dateString = [dateFormater stringFromDate:newDate];
        [displayStr setString:dateString];
        txtDisplay.text = displayStr;
        charCount = 16;
    }
    @catch (NSException *exception) {
        NSDate* currDate = [NSDate date];
        NSDate* newDate = [currDate dateByAddingTimeInterval:-60];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:newDate];
        
        [displayStr setString:dateString];
        txtDisplay.text = displayStr;
        charCount = 16;
    }
    @finally {
        
    }
}

- (IBAction)btn1DayFwd:(id)sender
{
    @try {
        NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        NSDate* currDate = [dateFormater dateFromString:displayStr];
        NSDate* newDate = [currDate dateByAddingTimeInterval:86400];
        NSString *dateString = [dateFormater stringFromDate:newDate];
        [displayStr setString:dateString];
        txtDisplay.text = displayStr;
        charCount = 16;
    }
    @catch (NSException *exception) {
        NSDate* currDate = [NSDate date];
        NSDate* newDate = [currDate dateByAddingTimeInterval:86400];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:newDate];
        
        [displayStr setString:dateString];
        txtDisplay.text = displayStr;
        charCount = 16;
    }
    @finally {
        
    }

}

- (IBAction)btn1DayAgo:(id)sender
{
    @try {
        NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"MM/dd/yyyy HH:mm:ss";
        NSDate* currDate = [dateFormater dateFromString:displayStr];
        NSDate* newDate = [currDate dateByAddingTimeInterval:-86400];
        NSString *dateString = [dateFormater stringFromDate:newDate];
        [displayStr setString:dateString];
        txtDisplay.text = displayStr;
        charCount = 16;
    }
    @catch (NSException *exception) {
        NSDate* currDate = [NSDate date];
        NSDate* newDate = [currDate dateByAddingTimeInterval:-86400];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:newDate];
        
        [displayStr setString:dateString];
        txtDisplay.text = displayStr;
        charCount = 16;
    }
    @finally {
        
    }

}

- (IBAction)btnDecimalClick:(id)sender {
    if ([displayStr length] > 0)
    {
        [displayStr appendString:@"."];
        txtDisplay.text = displayStr;
    }
    else
    {
        [displayStr appendString:@"0."];
        txtDisplay.text = displayStr;
    }
}

- (BOOL)validate
{
    if(charCount == 3)
    {
        NSString *str = [txtDisplay.text substringToIndex:2];
        NSInteger month = [str integerValue];
        if(month >12)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Date and time" message:@"Enter valid month" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            [alert show];
            
            [displayStr setString:@"__/__/____ __:__"];
            txtDisplay.text = displayStr;
            charCount = 0;
            return NO;
        }
        else
            return YES;
    }
    else if(charCount == 6)
    {
        NSString *str = [txtDisplay.text substringFromIndex:3];
        str = [str substringToIndex:2];
        NSInteger day = [str integerValue];
        if(day>31)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Date and time" message:@"Enter valid day of month" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            [alert show];
            [self btnBackClick:Nil];
            [self btnBackClick:Nil];
            return NO;
            
        }
        else
            return YES;
    }
    else if(charCount == 11)
    {
        NSString *str = [txtDisplay.text substringFromIndex:6];
        str = [str substringToIndex:4];
        NSInteger year = [str integerValue];
        if(year>2050)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Date and time" message:@"Enter valid year upto 2050" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            [alert show];
            [self btnBackClick:Nil];
            [self btnBackClick:Nil];
            [self btnBackClick:Nil];
            [self btnBackClick:Nil];

            return NO;
        }

    }
    return YES;
}

@end
