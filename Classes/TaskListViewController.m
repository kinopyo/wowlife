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
  UIBarButtonItem *editButton = [[UIBarButtonItem alloc] 
                                 initWithTitle:@"Edit" 
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(toggleEdit)];
  self.navigationItem.rightBarButtonItem = editButton;
  [editButton release];

  selectedTaskList = [[NSMutableArray alloc] init];
  
  Account *account = (Account *)managedObject;
  NSMutableSet *taskSet = [account valueForKey:@"tasks"];
  NSLog(@"account mutableSetValueForKey tasks: %@", taskSet);
  
}

-(IBAction)toggleEdit{
  [self.tableView setEditing:!self.tableView.editing animated:YES];
  
  // TODO refactor here
  // section count + 1 is the static one.
  NSUInteger staticPath[] = {[[self.fetchedResultsController sections] count], 0};
  NSIndexPath *staticIndexPath = [NSIndexPath indexPathWithIndexes:
                                  staticPath length:2];
  UITableViewCell *addTaskCell = [self.tableView cellForRowAtIndexPath:staticIndexPath];
  // show |addTaskCell| in editing mode, hide when not.
  addTaskCell.hidden = !self.tableView.editing;
  
  // edit mode
  if (self.tableView.editing)
  {
    [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    self.tableView.allowsSelectionDuringEditing = YES;
  }
  else
  {
    [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
  }

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
  // +1 for static section: add task
  return [[self.fetchedResultsController sections] count] +1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSUInteger sectionCount = [[self.fetchedResultsController sections] count];
  if (section < sectionCount) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
  } else {
    NSLog(@"section info is nil, section number is %u", section);
    return 1;
  }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  NSUInteger sectionCount = [[self.fetchedResultsController sections] count];
  // TODO section starts with 0.
  // refactor this if (section < sectionCount) 
  NSLog(@"section ________ %u", section);
  
  if (section < sectionCount) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    // |Task| doesn't conform to |NSFetchedResultsSectionInfo|,
    // so just get the 0 index that would be the |Task| object.
    Task *task = [sectionInfo.objects objectAtIndex:0];
    NSDictionary *taskTypeMap = [[NSDictionary alloc] initWithContentsOfFile:
                                 [[NSBundle mainBundle] pathForResource:kTaskTypeList 
                                                                 ofType:@"plist"]];
    
    return [taskTypeMap objectForKey:task.type];

  } else {
    return nil;
  }
  
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
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

- (void)tableView:(UITableView *)tableView 
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
  forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete)
  {
    // Delete the managed object for the given index path
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error])
    {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      // TODO
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }   
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  // TODO 綺麗に
  NSUInteger sectionCount = [[self.fetchedResultsController sections] count];
  NSUInteger section = [indexPath section];
  
  NSLog(@"sectionCount %u,  indexPath section %u", sectionCount, section);
  
  if (section < sectionCount) {
    return UITableViewCellEditingStyleDelete;
  } else {
    return UITableViewCellEditingStyleInsert;
  }

}

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
  // editing mode, tap to edit the |task|.
  if (self.tableView.editing){
    TaskDetailViewController* controller = [[[TaskDetailViewController alloc] 
                                             initWithStyle:UITableViewStyleGrouped] autorelease];
    controller.task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:controller animated:YES];
  }
  // if not editing mode, save selected task to account.
  else
  {
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

      // show checkmark
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
      [account addTasksObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
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

- (void)configureCell:(UITableViewCell *)cell 
          atIndexPath:(NSIndexPath *)indexPath
{
  // TODO 綺麗に
  NSUInteger sectionCount = [[self.fetchedResultsController sections] count];
  NSUInteger section = [indexPath section];
  
  NSLog(@"sectionCount %u,  indexPath section %u", sectionCount, section);

  if (section < sectionCount) {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = task.name;
    NSDictionary *taskCategoryMap = [[NSDictionary alloc] initWithContentsOfFile:
                                     [[NSBundle mainBundle] 
                                      pathForResource:kTaskCategoryList 
                                      ofType:@"plist"]];
    cell.detailTextLabel.text = [taskCategoryMap objectForKey:task.category];
    
    Account *account = (Account *)managedObject;
    NSSet *set = account.tasks;
    
    // editing mode, shows button to indicate that |task| can edit.
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([set containsObject:task]){
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
      cell.accessoryType = UITableViewCellAccessoryNone;    
    } 
  } else {
    cell.textLabel.text = @"Add New Task";
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // show when editing mode.
    cell.hidden = !self.tableView.editing;
    cell.detailTextLabel.text = nil;    
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
    [taskSet addObject:[self.fetchedResultsController 
                        objectAtIndexPath:indexPath]];
  }
  
  NSLog(@"task set: %@", taskSet);
  [self.navigationController popViewControllerAnimated:YES];

  [account addTasks:taskSet];
  NSError *error = NULL;
  if (![[account managedObjectContext] save:&error]) {
    NSLog(@"Error saving tasks to account: %@, for tasks: %@, error is: %@", 
          account.name, taskSet, [error localizedDescription]);
  }
    
}

- (IBAction)addNewTask 
{
  NSManagedObjectContext *context = [self.fetchedResultsController 
                                     managedObjectContext];
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
