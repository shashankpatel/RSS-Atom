//
//  AMImageView.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMImageView.h"
#import "Serializer.h"

@implementation AMImageView

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void) setImageWithContentsOfURLString:(NSString*) _urlString{
    self.image=nil;
    urlString=_urlString;
    if (connection) {
        [connection cancel];
    }
    
    if ((self.image=[Serializer imageForURLString:urlString])) {
        NSLog(@"Found from cache");
        return;
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
    NSData *imageData=[NSData dataWithData:receievedData];
    self.image=[UIImage imageWithData:imageData];
    [Serializer serializeData:imageData forURLString:urlString];
    [receievedData setLength:0];
    if (connection)[connection release];
    [delegate imageSuccessfullyLoaded];
}

- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error{
    [connection release];
    connection=nil;
    [delegate imageFailedToLoad];
}

@end
