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
#import "MWFeedParser.h"

#define kParsingModeDocuments 0
#define kParsingModeLive 1

@interface HomeViewController : AMViewController<FeedSelectorDelegate,FeedViewDelegate,MWFeedParserDelegate>{
    FeedSelectorViewController *feedSelector;
    FeedViewController *feedViewController;
    IBOutlet UITableView *table;
    IBOutlet UIView *detachableView;
    UIView *currentView;
    AMFeedInfo *feedInfo;
    NSMutableArray *feeds;
    MWFeedParser *feedParser;
    int parsingMode;
    BOOL stopIssued;
}

@property(nonatomic,retain) UIView *currentView;
@property(nonatomic,retain) AMFeedInfo *feedInfo;

-(void) initController;
-(IBAction)feedSelectorPressed:(id)sender;

@end
