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
#import "ManagedObjectAttributeEditor.h"
//#import "RaceSingleSelectionListEditor.h"
#import "ManagedObjectSingleSelectionDictionaryEditor.h"
#import "Convertor.h"
@implementation AccountDetailViewController
@synthesize account;

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {	
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    
//    raceValueMap = [[NSDictionary alloc] initWithObjectsAndKeys:@"Human",@"1", @"Orc", @"2", @"Drawf", @"3", @"Night Elf", @"4",
//                    @"Undead", @"5", @"Tauren", @"6", @"Gnome", @"7", @"Troll", @"8", @"Dijing", @"9", @"Blood Elf", @"10", 
//                    @"Draeni", @"11", @"Worgen", @"22", nil];
    raceValueMap = [[NSDictionary alloc] initWithObjectsAndKeys:@"Human",[NSNumber numberWithInt:1], 
                    @"Orc", [NSNumber numberWithInt:2], @"Drawf", [NSNumber numberWithInt:3], @"Night Elf", [NSNumber numberWithInt:4],
                    @"Undead", [NSNumber numberWithInt:5], @"Tauren", [NSNumber numberWithInt:6], @"Gnome", [NSNumber numberWithInt:7],
                    @"Troll", [NSNumber numberWithInt:8], @"Goblin", [NSNumber numberWithInt:9], @"Blood Elf", [NSNumber numberWithInt:10], 
                    @"Draenei", [NSNumber numberWithInt:11], @"Worgen", [NSNumber numberWithInt:22], nil];
    
    classValueMap = [[NSDictionary alloc] initWithObjectsAndKeys:@"Warrior", [NSNumber numberWithInt:1], @"Paladin", [NSNumber numberWithInt:2],
                     @"Hunter", [NSNumber numberWithInt:3], @"Rogue", [NSNumber numberWithInt:4],
                     @"Priest", [NSNumber numberWithInt:5], @"Death Knight", [NSNumber numberWithInt:6], 
                     @"Shaman", [NSNumber numberWithInt:7], @"Mage", [NSNumber numberWithInt:8], @"Warlock", [NSNumber numberWithInt:9], 
                     @"Druid", [NSNumber numberWithInt:11], nil];
    
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
                      [NSArray arrayWithObjects:@"ManagedObjectSingleSelectionDictionaryEditor", 
                       @"ManagedObjectSingleSelectionDictionaryEditor",
                       @"ManagedObjectStringEditor", nil],
					  
                      // Sentinel
                      nil];
    rowArguments = [[NSArray alloc] initWithObjects:
                    
                    // Section 1
                    [NSArray arrayWithObject:[NSNull null]],
                    
                    // Section 2,
                    [NSArray arrayWithObjects:
					 // race lists  
                     [NSDictionary dictionaryWithObject:raceValueMap forKey:@"map"],
                     
					 // class
					 [NSDictionary dictionaryWithObject:classValueMap forKey:@"map"],
					 // level  
                     [NSNull null], 
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
    
    id<GenericValueDisplay> rowValue = [account valueForKey:rowKey];
	
	NSUInteger row = [indexPath row];
	NSUInteger section = [indexPath section];
    
    // TODO refactor needed.
	if (section == 1)
    {
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * value = [f numberFromString:[rowValue genericValueDisplay]];
        [f release];
        
        // race
        if (row == 0) {
            cell.detailTextLabel.text = [raceValueMap objectForKey:value];            
        // class    
        } else if (row == 1) {
            cell.detailTextLabel.text = [classValueMap objectForKey:value];            
        }

	}
    else 
    {
		cell.detailTextLabel.text = [rowValue genericValueDisplay];
	}
    
    
    cell.textLabel.text = rowLabel;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *controllerClassName = [rowControllers 
                                     nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    Class controllerClass = NSClassFromString(controllerClassName);
    ManagedObjectAttributeEditor *controller = 
    [controllerClass alloc];
    controller = [controller initWithStyle:UITableViewStyleGrouped];
    controller.keypath = rowKey;
    controller.managedObject = account;
    controller.labelString = rowLabel;
    controller.title = rowLabel;
	NSLog(@"account name %@", [account valueForKey:@"name"]);    
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
    [raceValueMap release];
    [super dealloc];
}


@end

