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
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

@class AMNouvelleViewController;

@interface NouvelleAppDelegate : NSObject <UIApplicationDelegate,FBRequestDelegate,FBDialogDelegate,FBSessionDelegate,SA_OAuthTwitterControllerDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AMNouvelleViewController *viewController;

-(void) loadFaceBook;
-(BOOL) loadTwitter;
-(void)loginToFacebook;
-(void)logoutFromfacebook;
-(void) publishContent:(MWFeedItem*) feed withPostMessage:(NSString*) postMessage;
-(void) postOnTwitter:(NSString*) twitterPost;
-(void) askForFacebookBoast;
-(void) boastOnFacebook;
-(void) boastOnTwitter;
+(Facebook*) sharedFacebook;
+(SA_OAuthTwitterEngine*) sharedTwitter;

@end
