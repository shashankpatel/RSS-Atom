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

@implementation HomeViewController

@synthesize currentView;
@synthesize feedInfo;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    feeds=[[NSMutableArray alloc] init];
    feedParser=[[MWFeedParser alloc] initWithFeedURL:nil];
    feedParser.delegate=self;
    feedParser.connectionType=ConnectionTypeAsynchronously;
    parsingMode=kParsingModeDocuments;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillDisappear:(BOOL)animated{
    stopIssued=YES;
    [feedParser stopParsing];
    [feeds removeAllObjects];
    [table reloadData];
    [super viewWillDisappear:animated];
}

-(void) viewWillAppear:(BOOL)animated{
    [feedParser setUrl:feedInfo.urlString];
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

-(void) pushFromView:(UIView*) source toView:(UIView*) target {
    if ([target superview]!=self.view) {
        [self.view addSubview:target];
    }
    target.transform=CGAffineTransformMakeScale(0.5, 0.5);
    target.alpha=0;
    [UIView beginAnimations:@"PushView" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    source.transform=CGAffineTransformMakeScale(1.5,1.5);
    source.alpha=0;
    target.transform=CGAffineTransformIdentity;
    target.alpha=1;
    [UIView commitAnimations];
    currentView=target;
    
}

-(void) popFromView:(UIView*) source toView:(UIView*) target{
    if ([target superview]!=self.view) {
        [self.view addSubview:target];
    }
    source.transform=CGAffineTransformIdentity;
    target.transform=CGAffineTransformMakeScale(2, 2);
    [UIView beginAnimations:@"PushView" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    target.transform=CGAffineTransformIdentity;
    target.alpha=1;
    source.transform=CGAffineTransformMakeScale(0.5, 0.5);
    source.alpha=0;
    [UIView commitAnimations];
    currentView=target;
}

-(IBAction)feedSelectorPressed:(id)sender{
    [self.zoomController popToIndex:1];
    [self popFromView:currentView toView:feedSelector.view];
}

-(void) feedInfoSelected:(AMFeedInfo*) _feedInfo{
    //Some loading functionality for feed goes here
    self.feedInfo=_feedInfo;
    [self.zoomController pushToIndex:2];
    [feedParser setUrl:feedInfo.urlString];
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
    [self popFromView:currentView toView:detachableView];
}

#pragma UITableViewDataSource and UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FeedCell=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:FeedCell];
    if (!cell) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FeedCell] autorelease];
        cell.textLabel.font=[General regularLabelFont];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.textLabel.numberOfLines=1;
        cell.detailTextLabel.font=[General descriptionFont];
        cell.detailTextLabel.textColor=[UIColor whiteColor];
        cell.detailTextLabel.numberOfLines=3;
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor=[UIColor clearColor];
    }
    
    MWFeedItem *feed=[feeds objectAtIndex:indexPath.row];
    cell.textLabel.text=feed.title;
    cell.detailTextLabel.text=[feed.summary stringByConvertingHTMLToPlainText];
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
