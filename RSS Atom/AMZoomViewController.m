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

#pragma mark - View lifecycle

-(id) initWithViewController:(UIViewController*) viewController{
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
        viewControllers=[[NSMutableArray alloc] initWithArray:controllers];
        self.currentViewController=[controllers objectAtIndex:startIndex];
        for (AMViewController *vc in self.viewControllers) {
            vc.zoomController=self;
        }
        currentIndex=startIndex;
    }
    return self;
}

-(void) pushToIndex:(int) newIndex {
    UIViewController *targetViewController=[viewControllers objectAtIndex:newIndex];
    UIView *target=targetViewController.view;
    UIView *source=currentViewController.view;
    currentIndex=newIndex;
    currentViewController=targetViewController;
    if ([target superview]!=self.view) {
        [self.view addSubview:target];
    }
    target.transform=CGAffineTransformMakeScale(0.5, 0.5);
    target.alpha=0;
    [UIView beginAnimations:@"PushView" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    source.transform=CGAffineTransformMakeScale(1.5,1.5);
    source.alpha=0;
    target.transform=CGAffineTransformIdentity;
    target.alpha=1;
    [UIView commitAnimations];
}

-(void) popToIndex:(int) newIndex{
    UIViewController *targetViewController=[viewControllers objectAtIndex:newIndex];
    UIView *target=targetViewController.view;
    UIView *source=currentViewController.view;
    currentIndex=newIndex;
    currentViewController=targetViewController;
    if ([target superview]!=self.view) {
        [self.view addSubview:target];
    }
    source.transform=CGAffineTransformIdentity;
    target.transform=CGAffineTransformMakeScale(2, 2);
    [UIView beginAnimations:@"PushView" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    target.transform=CGAffineTransformIdentity;
    target.alpha=1;
    source.transform=CGAffineTransformMakeScale(0.5, 0.5);
    source.alpha=0;
    [UIView commitAnimations];
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
