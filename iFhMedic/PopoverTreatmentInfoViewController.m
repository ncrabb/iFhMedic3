//
//  PopoverTreatmentInfoViewController.m
//  iRescueMedic
//
//  Created by Nathan on 6/11/13.
//  Copyright (c) 2013 Emergidata. All rights reserved.
//

#import "PopoverTreatmentInfoViewController.h"
#import "TreatmentsViewController.h"
#import "DDPopoverBackgroundView.h"
#import "DateTimeViewController.h"
#import "ClsTableKey.h"
#import "ClsDrugs.h"
#import "TreatmentItemCellView.h"
#import "ClsTreatmentInputs.h"

@interface PopoverTreatmentInfoViewController ()
{
    NSMutableArray *array ;
    NSInteger textfieldset;
}
@end

@implementation PopoverTreatmentInfoViewController
@synthesize delegate;
@synthesize treatment;
@synthesize popover;
@synthesize bEdit;
@synthesize functionSelected;

@synthesize drugs;

@synthesize routesArray;

@synthesize lblTreatmentHeader;
@synthesize containerView;
@synthesize btnCopyTreatment;
@synthesize scrollView;
@synthesize selectedTreatmentCell;



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
    
    textfieldset = 0;
    lblTreatmentHeader.text = treatment.treatmentDesc;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTreatmentInputs];
}
- (void) loadTreatmentInputs
{

    array = [self getInputArray:treatment.treatmentID];
    int positionY = 0;
    int itemWidth = 640;
    int itemHeight = 44;
    CGRect rcPosition;
    for(int i=0;i<[array count]; i++)
    {
        
        TreatmentItemCellView *cell = (TreatmentItemCellView *)[DAO getViewFromXib:@"TreatmentItemCellView" classname:[TreatmentItemCellView class]];
        ClsTreatmentInputs* source = (ClsTreatmentInputs *)[array objectAtIndex:i];
        ClsTreatmentInputs *data;
        if ([treatment.arrayTreatmentInputValues count] > i)
        {
            data = (ClsTreatmentInputs *)[self.treatment.arrayTreatmentInputValues objectAtIndex:i];

            if(bEdit)
            {
                [cell setButtonText:data.inputValue];
            }
            source.inputValue = data.inputValue;
        }
        else
        {

            if(bEdit)
            {
                [cell setButtonText:source.inputValue];
            }
        }
        cell.lblTitle.text = source.inputName;
        cell.parent = self;
        if (source.inputRequired == 1)
        {
            [cell setLabelColor:[UIColor redColor]];
        }
        if(source.inputDataType == 0)
        {
            
            cell.tvNotes.hidden = NO;
            cell.btnText.hidden = YES;
            cell.tvNotes.delegate = cell;
        }
        else
        {
            cell.tvNotes.hidden = YES;
        }
        cell.treatmentInputInfo = source;
        if(bEdit)
        {
            [cell setButtonText:source.inputValue];
        }
        cell.index = i+1;
        rcPosition = CGRectMake(0, positionY , itemWidth, itemHeight);
        positionY += itemHeight;
        cell.frame = rcPosition;
        cell.tag = i+1;
        [scrollView addSubview:cell];
        
    }
    treatment.arrayTreatmentInputValues = array;
    scrollView.contentSize = CGSizeMake(640, positionY);
    [self.scrollView.layer setCornerRadius:10.0f];
    [self.scrollView.layer setMasksToBounds:YES];
    self.scrollView.layer.borderWidth = 1;
    self.scrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)isExistTreatmentName:(NSString *)name inArray:(NSMutableArray*)array
{
    for(int i=0; i <[array count] ; i++)
    {
        ClsTreatmentInputs *Inputtreatment = [array objectAtIndex:i];
        if([Inputtreatment.inputName isEqualToString:name])
        {
            return i;
        }
    }
    return -1;
}

-(NSMutableArray *)getInputArray:(NSInteger)treatmentId
{
    NSMutableArray *array ;//= [[NSMutableArray alloc] init];
    
    NSString* sql = [NSString stringWithFormat:@"Select InputId, InputName, InputDataType, inputRequired from TreatmentInputs where TreatmentID=%ld AND Active = 1", treatment.treatmentID];
    @synchronized(g_LOOKUPDB)
    {
        array = [DAO executeSelectTreatmentInputs:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];
    }
    NSInteger result = [self isExistTreatmentName:@"Attempts" inArray:array];
    if(result<0)
    {
        ClsTreatmentInputs *Extratreatment1 = [[ClsTreatmentInputs alloc] init];
        Extratreatment1.inputID = 103;
        Extratreatment1.inputDataType = 2;
        Extratreatment1.inputName = @"Attempts";
        [array addObject:Extratreatment1];
        Extratreatment1 = nil;
    }
    
    result = [self isExistTreatmentName:@"Successful" inArray:array];

    if(result<0)
    {
        ClsTreatmentInputs *Extratreatment2 = [[ClsTreatmentInputs alloc] init];
        Extratreatment2.inputID = 104;
        Extratreatment2.inputName = @"Successful";
        Extratreatment2.inputDataType = 4;
        [array addObject:Extratreatment2];
        Extratreatment2 = nil;
    }
    
    result = [self isExistTreatmentName:@"Complications" inArray:array];
    if(result<0)
    {
        ClsTreatmentInputs *Extratreatment3 = [[ClsTreatmentInputs alloc] init];
        Extratreatment3.inputID = 105;
        Extratreatment3.inputName = @"Complications";
        Extratreatment3.inputDataType = 5;
        [array addObject:Extratreatment3];
        Extratreatment3 = nil;
    }
    
    result = [self isExistTreatmentName:@"Prior To Arrival" inArray:array];
    if(result<0)
    {
        ClsTreatmentInputs *Extratreatment4 = [[ClsTreatmentInputs alloc] init];
        Extratreatment4.inputID = 106;
        Extratreatment4.inputName = @"Prior To Arrival";
         Extratreatment4.inputDataType = 4;
        [array addObject:Extratreatment4];
        Extratreatment4 = nil;
    }
    
    result = [self isExistTreatmentName:@"Response" inArray:array];
    if(result<0)
    {
        ClsTreatmentInputs *Extratreatment5 = [[ClsTreatmentInputs alloc] init];
        Extratreatment5.inputID = 107;
        Extratreatment5.inputName = @"Response";
        [array addObject:Extratreatment5];
        Extratreatment5 = nil;
    }
    
    
    return array;
}


#pragma mark-
#pragma mark Class Methods

- (void)inputButtonPressed:(ClsTreatmentInputs *)inputData tag:(NSInteger)tag
{
    if (textfieldset > 0)
    {
        TreatmentItemCellView *cell1 = (TreatmentItemCellView *)[scrollView viewWithTag:textfieldset];
        [cell1 setTextFieldResignRespond];
        textfieldset = 0;
    }
    functionSelected = tag;
    NSInteger y = 43*(tag-1);

    if(inputData.inputDataType == 11)
    {
        DateTimeViewController *popoverView =[[DateTimeViewController alloc] initWithNibName:@"DateTimeViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor blackColor];
        popoverView.view.tag = tag;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(450, 450);
        popoverView.delegate = self;
        [self.popover presentPopoverFromRect:CGRectMake(80, 0, 450, 190) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
    else if( ([inputData.inputName rangeOfString:@"Performed By"].location != NSNotFound) && (inputData.inputDataType != 4) )
    {
        PerformedByViewController *popoverView =[[PerformedByViewController alloc] initWithNibName:@"PerformedByViewController" bundle:nil];
       // popoverView.allCrew = true;
        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.view.tag = tag;

        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(500, 346);
        popoverView.delegate = self;
        [self.popover presentPopoverFromRect:CGRectMake(25, y, 475, 190) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }

    else if([inputData.inputName isEqualToString:@"Attempts"] || [inputData.inputName isEqualToString:@"Dose"] || [inputData.inputName isEqualToString:@"O2 Flow Rate"] || [inputData.inputName isEqualToString:@"Size"] || [inputData.inputName isEqualToString:@"Number of Shocks"] || [inputData.inputName isEqualToString:@"Rate (Breaths)"] || [inputData.inputName isEqualToString:@"O2 Flow"] || [inputData.inputName isEqualToString:@"Rate (LPM)"] || [inputData.inputName isEqualToString:@"ETCO2"] || inputData.inputDataType == 2 || inputData.inputDataType == 16)
    {
        NumericViewController *popoverView =[[NumericViewController alloc] initWithNibName:@"NumericViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor blackColor];
        popoverView.view.tag = tag;

        functionSelected = tag;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(430, 420);
        popoverView.delegate = self;
        [self.popover presentPopoverFromRect:CGRectMake(80, y, 430, 190) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
     else if([inputData.inputName isEqualToString:@"Drug Name"])
     {
         functionSelected = tag;
         PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
         popoverView.view.tag = tag;

         popoverView.view.backgroundColor = [UIColor whiteColor];
         if ([drugs count] < 1)
         {
             NSString* sql = @"Select DrugID, DrugName, Narcotic from Drugs order by DrugName";
             @synchronized(g_LOOKUPDB)
             {
                 self.drugs = [DAO executeSelectDrugs:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql];;
             }
         }
         
         popoverView.drugs = self.drugs;
         popoverView.functionSelected = 3;
         popoverView.view.backgroundColor = [UIColor whiteColor];
         
         
         self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
         self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
         self.popover.popoverContentSize = CGSizeMake(340, 440);
         popoverView.delegate = self;
         
         [self.popover presentPopoverFromRect:CGRectMake(80, y,350, 190) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];

     }
    else
    {
        [routesArray removeAllObjects];
        
            NSString* querySql = [NSString stringWithFormat:@"select IL.InputlookupID, 'Inputs', IL.LookupName from TreatmentInputs Inputs inner join TreatmentInputLookup IL on Inputs.InputID = IL.InputID where Inputs.InputID = %d and IL.treatmentID = %d and Inputs.treatmentID = %d and IL.active =1", (int)inputData.inputID, (int)treatment.treatmentID, (int)treatment.treatmentID];
            
            @synchronized(g_SYNCLOOKUPDB)
            {
                self.routesArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:querySql WithExtraInfo:NO];
            }
        
        functionSelected = tag;
        
        PopoverViewController *popoverView =[[PopoverViewController alloc] initWithNibName:@"PopoverViewController" bundle:nil];
        popoverView.view.tag = tag;

        popoverView.view.backgroundColor = [UIColor whiteColor];
        popoverView.arrays = self.routesArray;
        popoverView.functionSelected = 4;
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(350, 400);
        popoverView.delegate = self;
        
        [self.popover presentPopoverFromRect:CGRectMake(80, y,350, 190) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    }
}

- (void) loadEntryFields
{
    if (self.bEdit)
    {
        NSMutableArray *InputArray = [self getInputArray:[NSString stringWithFormat:@"%d",(int)treatment.treatmentID]];
        int positionY = 0;
        int itemWidth = 640;
        int itemHeight = 44;
        CGRect rcPosition;
        for(int i=0;i<[InputArray count]; i++)
        {
            
            TreatmentItemCellView *cell = (TreatmentItemCellView *)[DAO getViewFromXib:@"TreatmentItemCellView" classname:[TreatmentItemCellView class]];
            ClsTreatmentInputs* source = (ClsTreatmentInputs *)[InputArray objectAtIndex:i];
            ClsTreatmentInputs *data;
           if ([treatment.arrayTreatmentInputValues count] > i)
           {
               for (int k = 0; k < treatment.arrayTreatmentInputValues.count;k++)
               {
                        [cell setButtonText:data.inputValue];
                        data = (ClsTreatmentInputs *)[treatment.arrayTreatmentInputValues objectAtIndex:k];
                        if (data.inputID == source.inputID)
                        {
                            cell.treatmentInputInfo = source;
                            if(bEdit)
                            {
                                 [cell setButtonText:data.inputValue];
                            }
                            source.inputValue = data.inputValue;
                         }
                   
               }
               source.inputValue = data.inputValue;
               

           }
            else
            {
                cell.treatmentInputInfo = source;
                if(bEdit)
                {
                    [cell setButtonText:source.inputValue];
                }
            }
            cell.lblTitle.text = source.inputName;
            cell.parent = self;
            if (source.inputRequired == 1)
            {
                [cell setLabelColor:[UIColor redColor]];
            }
            if([source.inputName isEqualToString:@"Notes"] || [source.inputName isEqualToString:@"Physician Name"])
            {
                
                cell.tvNotes.hidden = NO;
                cell.btnText.hidden = YES;
                cell.tvNotes.delegate = cell;
            }
            else
            {
                cell.tvNotes.hidden = YES;
            }

            cell.index = i+1;
            rcPosition = CGRectMake(0, positionY , itemWidth, itemHeight);
            positionY += itemHeight;
            cell.frame = rcPosition;
            cell.tag = i+1;
            [scrollView addSubview:cell];
 
        }
        
        scrollView.contentSize = CGSizeMake(640, positionY);
        [self.scrollView.layer setCornerRadius:10.0f];
        [self.scrollView.layer setMasksToBounds:YES];
        self.scrollView.layer.borderWidth = 1;
        self.scrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [treatment.arrayTreatmentInputValues removeAllObjects];
        treatment.arrayTreatmentInputValues = nil;
        treatment.arrayTreatmentInputValues = InputArray;
        
    }
    else
    {
        if([treatment.arrayTreatmentInputValues count]== 0)
        {
            NSMutableArray *InputArray = [self getInputArray:[NSString stringWithFormat:@"%d",(int)treatment.treatmentID]];
            treatment.arrayTreatmentInputValues = InputArray;
        }
        else if ( [treatment.arrayTreatmentInputValues count] <= 2)
        {
            NSMutableArray *InputArray = [self getInputArray:[NSString stringWithFormat:@"%d",(int)treatment.treatmentID]];
            ClsTreatmentInputs* modTime = [InputArray objectAtIndex:0];
            ClsTreatmentInputs* enteredTime = [treatment.arrayTreatmentInputValues objectAtIndex:0];
            modTime.inputValue = enteredTime.inputValue;
            if ([treatment.arrayTreatmentInputValues count] == 2)
            {
                ClsTreatmentInputs* modDrug = [InputArray objectAtIndex:1];
                ClsTreatmentInputs* enteredDrug = [treatment.arrayTreatmentInputValues objectAtIndex:1];
                modDrug.inputValue = enteredDrug.inputValue;
            }
            treatment.arrayTreatmentInputValues = InputArray;
        }
        
        int positionY = 0;
        int itemWidth = 640;
        int itemHeight = 44;
        CGRect rcPosition;
        for(int i=0;i<[treatment.arrayTreatmentInputValues count]; i++)
        {
            
            TreatmentItemCellView *cell = (TreatmentItemCellView *)[DAO getViewFromXib:@"TreatmentItemCellView" classname:[TreatmentItemCellView class]];
            ClsTreatmentInputs *data = (ClsTreatmentInputs *)[treatment.arrayTreatmentInputValues objectAtIndex:i];
            cell.lblTitle.text = data.inputName;
            cell.parent = self;
            if (data.inputRequired == 1)
            {
                [cell setLabelColor:[UIColor redColor]];
            }
            if([data.inputName isEqualToString:@"Notes"] || [data.inputName isEqualToString:@"Physician Name"])
            {
                
                cell.tvNotes.hidden = NO;
                cell.btnText.hidden = YES;
                cell.tvNotes.delegate = cell;
            }
            else
            {
                cell.tvNotes.hidden = YES;
            }
            cell.treatmentInputInfo = data;
            if(bEdit)
            {
                [cell setButtonText:data.inputValue];
            }
            cell.index = i+1;
            rcPosition = CGRectMake(0, positionY , itemWidth, itemHeight);
            positionY += itemHeight;
            cell.frame = rcPosition;
            cell.tag = i+1;
            [scrollView addSubview:cell];
            
        }
        
        scrollView.contentSize = CGSizeMake(640, positionY);
        [self.scrollView.layer setCornerRadius:10.0f];
        [self.scrollView.layer setMasksToBounds:YES];
        self.scrollView.layer.borderWidth = 1;
        self.scrollView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    

    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    int treatmentID = treatment.treatmentID;

    selectedTreatmentCell = textView.tag;
    //[(PopoverTreatmentInfoViewController *)parent didTap];
    ClsTreatmentInputs *input = (ClsTreatmentInputs*)[treatment.arrayTreatmentInputValues objectAtIndex:functionSelected-1];
    input.inputValue = textView.text;

}






- (IBAction)OkClick:(id)sender {
     [delegate didClickOK];
}

-(void) doneDateTimeClick
{
    DateTimeViewController *p = (DateTimeViewController *)self.popover.contentViewController;
    TreatmentItemCellView *cell = (TreatmentItemCellView *)[scrollView viewWithTag:selectedTreatmentCell];
    for (TreatmentItemCellView * view in scrollView.subviews)
    {
        if(view.tag == functionSelected)
        {

            [cell.btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.btnText setTitle:p.displayStr forState:UIControlStateNormal];
            [cell setButtonText:p.displayStr];
            ClsTreatmentInputs *input = (ClsTreatmentInputs*)[treatment.arrayTreatmentInputValues objectAtIndex:functionSelected-1];
            input.inputValue = p.displayStr;

            cell.backgroundColor = [UIColor whiteColor];

        }
    }
    
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    
    if (cell.tag < array.count)
    {
        ClsTreatmentInputs *input1 = (ClsTreatmentInputs*)[treatment.arrayTreatmentInputValues objectAtIndex:cell.tag];
        if(input1.inputDataType != 0)
        {
            [self inputButtonPressed:input1 tag:cell.tag + 1];
        }
        else
        {
            TreatmentItemCellView *cell1 = (TreatmentItemCellView *)[scrollView viewWithTag:cell.tag + 1];
            [cell1 setTextFieldFirstRespond];
            textfieldset = cell.tag;
        }
    }
    
}

-(void) donePerformedByClick
{
    PerformedByViewController *p = (PerformedByViewController *) self.popover.contentViewController;
    TreatmentItemCellView *cell = (TreatmentItemCellView *)[self.scrollView viewWithTag:functionSelected];
     ClsTreatmentInputs *input = (ClsTreatmentInputs*)[treatment.arrayTreatmentInputValues objectAtIndex:functionSelected-1];
    input.inputValue = p.txtName.text;
    [cell.btnText setTitle:p.txtName.text forState:UIControlStateNormal];
    [cell setButtonText:p.txtName.text];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    if (cell.tag < array.count)
    {
        ClsTreatmentInputs *input1 = (ClsTreatmentInputs*)[treatment.arrayTreatmentInputValues objectAtIndex:cell.tag];
        if(input1.inputDataType != 0)
        {
            [self inputButtonPressed:input1 tag:cell.tag + 1];
        }
        else
        {
            TreatmentItemCellView *cell1 = (TreatmentItemCellView *)[scrollView viewWithTag:cell.tag + 1];
            [cell1 setTextFieldFirstRespond];
            textfieldset = cell.tag;
        }
    }

}



-(void)didTap
{
    
    PopoverViewController *p = (PopoverViewController *)popover.contentViewController;
    TreatmentItemCellView *cell = (TreatmentItemCellView *)[scrollView viewWithTag:functionSelected];
    ClsTreatmentInputs *input = (ClsTreatmentInputs*)[treatment.arrayTreatmentInputValues objectAtIndex:functionSelected-1];
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    if([cell.lblTitle.text isEqualToString:@"Notes"])
    {
        if([input.inputName isEqualToString:cell.lblTitle.text])
        {
            input.inputValue = cell.btnText.titleLabel.text;
            
        }
        return;
    }
    if([cell.lblTitle.text isEqualToString:@"Drug Name"])
    {
        
        ClsDrugs* drugSelected = [drugs objectAtIndex:p.rowSelected];
        
         [cell setButtonText:drugSelected.drugName];
        if (![drugSelected.drugName isEqualToString:@" "])
        {
            NSString* drugSql = [NSString stringWithFormat:@"Select DrugID from drugs where drugname = '%@'", drugSelected.drugName];
            NSString* drugID;
            @synchronized(g_LOOKUPDB)
            {
                drugID = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:drugSql];;
            }
            if (drugID.length > 0)
            {
                NSMutableArray* dosageArray = [[NSMutableArray alloc] init];
                NSString* sql = [NSString stringWithFormat:@"Select DrugID, DosageID, Units || ' ' || Dosage as Dose from DrugDosages where DrugID = %@", drugID ];
                @synchronized(g_LOOKUPDB)
                {
                    dosageArray = [DAO loadIncidentInfo:[[g_SETTINGS objectForKey:@"lookupDB"] pointerValue] Sql:sql WithExtraInfo:NO];
                }
                if ([dosageArray count] > 0)
                {
                    PopupDataViewController *popoverView =[[PopupDataViewController alloc] initWithNibName:@"PopupDataViewController" bundle:nil];
                    popoverView.view.backgroundColor = [UIColor whiteColor];
                    popoverView.array = dosageArray;
                    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
                    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
                    self.popover.popoverContentSize = CGSizeMake(500, 400);
                    popoverView.delegate = self;
                    CGRect rect = CGRectMake(430, 90, 250, 300);
                    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
                }
            }
            
            
            if([input.inputName isEqualToString:cell.lblTitle.text])
            {
                input.inputValue = drugSelected.drugName;
            }
           
        }
    }
    else
    {
        ClsTableKey * tableKey =  [routesArray objectAtIndex:p.rowSelected];
        [cell.btnText setTitle:tableKey.desc forState:UIControlStateNormal];

        [cell setButtonText:tableKey.desc];
    
        if([input.inputName isEqualToString:cell.lblTitle.text])
        {
            input.inputValue = tableKey.desc;
           
        }
    }
    if (cell.tag < array.count)
    {
        ClsTreatmentInputs *input1 = (ClsTreatmentInputs*)[treatment.arrayTreatmentInputValues objectAtIndex:cell.tag];
        if(input1.inputDataType != 0)
        {
            [self inputButtonPressed:input1 tag:cell.tag + 1];
        }
        else
        {
            TreatmentItemCellView *cell1 = (TreatmentItemCellView *)[scrollView viewWithTag:cell.tag + 1];
            [cell1 setTextFieldFirstRespond];
            textfieldset = cell.tag;
        }
    }
}

-(void) doneNumericClick
{
    NumericViewController *p = (NumericViewController *)self.popover.contentViewController;
    TreatmentItemCellView *cell = (TreatmentItemCellView *)[scrollView viewWithTag:functionSelected];

    [cell.btnText setTitle:p.displayStr forState:UIControlStateNormal];
    [cell setButtonText:p.displayStr];
    ClsTreatmentInputs *input = (ClsTreatmentInputs*)[treatment.arrayTreatmentInputValues objectAtIndex:functionSelected-1];
    input.inputValue = p.displayStr;

    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    if (cell.tag < array.count)
    {
        ClsTreatmentInputs *input1 = (ClsTreatmentInputs*)[treatment.arrayTreatmentInputValues objectAtIndex:cell.tag];
        if(input1.inputDataType != 0)
        {
            [self inputButtonPressed:input1 tag:cell.tag + 1];
        }
        else
        {
            TreatmentItemCellView *cell1 = (TreatmentItemCellView *)[scrollView viewWithTag:cell.tag + 1];
            [cell1 setTextFieldFirstRespond];
            textfieldset = cell.tag;
        }
    }
}

-(void)doneDataViewClick
{
    PopupDataViewController *p = (PopupDataViewController *)popover.contentViewController;

    if (p.txtDisplay.text.length > 0)
    {
        NSArray* selectedDosageArray = [p.txtDisplay.text componentsSeparatedByString:@" "];
        if ([selectedDosageArray count] > 1)
        {
            NSString* dose = [selectedDosageArray objectAtIndex:0];
            TreatmentItemCellView *cell = (TreatmentItemCellView *)[scrollView viewWithTag:functionSelected + 1];
            [cell.btnText setTitle:dose forState:UIControlStateNormal];
            ClsTreatmentInputs *input = (ClsTreatmentInputs*)[treatment.arrayTreatmentInputValues objectAtIndex:functionSelected];
            input.inputValue = dose;
            NSString* unit = [selectedDosageArray objectAtIndex:1];
            TreatmentItemCellView *cell1 = (TreatmentItemCellView *)[scrollView viewWithTag:functionSelected + 2];
            [cell1.btnText setTitle:unit forState:UIControlStateNormal];
            ClsTreatmentInputs *input1 = (ClsTreatmentInputs*)[treatment.arrayTreatmentInputValues objectAtIndex:functionSelected+ 1];
            input1.inputValue = unit;
        }
        
    }
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    
}
#pragma mark-
#pragma mark UIControl Callback methods

- (IBAction)btnSaveTreatmentClick:(id)sender {
    

    TreatmentItemCellView *cell = (TreatmentItemCellView *) [scrollView viewWithTag:1];
    NSString* time = cell.btnText.titleLabel.text;
    NSInteger storeInstance = treatment.instance;
    NSString* sql;
    NSString* instance = @"";
    if (storeInstance < 1 )
    {
        NSInteger test = 0;
        @synchronized(g_SYNCDATADB)
        {
            NSString* Ticketid =  [g_SETTINGS objectForKey:@"currentTicketID"];
            sql = [NSString stringWithFormat:@"Select inputInstance from ticketInputs where ticketID = %@ and InputID = %ld and inputValue = '%@' limit 1", Ticketid, treatment.treatmentID, time];
            
            instance = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sql];
        }
        if (instance.length < 1)
        {
            NSString* instance;
            @synchronized(g_SYNCDATADB)
            {
                NSString* Ticketid =  [g_SETTINGS objectForKey:@"currentTicketID"];
                NSString* sqlStr = [NSString stringWithFormat:@"Select max(inputInstance) from ticketInputs where ticketID = %@ and InputID = %ld ", Ticketid, treatment.treatmentID];
                
                instance = [DAO executeSelectScalar:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] Sql:sqlStr];
            }
            if (instance.length < 1)
            {
                test = 1;
            }
            else
            {
                test = [instance intValue] + 1;
            }
        }
        if (test > 0)
        {
            instance = [NSString stringWithFormat:@"%ld", test];
        }
        
        
    }
    else
    {
        instance = [NSString stringWithFormat:@"%ld", storeInstance];
    }

    
    for (int i = 0; i< [treatment.arrayTreatmentInputValues count]; i++)
    {
        
        NSString* svname = @"";
        NSString* svinpname = @"";
        NSString* svvalue = @"";
        NSInteger treatid = 0;
        
        for (UIView* subview in scrollView.subviews)
        {
            if (subview.tag == i+1)
            {
                ClsTreatmentInputs* input = [treatment.arrayTreatmentInputValues objectAtIndex:i];
                treatid = input.inputID;
                TreatmentItemCellView *cell = (TreatmentItemCellView*) subview;
                // svname = cell.treatmentInputInfo.inputName;
                // svinpname = cell.treatmentInputInfo.inputName;
                if (treatid == 102)
                {
                    svvalue = cell.tvNotes.text;
                }
                else
                {
                    svvalue = cell.btnText.titleLabel.text;
                }
                
                
                
                @synchronized(g_SYNCDATADB)
                {
                    NSString* Ticketid =  [g_SETTINGS objectForKey:@"currentTicketID"];
                    NSString* updateStr = [NSString stringWithFormat:@"Update TicketInputs set InputValue = '%@', IsUploaded = 0 where ticketID = %@ and InputID = %ld and InputSubID = %ld and inputInstance = %@", [self removeNull:svvalue], Ticketid, treatment.treatmentID, treatid, instance];
                    
                    NSString*  sqlStr = [NSString stringWithFormat:@"Insert into TicketInputs(LocalTicketID, TicketID, InputID, InputSubID, InputInstance, InputPage, InputName, InputValue) Values(0, %@, %d, %d, %@, '%@', '%@', '%@')", Ticketid, treatment.treatmentID, treatid, instance, treatment.treatmentDesc, svinpname, [self removeNull:svvalue]];
                    [DAO insertUpdate:[[g_SETTINGS objectForKey:@"dataDB"] pointerValue] InsertSql:sqlStr UpdateSql:updateStr];
                }
                break;
            }
            
        }
        
    }
    
    [delegate didClickOK];

}



- (NSString*) removeNull:(NSString*)str
{
    if ([str length] > 0 && ([str rangeOfString:@"(null)"].location == NSNotFound))
    {
        return [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }
    else
    {
        return @" ";
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{

    
}



@end
