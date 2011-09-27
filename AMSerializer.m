//
//  Serializer.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMSerializer.h"

@implementation AMSerializer

static NSMutableDictionary *cacheDictionary;
static NSString *cacheDictPath;

+(void) loadSerializer{
    [super load];
    NSLog(@"Searializer loaded");
    if(!cacheDictionary) {
        cacheDictPath=[[[AMSerializer cache] stringByAppendingPathComponent:@"cacheDict.plist"] retain];
        if([[NSFileManager defaultManager] createDirectoryAtPath:[AMSerializer cache]
                                     withIntermediateDirectories:NO
                                                      attributes:nil
                                                           error:nil])NSLog(@"Dir created");
        if ([[NSFileManager defaultManager] fileExistsAtPath:cacheDictPath]) {
            cacheDictionary=[[NSMutableDictionary alloc] initWithContentsOfFile:cacheDictPath];
        }else{
            cacheDictionary=[[NSMutableDictionary alloc] init];
        }
    }
}

+(NSString*) cache{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"cache"];
}

+(UIImage*) imageForURLString:(NSString*) urlString{
    NSString *imageFileName=[cacheDictionary objectForKey:urlString];
    NSString *imageFilePath=[[AMSerializer cache] stringByAppendingPathComponent:imageFileName];
    return [UIImage imageWithContentsOfFile:imageFilePath];
}

+(NSData*) dataForURLString:(NSString*) urlString{
    NSString *dataFileName=[cacheDictionary objectForKey:urlString];
    NSString *dataFilePath=[[AMSerializer cache] stringByAppendingPathComponent:dataFileName];
    return [NSData dataWithContentsOfFile:dataFilePath];
}

+(void) serializeImage:(UIImage*) image forURLString:(NSString*) urlString{
    NSData *imageData=UIImagePNGRepresentation(image);
    NSString *imageFileName=[NSString stringWithFormat:@"%f.png",[[NSDate date] timeInterval]];
    NSString *imageFilePath=[[AMSerializer cache] stringByAppendingPathComponent:imageFileName];
    [imageData writeToFile:imageFilePath atomically:YES];
    [cacheDictionary setObject:imageFileName forKey:urlString];
    [cacheDictionary writeToFile:cacheDictPath atomically:YES];
}

+(void) serializeData:(NSData*) data forURLString:(NSString*) urlString{
    if ([data length]==0) {
        return;
    }
    NSString *imageFileName=[NSString stringWithFormat:@"%f.data",[[NSDate date] timeIntervalSince1970]];
    NSString *imageFilePath=[[AMSerializer cache] stringByAppendingPathComponent:imageFileName];
    [data writeToFile:imageFilePath atomically:YES];
    [cacheDictionary setObject:imageFileName forKey:urlString];
    [cacheDictionary writeToFile:cacheDictPath atomically:YES];
}

@end
