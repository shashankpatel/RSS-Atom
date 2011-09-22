//
//  HomeViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedSelectorViewController.h"

@interface HomeViewController : UIViewController<FeedSelectorDelegate>{
    FeedSelectorViewController *feedSelector;
    IBOutlet UITableView *table;
    IBOutlet UIView *detachableView;
    UIView *currentView;
}

-(void) pushFromView:(UIView*) source toView:(UIView*) target;
-(void) popFromView:(UIView*) source toView:(UIView*) target;
-(IBAction)feedSelectorPressed:(id)sender;

@end
