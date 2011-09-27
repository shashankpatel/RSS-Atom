//
//  AMFeedSearcher.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/28/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMDataDownloader.h"

@protocol AMFeedSearcherDelegate <NSObject>

-(void) feedInfosReceived:(NSArray*) feedInfos;

@end

@interface AMFeedSearcher : AMDataDownloader<AMDataDownloaderDelegate>{
    NSString *searchText;
    NSObject<AMFeedSearcherDelegate> *feedSearchDelegate;
}

@property(nonatomic,retain) NSString *searchText;
@property(nonatomic,retain) NSObject<AMFeedSearcherDelegate> *delegate;

-(void) searchForText:(NSString*) searchText;

@end
