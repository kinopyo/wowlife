//
//  TaskListViewController.m
//  NavCoreData
//
//  Created by 朴　起煥 on 11/03/17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TaskListViewController.h"
#import "WowLifeAppDelegate.h"

#import "Account.h"
#import "Task.h"
#import "TaskDetailViewController.h"

@interface TaskListViewController (Private)
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TaskListViewController

@synthesize taskDetailViewController;
@synthesize selectedTaskList;
@synthesize managedObject;
@synthesize taskList;
@synthesize fetchedResultsController=__fetchedResultsController;


- (void)dealloc
{
	[taskList release];
	[managedObject release];
	[selectedTaskList release];
    [__fetchedResultsController release];
    [taskDetailViewController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set up the edit and add buttons.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:NSLocalizedString(@"addNewTask", @"addNewTask")
                                   style:UIBarButtonItemStyleDone
                                   target:self 
                                   action:@selector(addNewTask)];
    self.navigationItem.rightBarButtonItem = saveButton;
	
    [saveButton release];

	
//	NSString *entityName = @"Task";
//	NSManagedObjectContext *context = [managedObject managedObjectContext];
//	
//	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
//	[fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
//	
//	NSError *error = nil;
//	taskList = [context executeFetchRequest:fetchRequest error:&error];
//	// TODO retianがないとダメー
//	[taskList retain];
	
	selectedTaskList = [[NSMutableArray alloc] init];
  
  Account *account = (Account *)managedObject;
  NSMutableSet *taskSet = [account valueForKey:@"tasks"];
  NSLog(@"account mutableSetValueForKey tasks: %@", taskSet);
  
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  NSLog(@"%s", __FUNCTION__);
  Account *account = (Account *)managedObject;
  NSError *error = nil;
  if (![[account managedObjectContext] save:&error]) {
    NSLog(@"Error saving tasks to account: %@, error is: %@", account.name, [error localizedDescription]);
  }
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"section: %@", [self.fetchedResultsController sections]);
    
    NSLog(@"number of sections %u",[[self.fetchedResultsController sections] count]);
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	NSLog(@"task list count :%@", taskList);
//	return [taskList count];
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSLog(@"section info: %@", sectionInfo);
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	
	/**********************
	 The 'indexTitle' and 'name' depends on parameter 'sectionNameKeyPath' of this method.
	 - (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext: (NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name;
	 Currently I passed 'type' to sectionNameKeyPath, and the value in Task table is set to string 1,2,3,4...
	 If change string to "Daily", "Weekly", "Someday", the section number and numberOfRowsInSection would be mess up.
	 Don't know why.
	 
	 And the 'indexTitle' and 'name' seem to have the same value of taks.type.
	 
	 ************************/
	NSString *indexTitle = [sectionInfo indexTitle];
	
	// TODO refactor
	if ([indexTitle isEqualToString:@"1"]) {
		return @"Daily";
	} else if ([indexTitle isEqualToString:@"2"]){
		return @"Weekly";
	} else if ([indexTitle isEqualToString:@"3"]) {
		return @"Due Date";
	} else if ([indexTitle isEqualToString:@"4"]) {
		return @"Some day";
	} else {
		return @"Uncategorized";
	}
	
	NSLog(@"name %@, title%@",[sectionInfo name], [sectionInfo indexTitle]);
	
    return @"title";
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        // Delete the managed object for the given index path
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
//        
//        // Save the context.
//        NSError *error = nil;
//        if (![context save:&error])
//        {
//            /*
//             Replace this implementation with code to handle the error appropriately.
//             
//             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
//             */
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }   
//}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

  NSLog(@"%s", __FUNCTION__);
    Account *account = (Account *)managedObject;
  
  UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
  if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
      // remove out of list
      if ([selectedTaskList containsObject:indexPath]) {
          [selectedTaskList removeObject:indexPath];
      }
      
      // remove checkmark
      cell.accessoryType = UITableViewCellAccessoryNone;
[account removeTasksObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];

    
  } else {
      // add to list
      [selectedTaskList addObject:indexPath];
      NSLog(@"added indexPath");
      // show checkmark
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
[account addTasksObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
  }

  [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
//	NSUInteger row = [indexPath row];
//	Task *task = [taskList objectAtIndex:row];
//
//	cell.textLabel.text = task.name;
    
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = task.name;
  
  Account *account = (Account *)managedObject;
  NSSet *set = account.tasks;
  if ([set containsObject:task]){
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;    
  }
	
	
}

- (void)save
{
  Account *account = (Account *)managedObject;
//  NSMutableSet *taskSet = [account mutableSetValueForKey:@"tasks"];
//  NSLog(@"account mutableSetValueForKey tasks: %@", taskSet);
  NSMutableSet *taskSet = [[NSMutableSet alloc] init];

  for (NSIndexPath *indexPath in selectedTaskList) {
    //
    [taskSet addObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
  }
  
  NSLog(@"task set: %@", taskSet);
  [self.navigationController popViewControllerAnimated:YES];
  
//  Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:[managedObject managedObjectContext]];
//  task.name = @"Daily Heroic";
//  task.category = @"PVE";
////	task.type = @"1";


  

  [account addTasks:taskSet];
  NSError *error = NULL;
  if (![[account managedObjectContext] save:&error]) {
    NSLog(@"Error saving tasks to account: %@, for tasks: %@, error is: %@", account.name, taskSet, [error localizedDescription]);
  }
    
}

- (IBAction)addNewTask 
{
  NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
  NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
  NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
  
  [newManagedObject setValue:@"New Task" forKey:@"name"];
  
  NSError *error;
  if (![context save:&error])
    NSLog(@"Error saving entity: %@", [error localizedDescription]);

  TaskDetailViewController* controller = [[[TaskDetailViewController alloc] 
                                           initWithStyle:UITableViewStyleGrouped] autorelease];
  controller.task = newManagedObject;
  NSLog(@"task detail view: %@", [controller description]);
  [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil)
    {
        return __fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
     */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [managedObject managedObjectContext];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
//    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"category" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"type" cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error])
    {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

@end
