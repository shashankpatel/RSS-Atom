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

@interface AMFeedSelectorViewController : AMViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *table;
    NSMutableArray *feedInfos;
    NSObject<FeedSelectorDelegate> *delegate;
    IBOutlet UIButton *removeButton;
}

@property(nonatomic,retain) NSObject<FeedSelectorDelegate> *delegate;
@property(nonatomic,retain) NSArray *feedInfos;

-(IBAction) addFeedPressed:(id)sender;
-(IBAction) removeFeedPressed:(id)sender;

@end
