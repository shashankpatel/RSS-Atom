//
//  AMFeedManager.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/28/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMFeedManager.h"
#import "AMSerializer.h"
#import "MWFeedItem.h"
#import "JSON.h"

@implementation AMFeedManager

static sqlite3 *feedDB;

+ (void)loadFeedManager
{
    NSString *feedDBPath=[[AMSerializer documents] stringByAppendingPathComponent:@"feedDB.db"]; 
    NSLog(@"DB Path:%@",feedDBPath);
    if(![[NSFileManager defaultManager] fileExistsAtPath:feedDBPath]){
        NSString *resourceDBPath=[[NSBundle mainBundle] pathForResource:@"feedDB" ofType:@"db"];
        if([[NSFileManager defaultManager] copyItemAtPath:resourceDBPath toPath:feedDBPath error:nil])NSLog(@"Database copied to:%@",feedDBPath);
    }
    if(sqlite3_open([feedDBPath UTF8String], &feedDB)==SQLITE_OK){
        NSLog(@"SQLite opened");
    }
}

+(void) addFeedInfo:(AMFeedInfo*) feedInfo{
    NSString *addQuery=[NSString stringWithFormat:@"INSERT INTO feedURLs VALUES(NULL,'%@','%@','%@',(SELECT PID FROM feedCategories WHERE categoryName='%@'))",feedInfo.title,feedInfo.urlString,feedInfo.link,feedInfo.category];
    int ret = sqlite3_exec(feedDB, [addQuery UTF8String],NULL,NULL, NULL);
    if (ret==SQLITE_OK) {
        NSLog(@"Feed added");
    }else{
        printf("\n%s",sqlite3_errmsg(feedDB));
    }
}

+(void) removeFeedInfo:(AMFeedInfo*) feedInfo{
    NSString *removeQuery=[NSString stringWithFormat:@"DELETE FROM feedURLs WHERE feedID=%d",feedInfo.feedID];
    int ret = sqlite3_exec(feedDB, [removeQuery UTF8String],NULL,NULL, NULL);
    if (ret==SQLITE_OK) {
        NSLog(@"Feed removed");
    }
}

+(NSMutableDictionary*) allFeedCategories{
    NSString *allCatQuery=@"SELECT * FROM feedCategories";
	sqlite3_stmt *stmt;
	int ret = sqlite3_prepare_v2 (feedDB, [allCatQuery UTF8String], [allCatQuery length], &stmt, NULL);
    NSMutableDictionary *cats=[[NSMutableDictionary alloc] init];
    if (ret == SQLITE_OK)
	{
		while (sqlite3_step(stmt) == SQLITE_ROW){
            NSNumber *PID=[NSNumber numberWithInt:sqlite3_column_int(stmt, 0)];
			NSString *cat=[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 1)];
            [cats setObject:cat forKey:PID];
		}
	}else {
		NSLog(@"%s",sqlite3_errmsg(feedDB));
	}
    return [cats autorelease];
}

+(NSMutableDictionary*) allFeedInfos{
    NSMutableDictionary *allFeedCats=[AMFeedManager allFeedCategories];
    NSString *allFeedsQuery=@"SELECT * FROM feedURLs";
	sqlite3_stmt *stmt;
	int ret = sqlite3_prepare_v2 (feedDB, [allFeedsQuery UTF8String], [allFeedsQuery length], &stmt, NULL);
    NSMutableDictionary *feeds=[[NSMutableDictionary alloc] init];
    if (ret == SQLITE_OK)
	{
		while (sqlite3_step(stmt) == SQLITE_ROW){
            AMFeedInfo *feedInfo=[[AMFeedInfo alloc] init];
            feedInfo.feedID=sqlite3_column_int(stmt, 0);
			feedInfo.title=[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 1)];
            feedInfo.urlString=[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 2)];
            feedInfo.link=[NSString stringWithUTF8String:(char*)sqlite3_column_text(stmt, 3)];
            feedInfo.category=[allFeedCats objectForKey:[NSNumber numberWithInt:sqlite3_column_int(stmt, 4)]];
            
            NSMutableArray *feedsArray=[feeds objectForKey:feedInfo.category];
            if (!feedsArray) {
                feedsArray=[NSMutableArray array];
                [feeds setObject:feedsArray forKey:feedInfo.category];
            }
            [feedsArray addObject:feedInfo];
            [feedInfo release];
		}
	}else {
		NSLog(@"%s",sqlite3_errmsg(feedDB));
	}
    return [feeds autorelease];
}

+(NSMutableArray*) feedsForFeedID:(int) feedID{
    NSMutableArray *feeds=[[NSMutableArray alloc] init];
    NSString *allFeedsQuery=[NSString stringWithFormat:@"SELECT * FROM feeds WHERE feedID=%d",feedID];
	sqlite3_stmt *stmt;
	int ret = sqlite3_prepare_v2 (feedDB, [allFeedsQuery UTF8String], [allFeedsQuery length], &stmt, NULL);
    if (ret == SQLITE_OK)
	{
		while (sqlite3_step(stmt) == SQLITE_ROW){
            MWFeedItem *feedItem=[[MWFeedItem alloc] init];
            int column=1;
            char *data=(char*)sqlite3_column_text(stmt, column++);
            if(data!=NULL)feedItem.title=[NSString stringWithUTF8String:data];

            data=(char*)sqlite3_column_text(stmt, column++);
            if(data!=NULL)feedItem.link=[NSString stringWithUTF8String:data];
            
            data=(char*)sqlite3_column_text(stmt, column++);
            if(data!=NULL)feedItem.date=[NSDate dateWithTimeIntervalSince1970:[[NSString stringWithUTF8String:data] floatValue]];
            
            data=(char*)sqlite3_column_text(stmt, column++);
            if(data!=NULL)feedItem.updated=[NSDate dateWithTimeIntervalSince1970:[[NSString stringWithUTF8String:data] floatValue]];
            
            data=(char*)sqlite3_column_text(stmt, column++);
            if(data!=NULL)feedItem.summary=[NSString stringWithUTF8String:data];

            data=(char*)sqlite3_column_text(stmt, column++);
            if(data!=NULL)feedItem.content=[NSString stringWithUTF8String:data];

            data=(char*)sqlite3_column_text(stmt, column++);
            if(data!=NULL)feedItem.iconLink=[NSString stringWithUTF8String:data];
            
            data=(char*)sqlite3_column_text(stmt, column++);
            if(data!=NULL)feedItem.author=[NSString stringWithUTF8String:data];
            
            NSString *enclosureString;
            data=(char*)sqlite3_column_text(stmt, column++);
            if(data!=NULL) enclosureString=[NSString stringWithUTF8String:data];
            
            if([enclosureString length]>0){
                feedItem.enclosures=[enclosureString JSONValue];
            }
            [feeds addObject:feedItem];
            [feedItem release];
		}
	}else {
		NSLog(@"%s",sqlite3_errmsg(feedDB));
	}
    return [feeds autorelease];
}

+(void) addFeeds:(NSArray*) feeds forFeedID:(int) feedID{
    
    NSString *deleteFeedQuery=[NSString stringWithFormat:@"DELETE FROM feeds WHERE feedID=%d",feedID];
    int ret = sqlite3_exec(feedDB, [deleteFeedQuery UTF8String],NULL,NULL, NULL);
    if (ret==SQLITE_OK) {
        //NSLog(@"Feeds deleted");
    }
    
    
    for(MWFeedItem *feed in feeds){
        
        char *sql;
        sqlite3_stmt *outStmt;
        sql=(char*) [@"INSERT INTO feeds (PID,title,link,date,updated,summary,content,iconLink,author,enclosures,feedID) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" UTF8String];
        ret = sqlite3_prepare (feedDB, sql, strlen (sql), &outStmt, NULL);
        
        
        if (ret==SQLITE_OK) {
            sqlite3_reset (outStmt);
            sqlite3_clear_bindings (outStmt);
            
            sqlite3_bind_text(outStmt, 1, [feed.title UTF8String], strlen([feed.title UTF8String]), NULL);
            sqlite3_bind_text(outStmt, 2, [feed.link UTF8String], strlen([feed.link UTF8String]), NULL);
            sqlite3_bind_text(outStmt, 3, [[feed dateString] UTF8String], strlen([[feed dateString] UTF8String]), NULL);
            sqlite3_bind_text(outStmt, 4, [[feed updatedString] UTF8String], strlen([[feed updatedString] UTF8String]), NULL);
            sqlite3_bind_text(outStmt, 5, [feed.summary UTF8String], strlen([feed.summary UTF8String]), NULL);
            sqlite3_bind_text(outStmt, 6, [feed.content UTF8String], strlen([feed.content UTF8String]), NULL);
            sqlite3_bind_text(outStmt, 7, [feed.iconLink UTF8String], strlen([feed.iconLink UTF8String]), NULL);
            sqlite3_bind_text(outStmt, 8, [feed.author UTF8String], strlen([feed.author UTF8String]), NULL);
            sqlite3_bind_text(outStmt, 9, [[feed enclosureString] UTF8String], strlen([[feed enclosureString] UTF8String]), NULL);
            sqlite3_bind_int(outStmt, 10, feedID);
            
            
            int ret = sqlite3_step (outStmt);
            if (ret == SQLITE_DONE || ret == SQLITE_ROW){
                //NSLog(@"Feed added");
            }
            sqlite3_finalize(outStmt);
        }
        
    }
	
}

+(void) modifyCategoryNameFrom:(NSString*) oldName toName:(NSString*) newName{
    NSString *deleteFeedQuery=[NSString stringWithFormat:@"UPDATE feedCategories SET categoryName='%@' WHERE categoryName='%@'",newName,oldName];
    int ret = sqlite3_exec(feedDB, [deleteFeedQuery UTF8String],NULL,NULL, NULL);
    if (ret==SQLITE_OK) {
        NSLog(@"Category modified");
    }else{
        NSLog(@"Error:%s",sqlite3_errmsg(feedDB));
    }
}

@end
