//
//  PopOverWithSearchViewController.h
//  iRescueMedic
//
//  Created by admin on 2/27/15.
//  Copyright (c) 2015 Emergidata. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissSearchUserDelegate <NSObject>

-(void)doneSearchUserTap;

@end

@interface PopOverWithSearchViewController : UIViewController <UISearchBarDelegate>
{
    __weak id <DismissSearchUserDelegate> delegate;
}

@property (nonatomic) NSInteger functionSelected;

@property (nonatomic, strong) NSMutableArray* arrayUsers;

@property (weak) id delegate;
@property (nonatomic) NSInteger rowSelected;
@property (strong, nonatomic) IBOutlet UISearchBar *searchbar;

@property (strong, nonatomic) IBOutlet UITableView *tableview1;
@property (assign, nonatomic) NSInteger unitSelectedID;

@end
