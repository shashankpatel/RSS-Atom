//
//  MWFeedItem.m
//  MWFeedParser
//
//  Created by Michael Waterfall on 10/05/2010.
//  Copyright 2010 Michael Waterfall. All rights reserved.
//

#import "MWFeedItem.h"
#import "JSON.h"
#import "NSString+HTML.h"

#define EXCERPT(str, len) (([str length] > len) ? [[str substringToIndex:len-1] stringByAppendingString:@"…"] : str)

@implementation MWFeedItem

@synthesize title, link, date, updated, summary, content, enclosures, iconLink, author, feedID;
@synthesize plainStory,htmlStory;

-(id) init{
    if (self=[super init]) {
        rowCountForHeader=NSNotFound;
    }
    return self;
}

-(NSString*) title{
    return [title length]==0 ? @"" : title;
}

-(NSString*) link{
    return [link length]==0 ? @"" : link;
}

-(NSString*) summary{
    return [summary length]==0 ? @"" : summary;
}

-(NSString*) content{
    return [content length]==0 ? @"" : content;
}

-(NSString*) iconLink{
    return [iconLink length]==0 ? @"" : iconLink;
}

-(NSString*) author{
    return [author length]==0 ? @"" : author;
}

-(NSString*) plainStory{
    if (!plainStory) {
        plainStory=[self.summary length] > [self.content length] ? self.summary : self.content;
        plainStory=[[plainStory stringByConvertingHTMLToPlainText] retain];
    }
    return plainStory;
}

-(NSString*) htmlStory{
    if (!htmlStory) {
        htmlStory=[self.summary length] > [self.content length] ? self.summary : self.content;
    }
    return htmlStory;
}

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
    [plainStory release];
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

-(int) rowCountForHeader{
    if (rowCountForHeader==NSNotFound) {
        rowCountForHeader=0;
        if ([title length]>0) rowCountForHeader++;
        if ([[self dateString] length]>0) rowCountForHeader++;
        if ([author length]>0) rowCountForHeader++;
    }
    return rowCountForHeader;
}

static NSDateFormatter *dateFormatter;

-(NSString*) stringForHeaderForRow:(int) row{
    if (dateFormatter==nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        //[dateFormatter setDateFormat:@"dd MMM yyyy"];
    }
    if (row==0) {
        if ([title length]>0)return title;
        if (date!=nil)return [dateFormatter stringFromDate:date];
        if ([author length]>0)return author;
    }
    if (row==1) {
        if (date!=nil)return [dateFormatter stringFromDate:date];
        if ([author length]>0)return author;
    }
    if ([author length]>0)return author;
    return nil;
}


@end
