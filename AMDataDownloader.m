//
//  AMDataDownloader.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/28/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMDataDownloader.h"

@implementation AMDataDownloader

@synthesize urlString;

- (id)initWithDelegate:(NSObject<AMDataDownloaderDelegate> *)_delegate
{
    self = [super init];
    if (self) {
        delegate=_delegate;
        // Initialization code here.
    }
    
    return self;
}

-(void) stop{
    if (connection) {
        [connection cancel];
        [connection release];
        connection=nil;
    } 
}

-(void) downloadContentOfURLString:(NSString*) _urlString shouldCache:(BOOL) _shouldCache{
    self.urlString=_urlString;
    shouldCache=_shouldCache;
    [self stop];
    
    if (shouldCache) {
        NSData *data=[AMSerializer dataForURLString:urlString];
        if (data) {
            [delegate dataDownloadSucceededWithData:data];
        }
    }
    
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        NSLog(@"Connection opened");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    if(!receievedData)receievedData=[[NSMutableData alloc] init];
    [receievedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receievedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection{
    NSData *data=[NSData dataWithData:receievedData];
    if (shouldCache) {
        [AMSerializer serializeData:data forURLString:urlString];
    }
    [receievedData setLength:0];
    [connection release];
    connection=nil;
    [delegate dataDownloadSucceededWithData:data];
}

- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error{
    [connection release];
    connection=nil;
    [delegate dataDownloadFailedWithError:error];
}

-(void) dealloc{
    [connection release];
    [receievedData release];
    [super dealloc];
}

@end
