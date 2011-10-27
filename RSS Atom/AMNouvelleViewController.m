//
//  RSS_AtomViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMNouvelleViewController.h"
#import "AMZoomViewController.h"

#import "AMFeedSearchViewController.h"
#import "AMFeedSelectorViewController.h"
#import "AMFeedListViewController.h"
#import "AMFeedViewController.h"
#import "AMWebViewController.h"

@implementation AMNouvelleViewController

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
    
    AMFeedListViewController *hvc=[[AMFeedListViewController alloc] initWithNibName:@"AMFeedListViewController" bundle:nil];
    fsvc.delegate=hvc;
    [controllers addObject:hvc];
    [hvc release];
    
    AMFeedViewController *fvc=[[AMFeedViewController alloc] initWithNibName:@"AMFeedViewController" bundle:nil];
    hvc.feedViewController=fvc;
    [controllers addObject:fvc];
    [fvc release];
    
    AMWebViewController *wvc=[[AMWebViewController alloc] initWithNibName:@"AMWebViewController" bundle:nil];
    [controllers addObject:wvc];
    [wvc release];
    
    zvc=[[AMZoomViewController alloc] initWithViewControllers:controllers startIndex:1];
    [controllers release];
    [zvc pushToIndex:1];
    [self.view addSubview:zvc.view];
    [super viewDidLoad];
}


@end
