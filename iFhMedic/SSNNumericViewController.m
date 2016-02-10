//
//  SSNNumericViewController.m
//  iRescueMedic
//
//  Created by Nathan on 7/1/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "SSNNumericViewController.h"

@interface SSNNumericViewController ()

@end

@implementation SSNNumericViewController
@synthesize displayStr;
@synthesize txtDisplay;
@synthesize lblTitle;
@synthesize btnUTO;
@synthesize utoEnabled;
@synthesize delegate;
@synthesize phoneFormat;

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
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (utoEnabled)
    {
        btnUTO.hidden = false;
    }
    else
    {
        btnUTO.hidden = true;
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
    if([self validateText:@"1"])
    {
        [displayStr appendString:@"1"];
        txtDisplay.text = displayStr;
    }
}

- (IBAction)btn2Click:(id)sender {
    if([self validateText:@"2"])
    {
        [displayStr appendString:@"2"];
        txtDisplay.text = displayStr;
    }
}

- (IBAction)btn3Click:(id)sender {
    if([self validateText:@"3"])
    {
        [displayStr appendString:@"3"];
        txtDisplay.text = displayStr;
    }
}

- (IBAction)btn4Click:(id)sender {
    if([self validateText:@"4"])
    {
        [displayStr appendString:@"4"];
        txtDisplay.text = displayStr;
}
}

- (IBAction)btn5Click:(id)sender {
    if([self validateText:@"5"])
    {
        [displayStr appendString:@"5"];
        txtDisplay.text = displayStr;
    }
}

- (IBAction)btn6Click:(id)sender {
    if([self validateText:@"6"])
    {
        [displayStr appendString:@"6"];
        txtDisplay.text = displayStr;
    }
}

- (IBAction)btn7Click:(id)sender {
    if([self validateText:@"7"])
    {
        [displayStr appendString:@"7"];
        txtDisplay.text = displayStr;
    }
}

- (IBAction)btn8Click:(id)sender {
    if([self validateText:@"8"])
    {
        [displayStr appendString:@"8"];
        txtDisplay.text = displayStr;
    }
}

- (IBAction)btn9Click:(id)sender {
    if([self validateText:@"9"])
    {
        [displayStr appendString:@"9"];
        txtDisplay.text = displayStr;
    }
}

- (IBAction)btn0Click:(id)sender {
    if([self validateText:@"0"])
    {
       // if ([displayStr length] > 0)
        {
            [displayStr appendString:@"0"];
            txtDisplay.text = displayStr;
        }
    }
}

- (IBAction)btnBackClick:(id)sender {

    if ( ([displayStr length] == 2 ) && ([[displayStr substringToIndex:1] isEqualToString:@"0"]))
    {
        [displayStr setString:[displayStr substringToIndex:[displayStr length] - 2]];
    }
    else
    {
        if ([displayStr length] > 0)
        {
            [displayStr setString:[displayStr substringToIndex:[displayStr length] - 1]];
        }
    }
    txtDisplay.text = displayStr;
}

- (IBAction)btnClearClick:(id)sender {
    [displayStr setString:@""];
    txtDisplay.text = displayStr;     
}

- (IBAction)btnEnterClick:(id)sender {
    if ([txtDisplay.text containsString:@"UTO"])
    {
        [delegate doneSSNClick];
        return;
    }
    if([txtDisplay.text length] <11)
    {
        if (phoneFormat == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Phone Number" message:@"Please enter 10 digit Phone number" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            [alert show];
            alert = Nil;
        }
        else
        {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Social Security Number" message:@"Please enter 9 digit SSN number" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                [alert show];
                alert = Nil;

        }
    }
    else
    {
        [delegate doneSSNClick];
    }
}


- (BOOL)validateText:(NSString *)string{

    if (phoneFormat == 1)
    {
        if([txtDisplay.text length]>11)
        {
            return NO;
            
        }
    }
    else
    {
        if([txtDisplay.text length]>10)
        {
            return NO;
            
        }
    }

    
    {
        if (phoneFormat == 1)
        {
            if(([txtDisplay.text length] == 3) || ([txtDisplay.text length] == 7))
            {
                [displayStr appendString:@"-"];
            }
        }
        else
        {
                if(([txtDisplay.text length] == 3) || ([txtDisplay.text length] == 6))
                {
                    [displayStr appendString:@"-"];
                }
        }
                return YES;
    }
    
    return YES;
}

- (IBAction)btnUTOClick:(id)sender
{
    [displayStr setString:@"UTO"];
    txtDisplay.text = displayStr;
}

@end
