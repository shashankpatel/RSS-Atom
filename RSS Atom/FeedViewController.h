//
//  FeedViewController.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMViewController.h"
#import "MWFeedItem.h"

@protocol FeedViewDelegate <NSObject>

-(void) btnListPressed;

@end

@interface FeedViewController : AMViewController<UIGestureRecognizerDelegate,UIWebViewDelegate>{
    NSObject<FeedViewDelegate> *delegate;
    IBOutlet UIWebView *webView;
    MWFeedItem *feed;
}

@property(nonatomic,retain) NSObject<FeedViewDelegate> *delegate;
@property(nonatomic,retain) MWFeedItem *feed;

-(void) processWebView;

-(IBAction) btnListPressed:(id)sender;
-(void) loadDescription;

@end
