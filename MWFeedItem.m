//
//  MWFeedItem.m
//  MWFeedParser
//
//  Created by Michael Waterfall on 10/05/2010.
//  Copyright 2010 Michael Waterfall. All rights reserved.
//

#import "MWFeedItem.h"
#import "JSON.h"

#define EXCERPT(str, len) (([str length] > len) ? [[str substringToIndex:len-1] stringByAppendingString:@"…"] : str)

@implementation MWFeedItem

@synthesize title, link, date, updated, summary, content, enclosures, iconLink, author, feedID;

#pragma mark NSObject

- (NSString *)description {
	NSMutableString *string = [[NSMutableString alloc] initWithString:@"MWFeedItem: "];
	if (title)   [string appendFormat:@"“%@”", EXCERPT(title, 50)];
	if (date)    [string appendFormat:@" - %@", date];
	//if (link)    [string appendFormat:@" (%@)", link];
	//if (summary) [string appendFormat:@", %@", EXCERPT(summary, 50)];
	return [string autorelease];
}

- (void)dealloc {
	[iconLink release];
	[author release];
	[title release];
	[link release];
	[date release];
	[updated release];
	[summary release];
	[content release];
	[enclosures release];
	[super dealloc];
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		title = [[decoder decodeObjectForKey:@"title"] retain];
		link = [[decoder decodeObjectForKey:@"link"] retain];
		date = [[decoder decodeObjectForKey:@"date"] retain];
		updated = [[decoder decodeObjectForKey:@"updated"] retain];
		summary = [[decoder decodeObjectForKey:@"summary"] retain];
		content = [[decoder decodeObjectForKey:@"content"] retain];
		enclosures = [[decoder decodeObjectForKey:@"enclosures"] retain];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	if (title) [encoder encodeObject:title forKey:@"title"];
	if (link) [encoder encodeObject:link forKey:@"link"];
	if (date) [encoder encodeObject:date forKey:@"date"];
	if (updated) [encoder encodeObject:updated forKey:@"updated"];
	if (summary) [encoder encodeObject:summary forKey:@"summary"];
	if (content) [encoder encodeObject:content forKey:@"content"];
	if (enclosures) [encoder encodeObject:enclosures forKey:@"enclosures"];
}

-(NSString*) addFeedQuery{
    NSString *dateString=[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    NSString *updatedString=[NSString stringWithFormat:@"%f",[updated timeIntervalSince1970]];
    NSString *enclosureString=@"";
    if ([enclosures count]>0) {
        enclosureString=[enclosures JSONRepresentation];;
    }
    
    NSString *titleString,*linkString,*summaryString,*contentString,*iconLinkString,*authorString;
    
    titleString=title;
    linkString=link;
    summaryString=summary;
    contentString=content;
    iconLinkString=iconLink;
    authorString=author;
    
    if ([title length]==0) {
        titleString=@"";
    }
    if ([link length]==0) {
        linkString=@"";
    }
    if ([summary length]==0) {
        summaryString=@"";
    }
    if ([content length]==0) {
        contentString=@"";
    }
    if ([iconLink length]==0) {
        iconLinkString=@"";
    }
    if ([author length]==0) {
        authorString=@"";
    }
    
    titleString=[titleString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    linkString=[linkString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    summaryString=[summaryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    contentString=[contentString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    iconLinkString=[iconLinkString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    authorString=[authorString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *addFeedQuery=[NSString stringWithFormat:@"INSERT INTO feeds VALUES(NULL,'%@','%@','%@','%@','%@','%@','%@','%@','%@',%d)", titleString, linkString, dateString, updatedString, summaryString, contentString, iconLinkString, authorString, enclosureString, feedID];
    return  addFeedQuery;
}

-(NSString*) dateString{
    NSString *dateString=[NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    return  dateString;
}

-(NSString*) updatedString{
    NSString *updatedString=[NSString stringWithFormat:@"%f",[updated timeIntervalSince1970]];
    return updatedString;
}

-(NSString*) enclosureString{
    NSString *enclosureString=@"";
    if ([enclosures count]>0) {
        enclosureString=[enclosures JSONRepresentation];;
    }
    return  enclosureString;
}

@end
