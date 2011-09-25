//
//  HomeViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedSelectorViewController.h"
#import "FeedViewController.h"
#import "AMViewController.h"

@interface HomeViewController : AMViewController<FeedSelectorDelegate,FeedViewDelegate>{
    FeedSelectorViewController *feedSelector;
    FeedViewController *feedViewController;
    IBOutlet UITableView *table;
    IBOutlet UIView *detachableView;
    UIView *currentView;
}

@property(nonatomic,retain) UIView *currentView;

-(void) pushFromView:(UIView*) source toView:(UIView*) target;
-(void) popFromView:(UIView*) source toView:(UIView*) target;
-(IBAction)feedSelectorPressed:(id)sender;

@end
