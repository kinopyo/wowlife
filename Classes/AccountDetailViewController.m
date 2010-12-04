//
//  AccountDetailViewController.m
//  WowLife
//
//  Created by Wowzolo on 10-12-3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "NSArray-NestedArrays.h"
#import "GenericValueDisplay.h"
@implementation AccountDetailViewController
@synthesize account;


#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {	
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    sectionNames = [[NSArray alloc] initWithObjects:
                    [NSNull null],
                    NSLocalizedString(@"General", @"General"),
                    nil];
    rowLabels = [[NSArray alloc] initWithObjects:
				 
                 // Section 1
                 [NSArray arrayWithObjects:NSLocalizedString(@"Name", @"Name"), nil],
				 
                 // Section 2
                 [NSArray arrayWithObjects:NSLocalizedString(@"Race", @"Race"),
                  NSLocalizedString(@"Class", @"Class"),
                  NSLocalizedString(@"Level", @"Level"),
                  nil],
                 				 
                 // Sentinel
                 nil];
	
    rowKeys = [[NSArray alloc] initWithObjects:
               
               // Section 1
               [NSArray arrayWithObjects:@"name", nil],
			   
               // Section 2
               [NSArray arrayWithObjects:@"race", @"klass", @"level", nil],
               
               // Sentinel
               nil];
    
	rowControllers = [[NSArray alloc] initWithObjects:
					  
                      // Section 1
                      [NSArray arrayWithObject:@"ManagedObjectStringEditor"],
					  
                      // Section 2
                      [NSArray arrayWithObjects:@"ManagedObjectStringEditor", 
                       @"ManagedObjectDateEditor",
                       @"ManagedObjectSingleSelectionListEditor", nil],
					  
                      // Sentinel
                      nil];
    rowArguments = [[NSArray alloc] initWithObjects:
                    
                    // Section 1
                    [NSArray arrayWithObject:[NSNull null]],
                    
                    // Section 2,
                    [NSArray arrayWithObjects:[NSNull null], 
                     [NSNull null], 
                     [NSDictionary dictionaryWithObject:[NSArray 
                                                         arrayWithObjects:@"Male", @"Female", nil] 
                                                 forKey:@"list"], 
                     nil],
                    
                    // Sentinel
                    nil];
    
    
	
    [super viewDidLoad];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [sectionNames count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id theTitle = [sectionNames objectAtIndex:section];
    if ([theTitle isKindOfClass:[NSNull class]])
        return nil;
	
    return theTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [rowLabels countOfNestedArray:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Account Detail Cell Identifier";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    
    id <GenericValueDisplay> rowValue = [account valueForKey:rowKey];
    
    cell.detailTextLabel.text = [rowValue genericValueDisplay];
    cell.textLabel.text = rowLabel;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[account release];
    [sectionNames release];
    [rowLabels release];
    [rowKeys release];
    [rowControllers release];
    [super dealloc];
}


@end

