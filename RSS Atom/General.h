//
//  General.h
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface General : NSObject

+(void) load;
+(UIFont*) selectedFontRegular;
+(UIFont*) selectedFontLarge;
+(UIFont*) retractedLabelFont;
+(UIFont*) regularLabelFont;
+(UIFont*) descriptionFont;

@end
