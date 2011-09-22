//
//  HomeViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    feedSelector=[[FeedSelectorViewController alloc] initWithNibName:@"FeedSelectorViewController" bundle:nil];
    feedSelector.delegate=self;
    feedSelector.view.alpha=0;
    [self.view addSubview:feedSelector.view];
    currentView=detachableView;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) pushFromView:(UIView*) source toView:(UIView*) target {
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
    currentView=target;
    
}

-(void) popFromView:(UIView*) source toView:(UIView*) target{
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
    currentView=target;
}

-(IBAction)feedSelectorPressed:(id)sender{
    [self popFromView:currentView toView:feedSelector.view];
}

-(void) feedSelectedForURLString:(NSString*) urlString{
    [self pushFromView:currentView toView:detachableView];
}


@end
