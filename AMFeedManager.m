//
//  AMFeedManager.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/28/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMFeedManager.h"
#import "AMSerializer.h"

@implementation AMFeedManager

static sqlite3 *feedDB;

+ (void)loadFeedManager
{
    NSString *feedDBPath=[[AMSerializer documents] stringByAppendingPathComponent:@"feedDB.db"]; 
    if(![[NSFileManager defaultManager] fileExistsAtPath:feedDBPath]){
        NSString *resourceDBPath=[[NSBundle mainBundle] pathForResource:@"feedDB" ofType:@"db"];
        if([[NSFileManager defaultManager] copyItemAtPath:resourceDBPath toPath:feedDBPath error:nil])NSLog(@"Database copied to:%@",feedDBPath);
    }
    if(sqlite3_open([feedDBPath UTF8String], &feedDB)==SQLITE_OK){
        NSLog(@"SQLite opened");
    }
}

+(void) addFeedInfo:(AMFeedInfo*) feedInfo{
    NSString *addQuery=[NSString stringWithFormat:@"INSERT INTO feedURLs VALUES('%@','%@','%@')",feedInfo.title,feedInfo.urlString,feedInfo.link];
    int ret = sqlite3_exec(feedDB, [addQuery UTF8String],NULL,NULL, NULL);
    if (ret==SQLITE_OK) {
        NSLog(@"Feed added");
    }
}

+(NSMutableArray*) allFeeds{
    NSString *allFeedsQuery=@"SELECT * FROM feedURLs";
	sqlite3_stmt *stmt;
	int ret = sqlite3_prepare_v2 (feedDB, [allFeedsQuery UTF8String], [allFeedsQuery length], &stmt, NULL);
    NSMutableArray *feeds=[[NSMutableArray alloc] init];
    if (ret == SQLITE_OK)
	{
		while (sqlite3_step(stmt) == SQLITE_ROW){
            AMFeedInfo *feedInfo=[[AMFeedInfo alloc] init];
			feedInfo.title=[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 0)];
            feedInfo.urlString=[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 1)];
            feedInfo.link=[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 2)];
            [feeds addObject:feedInfo];
            [feedInfo release];
		}
	}else {
		NSLog(@"%s",sqlite3_errmsg(feedDB));
	}
    return [feeds autorelease];
}

@end
