//
//  HomeViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "HomeViewController.h"
#import "General.h"
#import "NSString+HTML.h"
#import "AMFeedManager.h"
#import "ElementParser.h"
#import "AMFeedCell.h"

@implementation HomeViewController

@synthesize currentView;
@synthesize feedInfo;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

static BOOL initialized=NO;

-(void) initController{
    feeds=[[NSMutableArray alloc] init];
    parsingMode=kParsingModeDocuments;
    NSArray *allfeedInfos=[AMFeedManager allFeedInfos];
    if ([allfeedInfos count]!=0) {
        self.feedInfo=[allfeedInfos objectAtIndex:0];
    }
    feedParser=[[MWFeedParser alloc] initWithFeedURL:feedInfo.urlString];
    feedParser.connectionType=ConnectionTypeAsynchronously;
    feedParser.delegate=self;
    initialized=YES;
}

-(void) viewWillDisappear:(BOOL)animated{
    stopIssued=YES;
    [feedParser stopParsing];
    [feedParser reset];
    [feeds removeAllObjects];
    [table reloadData];
    [super viewWillDisappear:animated];
}

-(void) viewWillAppear:(BOOL)animated{
    if (!initialized) {
        [self initController];
    }
    stopIssued=NO;
    //[feedParser setUrl:feedInfo.urlString];
    if (parsingMode==kParsingModeDocuments) {
        if(![feedParser parseFromDocuments]){
            parsingMode=kParsingModeLive;
            [feedParser parse];
        }
    }else{
        [feedParser parse];
    }
    [super viewWillAppear:animated];
}

-(IBAction)feedSelectorPressed:(id)sender{
    [self.zoomController popToIndex:1];
}

-(void) feedInfoSelected:(AMFeedInfo*) _feedInfo{
    //Some loading functionality for feed goes here
    self.feedInfo=_feedInfo;
    [feedParser setUrl:feedInfo.urlString];
    [self.zoomController pushToIndex:2];
    return;
    if (parsingMode==kParsingModeDocuments) {
        if(![feedParser parseFromDocuments]){
            parsingMode=kParsingModeLive;
            [feedParser parse];
        }
    }else{
        [feedParser parse];
    }
    
    //[feedParser parse];
    
}

-(void) feedsReceived:(NSArray*) _feeds{
    [feeds addObjectsFromArray:_feeds];
    [table reloadData];
}

-(void) btnListPressed{
    return;
}

#pragma UITableViewDataSource and UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FeedCell=@"CELL";
    AMFeedCell *cell=(AMFeedCell*) [tableView dequeueReusableCellWithIdentifier:FeedCell];
    if (!cell) {
        cell=[AMFeedCell cell];
//        cell.titleLabel.font=[General regularLabelFont];
//        cell.titleLabel.textColor=[UIColor whiteColor];
        cell.titleLabel.numberOfLines=1;
//        cell.descriptionLabel.font=[General descriptionFont];
//        cell.descriptionLabel.textColor=[UIColor whiteColor];
        cell.descriptionLabel.numberOfLines=3;
        //cell.backgroundColor=[UIColor clearColor];
        //cell.contentView.backgroundColor=[UIColor clearColor];
    }
    
    MWFeedItem *feed=[feeds objectAtIndex:indexPath.row];
    cell.titleLabel.text=feed.title;
    cell.descriptionLabel.text=[feed.summary stringByConvertingHTMLToPlainText];
    
	if (feed.iconLink==nil && feed.summary!=nil) {
		NSString *iconLink=nil;
		NSString *feedSummery=[NSString stringWithString:feed.summary];
		
		Element* root = [Element parseHTML:feedSummery];
		NSArray* imageElements = [root selectElements: @"img"];
		
		if (imageElements!=nil && [imageElements count]>0) {
			Element* imageElement =[imageElements objectAtIndex:0];
			iconLink=[imageElement attribute:@"src"];
		}
		if (iconLink==nil || [iconLink length]==0) {
			if (feed.content!=nil && [feed.content length]!=0) {
				feedSummery=[[NSString alloc] initWithString:feed.content];
				root = [Element parseHTML: feedSummery];
				[feedSummery release];
				imageElements = [root selectElements: @"img"];
				
				Element* imageElement =[imageElements objectAtIndex:0];
				iconLink=[imageElement attribute:@"src"];
			}
		}
		if (iconLink==nil) {
			iconLink=@"";
		}
		feed.iconLink=iconLink;
	}
    [cell loadImageFromURLString:feed.iconLink];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.zoomController pushToIndex:3];
}

#pragma MWFeedParserDelegate methods

- (void)feedParserDidStart:(MWFeedParser *)parser{
    NSLog(@"Parsing started");
    [feeds removeAllObjects];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info{
    
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
    [feeds addObject:item];
}

- (void)feedParserDidFinish:(MWFeedParser *)parser{
    if (stopIssued) {
        stopIssued=NO;
        parsingMode=kParsingModeDocuments;
        return;
    }
    NSLog(@"Parsing finished");
    [table reloadData];
    
    if (parsingMode==kParsingModeDocuments) {
        parsingMode=kParsingModeLive;
        [feedParser parse];
    }else{
        parsingMode=kParsingModeDocuments;
    }
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    
}

@end
