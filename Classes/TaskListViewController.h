//
//  RootViewController.h
//  NavCoreData
//
//  Created by 朴　起煥 on 11/03/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface TaskListViewController : UITableViewController {
	NSMutableArray *selectedTaskList;
	NSArray *taskList;
	NSManagedObject *managedObject;
}

@property (nonatomic, retain) NSMutableArray *selectedTaskList; 
@property (nonatomic, retain) NSArray *taskList;
@property (nonatomic, retain) NSManagedObject *managedObject; 

@end
