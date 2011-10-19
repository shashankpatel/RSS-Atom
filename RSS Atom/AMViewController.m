//
//  AMViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/25/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMViewController.h"

@implementation AMViewController

@synthesize zoomController;
@synthesize viewMode;
@synthesize titleBarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) shrink{
}

-(void) expand{
}

-(void) dealloc{
    [zoomController release];
    [super dealloc];
}

@end
