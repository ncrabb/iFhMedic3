//
//  TabViewController.m
//  iMobileMedic
//
//  Created by Admin on 8/29/13.
//  Copyright (c) 2013 MobieSoftwareSystem. All rights reserved.
//

#import "TabViewController.h"

#import "TabBar.h"
#import "TabBarButton.h"
#import "DDPopoverBackgroundView.h"
#import "ImageGalleryViewController.h"
#import "FaxViewController.h"
#import "PopupGCSViewController.h"
#import "CrewViewController.h"
#import "ClsTableKey.h"
#import "Base64.h"
#import "SummeryViewController.h"

#define IOS_OLDER_THAN_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] < 6.0 )
#define IOS_NEWER_OR_EQUAL_TO_6 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 6.0 )

@interface TabViewController () <TabBarDelegate>
{
    bool newMedia;
}
@property (weak, nonatomic) IBOutlet TabBar *tabBar;

@end

@implementation TabViewController
{
    UIViewController *_currentViewController;
}

@synthesize tabBar;
@synthesize sceneView;
@synthesize calltimesView;
@synthesize patientView;
@synthesize chiefComplaintView;
@synthesize assessmentView;
@synthesize vitalsView;
@synthesize treatmentsView;
@synthesize historyView;
@synthesize medView;
@synthesize allergyView;
@synthesize symptomView;
@synthesize opqrstView;
@synthesize injuryView;
@synthesize diagramView;
@synthesize narrativeView;
@synthesize outcomeView;
@synthesize insuranceView;
@synthesize signatureView;
@synthesize protocolView;
@synthesize cprView;
@synthesize narcoticView;
@synthesize summary;
@synthesize popover;



- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithObjects:
                               [TabBarButton buttonWithTitle:@"Scene" image:[UIImage imageNamed:@"scene"] selectedImage:[UIImage imageNamed:@"selected_scene"]],
                               [TabBarButton buttonWithTitle:@"Call Times" image:[UIImage imageNamed:@"call_times"] selectedImage:[UIImage imageNamed:@"selected_call_times"]],
                               [TabBarButton buttonWithTitle:@"Patient" image:[UIImage imageNamed:@"unselect_patient_icon"] selectedImage:[UIImage imageNamed:@"patient_icon"]],
                               [TabBarButton buttonWithTitle:@"Impression" image:[UIImage imageNamed:@"cheif_complaint"] selectedImage:[UIImage imageNamed:@"selected_cheif_complaint"]],
                               [TabBarButton buttonWithTitle:@"Assessment" image:[UIImage imageNamed:@"assessment"] selectedImage:[UIImage imageNamed:@"selected_assessment"]],
                               [TabBarButton buttonWithTitle:@"Vitals" image:[UIImage imageNamed:@"vitals"] selectedImage:[UIImage imageNamed:@"selected_vitals"]],
                               [TabBarButton buttonWithTitle:@"Treatments" image:[UIImage imageNamed:@"treatments"] selectedImage:[UIImage imageNamed:@"selected_treatments"]],
                               [TabBarButton buttonWithTitle:@"History" image:[UIImage imageNamed:@"history"] selectedImage:[UIImage imageNamed:@"selected_history"]],
                               [TabBarButton buttonWithTitle:@"Pt Medications" image:[UIImage imageNamed:@"medication"] selectedImage:[UIImage imageNamed:@"selected_medication"]],
                                [TabBarButton buttonWithTitle:@"Allergies" image:[UIImage imageNamed:@"allergies"] selectedImage:[UIImage imageNamed:@"selected_allergies"]],
                                [TabBarButton buttonWithTitle:@"Symptoms" image:[UIImage imageNamed:@"symptoms"] selectedImage:[UIImage imageNamed:@"selected_symptoms"]],
                                [TabBarButton buttonWithTitle:@"OPQRST" image:[UIImage imageNamed:@"opqrst"] selectedImage:[UIImage imageNamed:@"selected_opqrst"]],
                                [TabBarButton buttonWithTitle:@"Injury" image:[UIImage imageNamed:@"injury"] selectedImage:[UIImage imageNamed:@"injury_icon"]],
                               
                                [TabBarButton buttonWithTitle:@"Diagram" image:[UIImage imageNamed:@"diagram"] selectedImage:[UIImage imageNamed:@"selected_diagram"]],
                               
                               [TabBarButton buttonWithTitle:@"Narrative" image:[UIImage imageNamed:@"narrative"] selectedImage:[UIImage imageNamed:@"narrative_icon"]],
                               
                               [TabBarButton buttonWithTitle:@"Outcome" image:[UIImage imageNamed:@"outcome"] selectedImage:[UIImage imageNamed:@"outcome_icon"]],
                               
                                [TabBarButton buttonWithTitle:@"Insurance" image:[UIImage imageNamed:@"insurance"] selectedImage:[UIImage imageNamed:@"selected_insurance"]],
                               
                                [TabBarButton buttonWithTitle:@"Signature" image:[UIImage imageNamed:@"signatures"] selectedImage:[UIImage imageNamed:@"selected_signatures"]],
                               
                                 [TabBarButton buttonWithTitle:@"Protocols" image:[UIImage imageNamed:@"protocols"] selectedImage:[UIImage imageNamed:@"selected_protocols"]],
                                 [TabBarButton buttonWithTitle:@"CPR" image:[UIImage imageNamed:@"cpr"] selectedImage:[UIImage imageNamed:@"cpr_icon"]],
                                 [TabBarButton buttonWithTitle:@"Narcotic" image:[UIImage imageNamed:@"narcotic"] selectedImage:[UIImage imageNamed:@"narcotic_icon"]],
                               
                               nil];


    
    [self.tabBar setDelegate:self];
    [self.tabBar setButtonsOnPage:11];
    [self.tabBar addButtonsWithArray:buttons];
    [self.tabBar setSelectedButtonAtIndex:0];
    
   
    
    self.viewHeight = 694;
    
    

    if (sceneView == nil)
    {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First"
                                                      bundle:nil];
        
        self.sceneView = [sb instantiateViewControllerWithIdentifier:@"Scene"];

        CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
        sceneView.view.frame = theRect;
        self.sceneView.delegate = self;

        [self.tabBar setSelectedButtonAtIndex:0];
    }

    [self addChildViewController:sceneView];
    [self.view addSubview:sceneView.view];
    [sceneView didMoveToParentViewController:self];
    _currentViewController = sceneView;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) dismissViewControl
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) dismissViewControlAndStartNew:(NSInteger) tag
{

//    [self checkTabComplete:tag];
   // [self infiniTabBar:(InfiniTabBar*)self.tabBarController didSelectItemWithTag:(int)tag];
        [self.tabBar setSelectedButtonAtIndex:tag];
    [self tabBar:self.tabBar didSelectButtonAtIndex:tag];
}

-(void)setTabsRequired:(NSMutableArray*) tabArray
{
    UIColor *whiteColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    for (int j = 0; j < 19; j++)
    {
        TabBarButton *button = [self.tabBar buttonAtIndex:j];
        button.titleColor = whiteColor;
        button.titleSelectedColor = whiteColor;
    }
    
    for (int i = 0; i < tabArray.count; i++)
    {
        NSString* tabpage = [tabArray objectAtIndex:i];
        [self didSelectColorWithIndex:[tabpage intValue]];
    }
        
}


- (void) didSelectColorWithIndex:(NSInteger)index
{
    UIColor *redColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
    
    switch ( index )
    {
        case 0: // One
        {
            TabBarButton *button = [self.tabBar buttonAtIndex:0];
            button.titleColor = redColor;
            button.titleSelectedColor = redColor;
            break;
        }
            
        case 1:
        {
            TabBarButton *button = [self.tabBar buttonAtIndex:1];
            button.titleColor = redColor;
            button.titleSelectedColor = redColor;
            break;
        }
            
        case 2:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:2];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
            
        case 3:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:3];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 4:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:4];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 5:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:5];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 6:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:6];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 7:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:7];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 8:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:8];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 9:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:9];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 10:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:10];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 11:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:11];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 12:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:12];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 13:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:13];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 14:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:14];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 15:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:15];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 16:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:16];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
            
        case 17:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:17];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;

        }
        case 18:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:18];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
            
        case 19:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:19];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
        case 20:
        {
            TabBarButton *button1 = [self.tabBar buttonAtIndex:20];
            button1.titleColor = redColor;
            button1.titleSelectedColor = redColor;
            break;
        }
            
    }
}



-(void) didTap
{
    [self.popover dismissPopoverAnimated:YES];
}


#pragma mark - TabBarDelegate

- (void) tabBar:(TabBar*)tabBar didSelectButtonAtIndex:(NSInteger)index
{
    [_currentViewController.view removeFromSuperview];
    [_currentViewController willMoveToParentViewController:nil];
    [_currentViewController removeFromParentViewController];
    
    
    switch ( index )
    {
        case 0:
        {
            if (sceneView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First" bundle:nil];
                
                self.sceneView = [sb instantiateViewControllerWithIdentifier:@"Scene"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                sceneView.view.frame = theRect;
                self.sceneView.delegate = self;
                
            }
            [self addChildViewController:sceneView];
            [self.view addSubview:sceneView.view];
            [sceneView didMoveToParentViewController:self];
            _currentViewController = sceneView;
            break;
        }
            
        case 1:
        {
            if (calltimesView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First" bundle:nil];
                
                self.calltimesView = [sb instantiateViewControllerWithIdentifier:@"Calltimes"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                calltimesView.view.frame = theRect;
                self.calltimesView.delegate = self;
            }
            
            
            [self addChildViewController:calltimesView];
            [self.view addSubview:calltimesView.view];
            [calltimesView didMoveToParentViewController:self];
            _currentViewController = calltimesView;
            break;
        }
            
        case 2:
        {
            if (patientView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First" bundle:nil];
                
                self.patientView = [sb instantiateViewControllerWithIdentifier:@"Patient"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                patientView.view.frame = theRect;
                self.patientView.delegate = self;
            }
            
            
            [self addChildViewController:patientView];
            [self.view addSubview:patientView.view];
            [patientView didMoveToParentViewController:self];
            _currentViewController = patientView;
            break;
        }
            
        case 3:
        {
            if (chiefComplaintView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First" bundle:nil];
                
                self.chiefComplaintView = [sb instantiateViewControllerWithIdentifier:@"ChiefComplaint"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                chiefComplaintView.view.frame = theRect;
                self.chiefComplaintView.delegate = self;
            }
            
            [self addChildViewController:chiefComplaintView];
            [self.view addSubview:chiefComplaintView.view];
            [chiefComplaintView didMoveToParentViewController:self];
            _currentViewController = chiefComplaintView;
            break;
        }
            
        case 4:
        {
            if (assessmentView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First" bundle:nil];
                
                self.assessmentView = [sb instantiateViewControllerWithIdentifier:@"Assessment"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                assessmentView.view.frame = theRect;
                self.assessmentView.delegate = self;
            }
            
            [self addChildViewController:assessmentView];
            [self.view addSubview:assessmentView.view];
            [assessmentView didMoveToParentViewController:self];
            _currentViewController = assessmentView;
            break;
        }
   
        case 5:
        {
            if (vitalsView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First" bundle:nil];
                
                self.vitalsView = [sb instantiateViewControllerWithIdentifier:@"Vitals"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                vitalsView.view.frame = theRect;
                self.vitalsView.delegate = self;
            }
            
            [self addChildViewController:vitalsView];
            [self.view addSubview:vitalsView.view];
            [vitalsView didMoveToParentViewController:self];
            _currentViewController = vitalsView;
            break;
        }
    
        case 6:
        {
            if (treatmentsView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First" bundle:nil];
                
                self.treatmentsView = [sb instantiateViewControllerWithIdentifier:@"Treatments"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                treatmentsView.view.frame = theRect;
                self.treatmentsView.delegate = self;
            }
            
            [self addChildViewController:treatmentsView];
            [self.view addSubview:treatmentsView.view];
            [treatmentsView didMoveToParentViewController:self];
            _currentViewController = treatmentsView;
            break;
        }
        case 7:
        {
            if (historyView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First" bundle:nil];
                
                self.historyView = [sb instantiateViewControllerWithIdentifier:@"History"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                historyView.view.frame = theRect;
                self.historyView.delegate = self;
            }
            
            [self addChildViewController:historyView];
            [self.view addSubview:historyView.view];
            [historyView didMoveToParentViewController:self];
            _currentViewController = historyView;
            break;
        }
        case 8:
        {
            if (medView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First" bundle:nil];
                
                self.medView = [sb instantiateViewControllerWithIdentifier:@"Med"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                medView.view.frame = theRect;
                self.medView.delegate = self;
            }
            
            [self addChildViewController:medView];
            [self.view addSubview:medView.view];
            [medView didMoveToParentViewController:self];
            _currentViewController = medView;
            break;
        }
        case 9:
        {
            if (allergyView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First" bundle:nil];
                
                self.allergyView = [sb instantiateViewControllerWithIdentifier:@"Allergy"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                allergyView.view.frame = theRect;
                self.allergyView.delegate = self;
            }
            
            [self addChildViewController:allergyView];
            [self.view addSubview:allergyView.view];
            [allergyView didMoveToParentViewController:self];
            _currentViewController = allergyView;
            break;
        }
        case 10:
        {
            if (symptomView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"First" bundle:nil];
                
                self.symptomView = [sb instantiateViewControllerWithIdentifier:@"Symptom"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                symptomView.view.frame = theRect;
                self.symptomView.delegate = self;
            }
            
            [self addChildViewController:symptomView];
            [self.view addSubview:symptomView.view];
            [symptomView didMoveToParentViewController:self];
            _currentViewController = symptomView;
            break;
        }
        case 11:
        {
            if (opqrstView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
                
                self.opqrstView = [sb instantiateViewControllerWithIdentifier:@"Opqrst"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                opqrstView.view.frame = theRect;
                self.opqrstView.delegate = self;
            }
            
            [self addChildViewController:opqrstView];
            [self.view addSubview:opqrstView.view];
            [opqrstView didMoveToParentViewController:self];
            _currentViewController = opqrstView;
            break;
        }
        case 12:
        {
            if (injuryView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
                
                self.injuryView = [sb instantiateViewControllerWithIdentifier:@"Injury"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                injuryView.view.frame = theRect;
                self.injuryView.delegate = self;
            }
            
            [self addChildViewController:injuryView];
            [self.view addSubview:injuryView.view];
            [injuryView didMoveToParentViewController:self];
            _currentViewController = injuryView;
            break;
        }
            
        case 13:
        {
            if (diagramView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
                
                self.diagramView = [sb instantiateViewControllerWithIdentifier:@"Diagram"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                diagramView.view.frame = theRect;
                self.diagramView.delegate = self;
            }
            
            [self addChildViewController:diagramView];
            [self.view addSubview:diagramView.view];
            [diagramView didMoveToParentViewController:self];
            _currentViewController = diagramView;
            break;
        }
            
        case 14:
        {
            if (narrativeView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
                
                self.narrativeView = [sb instantiateViewControllerWithIdentifier:@"Narrative"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                narrativeView.view.frame = theRect;
                self.narrativeView.delegate = self;
            }
            
            [self addChildViewController:narrativeView];
            [self.view addSubview:narrativeView.view];
            [narrativeView didMoveToParentViewController:self];
            _currentViewController = narrativeView;
            break;
        }
            
        case 15:
        {
            if (outcomeView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
                
                self.outcomeView = [sb instantiateViewControllerWithIdentifier:@"Outcome"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                outcomeView.view.frame = theRect;
                self.outcomeView.delegate = self;
            }
            
            [self addChildViewController:outcomeView];
            [self.view addSubview:outcomeView.view];
            [narrativeView didMoveToParentViewController:self];
            _currentViewController = outcomeView;
            break;
        }
            
        case 16:
        {
            if (insuranceView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
                
                self.insuranceView = [sb instantiateViewControllerWithIdentifier:@"Insurance"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                insuranceView.view.frame = theRect;
                self.insuranceView.delegate = self;
            }
            
            [self addChildViewController:insuranceView];
            [self.view addSubview:insuranceView.view];
            [insuranceView didMoveToParentViewController:self];
            _currentViewController = insuranceView;
            break;
        }
            
        case 17:
        {
            if (signatureView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
                
                self.signatureView = [sb instantiateViewControllerWithIdentifier:@"Signature"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                signatureView.view.frame = theRect;
                self.signatureView.delegate = self;
            }
            
            [self addChildViewController:signatureView];
            [self.view addSubview:signatureView.view];
            [signatureView didMoveToParentViewController:self];
            _currentViewController = signatureView;
            break;
        }
            
        case 18:
        {
            if (protocolView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
                
                self.protocolView = [sb instantiateViewControllerWithIdentifier:@"Protocol"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                protocolView.view.frame = theRect;
                self.protocolView.delegate = self;
            }
            
            [self addChildViewController:protocolView];
            [self.view addSubview:protocolView.view];
            [protocolView didMoveToParentViewController:self];
            _currentViewController = protocolView;
            break;
        }
            
        case 19:
        {
            if (cprView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
                
                self.cprView = [sb instantiateViewControllerWithIdentifier:@"Cpr"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                cprView.view.frame = theRect;
                self.cprView.delegate = self;
            }
            
            [self addChildViewController:cprView];
            [self.view addSubview:cprView.view];
            [cprView didMoveToParentViewController:self];
            _currentViewController = cprView;
            break;
        }
            
        case 20:
        {
            if (narcoticView == nil)
            {
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
                
                self.narcoticView = [sb instantiateViewControllerWithIdentifier:@"Narcotic"];
                CGRect theRect = CGRectMake(0, 0, 1024, self.viewHeight);
                narcoticView.view.frame = theRect;
                self.narcoticView.delegate = self;
            }
            
            [self addChildViewController:narcoticView];
            [self.view addSubview:narcoticView.view];
            [narcoticView didMoveToParentViewController:self];
            _currentViewController = narcoticView;
            break;
        }
            
    }
}


- (IBAction)btnQuickClick:(UIButton*)sender {
    QuickViewController *popoverView =[[QuickViewController alloc] initWithNibName:@"QuickViewController" bundle:nil];
    self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
    self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];
    self.popover.popoverContentSize = CGSizeMake(540, 580);
    popoverView.delegate = self;
    
    [self.popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (void) doneQuickButton
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

- (IBAction) galleryClicked:(UIButton *)sender
{
    ImageGalleryViewController* gallery = [[ImageGalleryViewController alloc] initWithNibName:@"ImageGalleryViewController" bundle:nil];
    
    [self presentViewController:gallery animated:NO completion:nil];
    
}


- (IBAction)btnFaxPressed:(UIButton *)sender
{
    NSString* MachineID = [g_SETTINGS objectForKey:@"MachineID"];
    if ([MachineID isEqualToString:@"LOCAL"])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"This feature is not available in the demo version." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        FaxViewController *popoverView =[[FaxViewController alloc] initWithNibName:@"FaxViewController" bundle:nil];
        
        popoverView.view.backgroundColor = [UIColor whiteColor];
        
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(600, 440);
        // popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.y += 30;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void) crewBtnPressed
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                  bundle:nil];
    
    CrewViewController *crewView = [sb instantiateViewControllerWithIdentifier:@"CrewUI"];
    crewView.affectCurrentTicket = 1;
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [self presentViewController:crewView animated:YES completion:nil];
    
}

- (IBAction)btnPrintPressed:(UIButton *)sender
{
    NSString* MachineID = [g_SETTINGS objectForKey:@"MachineID"];
    if ([MachineID isEqualToString:@"LOCAL"])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"FhMedic" message:@"This feature is not available in the demo version." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        PopupGCSViewController *popoverView =[[PopupGCSViewController alloc] initWithNibName:@"PopupGCSViewController" bundle:nil];
        popoverView.view.backgroundColor = [UIColor whiteColor];
        NSMutableArray* array = [[NSMutableArray alloc] init];
        ClsTableKey* key = [[ClsTableKey alloc] init];
        key.tableID = 1;
        key.tableName = @"Print";
        key.desc = @"PCR Report";
        [array addObject:key];
        
        ClsTableKey* key1 = [[ClsTableKey alloc] init];
        key1.tableID = 2;
        key1.tableName = @"Print";
        key1.desc = @"Supplemental Report";
        [array addObject:key1];
        
        ClsTableKey* key2 = [[ClsTableKey alloc] init];
        key2.tableID = 3;
        key2.tableName = @"Print";
        key2.desc = @"Narcotic Report";
        [array addObject:key2];
        
        ClsTableKey* key3 = [[ClsTableKey alloc] init];
        key3.tableID = 4;
        key3.tableName = @"Print";
        key3.desc = @"ABN Form";
        [array addObject:key3];
        
        ClsTableKey* key4 = [[ClsTableKey alloc] init];
        key4.tableID = 5;
        key4.tableName = @"Print";
        key4.desc = @"PCS Form";
        [array addObject:key4];
        
        popoverView.array = array;
        popoverView.lblTitle.text = @"Print";
        self.popover =[[UIPopoverController alloc] initWithContentViewController:popoverView];
        self.popover.popoverBackgroundViewClass = [DDPopoverBackgroundView class];  // Mani
        self.popover.popoverContentSize = CGSizeMake(320, 400);
        // popoverView.delegate = self;
        CGRect frame = sender.frame;
        frame.origin.y += 30;
        [self.popover presentPopoverFromRect:frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}


- (IBAction) photoClicked:(UIButton *)sender
{
    [self takePhotoPressed];
}
- (IBAction) crewClicked:(UIButton *)sender;
{
    [self crewBtnPressed];
}


- (void)takePhotoPressed
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        newMedia = true;
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
        imagePicker.allowsEditing = NO;
        UIImageView* guideImageView = [[UIImageView alloc] init];
        guideImageView.image = [UIImage imageNamed:@"card.png"];
        guideImageView.frame = CGRectMake(260, 230, 504, 288);
        //guideImageView.frame = CGRectMake(120, 25, 800, 600);
        guideImageView.backgroundColor = [UIColor clearColor];
        guideImageView.contentMode = UIViewContentModeScaleAspectFit;
        guideImageView.alpha = 1;
        //[imagePicker.view addSubview:guideImageView];
        [self presentViewController:imagePicker
                                animated:YES completion:nil];
    }
    else
    {
        newMedia = false;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"No Camera Detected"
                              message: @"Failed to detect camera."\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //  [self.popoverController dismissPopoverAnimated:true];
    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(720, 625, 1218, 710));
        //CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(520, 480, 1318, 810));
        //  UIImage *img = [UIImage imageWithCGImage:ref scale:1 orientation:UIImageOrientationDown];
        CGImageRelease(ref);
        
        
        if (newMedia)
        {
            CGSize size = CGSizeMake(640, 480);
            UIImage* image1 = [self scaleToSize:image newSize:size];
            NSData* data = UIImageJPEGRepresentation(image1, 1.0f);
            NSString* imgStr = [Base64 encode:data];
            NSDate* sourceDate = [NSDate date];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
            NSString* timeAdded = [dateFormat stringFromDate:sourceDate];
            NSString* sql;
            NSInteger count ;
            NSString* ticketID = [g_SETTINGS objectForKey:@"currentTicketID"];
            sql = [NSString stringWithFormat:@"Select MAX(AttachmentID) from TicketAttachments where TicketID = %@", ticketID ];
            @synchronized(g_SYNCBLOBSDB)
            {
                count = [DAO getCount:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            if (count < 7)
            {
                count = 7;
            }
            
            
            sql = [NSString stringWithFormat:@"Insert into TicketAttachments(LocalTicketID, TicketID, AttachmentID, FileType, FileStr, FileName, TimeAdded) Values(0, %@, %d, 'Photo', '%@', '%@', '%@')", ticketID, count + 1, imgStr, @" ", timeAdded ];
            
            @synchronized(g_SYNCBLOBSDB)
            {
                [DAO saveImage:[[g_SETTINGS objectForKey:@"blobsDB"] pointerValue] Sql:sql];
            }
            
            
            
            
        }
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        
    }
}

-(UIImage*)scaleToSize:(UIImage*)image newSize:(CGSize)size
{
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)btnSummaryPressed:(UIButton *)sender
{
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    self.summary = [[SummeryViewController alloc] initWithNibName:@"SummeryViewController" bundle:nil];
    summary.delegate = self;
    [self presentViewController:summary animated:YES completion:nil];
}

- (IBAction) btnCrewPressed:(UIButton *)sender
{
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    
    CrewViewController *crewView = [sb instantiateViewControllerWithIdentifier:@"CrewUI"];
    crewView.affectCurrentTicket = 1;
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
    [self presentViewController:crewView animated:YES completion:nil];
    
}


@end
