//
//  AMZoomViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/25/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMZoomViewController.h"
#import "AMViewController.h"

@implementation AMZoomViewController

@synthesize viewControllers;
@synthesize currentViewController;
@synthesize currentIndex;
@synthesize transitionType;

static AMZoomViewController *singleton;

+(AMZoomViewController*) sharedZoomViewController{
    return singleton;
}

#pragma mark - View lifecycle

-(id) initWithViewController:(AMViewController*) viewController{
    self=[super initWithNibName:@"AMZoomViewController" bundle:nil];
    if (self) {
        viewControllers=[[NSMutableArray alloc] initWithObjects:viewController, nil];
        self.currentViewController=viewController;
        currentIndex=[viewControllers indexOfObject:currentViewController];
    }
    return self;
}

-(id) initWithViewControllers:(NSArray*) controllers startIndex:(int) startIndex{
    self=[super initWithNibName:@"AMZoomViewController" bundle:nil];
    if (self) {
        singleton=self;
        viewControllers=[[NSMutableArray alloc] initWithArray:controllers];
        self.currentViewController=[controllers objectAtIndex:startIndex];
        for (AMViewController *vc in self.viewControllers) {
            vc.zoomController=self;
            [self.view addSubview:vc.view];
            [vc.view removeFromSuperview];
        }
        currentIndex=startIndex;
    }
    return self;
}

-(void) pushToIndex:(int) newIndex {
    [self pushToIndex:newIndex expand:NO];
}

-(void) pushToIndex:(int) newIndex expand:(BOOL) expand{
    self.view.window.userInteractionEnabled=NO;
    self.transitionType=kTransitionTypePush;
    AMViewController *targetViewController=[viewControllers objectAtIndex:newIndex];
    [targetViewController viewWillAppear:YES];
    [currentViewController viewWillDisappear:YES];
    UIView *target=targetViewController.view;
    UIView *source=currentViewController.view;
    currentIndex=newIndex;
    
    if ([target superview]!=self.view) {
        [self.view addSubview:target];
    }
    
    
    
    float targetScale=expand ? 0.9 : 0.5;
    
    target.transform=CGAffineTransformMakeScale(targetScale, targetScale);
    target.alpha=1;
    [UIView beginAnimations:@"PushView" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    currentViewController.titleBarView.alpha=0;
    targetViewController.titleBarView.alpha=1;
    source.transform=CGAffineTransformMakeScale(1.5,1.5);
    source.alpha=0;
    target.transform=CGAffineTransformIdentity;
    target.alpha=1;
    [UIView commitAnimations];
    if (expand) {
        //[currentViewController expand];
    }
    currentViewController=targetViewController;
}

-(void) popToIndex:(int) newIndex{
    [self popToIndex:newIndex shrink:NO];
}

-(void) popToIndex:(int) newIndex shrink:(BOOL) shrink{
    self.view.window.userInteractionEnabled=NO;
    self.transitionType=kTransitionTypePop;
    AMViewController *targetViewController=[viewControllers objectAtIndex:newIndex];
    
    [targetViewController viewWillAppear:YES];
    [currentViewController viewWillDisappear:YES];
    UIView *target=targetViewController.view;
    UIView *source=currentViewController.view;
    currentIndex=newIndex;
    if ([target superview]!=self.view) {
        [self.view addSubview:target];
    }
    
    source.transform=CGAffineTransformIdentity;
    target.transform=CGAffineTransformMakeScale(2, 2);
    
    [UIView beginAnimations:@"PushView" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    currentViewController.titleBarView.alpha=0;
    targetViewController.titleBarView.alpha=1;
    
    target.transform=CGAffineTransformIdentity;
    target.alpha=1;
    if (shrink) {
        [targetViewController shrink];
    }
    float sourceScale=shrink ? 0.9 : 0.5;
    source.transform=CGAffineTransformMakeScale(sourceScale,sourceScale);
    source.alpha=shrink ? 1 : 0;
    
    [self.view bringSubviewToFront:target];
    [UIView commitAnimations];
    currentViewController=targetViewController;
}

-(void) animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    [currentViewController viewDidAppear:YES];
    self.view.window.userInteractionEnabled=YES;
}

- (void)viewDidLoad
{
    [self.view addSubview:currentViewController.view];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) dealloc{
    [viewControllers release];
    [currentViewController release];
    [super dealloc];
}

@end
