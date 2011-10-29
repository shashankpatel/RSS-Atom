//
//  Serializer.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMSerializer : NSObject


+(void) checkCacheStatus;
+(void) loadSerializer;
+(NSString*) cache;
+(NSString*) documents;
+(UIImage*) imageForURLString:(NSString*) urlString;
+(NSData*) dataForURLString:(NSString*) urlString;
+(void) serializeImage:(UIImage*) image forURLString:(NSString*) urlString;
+(void) serializeData:(NSData*) data forURLString:(NSString*) urlString;

@end
