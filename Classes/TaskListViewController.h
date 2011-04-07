//
//  RootViewController.h
//  NavCoreData
//
//  Created by 朴　起煥 on 11/03/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define kAddNewTaskLabelText  @"Add New Task"
#define kEditButtonText @"Edit"

@class TaskDetailViewController;

@interface TaskListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
//	NSMutableArray *selectedTaskList;
//	NSArray *taskList;
//	NSManagedObject *managedObject;
}

@property (nonatomic, retain) NSArray *taskList;
@property (nonatomic, retain) NSManagedObject *managedObject; 
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

-(IBAction)addNewTask;
@end
