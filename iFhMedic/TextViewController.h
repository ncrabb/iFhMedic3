//
//  TextViewController.h
//  iFhMedic
//
//  Created by admin on 9/20/15.
//  Copyright (c) 2015 com.emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DismissTextDelegate <NSObject>

-(void) doneText;

@end
@interface TextViewController : UIViewController
{
    __weak id <DismissTextDelegate> delegate;
}
@property (weak) id delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtDisplay;


- (IBAction)btnDoneClick:(id)sender;


@end
