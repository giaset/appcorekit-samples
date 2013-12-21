//
//  GSCodeRougeLabViewController.m
//  CodeRougeLab
//
//  Created by Gianni Settino on 12-20-2013.
//  Copyright (c) 2013 WhereCloud Inc. All rights reserved.
//

#import "GSCodeRougeLabViewController.h"

@interface GSCodeRougeLabViewController ()
@property(nonatomic,retain) CKSampleTwitterTimelineModel* timeline;
@property(nonatomic,retain) CKSampleTwitterTweetModel* selectedTweet;
@end

@implementation GSCodeRougeLabViewController


- (id)initWithTimeline:(CKSampleTwitterTimelineModel*)theTimeline{
    self = [super init];
    self.timeline = theTimeline;
    self.selectedTweet = nil;
    [self setup];
    return self;
}

- (void)setup{
    self.title = _(@"kTimelineTitle");
    
    __unsafe_unretained GSCodeRougeLabViewController* bself = self;
    
    //Setup the factory allowing to create cell controller when tweet models gets inserted into self.timeline.tweets collection asynchronously
    CKCollectionCellControllerFactory* tweetsFactory = [CKCollectionCellControllerFactory factory];
    [tweetsFactory addItemForObjectOfClass:[CKSampleTwitterTweetModel class] withControllerCreationBlock:^CKCollectionCellController *(id object, NSIndexPath *indexPath) {
        CKSampleTwitterTweetModel* tweet = (CKSampleTwitterTweetModel*)object;
        return [bself cellControllerForTweet:tweet];
    }];
    
    //Setup the section binded to the self.timeline.tweets collection
    CKFormBindedCollectionSection* section = [CKFormBindedCollectionSection sectionWithCollection:self.timeline.tweets factory:tweetsFactory appendSpinnerAsFooterCell:YES];
    [self addSections:@[section]];
}


- (CKTableViewCellController*)cellControllerForTweet:(CKSampleTwitterTweetModel*)tweet{
    __unsafe_unretained GSCodeRougeLabViewController *bself = self;
    
    //Create block that will be executed when cell is clicked
    void (^clickBlock)(CKTableViewCellController*) = ^(CKTableViewCellController *controller){
        CKSampleTwitterTweetModel *thisTweet = (CKSampleTwitterTweetModel *) controller.value;
        bself.selectedTweet = (bself.selectedTweet == thisTweet) ? nil : thisTweet;
    };
    
    //Setup the cell controller to display a tweet model
    CKTableViewCellController* cellController =  [CKTableViewCellController cellControllerWithTitle:tweet.name
                                                                                           subtitle:tweet.message
                                                                                       defaultImage:[UIImage imageNamed:@"default_avatar"]
                                                                                           imageURL:tweet.imageUrl
                                                                                          imageSize:CGSizeMake(44,44)
                                                                                             action:clickBlock];
    cellController.value = tweet;
    
    //Customize the layout to keep the cell imageview on top with insets
    [cellController setLayoutBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {
        [controller performLayout];
        cell.imageView.frame = CGRectMake(controller.contentInsets.left,controller.contentInsets.top,44,44);
    }];
    
    //Setup block
    [cellController setSetupBlock:^(CKTableViewCellController *controller, UITableViewCell *cell) {        
        CKSampleTwitterTweetModel *thisTweet = (CKSampleTwitterTweetModel *) controller.value;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell beginBindingsContextByRemovingPreviousBindings];
        
        [bself bind:@"selectedTweet" executeBlockImmediatly:YES withBlock:^(id value) {
            [UIView animateWithDuration:0.5f animations:^{
                cell.backgroundColor = (bself.selectedTweet == thisTweet) ? [UIColor colorWithRGBValue:0x333333] : [UIColor whiteColor];
                cell.textLabel.textColor = (bself.selectedTweet == thisTweet) ? [UIColor whiteColor] : [UIColor blackColor];
                cell.detailTextLabel.textColor = (bself.selectedTweet == thisTweet) ? [UIColor whiteColor] : [UIColor blackColor];
                //toolbar.hidden = !(bself.selectedTweet == thisTweet);
            }];
        }];
        
        [cell endBindingsContext];
    }];
    
    return cellController;
}

- (void)addToolbarToCellController:(CKTableViewCellController *)cellController
{
    //Get the tweet and create a toolbar for it
    CKSampleTwitterTweetModel *tweet = (CKSampleTwitterTweetModel *)cellController.value;
    UIToolbar *toolbar = [self customToolbarForTweet:tweet];
    
    //Get current section
    CKFormTableViewController *currentForm = (CKFormTableViewController *)cellController.containerController;
    CKFormSection *section = (CKFormSection *)[currentForm sectionAtIndex:cellController.indexPath.section];
    
    //Create a dummy cellController that has the toolbar as its view and add it to the section right under the selected cell
    
}

- (UIToolbar *)customToolbarForTweet:(CKSampleTwitterTweetModel*)tweet{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.tintColor = [UIColor whiteColor];
    toolbar.barTintColor = [UIColor redColor];
    
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc]initWithTitle:_(@"Previous") style:UIBarButtonItemStyleBordered block:^{
    }];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]initWithTitle:_(@"Next") style:UIBarButtonItemStyleBordered block:^{
    }];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone block:^{
    }];
    
    NSArray *itemsArray = [NSArray arrayWithObjects:previousButton, nextButton, flexButton, doneButton, nil];
    
    [toolbar setItems:itemsArray];
    
    return toolbar;
}

@end
