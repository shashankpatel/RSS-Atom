//
//  RSS_AtomAppDelegate.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "NouvelleAppDelegate.h"
#import "AMNouvelleViewController.h"
#import "General.h"
#import "AMSerializer.h"
#import "AMFeedManager.h"

@implementation NouvelleAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

static Facebook* facebook;
static NSString* kAppId = @"274510792589386";
static NSArray *permissions;
static MWFeedItem *feedToPublish;
static NSString *postMessage;
static BOOL publishScheduled;

static SA_OAuthTwitterEngine *engine;
static NSString *kOAuthConsumerKey=@"AfpVFBP5BGKqbK5yDiNisA";
static NSString *kOAuthConsumerSecret=@"I9N5HCubJhB212YGBleAs1AY4KSq6ECUqHASNozTTdA";

static NSString *twitterPostString;

-(void) loadFaceBook{
    publishScheduled=NO;
    permissions =  [[NSArray arrayWithObjects:
                     @"read_stream", @"publish_stream", @"read_friendlists",nil] retain];
    facebook=[[Facebook alloc] initWithAppId:kAppId
                                 andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
}

-(BOOL) loadTwitter{
    BOOL loading=NO;
    if (engine) return loading;
    engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	engine.consumerKey = kOAuthConsumerKey;
	engine.consumerSecret = kOAuthConsumerSecret;
	AMViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: engine delegate: self];
	if (controller) {
        loading=YES;
        AMZoomViewController *zvc=[AMZoomViewController sharedZoomViewController];
        controller.zoomController=zvc;
        [zvc.viewControllers addObject:controller];
        int index=[zvc.viewControllers indexOfObject:controller];
        [zvc pushToIndex:index];
    }
    return loading;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self loadFaceBook];
    [General loadFonts];
    [AMSerializer loadSerializer];
    [AMFeedManager loadFeedManager];
    // Override point for customization after application launch.
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url];
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

#pragma mark - Facebook Methods

- (void)loginToFacebook {
    [facebook authorize:permissions];
}

-(void) publishContent:(MWFeedItem*) feed withPostMessage:(NSString*) _postMessage{
    if (!facebook.isSessionValid) {
        feedToPublish=[feed retain];
        postMessage=[_postMessage retain];
        publishScheduled=YES;
        [facebook authorize:permissions];
    }
    
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary 
                                                           dictionaryWithObjectsAndKeys: @"I want Nouvelle for iOS",@"name",@"http://appmaggot.com/nouvelle",
                                                           @"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:[actionLinks objectAtIndex:0]];
    
    NSString *caption=[AMFeedManager titleForFeedID:feed.feedID];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:feed.title forKey:@"name"];
    if ([caption length]>0) {
        [params setObject:caption forKey:@"caption"];
    }
    
    NSString *description=[feed plainStory];
    if ([description length]>120) {
        description=[description substringToIndex:119];
        description=[description stringByAppendingString:@"... Read on Nouvelle"];
    }
    if ([description length]<5) {
        description=@"Read on Nouvelle";
    }
    [params setObject:description forKey:@"description"];
    
    static NSString *websiteLink=@"http://www.appmaggot.com/nouvelle";
    
    [params setObject:feed.link forKey:@"link"];
    if ([feed.iconLink length]>0) {
        [params setObject:feed.iconLink forKey:@"picture"];
    }
    
    [params setObject:_postMessage forKey:@"message"];
    [params setObject:actionLinksStr forKey:@"actions"];
    
    [facebook requestWithGraphPath:@"me/feed"   // or use page ID instead of 'me'
                   andParams:params
               andHttpMethod:@"POST"
                 andDelegate:self];
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logoutFromfacebook {
    [facebook logout:self];
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    if (publishScheduled) {
        [self publishContent:feedToPublish withPostMessage:postMessage];
    }
    
    NSLog(@"Logged in");
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    NSLog(@"Logged out successfully");
}


////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Facebook:received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"Facebook:%@,%@",[[result class] description], [result description]);
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Request failed with error:%@",[error description]);
};


////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
-(void)dialogDidComplete:(FBDialog *)dialog {
    NSLog(@"published successfully");
}


-(void) postOnTwitter:(NSString*) twitterPost{
    BOOL loading=[self loadTwitter];
    if (loading) {
        twitterPostString=[twitterPost retain];
    }else{
        NSLog(@"sendUpdate: connectionIdentifier = %@", [engine sendUpdate:twitterPost]);
    }
}

#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
    if ([twitterPostString length]>0) {
        [self postOnTwitter:twitterPostString];
        twitterPostString=nil;
    }
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}


@end
