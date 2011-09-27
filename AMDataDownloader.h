//
//  AMDataDownloader.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/28/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMSerializer.h"

@protocol AMDataDownloaderDelegate <NSObject>

-(void) dataDownloadSucceededWithData:(NSData*) data;
-(void) dataDownloadFailedWithError:(NSError*) error;

@end

@interface AMDataDownloader : NSObject{
    NSURLConnection *connection;
    NSMutableData *receievedData;
    NSString *urlString;
    BOOL shouldCache;
    NSObject<AMDataDownloaderDelegate> *delegate;
}

@property(nonatomic,retain) NSString *urlString;

- (id)initWithDelegate:(NSObject<AMDataDownloaderDelegate> *)_delegate;
-(void) stop;
-(void) downloadContentOfURLString:(NSString*) _urlString shouldCache:(BOOL) _shouldCache;

@end
