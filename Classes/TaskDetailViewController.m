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
        NSLog(@"%@", __FUNCTION__);
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
    
	rowControllers = [[NSArray alloc] initWithObjects:
					  
                      // Section 1
                      [NSArray arrayWithObjects:
                       @"ManagedObjectStringEditor",    // name
                       @"ManagedObjectStringEditor",                            // type
                       @"ManagedObjectStringEditor",                            // category
                       @"ManagedObjectStringEditor",                            // due_date
                       nil],
					  
                      // Sentinel
                      nil];
    
    rowArguments = [[NSArray alloc] initWithObjects:
                    
                    // Section 1
                    [NSArray arrayWithObjects:
                     [NSNull null],
                     [NSNull null],
                     [NSNull null],
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
    NSLog(@"%@", __FUNCTION__);
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        NSLog(@"%@", __FUNCTION__);
    // Return the number of sections.
    return [sectionNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        NSLog(@"%@", __FUNCTION__);
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
    NSLog(@"%@", __FUNCTION__);
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    id rowController = [rowControllers nestedObjectAtIndexPath:indexPath];
    
    // Configure the cell...
    id<GenericValueDisplay> rowValue = [task valueForKey:rowKey];
    
    cell.detailTextLabel.text = [rowValue genericValueDisplay];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
