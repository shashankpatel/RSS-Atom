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
#define kHeaderTextTag 999
#define kTableTransitionPositive 1
#define kTableTransitionNegative -1

#define kCatModeDelete -1
#define kCatModeNormal 1

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
    BOOL editMode;
    IBOutlet UIButton *addCat,*removeCat;
    int tableIndex,tableTransition;
    IBOutlet UIButton *removeButton,*manageButton;
    CGRect bottomFrame,topFrame;
    IBOutlet UIView *addFeedCatView;
    IBOutlet UITextField *tfFeedCat;
    NSMutableArray *gridTiles;
    IBOutlet UIView *catOverlay;
    IBOutlet UIButton *deleteButton;
    IBOutlet UIView *mainTitleBar;
    int catMode;
}

@property(nonatomic,retain) NSObject<FeedSelectorDelegate> *delegate;
@property(nonatomic,retain) NSMutableDictionary *feedInfos;
@property(nonatomic,retain) NSArray *allCategories;
@property int tableIndex;

-(IBAction) cancelAddFeedCatPressed;
-(IBAction) okAddFeedCatPressed;

-(IBAction) addFeedPressed:(id)sender;
-(IBAction) removeFeedPressed:(id)sender;
-(void) textFieldDoubleTapped:(UITapGestureRecognizer*) singleDTap;
-(void) makeViewTranparent:(UIView *) view;

-(IBAction) editPressed:(id)sender;

-(void) processTableChange;
-(void) addFeedCatPressed;
-(void) regenerateGrid;
-(IBAction) gridPressed:(id)sender;
-(IBAction) delCatPressed:(id)sender;

@end
