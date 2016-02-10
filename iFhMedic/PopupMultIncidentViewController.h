//
//  PopupMultIncidentViewController.h
//  iRescueMedic
//
//  Created by admin on 10/24/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissMultipleIncidentDelegate <NSObject>

-(void) doneMultipleIncident;

@end

@interface PopupMultIncidentViewController : UIViewController
{
    __weak id <DismissMultipleIncidentDelegate> delegate;
    NSMutableArray *arrSelectedData;
}


@property (nonatomic, strong) NSMutableArray* array;
@property (weak) id delegate;
@property (nonatomic, strong) NSMutableArray *arrRowSelected;
@property (nonatomic, strong) NSString *strSelectedData;

-(void)setDefaultData;

- (IBAction)doneClicked:(id)sender;

@end
