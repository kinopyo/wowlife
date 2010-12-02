//
//  AccountTableViewController.h
//  WowLife
//
//  Created by Wowzolo on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccountDetailViewController;

@interface AccountTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIAlertViewDelegate>{
	NSMutableArray *accountArray;
	AccountDetailViewController *accountDetailViewController;
@private	
	NSFetchedResultsController *_fetchedResultsController;
    NSUInteger                  sectionInsertCount;	
}

@property (retain, nonatomic) NSMutableArray *accountArray;
@property (retain, nonatomic) IBOutlet AccountDetailViewController *accountDetailViewController;

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

-(IBAction)addAccount;
-(IBAction)toggleEdit;
@end
