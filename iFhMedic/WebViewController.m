//
//  WebViewController.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 05/05/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize toolBar;

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
	// Do any additional setup after loading the view.
    CGRect rect = CGRectMake(0, 64, 1024, 705);
    webView = [[WKWebView alloc] initWithFrame:rect];
    [self.view addSubview:webView];
    [self setViewUI];

    NSString *sUrl = [NSString stringWithFormat:@"http://www.firehousesoftware.com/webhelp/FHMedic/Default.htm"];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sUrl]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark --
#pragma mark <UIWebViewDelegate>

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}

#pragma mark- UI controls adjustments
-(void) setViewUI
{
    // toolBar background image
    UIImage *toolBarIMG = [UIImage imageNamed:NSLocalizedString(@"IMG_BG_NAVIGATIONBAR", nil)];
    [self.toolBar setBackgroundImage:toolBarIMG forToolbarPosition:0 barMetrics:0];
    toolBarIMG = nil;
    
}


@end
