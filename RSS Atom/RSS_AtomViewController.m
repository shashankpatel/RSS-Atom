//
//  RSS_AtomViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "RSS_AtomViewController.h"
#import "AMZoomViewController.h"

#import "AMFeedSearchViewController.h"
#import "AMFeedSelectorViewController.h"
#import "HomeViewController.h"
#import "AMFeedViewController.h"

@implementation RSS_AtomViewController

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSMutableArray *controllers=[[NSMutableArray alloc] init];
    
    AMFeedSearchViewController *vc=[[AMFeedSearchViewController alloc] initWithNibName:@"AMFeedSearchViewController" bundle:nil];
    [controllers addObject:vc];
    [vc release];
    
    AMFeedSelectorViewController *fsvc=[[AMFeedSelectorViewController alloc] initWithNibName:@"AMFeedSelectorViewController" bundle:nil];
    [controllers addObject:fsvc];
    [fsvc release];
    
    HomeViewController *hvc=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    fsvc.delegate=hvc;
    [controllers addObject:hvc];
    [hvc release];
    
    AMFeedViewController *fvc=[[AMFeedViewController alloc] initWithNibName:@"AMFeedViewController" bundle:nil];
    hvc.feedViewController=fvc;
    [controllers addObject:fvc];
    [fvc release];
    
    
    zvc=[[AMZoomViewController alloc] initWithViewControllers:controllers startIndex:1];
    [controllers release];
    [zvc pushToIndex:2];
    [self.view addSubview:zvc.view];
    [super viewDidLoad];
}


@end
