//
//  PopupMedViewController.h
//  iRescueMedic
//
//  Created by admin on 9/5/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissMedViewDelegate <NSObject>

-(void)doneMedClick;

@end


@interface PopupMedViewController : UIViewController
{
    __weak id <DismissMedViewDelegate> delegate;
}
@property (weak) id delegate;

@property (strong, nonatomic) IBOutlet UITextField *txtDrugName;
@property (nonatomic, assign) NSInteger buttonClicked;

- (IBAction)btnCancel:(id)sender;

- (IBAction)btnContinue:(UIButton *)sender;


@end
