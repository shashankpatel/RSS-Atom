//
//  General.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "General.h"

@implementation General

static UIFont *selectedFontRegular,*selectedFontLarge,*retractedLabelFont,*regularLabelFont,*descriptionFont;

+(void) load{
    selectedFontRegular= [[UIFont fontWithName: @"SegoeUI" size: 17] retain];
    selectedFontLarge= [[UIFont fontWithName: @"SegoeUI-Bold" size: 25] retain];
    retractedLabelFont=[[UIFont fontWithName: @"SegoeUI-Bold" size: 11] retain];
    regularLabelFont=[[UIFont fontWithName: @"SegoeUI-Bold" size: 15] retain];
    descriptionFont= [[UIFont fontWithName: @"SegoeUI" size: 12] retain];
    if (selectedFontRegular==nil || selectedFontLarge==nil) {
		NSLog(@"Font not found");
	}
}

+(UIFont*) selectedFontRegular{
    return selectedFontRegular;
}

+(UIFont*) selectedFontLarge{
    return selectedFontLarge;
}

+(UIFont*) retractedLabelFont{
    return retractedLabelFont;
}

+(UIFont*) regularLabelFont{
    return regularLabelFont;
}

+(UIFont*) descriptionFont{
    return descriptionFont;
}



@end
