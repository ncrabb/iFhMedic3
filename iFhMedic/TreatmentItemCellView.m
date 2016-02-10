//
//  TreatmentItemCellView.m
//  iRescueMedic
//
//  Created by Balraj Randhawa on 01/07/14.
//  Copyright (c) 2014 Emergidata. All rights reserved.
//

#import "TreatmentItemCellView.h"
#import "PopoverTreatmentInfoViewController.h"

@implementation TreatmentItemCellView
@synthesize lblTitle;
@synthesize btnText;
@synthesize index;
@synthesize tvNotes;

@synthesize parent;
@synthesize treatmentInputInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       // self.tvNotes.delegate = self;
    }
    
    return self;
}


- (IBAction)buttonPressed:(id)sender
{
    ((PopoverTreatmentInfoViewController *)parent).selectedTreatmentCell = self.tag;
    [(PopoverTreatmentInfoViewController *)parent inputButtonPressed:treatmentInputInfo tag:index];
}

- (void)textViewDidEndEditing:(UITextView *)textView{

    int treatmentID = ((PopoverTreatmentInfoViewController *)parent).treatment.treatmentID;

    ((PopoverTreatmentInfoViewController *)parent).functionSelected = index;

    
    ((PopoverTreatmentInfoViewController *)parent).selectedTreatmentCell = self.tag;

    ClsTreatmentInputs *input = (ClsTreatmentInputs*)[((PopoverTreatmentInfoViewController *)parent).treatment.arrayTreatmentInputValues objectAtIndex:((PopoverTreatmentInfoViewController *)parent).functionSelected-1];
    input.inputValue = textView.text;
    [btnText setTitle:textView.text forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   // [txtValue resignFirstResponder];
    return YES;   
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    int treatmentID = ((PopoverTreatmentInfoViewController *)parent).treatment.treatmentID;

    ((PopoverTreatmentInfoViewController *)parent).functionSelected = index;
    [btnText setTitle:textField.text forState:UIControlStateNormal];

    ((PopoverTreatmentInfoViewController *)parent).selectedTreatmentCell = self.tag;
 
     ClsTreatmentInputs *input = (ClsTreatmentInputs*)[((PopoverTreatmentInfoViewController *)parent).treatment.arrayTreatmentInputValues objectAtIndex:((PopoverTreatmentInfoViewController *)parent).functionSelected-1];
   // input.inputValue = txtValue.text;
   // [btnText setTitle:txtValue.text forState:UIControlStateNormal];

    return YES;
}

- (void)setButtonText:(NSString *)str
{
    [btnText setTitle:str forState:UIControlStateNormal];
    self.tvNotes.text = str;
}

- (void) setLabelColor:(UIColor*) color
{
    lblTitle.textColor = color;
}

- (void) setTextFieldFirstRespond
{
    btnText.hidden = YES;
    [tvNotes becomeFirstResponder];
}
- (void) setTextFieldResignRespond
{
    [tvNotes resignFirstResponder];
}
@end
