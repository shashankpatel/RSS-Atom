//
//  Serializer.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/23/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Serializer : NSObject

+(void) loadSerializer;
+(NSString*) cache;
+(UIImage*) imageForURLString:(NSString*) urlString;
+(void) serializeImage:(UIImage*) image forURLString:(NSString*) urlString;
+(void) serializeData:(NSData*) data forURLString:(NSString*) urlString;

@end
