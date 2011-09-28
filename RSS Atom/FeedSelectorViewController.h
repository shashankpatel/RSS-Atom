//
//  FeedSelectorViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMViewController.h"
#import "AMFeedInfo.h"

@protocol FeedSelectorDelegate <NSObject>

-(void) feedInfoSelected:(AMFeedInfo*) feedInfo;

@end

@interface FeedSelectorViewController : AMViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *table;
    NSArray *feedInfos;
    NSObject<FeedSelectorDelegate> *delegate;
}

@property(nonatomic,retain) NSObject<FeedSelectorDelegate> *delegate;
@property(nonatomic,retain) NSArray *feedInfos;

-(IBAction) addFeedPressed:(id)sender;

@end
