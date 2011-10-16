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
#define kHeaderTextTag 2000
#define kTableTransitionPositive 1
#define kTableTransitionNegative -1

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
    IBOutlet UIButton *upButton,*downButton,*removeButton;
    CGRect bottomFrame,topFrame;
}

@property(nonatomic,retain) NSObject<FeedSelectorDelegate> *delegate;
@property(nonatomic,retain) NSMutableDictionary *feedInfos;
@property(nonatomic,retain) NSArray *allCategories;
@property int tableIndex;

-(IBAction) addFeedPressed:(id)sender;
-(IBAction) removeFeedPressed:(id)sender;
-(void) textFieldDoubleTapped:(UITapGestureRecognizer*) singleDTap;
-(void) makeViewTranparent:(UIView *) view;

-(IBAction) editPressed:(id)sender;

-(IBAction) upPressed;
-(IBAction) downPressed;
-(void) processTableChange;
-(void) setButtonTexts;

@end
