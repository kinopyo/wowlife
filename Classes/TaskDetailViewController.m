//
//  TaskDetailViewController.m
//  WowLife
//
//  Created by Wowzolo on 11-4-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "NSArray-NestedArrays.h"
#import "GenericValueDisplay.h"
#import "ManagedObjectAttributeEditor.h"



@implementation TaskDetailViewController
@synthesize task;

- (void)dealloc
{
	[task release];
    [sectionNames release];
    [rowLabels release];
    [rowKeys release];
    [rowControllers release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  
  taskCategoryMap = [[NSDictionary alloc] initWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:kTaskCategoryList 
                                                     ofType:@"plist"]];
  taskTypeMap = [[NSDictionary alloc] initWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:kTaskTypeList 
                                                     ofType:@"plist"]];

    sectionNames = [[NSArray alloc] initWithObjects:
                    NSLocalizedString(@"Task", @"Task"),
                    nil];
    rowLabels = [[NSArray alloc] initWithObjects:
				 
                 // Section 1
                 [NSArray arrayWithObjects:NSLocalizedString(@"Name", @"Name"),
                  NSLocalizedString(@"Type", @"Type"),
                  NSLocalizedString(@"Category", @"Category"),
                  NSLocalizedString(@"Due Date", @"Due Date"),
                  nil],
                 
                 // Sentinel
                 nil];
	
    rowKeys = [[NSArray alloc] initWithObjects:
               
               // Section 1
               [NSArray arrayWithObjects:@"name",@"type", @"category", @"due_date", nil],
               
               // Sentinel
               nil];
  
  rowValueMaps = [[NSArray alloc] initWithObjects:
                  
                  // Section 1
                  [NSArray arrayWithObjects:
                   [NSNull null],
                   taskTypeMap,
                   taskCategoryMap,
                   [NSNull null],
                   nil],
                  // Section 3
                  [NSNull null],
                  
                  nil];
    
	rowControllers = [[NSArray alloc] initWithObjects:
					  
                      // Section 1
                      [NSArray arrayWithObjects:
                       @"ManagedObjectStringEditor",    // name
                       @"ManagedObjectSingleSelectionDictionaryEditor", // type
                       @"ManagedObjectSingleSelectionDictionaryEditor", // category
                       @"ManagedObjectStringEditor",                    // due_date
                       nil],
					  
                      // Sentinel
                      nil];
    
    rowArguments = [[NSArray alloc] initWithObjects:
                    
                    // Section 1
                    [NSArray arrayWithObjects:
                     [NSNull null],
                     [NSDictionary dictionaryWithObject:taskTypeMap
                                                 forKey:@"map"],
                     [NSDictionary dictionaryWithObject:taskCategoryMap
                                                 forKey:@"map"],
                     [NSNull null],
                     nil],
                    
                    // Sentinel
                    nil];
  
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self.tableView reloadData];
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

- (void)save
{
  
//  Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:[managedObject managedObjectContext]];
//  task.name = @"Daily Heroic";
//  task.category = @"PVE";
//  //	task.type = @"1";
//  
//  Account *account = (Account *)managedObject;
//  
//  [account addTasksObject:task];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [sectionNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [rowLabels countOfNestedArray:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  id theTitle = [sectionNames objectAtIndex:section];
  if ([theTitle isKindOfClass:[NSNull class]])
    return nil;
  
  return theTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
  }
    
  NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
  NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
  NSDictionary *rowValueMap = [rowValueMaps nestedObjectAtIndexPath:indexPath];
  id rowController = [rowControllers nestedObjectAtIndexPath:indexPath];
  
  // use rowController(String) to do specified action.
  if ([rowController isEqual:@"TaskListViewController"]) {
    
  } else {
    
    id<GenericValueDisplay> rowValue = [task valueForKey:rowKey];
    
    
    // if a ValueMap is assigned, then get value from that map.
    if ([rowValueMap isKindOfClass:[NSDictionary class]]) {
      if (rowValueMap != nil) {
        cell.detailTextLabel.text = [rowValueMap objectForKey:[rowValue genericValueDisplay]];
      }
    }    
    // if not, just show the plain text.
    else
    {
      cell.detailTextLabel.text = [rowValue genericValueDisplay];
    }
    
  }
  
  cell.textLabel.text = rowLabel;
  
  
  cell.accessoryType = (rowController == [NSNull null]) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
  
  
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//  NSUInteger section = [indexPath section];
  
  NSString *controllerClassName = [rowControllers 
                                   nestedObjectAtIndexPath:indexPath];
  NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
  NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
  Class controllerClass = NSClassFromString(controllerClassName);
  ManagedObjectAttributeEditor *controller = [controllerClass alloc];
  controller = [controller initWithStyle:UITableViewStyleGrouped];
  controller.keypath = rowKey;
  controller.managedObject = task;
  controller.labelString = rowLabel;
  controller.title = rowLabel;
  
  NSDictionary *args = [rowArguments nestedObjectAtIndexPath:indexPath];
  if ([args isKindOfClass:[NSDictionary class]]) {
    if (args != nil) {
      for (NSString *oneKey in args) {
        id oneArg = [args objectForKey:oneKey];
        [controller setValue:oneArg forKey:oneKey];
      }
    }
  }    
  
  [self.navigationController pushViewController:controller animated:YES];
  [controller release];
}

@end
