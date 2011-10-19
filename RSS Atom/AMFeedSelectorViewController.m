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
#import "AMFeedListViewController.h"
#import "AMFeedManager.h"
#import "NSString+HTML.h"
#import "AMFeedSearchViewController.h"

@implementation AMFeedSelectorViewController

@synthesize delegate;
@synthesize feedInfos;
@synthesize allCategories;
@synthesize tableIndex;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    headerViews=[[NSMutableDictionary alloc] init];
    self.tableIndex=0;
    upButton.titleLabel.font=[General regularLabelFont];
    downButton.titleLabel.font=[General regularLabelFont];
    bottomFrame=CGRectMake(0, 416, 320, 328);
    topFrame=CGRectMake(0, 44, 320, 328);
    manageButton.hidden=YES;
    tableIndex=NSNotFound;
    [self makeViewTranparent:table];
    [super viewDidLoad];
}

-(void) setTableIndex:(int)_tableIndex{
    if(tableIndex>_tableIndex){
        tableTransition=kTableTransitionNegative;
    }else{
        tableTransition=kTableTransitionPositive;
    }
    tableIndex=_tableIndex;
    
    [upButton setTitle:nil forState:UIControlStateNormal];
    [downButton setTitle:nil forState:UIControlStateNormal];
}

-(void) setButtonTexts{
    if(tableIndex>0){
        [upButton setTitle:[allCategories objectAtIndex:tableIndex-1] forState:UIControlStateNormal];
        //upButton.hidden=NO;
    }else{
        [upButton setTitle:@"✚" forState:UIControlStateNormal];
        //upButton.hidden=YES;
    }
    
    if(tableIndex<[allCategories count]-1){
        [downButton setTitle:[allCategories objectAtIndex:tableIndex+1] forState:UIControlStateNormal];
        //downButton.hidden=NO;
    }else{
        [downButton setTitle:@"✚" forState:UIControlStateNormal];
        //downButton.hidden=YES;
    }
}

-(int) tableIndex{
    return tableIndex;
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
    if(self.tableIndex==NSNotFound) self.tableIndex=0;
    [self setButtonTexts];
    [table reloadData];
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[feedInfos objectForKey:[allCategories objectAtIndex:tableIndex]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FeedCell=@"CELL";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:FeedCell];
    if (!cell) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeedCell] autorelease];
        cell.textLabel.font=[General selectedFontRegular];
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor blackColor];
        cell.showsReorderControl = YES;
        
        AMImageView *amiv=[[AMImageView alloc] init];
        amiv.tag=2222;
        [cell.contentView addSubview:amiv];
        amiv.frame=CGRectMake(15, 15, 16, 16);
        [amiv release];
    }
    NSString *category=[allCategories objectAtIndex:tableIndex];
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
    return 1;
    return [allCategories count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *category=[allCategories objectAtIndex:tableIndex];
    AMFeedInfo *feedInfo=[[feedInfos objectForKey:category] objectAtIndex:indexPath.row];
    [delegate feedInfoSelected:feedInfo];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[headerViews objectForKey:[NSNumber numberWithInt:section]];
    if (headerView) {
        UILabel *headerLabel=(UILabel*)[headerView viewWithTag:kHeaderTextTag];
        headerLabel.text=[allCategories objectAtIndex:tableIndex];
        return headerView;
    }
    headerView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    headerView.backgroundColor=[UIColor clearColor];
    UITextField *label=[[[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 30)] autorelease];
    label.tag=kHeaderTextTag;
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=UITextAlignmentCenter;
    label.font=[General regularLabelFont];
    label.text=[allCategories objectAtIndex:tableIndex];
    label.delegate=self;
    UITapGestureRecognizer *singleDTap=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldDoubleTapped:)] autorelease];
    singleDTap.numberOfTouchesRequired=1;
    singleDTap.numberOfTapsRequired=2;
    [label addGestureRecognizer:singleDTap];
    [headerView addSubview:label];
    
    [headerViews setObject:headerView forKey:[NSNumber numberWithInt:section]];
    
    return  headerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
    UIView *footerView=[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
    UIButton *rButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setImage:[UIImage imageNamed:@"removeIconSmall.png"] 
             forState:UIControlStateNormal];
    rButton.frame=CGRectMake(230, 7, 30, 30);
    rButton.center=CGPointMake(80, 22);
    rButton.tag=kRemoveButtonTag+section;
    [rButton addTarget:self 
                action:@selector(removeFeedPressed:) 
      forControlEvents:UIControlEventTouchUpInside];
    
    if ([[feedInfos objectForKey:[allCategories objectAtIndex:section]] count]==0) {
        rButton.hidden=YES;
    }
    
    [footerView addSubview:rButton];
    
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"addIconSmall.png"] 
               forState:UIControlStateNormal];
    addButton.frame=CGRectMake(260, 7, 30, 30);
    addButton.center=CGPointMake(240, 22);
    addButton.tag=kAddButtonTag+section;
    [addButton addTarget:self 
                  action:@selector(addFeedPressed:) 
        forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addButton];
    
    UIButton *dustBinButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [dustBinButton setBackgroundImage:[UIImage imageNamed:@"dustBinIconSmall.png"] forState:UIControlStateNormal];
    dustBinButton.frame=CGRectMake(290, 7, 30, 30);
    dustBinButton.center=CGPointMake(160, 22);
    [footerView addSubview:dustBinButton];
    
    return  footerView;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *category=[allCategories objectAtIndex:tableIndex];
    AMFeedInfo *feedInfo=[[feedInfos objectForKey:category] objectAtIndex:indexPath.row];
    [AMFeedManager removeFeedInfo:feedInfo];
    
    self.feedInfos=[AMFeedManager allFeedInfos];
    self.allCategories=[[AMFeedManager allFeedCategories] allValues];
    
    [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    if ([[feedInfos objectForKey:[allCategories objectAtIndex:tableIndex]] count]==0) {
        [self removeFeedPressed:removeButton];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}

-(IBAction) addFeedPressed:(UIButton *) addButton{
    selectedSection=tableIndex;
    AMFeedSearchViewController *vc=(AMFeedSearchViewController*)[self.zoomController.viewControllers objectAtIndex:0];
    vc.category=[allCategories objectAtIndex:selectedSection];
    [self.zoomController popToIndex:0];
}

-(IBAction) removeFeedPressed:(UIButton *) rButton{
    [table setEditing:!table.editing animated:YES];
    if(table.editing){
        [rButton setTitle:@"✓" forState:UIControlStateNormal];
        [rButton setImage:[UIImage imageNamed:@"checkMarkIconSmall.png"] forState:UIControlStateNormal];
    }else{
        [rButton setTitle:@"－" forState:UIControlStateNormal];
        [rButton setImage:nil forState:UIControlStateNormal];
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

-(IBAction) editPressed:(id)sender{
    editMode=!editMode;
    [table setEditing:editMode animated:YES];
    return;
    editMode=!editMode;
    NSRange indexRange;
    indexRange.location=0;
    indexRange.length=[allCategories count];;
    NSIndexSet *indexSet=[NSIndexSet indexSetWithIndexesInRange:indexRange];
    [table reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

-(IBAction) upPressed{
    if (tableIndex==0) {
        return;
    }
    self.tableIndex--;
    [self processTableChange];
}

-(IBAction) downPressed{
    if (tableIndex==[allCategories count]-1) {
        return;
    }
    self.tableIndex++;
    [self processTableChange];
}

-(void) processTableChange{
    /*NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:0];
    [table reloadSections:indexSet withRowAnimation:tableTransition==kTableTransitionNegative? UITableViewRowAnimationBottom:UITableViewRowAnimationTop];
    UIView *headerView=[headerViews objectForKey:[NSNumber numberWithInt:0]];
    if (headerView) {
        UILabel *headerLabel=(UILabel*)[headerView viewWithTag:kHeaderTextTag];
        headerLabel.text=[allCategories objectAtIndex:tableIndex];
    }
    return;*/
    float animationDuration=tableTransition==kTableTransitionNegative ? 0.3 : 0.2;
    [UIView beginAnimations:@"Table move" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(tableAnimationStopped)];
    table.frame=tableTransition==kTableTransitionNegative ? bottomFrame : topFrame;
    [UIView commitAnimations];
}

-(void) tableAnimationStopped{
    //NSIndexSet *indexSet=[NSIndexSet indexSetWithIndex:0];
    [table reloadData];
    float animationDuration=tableTransition==kTableTransitionNegative ? 0.2 : 0.3;
    table.frame=tableTransition==kTableTransitionNegative ? topFrame :bottomFrame;
    [UIView beginAnimations:@"Table move" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationDelegate:nil];
    table.frame=CGRectMake(0, 88, 320, 328);
    [self setButtonTexts];
    [UIView commitAnimations];
}

-(void) dealloc{
    [feedInfos release];
    [delegate release];
    [super dealloc];
}




@end
