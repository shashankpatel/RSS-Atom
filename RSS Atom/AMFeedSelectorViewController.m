//
//  FeedSelectorViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMFeedSelectorViewController.h"
#import "General.h"
#import "AMImageView.h"
#import "HomeViewController.h"
#import "AMFeedManager.h"
#import "NSString+HTML.h"
#import "AMFeedSearchViewController.h"

@implementation AMFeedSelectorViewController

@synthesize delegate;
@synthesize feedInfos;
@synthesize allCategories;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    headerViews=[[NSMutableDictionary alloc] init];
    [self makeViewTranparent:table];
    [super viewDidLoad];
}

-(void) makeViewTranparent:(UIView *) view{
    for (UIView *subView in [view subviews]) {
        [self makeViewTranparent:subView];
    }
    view.backgroundColor=[UIColor clearColor];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void) viewWillAppear:(BOOL)animated{
    self.feedInfos=[AMFeedManager allFeedInfos];
    self.allCategories=[[AMFeedManager allFeedCategories] allValues];
    [table reloadData];
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[feedInfos objectForKey:[allCategories objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FeedCell=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:FeedCell];
    if (!cell) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeedCell] autorelease];
        cell.textLabel.font=[General selectedFontRegular];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        
        AMImageView *amiv=[[AMImageView alloc] init];
        amiv.tag=2222;
        [cell.contentView addSubview:amiv];
        amiv.frame=CGRectMake(15, 15, 16, 16);
        [amiv release];
    }
    NSString *category=[allCategories objectAtIndex:indexPath.section];
    AMFeedInfo *feedInfo=[[feedInfos objectForKey:category] objectAtIndex:indexPath.row];
    cell.textLabel.text=[feedInfo.title stringByConvertingHTMLToPlainText];
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

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [allCategories count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *category=[allCategories objectAtIndex:indexPath.section];
    AMFeedInfo *feedInfo=[[feedInfos objectForKey:category] objectAtIndex:indexPath.row];
    [delegate feedInfoSelected:feedInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[headerViews objectForKey:[NSNumber numberWithInt:section]];
    if (headerView) {
        UIButton *removeButton=(UIButton*) [headerView viewWithTag:kRemoveButtonTag+section];
        if ([[feedInfos objectForKey:[allCategories objectAtIndex:section]] count]==0) {
            removeButton.hidden=YES;
        }else{
            removeButton.hidden=NO;
        }
        return headerView;
    }
    headerView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    headerView.backgroundColor=[UIColor clearColor];
    UITextField *label=[[[UITextField alloc] initWithFrame:CGRectMake(10, 10, 230, 30)] autorelease];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    //label.textAlignment=UITextAlignmentCenter;
    label.font=[General selectedFontRegular];
    label.text=[allCategories objectAtIndex:section];
    label.delegate=self;
    UITapGestureRecognizer *singleDTap=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldDoubleTapped:)] autorelease];
    singleDTap.numberOfTouchesRequired=1;
    singleDTap.numberOfTapsRequired=2;
    [label addGestureRecognizer:singleDTap];
    [headerView addSubview:label];
    
    UIButton *rButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setImage:[UIImage imageNamed:@"removeIconSmall.png"] 
             forState:UIControlStateNormal];
    rButton.frame=CGRectMake(230, 7, 30, 30);
    rButton.tag=kRemoveButtonTag+section;
    [rButton addTarget:self 
                action:@selector(removeFeedPressed:) 
      forControlEvents:UIControlEventTouchUpInside];
    
    if ([[feedInfos objectForKey:[allCategories objectAtIndex:section]] count]==0) {
        rButton.hidden=YES;
    }
    
    [headerView addSubview:rButton];
    
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"addIconSmall.png"] 
               forState:UIControlStateNormal];
    addButton.frame=CGRectMake(260, 7, 30, 30);
    addButton.tag=kAddButtonTag+section;
    [addButton addTarget:self 
                  action:@selector(addFeedPressed:) 
        forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addButton];
    
    UIButton *dustBinButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [dustBinButton setBackgroundImage:[UIImage imageNamed:@"dustBinIconSmall.png"] forState:UIControlStateNormal];
    dustBinButton.frame=CGRectMake(290, 7, 30, 30);
    [headerView addSubview:dustBinButton];
    
    [headerViews setObject:headerView forKey:[NSNumber numberWithInt:section]];
    
    return  headerView;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    UIButton *dustBinButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [dustBinButton setBackgroundImage:[UIImage imageNamed:@"dustBinIconSmall.png"] forState:UIControlStateNormal];
    dustBinButton.frame=CGRectMake(140, 0, 40, 40);
    [footerView addSubview:dustBinButton];
    return  footerView;
}*/

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *category=[allCategories objectAtIndex:indexPath.section];
    AMFeedInfo *feedInfo=[[feedInfos objectForKey:category] objectAtIndex:indexPath.row];
    [AMFeedManager removeFeedInfo:feedInfo];
    
    self.feedInfos=[AMFeedManager allFeedInfos];
    self.allCategories=[[AMFeedManager allFeedCategories] allValues];
    
    [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    if ([[feedInfos objectForKey:[allCategories objectAtIndex:indexPath.section]] count]==0) {
        UIButton *removeButton=(UIButton*) [[headerViews objectForKey:[NSNumber numberWithInt:indexPath.section]] viewWithTag:kRemoveButtonTag+indexPath.section];
        removeButton.hidden=YES;
        [self removeFeedPressed:removeButton];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return (indexPath.section==selectedSection);
}

-(IBAction) addFeedPressed:(UIButton *) addButton{
    selectedSection=addButton.tag-kAddButtonTag;
    AMFeedSearchViewController *vc=(AMFeedSearchViewController*)[self.zoomController.viewControllers objectAtIndex:0];
    vc.category=[allCategories objectAtIndex:selectedSection];
    [self.zoomController popToIndex:0];
}

-(IBAction) removeFeedPressed:(UIButton *) rButton{
    selectedSection=rButton.tag-kRemoveButtonTag;
    [table setEditing:!table.editing animated:YES];
    if(table.editing){
        [rButton setImage:[UIImage imageNamed:@"checkMarkIconSmall.png"] forState:UIControlStateNormal];
    }else{
        [rButton setImage:[UIImage imageNamed:@"removeIconSmall.png"] forState:UIControlStateNormal];
    }
}


-(void) textFieldDoubleTapped:(UITapGestureRecognizer*) singleDTap{
    UITextField *textField=(UITextField*) singleDTap.view;
    textField.tag=1000;
    [textField becomeFirstResponder];
    NSLog(@"Double tap");
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag==1000){
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.tag=999;
    [textField resignFirstResponder];
    return YES;
}

-(void) dealloc{
    [feedInfos release];
    [delegate release];
    [super dealloc];
}


@end
