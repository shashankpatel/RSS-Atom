//
//  RSS_AtomViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "RSS_AtomViewController.h"

@implementation RSS_AtomViewController

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    [self.view addSubview:homeViewController.view];
    [super viewDidLoad];
}


@end
