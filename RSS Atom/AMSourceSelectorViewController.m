//
//  FeedSelectorViewController.m
//  RSS Atom
//
//  Created by Shashank Patel on 9/22/11.
//  Copyright 2011 Not Applicable. All rights reserved.
//

#import "AMSourceSelectorViewController.h"
#import "General.h"
#import "AMImageView.h"
#import "AMFeedListViewController.h"
#import "AMFeedManager.h"
#import "NSString+HTML.h"
#import "AMFeedSearchViewController.h"
#import "AMCatTile.h"

@implementation AMSourceSelectorViewController

@synthesize delegate;
@synthesize feedInfos;
@synthesize allCategories;
@synthesize tableIndex;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    catMode=kCatModeNormal;
    catOverlay.alpha=0;
    addFeedCatView.center=CGPointMake(160, -69);
    addFeedCatView.alpha=0;
    headerViews=[[NSMutableDictionary alloc] init];
    NSLog(@"View did load");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"tableIndex"]!=nil) {
        NSNumber *lastTableIndex=[defaults objectForKey:@"tableIndex"];
        self.tableIndex=[lastTableIndex intValue];
    }else{
        self.tableIndex=0;
    }
    titleLabel.font=[General regularLabelFont];
    bottomFrame=CGRectMake(0, 416, 320, 328);
    topFrame=CGRectMake(0, 44, 320, 328);
    manageButton.hidden=YES;
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:tableIndex] forKey:@"tableIndex"];
    [defaults synchronize];
    
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
    self.allCategories=[[[AMFeedManager allFeedCategories] allValues] sortedArrayUsingSelector:@selector(compare:)];
    [self regenerateGrid];
    int countUpperBound=[allCategories count]-1;
    if (tableIndex>countUpperBound){
        [self gridPressed:nil];
    }
    [table reloadData];
    [super viewWillAppear:animated];
}

-(IBAction) delCatPressed:(id)sender{
    [UIView beginAnimations:@"Show delete" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.2];
    if (catMode==kCatModeNormal) {
        for (AMCatTile *tile in gridTiles) {
            if (tile.index==kAddButtonTag)continue;
            [tile showDelete];
        }
        [deleteButton setImage:[UIImage imageNamed:@"checkMarkIconSmall.png"] forState:UIControlStateNormal];
        catMode=kCatModeDelete;
    }else{
        for (AMCatTile *tile in gridTiles) {
            if (tile.index==kAddButtonTag)continue;
            [tile hideDelete];
        }
        [deleteButton setImage:[UIImage imageNamed:@"dustBinIconSmall.png"] forState:UIControlStateNormal];
        catMode=kCatModeNormal;
    }
    [UIView commitAnimations];
}

-(void) deleteCatTile:(UIButton*) button{
    AMCatTile *_tile=(AMCatTile*)[button superview];
    NSString *feedCat=[allCategories objectAtIndex:_tile.index];
    [AMFeedManager removeFeedCat:feedCat];
    [_tile removeFromSuperview];
    [gridTiles removeObject:_tile];
    
    self.feedInfos=[AMFeedManager allFeedInfos];
    self.allCategories=[[[AMFeedManager allFeedCategories] allValues] sortedArrayUsingSelector:@selector(compare:)];
    
    [UIView beginAnimations:@"Delete tile" context:nil];
    [UIView setAnimationDuration:0.3];
    
    int totalRows=[gridTiles count] / 3;
    if (totalRows!=[gridTiles count] / 3.0) {
        totalRows++;
    }
    
    for (int i=0; i<[gridTiles count]; i++) {
        int row=i / 3;
        int column=i % 3;
        AMCatTile *tile=[gridTiles objectAtIndex:i];
        int index=[allCategories indexOfObject:tile.button.titleLabel.text];
        if (index!=NSNotFound) {
            NSLog(@"Index:%d",index);
            tile.index=index;
        }
        
        if (row==0) {
            if (column==0) {
                [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectTL.png"] forState:UIControlStateNormal];
            }else if(column==2){
                [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectTR.png"] forState:UIControlStateNormal];                
            }else{
                [tile.button setBackgroundImage:[UIImage imageNamed:@"rect.png"] forState:UIControlStateNormal];
            }
        }else if(row==totalRows-1){
            if (column==0) {
                [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectBL.png"] forState:UIControlStateNormal];
            }else if(column==2){
                [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectBR.png"] forState:UIControlStateNormal];                
            }else{
                [tile.button setBackgroundImage:[UIImage imageNamed:@"rect.png"] forState:UIControlStateNormal];
            }
        }
        
        tile.frame=CGRectMake(10+column*100, 54+row*100, 100, 100);
    }
    [UIView commitAnimations];
}

-(void) regenerateGrid{
    if (!gridTiles)gridTiles=[[NSMutableArray alloc] init];
    [gridTiles removeAllObjects];
    
    for (UIView * subView in [catOverlay subviews]) {
        if (subView.tag==-10000) {
            continue;
        }
        [subView removeFromSuperview];
    }
    
    for (NSString *category in allCategories) {
        AMCatTile *catTile=[AMCatTile catTile];
        catTile.index=[allCategories indexOfObject:category];
        [catTile.button setTitle:category forState:UIControlStateNormal];
        [gridTiles addObject:catTile];
        [catOverlay addSubview:catTile];
        [catTile.button addTarget:self action:@selector(tilePressed:) forControlEvents:UIControlEventTouchUpInside];
        [catTile.deleteButton addTarget:self action:@selector(deleteCatTile:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([allCategories count]<12) {
        AMCatTile *catTile=[AMCatTile catTile];
        catTile.index=kAddButtonTag;
        [catTile.button setTitle:@"✚" forState:UIControlStateNormal];
        [gridTiles addObject:catTile];
        [catOverlay addSubview:catTile];
        [catTile.button addTarget:self action:@selector(tilePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    int totalRows=[gridTiles count] / 3;
    if (totalRows!=[gridTiles count] / 3.0) {
        totalRows++;
    }
    
    for (int i=0; i<[gridTiles count]; i++) {
        int row=i / 3;
        int column=i % 3;
        AMCatTile *tile=[gridTiles objectAtIndex:i];
        if (row==0) {
            if (column==0) {
                [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectTL.png"] forState:UIControlStateNormal];
            }else if(column==2){
                [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectTR.png"] forState:UIControlStateNormal];                
            }
        }else if(row==totalRows-1){
            if (column==0) {
                [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectBL.png"] forState:UIControlStateNormal];
            }else if(column==2){
                [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectBR.png"] forState:UIControlStateNormal];                
            }
        }
        
        tile.frame=CGRectMake(10+column*100, 54+row*100, 100, 100);
        if (i!=tableIndex) {
            int transX,transY;
            
            transX=(tile.center.x-160)*10;
            transY=-(tile.center.y-(50.0*totalRows))*10;
            
            tile.transform=CGAffineTransformMakeTranslation(transX, transY);
        }
        tile.alpha=0;
    }
}

-(void) tilePressed:(UIButton*) sender{
    AMCatTile *tile=(AMCatTile*) [sender superview];
    if (tile.index==kAddButtonTag) {
        [self addFeedCatPressed];
        return;
    }else{
        if (tableIndex!=tile.index) {
            self.tableIndex=tile.index;
            //[table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [table reloadData];
        }
    }
    
    tile.transform=CGAffineTransformMakeScale(1, 1);
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(tileAnimationEnded)];
    tile.frame=CGRectMake(0, 44, 320, 44);
    [tile.button setBackgroundImage:nil forState:UIControlStateNormal];
    table.alpha=1;
    int totalRows=[gridTiles count] / 3;
    for (int i=0; i<[gridTiles count]; i++) {
        int row=i / 3;
        int column=i % 3;
        AMCatTile *tile=[gridTiles objectAtIndex:i];
        
        if (i!=tableIndex) {
            tile.frame=CGRectMake(10+column*100, 54+row*100, 100, 100);
            
            int transX,transY;
            
            transX=(tile.center.x-160)*10;
            transY=-(tile.center.y-(50.0*totalRows))*10;
            
            tile.transform=CGAffineTransformMakeTranslation(transX, transY);
            tile.alpha=0;
        }

    }
    
    [UIView commitAnimations];
}

-(void) tileAnimationEnded{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:nil];
    [UIView setAnimationDidStopSelector:nil];
    
    catOverlay.alpha=0.0;
    mainTitleBar.hidden=NO;
    table.alpha=1;
    
    [UIView commitAnimations];
}


-(IBAction) gridPressed:(id)sender{
    if (tableIndex<[allCategories count]){
        AMCatTile *tile=[gridTiles objectAtIndex:tableIndex];
        tile.transform=CGAffineTransformMakeScale(1, 1);
    }
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.4];
    catOverlay.alpha=1.0;
    int totalRows=[gridTiles count] / 3;
    if (totalRows!=[gridTiles count] / 3.0) {
        totalRows++;
    }
    for (int i=0; i<[gridTiles count]; i++) {
        AMCatTile *tile=[gridTiles objectAtIndex:i];
        if (i!=tableIndex) {
            tile.transform=CGAffineTransformMakeTranslation(0,0);
            //tile.transform=CGAffineTransformMakeScale(1, 1);
        }else{
            int row=i / 3;
            int column=i % 3;
            tile.frame=CGRectMake(10+column*100, 54+row*100, 100, 100);
            if (row==0) {
                if (column==0) {
                    [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectTL.png"] forState:UIControlStateNormal];
                }else if(column==2){
                    [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectTR.png"] forState:UIControlStateNormal];                
                }else{
                    [tile.button setBackgroundImage:[UIImage imageNamed:@"rect.png"] forState:UIControlStateNormal];
                }
            }else if(row==totalRows-1){
                if (column==0) {
                    [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectBL.png"] forState:UIControlStateNormal];
                }else if(column==2){
                    [tile.button setBackgroundImage:[UIImage imageNamed:@"roundRectBR.png"] forState:UIControlStateNormal];                
                }else{
                    [tile.button setBackgroundImage:[UIImage imageNamed:@"rect.png"] forState:UIControlStateNormal];
                }
            }
        }
        tile.alpha=1;
    }
    mainTitleBar.hidden=YES;
    table.alpha=0;
    [UIView commitAnimations];
}

-(void) addFeedCatPressed{
    [UIView beginAnimations:@"Show addCatView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    addFeedCatView.center=CGPointMake(160, 69);
    addFeedCatView.alpha=1;
    table.alpha=0;
    for (int i=0; i<[gridTiles count]; i++) {
        AMCatTile *tile=[gridTiles objectAtIndex:i];
        tile.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        tile.userInteractionEnabled=NO;
    }
    [UIView commitAnimations];
    [tfFeedCat becomeFirstResponder];
    
}

-(IBAction) cancelAddFeedCatPressed{
    [UIView beginAnimations:@"Show addCatView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    addFeedCatView.center=CGPointMake(160, -69);
    addFeedCatView.alpha=0;
    for (int i=0; i<[gridTiles count]; i++) {
        AMCatTile *tile=[gridTiles objectAtIndex:i];
        tile.backgroundColor=[UIColor clearColor];
        tile.userInteractionEnabled=YES;
    }
    [UIView commitAnimations];
    tfFeedCat.text=nil;
    [tfFeedCat resignFirstResponder];
}

-(IBAction) okAddFeedCatPressed{
    if ([tfFeedCat.text length]==0) {
        return;
    }
    [AMFeedManager addFeedCat:tfFeedCat.text];
    self.feedInfos=[AMFeedManager allFeedInfos];
    self.allCategories=[[[AMFeedManager allFeedCategories] allValues] sortedArrayUsingSelector:@selector(compare:)];
    [UIView beginAnimations:@"Show addCatView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    addFeedCatView.center=CGPointMake(160, -69);
    addFeedCatView.alpha=0;
    [self regenerateGrid];
    [self gridPressed:nil];
    [table reloadData];
    [UIView commitAnimations];
    [tfFeedCat resignFirstResponder];
    tfFeedCat.text=nil;
    //[self viewWillAppear:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int sectionCount=0;
    if (tableIndex<[allCategories count]) {
        sectionCount=1;
        return sectionCount;
    }
    return sectionCount;
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
        amiv.image=[UIImage imageNamed:@"favicon.png"];
        [amiv initAMImageView];
        amiv.shouldLoadSmallImage=YES;
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
UITapGestureRecognizer *singleDTap;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView=[headerViews objectForKey:[NSNumber numberWithInt:section]];
    if (headerView) {
        UILabel *headerLabel=(UILabel*)[headerView viewWithTag:kHeaderTextTag];
        headerLabel.text=[allCategories objectAtIndex:tableIndex];
        [headerLabel removeGestureRecognizer:singleDTap];
        [headerLabel addGestureRecognizer:singleDTap];
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
    singleDTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldDoubleTapped:)];
    singleDTap.numberOfTouchesRequired=1;
    singleDTap.numberOfTapsRequired=2;
    [label addGestureRecognizer:singleDTap];
    [headerView addSubview:label];
    
    [headerViews setObject:headerView forKey:[NSNumber numberWithInt:section]];
    
    return  headerView;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSString *category=[allCategories objectAtIndex:tableIndex];
    NSMutableArray *feedInfoArray=[feedInfos objectForKey:category];
    AMFeedInfo *sourceFeedInfo=[[feedInfoArray objectAtIndex:sourceIndexPath.row] retain];
    
    [feedInfoArray removeObject:sourceFeedInfo];
    [feedInfoArray insertObject:sourceFeedInfo atIndex:destinationIndexPath.row];
    [sourceFeedInfo release];
    
    for (AMFeedInfo *feedInfo in feedInfoArray) {
        int feedInfoIndex=[feedInfoArray indexOfObject:feedInfo];
        if (feedInfo.sortIndex!=feedInfoIndex) {
            [AMFeedManager modifySortIndex:feedInfoIndex forFeedID:feedInfo.feedID];
            feedInfo.sortIndex=feedInfoIndex;
        }
    }
    
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *category=[allCategories objectAtIndex:tableIndex];
    AMFeedInfo *feedInfo=[[feedInfos objectForKey:category] objectAtIndex:indexPath.row];
    [AMFeedManager removeFeedInfo:feedInfo];
    
    self.feedInfos=[AMFeedManager allFeedInfos];
    self.allCategories=[[[AMFeedManager allFeedCategories] allValues] sortedArrayUsingSelector:@selector(compare:)];
    
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
    if (textField==tfFeedCat) {
        return YES;
    }
    if(textField.tag==1000){
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==tfFeedCat) {
        [textField resignFirstResponder];
        return YES;
    }
    textField.tag=999;
    [AMFeedManager modifyCategoryNameFrom:[allCategories objectAtIndex:tableIndex] toName:textField.text];
    [self viewWillAppear:YES];
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

-(void) processTableChange{
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
    table.frame=CGRectMake(0, 44, 320, 416);
    [UIView commitAnimations];
}

-(void) dealloc{
    [feedInfos release];
    [delegate release];
    [super dealloc];
}




@end
