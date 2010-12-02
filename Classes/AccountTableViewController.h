//
//  AccountTableViewController.h
//  WowLife
//
//  Created by Wowzolo on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddAccountViewController;
@class AccountDetailViewController;

@interface AccountTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIAlertViewDelegate>{
//	IBOutlet UITableView *accountTableView;
	NSMutableArray *accountArray;
	AddAccountViewController *addAccountViewController;
	AccountDetailViewController *accountDetailViewController;
@private	
	NSFetchedResultsController *_fetchedResultsController;
//	NSManagedObjectContext *managedObjectContext;

}

@property (retain, nonatomic) NSMutableArray *accountArray;
@property (retain, nonatomic) AddAccountViewController *addAccountViewController;
@property (retain, nonatomic) AccountDetailViewController *accountDetailViewController;

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
//@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(IBAction)addAccount;
-(IBAction)toggleEdit;
@end
