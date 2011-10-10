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

#define kRemoveButtonTag -10000
#define kAddButtonTag 10000

@protocol FeedSelectorDelegate <NSObject>

-(void) feedInfoSelected:(AMFeedInfo*) feedInfo;

@end

@interface AMFeedSelectorViewController : AMViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    IBOutlet UITableView *table;
    NSMutableDictionary *feedInfos;
    NSObject<FeedSelectorDelegate> *delegate;
    NSArray *allCategories;
    NSMutableDictionary *headerViews;
    int selectedSection;
}

@property(nonatomic,retain) NSObject<FeedSelectorDelegate> *delegate;
@property(nonatomic,retain) NSMutableDictionary *feedInfos;
@property(nonatomic,retain) NSArray *allCategories;

-(IBAction) addFeedPressed:(id)sender;
-(IBAction) removeFeedPressed:(id)sender;
-(void) textFieldDoubleTapped:(UITapGestureRecognizer*) singleDTap;
-(void) makeViewTranparent:(UIView *) view;

@end
