//
//  AMFeedListViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMSourceSelectorViewController.h"
#import "AMFeedViewController.h"
#import "AMViewController.h"
#import "MWFeedParser.h"
#import "AMSettingsViewController.h"

@interface AMFeedListViewController : AMViewController<FeedSelectorDelegate,FeedViewDelegate,MWFeedParserDelegate>{
    AMSourceSelectorViewController *feedSelector;
    AMFeedViewController *feedViewController;
    IBOutlet UITableView *table;
    IBOutlet UIView *detachableView;
    UIView *currentView;
    AMFeedInfo *feedInfo;
    NSMutableArray *feeds,*tempFeeds;
    MWFeedParser *feedParser;
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
    NSMutableArray *cells;
    IBOutlet UILabel *feedTitle;
    IBOutlet AMSettingsViewController *settingsController;
    IBOutlet UIView *settingsView;
}

@property(nonatomic,retain) UIView *currentView;
@property(nonatomic,retain) AMFeedInfo *feedInfo;
@property(nonatomic,retain) AMFeedViewController *feedViewController;

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, retain) NSMutableArray *feeds;

- (void)setupStrings;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
- (void) reloadFeeds;

-(void) initController;
-(IBAction)feedSelectorPressed:(id)sender;
-(IBAction) backgroundButtonPressed:(id)sender;

-(void) makeViewTranparent:(UIView *) view;
-(IBAction) wrenchPressed;
-(IBAction) cancelSettingsPressed;
-(void) showSettingsTable;
-(IBAction) hideSettingsTable;

@end
