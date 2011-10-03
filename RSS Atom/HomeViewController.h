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
    NSMutableArray *feeds,*tempFeeds;
    MWFeedParser *feedParser;
    int parsingMode;
    BOOL stopIssued;
    
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
}

@property(nonatomic,retain) UIView *currentView;
@property(nonatomic,retain) AMFeedInfo *feedInfo;
@property(nonatomic,retain) FeedViewController *feedViewController;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

-(void) initController;
-(IBAction)feedSelectorPressed:(id)sender;

@end
