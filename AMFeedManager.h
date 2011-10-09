//
//  AMFeedManager.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/28/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SQLite3.h>
#import "AMFeedInfo.h"

@interface AMFeedManager : NSObject{
}

+ (void)loadFeedManager;
+(void) addFeedInfo:(AMFeedInfo*) feedInfo;
+(void) removeFeedInfo:(AMFeedInfo*) feedInfo;
+(NSMutableDictionary*) allFeedCategories;
+(NSMutableDictionary*) allFeedInfos;

@end
