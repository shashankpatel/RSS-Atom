//
//  FeedSearchViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/25/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMViewController.h"
#import "AMFeedSearcher.h"

@interface AMFeedSearchViewController : AMViewController<UITextFieldDelegate,AMFeedSearcherDelegate>{
    AMFeedSearcher *feedSearcher;
    IBOutlet UITableView *table;
    NSMutableArray *feedInfos;
    IBOutlet UIView *loadingView;
    NSMutableArray *selectedURLsArray;
    IBOutlet UITextField *searchBar;
}

-(void) addButtonPressed:(UIButton*) addButton;
-(IBAction) backButtonPressed:(id)sender;

@end
