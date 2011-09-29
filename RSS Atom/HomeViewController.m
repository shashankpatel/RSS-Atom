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
#import <QuartzCore/QuartzCore.h>

@implementation HomeViewController

@synthesize currentView;
@synthesize feedInfo;
@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;
#define REFRESH_HEADER_HEIGHT 52.0f

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self addPullToRefreshHeader];
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
    static NSString *FeedCell=@"AMFEEDCELL";
    AMFeedCell *cell=(AMFeedCell*) [tableView dequeueReusableCellWithIdentifier:FeedCell];
    if (!cell) {
        cell=[AMFeedCell cell];
        cell.titleLabel.font=[General regularLabelFont];
        cell.titleLabel.numberOfLines=1;
        cell.descriptionLabel.font=[General descriptionFont];
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
				if([imageElements count]>0){
                    Element* imageElement =[imageElements objectAtIndex:0];
                    iconLink=[imageElement attribute:@"src"];
                }
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
    [self stopLoading];
    
    if (parsingMode==kParsingModeDocuments) {
        parsingMode=kParsingModeLive;
        [feedParser parse];
    }else{
        parsingMode=kParsingModeDocuments;
    }
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    
}

#pragma UIScrollViewDelegate methods

- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:@"Pull down to refresh..."];
    textRelease = [[NSString alloc] initWithString:@"Release to refresh..."];
    textLoading = [[NSString alloc] initWithString:@"Loading..."];
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 16) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 26) / 2),
                                    16, 26);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [table addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            table.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            table.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    table.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    table.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    parsingMode=kParsingModeLive;
    [feedParser parse];
    //[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

@end
