//
//  RSS_AtomViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "RSS_AtomViewController.h"
#import "AMZoomViewController.h"

#import "FeedSearchViewController.h"
#import "FeedSelectorViewController.h"
#import "HomeViewController.h"
#import "FeedViewController.h"

@implementation RSS_AtomViewController

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSMutableArray *controllers=[[NSMutableArray alloc] init];
    
    FeedSearchViewController *vc=[[FeedSearchViewController alloc] initWithNibName:@"FeedSearchViewController" bundle:nil];
    [controllers addObject:vc];
    [vc release];
    
    FeedSelectorViewController *fsvc=[[FeedSelectorViewController alloc] initWithNibName:@"FeedSelectorViewController" bundle:nil];
    [controllers addObject:fsvc];
    [fsvc release];
    
    HomeViewController *hvc=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    fsvc.delegate=hvc;
    [controllers addObject:hvc];
    [hvc release];
    
    FeedViewController *fvc=[[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    [controllers addObject:fvc];
    [fvc release];
    
    
    AMZoomViewController *zvc=[[AMZoomViewController alloc] initWithViewControllers:controllers startIndex:2];
    [zvc pushToIndex:2];
    [self.view addSubview:zvc.view];
    [super viewDidLoad];
}


@end
