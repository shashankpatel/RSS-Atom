//
//  RSS_AtomAppDelegate.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "MWFeedItem.h"
#import "MGTwitterEngine.h"

@class AMNouvelleViewController;

@interface NouvelleAppDelegate : NSObject <UIApplicationDelegate,FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AMNouvelleViewController *viewController;

-(void) loadFaceBook;
-(void) loadTwitter;
-(void)loginToFacebook;
-(void)logoutFromfacebook;
-(void) publishContent:(MWFeedItem*) feed withPostMessage:(NSString*) postMessage;
-(void) postOnTwitter:(NSString*) twitterPost;

@end
