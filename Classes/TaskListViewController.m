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

@interface TaskListViewController (Private)
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TaskListViewController

@synthesize selectedTaskList;
@synthesize managedObject;
@synthesize taskList;

- (void)dealloc
{
	[taskList release];
	[managedObject release];
	[selectedTaskList release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Set up the edit and add buttons.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:NSLocalizedString(@"Save", @"Save")
                                   style:UIBarButtonItemStyleDone
                                   target:self 
                                   action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
	
    [saveButton release];

	
	NSString *entityName = @"Task";
	NSManagedObjectContext *context = [managedObject managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	[fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
	
	NSError *error = nil;
	taskList = [context executeFetchRequest:fetchRequest error:&error];
	// TODO retianがないとダメー
	[taskList retain];
	
	selectedTaskList = [[NSMutableArray alloc] init];
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
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//	return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"task list count :%@", taskList);
	return [taskList count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	
//    return @"title";
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	NSUInteger row = [indexPath row];
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

	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
	if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
		// remove out of list
		if ([selectedTaskList containsObject:indexPath]) {
			[selectedTaskList removeObject:indexPath];
		}
//		for (NSIndexPath *addedIndexPath in [selectedTaskList reverseObjectEnumerator]) {
//			if (indexPath == addedIndexPath) {
//				[selectedTaskList removeObject:addedIndexPath];
//			}
//		}
		
		// remove checkmark
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else {
		// add to list
		[selectedTaskList addObject:indexPath];
		NSLog(@"added indexPath");
		// show checkmark
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}

	NSLog(@"%s", __FUNCTION__);

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
	NSUInteger row = [indexPath row];
	Task *task = [taskList objectAtIndex:row];

	cell.textLabel.text = task.name;
	
	
}

- (void)save
{

	Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:[managedObject managedObjectContext]];
	task.name = @"Daily Heroic";
	task.category = @"PVE";
//	task.type = @"1";

	Account *account = (Account *)managedObject;
	
	[account addTasksObject:task];
    
}

@end
