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

+(void) checkCacheStatus{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *cachePath = [AMSerializer cache];    
    NSString *filePath;
    unsigned long long int folderSize = 0;
    
    NSArray *_documentsFileList = [fileManager subpathsAtPath:cachePath];
    NSEnumerator *_documentsEnumerator = [_documentsFileList objectEnumerator];
    while (filePath = [_documentsEnumerator nextObject]) {
        NSDictionary *_documentFileAttributes = [fileManager attributesOfItemAtPath:[cachePath stringByAppendingPathComponent:filePath] error:nil];
        folderSize += [_documentFileAttributes fileSize];
    }
    
    float fSize=(folderSize/(1024.0*1024));
    if (fSize>25) {
        NSLog(@"Folder size:%f. Cleaning up",fSize);
        if ([fileManager removeItemAtPath:cachePath error:nil]) {
            if([fileManager createDirectoryAtPath:cachePath
                      withIntermediateDirectories:NO
                                       attributes:nil
                                            error:nil])NSLog(@"Dir created");
            [cacheDictionary release];
            cacheDictionary=[[NSMutableDictionary alloc] init];
        }else{
            NSLog(@"Cannot remove cache");
        }
    }
}

+(void) loadSerializer{
    [super load];
    NSLog(@"Searializer loaded");
    if(!cacheDictionary) {
        cacheDictPath=[[[AMSerializer cache] stringByAppendingPathComponent:@"cacheDict.plist"] retain];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSNumber numberWithInt:4] forKey:@"tableIndex"];
        [defaults synchronize];
        
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
    return [[AMSerializer documents] stringByAppendingPathComponent:@"cache"];
}

+(NSString*) documents{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
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
    [AMSerializer serializeData:imageData forURLString:urlString];
    return;
    NSString *imageFileName=[NSString stringWithFormat:@"%f.png",[[NSDate date] timeIntervalSince1970]];
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
