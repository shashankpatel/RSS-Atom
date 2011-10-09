//
//  FeedSearchViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/25/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMFeedSearchViewController.h"
#import "AMFeedInfo.h"
#import "AMImageView.h"
#import "General.h"
#import "NSString+HTML.h"
#import "AMFeedManager.h"

@implementation AMFeedSearchViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    feedInfos=[[NSMutableArray alloc] init];
    feedSearcher=[[AMFeedSearcher alloc] init];
    feedSearcher.delegate=self;
    NSArray *storedFeedInfos=[AMFeedManager allFeedInfos];
    selectedURLsArray=[[NSMutableArray alloc] init];
    for (AMFeedInfo *feedInfo in storedFeedInfos) {
        [selectedURLsArray addObject:feedInfo.urlString];
    }
    
    [searchBar becomeFirstResponder];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [searchBar becomeFirstResponder];
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated{
    [searchBar resignFirstResponder];
    [selectedURLsArray removeAllObjects];
    [feedInfos removeAllObjects];
    searchBar.text=nil;
    [table reloadData];
    [super viewWillDisappear:animated];
}

-(IBAction) backButtonPressed:(id)sender{
    [searchBar resignFirstResponder];
    [self.zoomController pushToIndex:1];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [feedInfos removeAllObjects];
    [table reloadData];
    [textField resignFirstResponder];
    if ([textField.text length]==0){
        return YES;
    }
    
    [self.view addSubview:loadingView];
    [feedSearcher searchForText:textField.text];
    return YES;
}

-(void) feedInfosReceived:(NSArray*) _feedInfos{
    [feedInfos addObjectsFromArray:_feedInfos];
    if ([searchBar.text isEqualToString:@"gizmodo"]) {
        AMFeedInfo *feedInfo=[[AMFeedInfo alloc] init];
        feedInfo.urlString=@"http://gizmodo.com/vip.xml";
        feedInfo.title=@"Gizmodo";
        feedInfo.link=@"http://www.gizmodo.com/";
        [feedInfos addObject:feedInfo];
        [feedInfo release];
    }
    [table reloadData];
    [loadingView removeFromSuperview];
}

-(void) addButtonPressed:(UIButton*) addButton{
    NSString *feedURLString=addButton.titleLabel.text;
    
    if ([selectedURLsArray indexOfObject:feedURLString]!=NSNotFound){
        [selectedURLsArray removeObject:feedURLString];
    }else{
        UITableViewCell *cell=(UITableViewCell*)[addButton superview];
        while (![cell isKindOfClass:[UITableViewCell class]]) {
            cell=(UITableViewCell*)[cell superview];
        }
        NSIndexPath *indexPath=[table indexPathForCell:cell];
        [AMFeedManager addFeedInfo:[feedInfos objectAtIndex:indexPath.row]];
        [selectedURLsArray addObject:feedURLString];
    }
         
    for (int i=0; i<[feedInfos count]; i++) {
        AMFeedInfo *feedInfo=[feedInfos objectAtIndex:i];
        if ([feedInfo.urlString isEqualToString:feedURLString]) {
            UITableViewCell *cell=[table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell) {
                UIButton *_addButton= (UIButton*)cell.accessoryView;
                if ([selectedURLsArray indexOfObject:feedURLString]!=NSNotFound) {
                    [_addButton setImage:[UIImage imageNamed:@"checkMarkIconSmall.png"] forState:UIControlStateNormal];
                }else{
                    [_addButton setImage:[UIImage imageNamed:@"addIconSmall.png"] forState:UIControlStateNormal];
                }
                
            } 
        }               
    }   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [feedInfos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FeedCell=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:FeedCell];
    if (!cell) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:FeedCell] autorelease];
        cell.textLabel.font=[General regularLabelFont];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.detailTextLabel.font=[General descriptionFont];
        cell.detailTextLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame=CGRectMake(0, 0, 44, 44);
        cell.accessoryView=addButton;
        [addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        AMImageView *amiv=[[AMImageView alloc] init];
        [amiv initAMImageView];
        amiv.tag=2222;
        [cell addSubview:amiv];
        amiv.frame=CGRectMake(20, 15, 16, 16);
        [amiv release];
    }
    UIButton *addButton= (UIButton*)cell.accessoryView;
    AMFeedInfo *feedInfo=[feedInfos objectAtIndex:indexPath.row];
    if ([selectedURLsArray indexOfObject:feedInfo.urlString]!=NSNotFound) {
        [addButton setImage:[UIImage imageNamed:@"checkMarkIconSmall.png"] forState:UIControlStateNormal];
    }else{
        [addButton setImage:[UIImage imageNamed:@"addIconSmall.png"] forState:UIControlStateNormal];
    }
    [addButton setTitle:feedInfo.urlString forState:UIControlStateNormal];
    cell.textLabel.text=[feedInfo.title stringByConvertingHTMLToPlainText];
    cell.detailTextLabel.text=feedInfo.urlString;
    
    
    NSRange startRange,endRange;
    NSString *domain=feedInfo.link;
    startRange=[domain rangeOfString:@"//"];
    if (startRange.location==NSNotFound) {
        domain=@"helloworld/";
    }
    startRange.location=startRange.location+2;
    domain=[domain substringFromIndex:startRange.location];
    endRange=[domain rangeOfString:@"/"];
    domain=[domain substringToIndex:endRange.location];
    domain=[domain stringByReplacingOccurrencesOfString:@"www." withString:@""];
    NSString *urlString=[[NSString stringWithFormat:@"http://www.google.com/s2/favicons?domain=%@",domain] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AMImageView *amiv=(AMImageView*) [cell viewWithTag:2222];
    [amiv setImageWithContentsOfURLString:urlString];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    UIButton *addButton= (UIButton*)cell.accessoryView;
    [self addButtonPressed:addButton];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    headerView.backgroundColor=[UIColor clearColor];
    UILabel *label=[[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 30)] autorelease];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.font=[General selectedFontRegular];
    label.text=@"Results";
    if ([feedInfos count]==0) {
        label.text=@"";
    }
    [headerView addSubview:label];
    return  headerView;
}


-(void) dealloc{
    [feedSearcher release];
    [super dealloc];
}

@end
