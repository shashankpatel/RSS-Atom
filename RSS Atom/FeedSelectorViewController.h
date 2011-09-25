//
//  FeedSelectorViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMViewController.h"

@protocol FeedSelectorDelegate <NSObject>

-(void) feedSelectedForURLString:(NSString*) urlString;

@end

@interface FeedSelectorViewController : AMViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *table;
    NSMutableArray *feedURLs;
    NSObject<FeedSelectorDelegate> *delegate;
}

@property(nonatomic,retain) NSObject<FeedSelectorDelegate> *delegate;

-(IBAction) addFeedPressed:(id)sender;

@end
