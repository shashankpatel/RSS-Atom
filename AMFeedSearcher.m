//
//  AMFeedSearcher.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/28/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMFeedSearcher.h"
#import "JSON.h"
#import "AMFeedInfo.h"

@implementation AMFeedSearcher

@synthesize searchText;
@synthesize delegate=feedSearchDelegate;

- (id)init
{
    self = [super initWithDelegate:self];
    if (self) {
    }
    
    return self;
}

-(void) searchForText:(NSString*) _searchText{
    self.searchText=_searchText;
    NSString *_urlString=[[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/feed/find?v=1.0&q=%@",searchText] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [super downloadContentOfURLString:_urlString shouldCache:NO];
}

-(void) dataDownloadSucceededWithData:(NSData*) data{
    NSMutableArray *feedInfos=[[NSMutableArray alloc] init];
    @try {
        NSString *receivedString=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *receivedDict=[receivedString JSONValue];
        NSArray *entries=[[receivedDict objectForKey:@"responseData"] objectForKey:@"entries"];
        for(NSDictionary *entry in entries){
            AMFeedInfo *feedInfo=[[AMFeedInfo alloc] init];
            feedInfo.title=[entry objectForKey:@"title"];
            feedInfo.urlString=[entry objectForKey:@"url"];
            feedInfo.link=[entry objectForKey:@"link"];
            [feedInfos addObject:feedInfo];
            [feedInfo release];
        }
    }
    @catch (NSException *exception) {
    }
    [feedSearchDelegate feedInfosReceived:feedInfos];
}

-(void) dataDownloadFailedWithError:(NSError*) error{
    NSMutableArray *feedInfos=[NSMutableArray array];
    [feedSearchDelegate feedInfosReceived:feedInfos];
}

-(void) dealloc{
    [searchText release];
    [super dealloc];
}

@end
