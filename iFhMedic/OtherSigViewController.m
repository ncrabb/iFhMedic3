//
//  OtherSigViewController.m
//  iRescueMedic
//
//  Created by admin on 12/26/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "OtherSigViewController.h"
#import "ClsTableKey.h"
#import "DDPopoverBackgroundView.h"

@interface OtherSigViewController ()

@end

@implementation OtherSigViewController
@synthesize txtName;
@synthesize lblHeader;
@synthesize btnSignature;
@synthesize labelTitle;
@synthesize sigType;
@synthesize delegate;
@synthesize needToSave;
@synthesize signView;
@synthesize image;
@synthesize array;
@synthesize popover;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    txtName.delegate = self;

    needToSave = FALSE;
    
    containerView = [[UIView alloc] initWithFrame:CGRectMake(44, 175.0, 440, 155)];
    containerView.backgroundColor = [UIColor whiteColor];
    
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.borderWidth = 2;
    containerView.layer.cornerRadius = 8;
    containerView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,440, 155)];
    
    self.signView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:self.signView];
    [self.view addSubview:containerView];
}

- (void) viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:YES];
    lblHeader.text = labelTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSignatureTypeClick:(UIButton*)sender {
    [txtName resignFirstResponder];
    if (self.sigType == 8)
    {
        if (array == nil)
        {
            self.array = [[NSMutableArray alloc] init];
            ClsTableKey* key1 = [[ClsTableKey alloc] init];
            key1.tableID = 1;
            key1.desc = @"Power of Attorney";
            [array addObject:key1];
            ClsTableKey* key2 = [[ClsTableKey alloc] init];
            key2.tableID = 1;
            key2.desc = @"Relative or other person who receives govt benefits";
            [array addObject:key2];
            ClsTableKey* key3 = [[ClsTableKey alloc] init];
            key3.tableID = 3;
            key3.desc = @"Relative or other person who arrange treatment";
            [array addObject:key3];
            ClsTableKey* key4 = [[ClsTableKey alloc] init];
            key4.tableID = 4;
            key4.desc = @"Representative of an agency or institution that furnishes care";
            [array addObject:key4];
            ClsTableKey* key5 = [[ClsTableKey alloc] init];
            key5.tableID = 5;
            key5.desc = @"Spouse";
            [array addObject:key5];
            ClsTableKey* key6 = [[ClsTableKey alloc] init];
            key6.tableID = 6;
            key6.desc = @"Doctor";
            [array addObject:key6];
        }
        functionSelected = 8;
        PopupDataViewController *popoverView =[[PopupDataViewController alloc] initWithNibName:@"PopupDataViewController" bundle:nil];
        
        popoverView.array = self.array;
        popoverView.view.backgroundColor = [UIColor whiteColor];
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(520, 360);
        popoverView.delegate = self;
        CGRect frame = ((UIView *)sender).frame;
        frame.origin.x -= 122;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];

    }
    else if (self.sigType == 3)
    {
        if (array == nil)
        {
            self.array = [[NSMutableArray alloc] init];
            ClsTableKey* key1 = [[ClsTableKey alloc] init];
            key1.tableID = 1;
            key1.desc = @"Doctor";
            [array addObject:key1];
            ClsTableKey* key2 = [[ClsTableKey alloc] init];
            key2.tableID = 1;
            key2.desc = @"Nurse";
            [array addObject:key2];
            ClsTableKey* key3 = [[ClsTableKey alloc] init];
            key3.tableID = 3;
            key3.desc = @"Coroner";
            [array addObject:key3];
            ClsTableKey* key4 = [[ClsTableKey alloc] init];
            key4.tableID = 4;
            key4.desc = @"PD Unit";
            [array addObject:key4];
            ClsTableKey* key5 = [[ClsTableKey alloc] init];
            key5.tableID = 5;
            key5.desc = @"Other";
            [array addObject:key5];
        }
        functionSelected = 3;
        PopupDataViewController *popoverView =[[PopupDataViewController alloc] initWithNibName:@"PopupDataViewController" bundle:nil];
        
        popoverView.array = self.array;
        popoverView.view.backgroundColor = [UIColor whiteColor];
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(480, 360);
        popoverView.delegate = self;
        CGRect frame = ((UIView *)sender).frame;
        frame.origin.x -= 122;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];

    }

}

- (UIImage *)signatureImage
{
    UIGraphicsBeginImageContext(containerView.bounds.size);
    
    [containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return viewImage;
    
}

- (IBAction)btnCancel:(id)sender {
    [self.delegate doneOtherSigningClick];
    needToSave = FALSE;
}

- (IBAction)btnClear:(id)sender {
    [signView removeFromSuperview];
    self.signView = nil;
    
    self.signView = [[ScribbleView alloc] initWithFrame:CGRectMake(0.0, 0.0,440, 155)];
    
    self.signView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:self.signView];
}

- (IBAction)btnSave:(id)sender {
    needToSave = TRUE;
    self.image = [self signatureImage];
    NSLog(@"Exit image");
    [self.delegate doneOtherSigningClick];
}

- (void) doneDataViewClick
{
    PopupDataViewController *p = (PopupDataViewController *) popover.contentViewController;
    [btnSignature setTitle:p.txtDisplay.text forState:UIControlStateNormal];
    [popover dismissPopoverAnimated:YES];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
   // [textField resignFirstResponder];
    
}
@end
