//
//  WebViewController.h
//  iRescueMedic
//
//  Created by Balraj Randhawa on 05/05/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController
{
    WKWebView *webView;
}
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)doneButtonPressed:(id)sender;

@end
