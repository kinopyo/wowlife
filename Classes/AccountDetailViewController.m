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
#import "Account.h"
#import "TaskListViewController.h"


enum TabelSections {
	TableSectionName = 0,
	TableSectionGeneral,
	TableSectionTask,
};

@implementation AccountDetailViewController
@synthesize account;

#pragma mark -
#pragma mark View lifecycle
- (void)viewWillAppear:(BOOL)animated {	
  [self.tableView reloadData];
  [super viewWillAppear:animated];
}

- (void)viewDidLoad {

  classValueMap = [[NSDictionary alloc] initWithContentsOfFile:
                                 [[NSBundle mainBundle] pathForResource:@"classList" ofType:@"plist"]];
  
  raceValueMap = [[NSDictionary alloc] initWithContentsOfFile:
                                [[NSBundle mainBundle] pathForResource:@"raceList" ofType:@"plist"]];
  
  sexValueMap = [[NSDictionary alloc] initWithContentsOfFile:
                  [[NSBundle mainBundle] pathForResource:@"sexList" ofType:@"plist"]];  
  
  sectionNames = [[NSArray alloc] initWithObjects:
                  [NSNull null],
                  NSLocalizedString(@"General", @"General"),
                  NSLocalizedString(@"Tasks", @"Tasks"),
                  nil];
  rowLabels = [[NSArray alloc] initWithObjects:
               
               // Section 1
               [NSArray arrayWithObjects:NSLocalizedString(@"Name", @"Name"), nil],
               
               // Section 2
               [NSArray arrayWithObjects:NSLocalizedString(@"Race", @"Race"),
                NSLocalizedString(@"Class", @"Class"),
                NSLocalizedString(@"Sex", @"Sex"),
                NSLocalizedString(@"Level", @"Level"),
                nil],
               
               // section 3
               [NSArray arrayWithObjects:NSLocalizedString(@"Task List", @"Task List"), nil],
                               
               // Sentinel
               nil];
  
  // the actual column name of the table.
  rowKeys = [[NSArray alloc] initWithObjects:
             
             // Section 1
             [NSArray arrayWithObjects:@"name", nil],
             
             // Section 2
             [NSArray arrayWithObjects:@"race", @"klass", @"Sex", @"level", nil],
             
             // Section 3
             [NSNull null],
             
             // Sentinel
             nil];
  
  rowValueMaps = [[NSArray alloc] initWithObjects:
               
               // Section 1
               [NSNull null], 
               
               // Section 2
               [NSArray arrayWithObjects:raceValueMap, 
                                         classValueMap,
                                         sexValueMap,
                                         [NSNull null],
                                         nil],
               // Section 3
               [NSNull null],
               
               nil];
  
  rowControllers = [[NSArray alloc] initWithObjects:
                    
                    // Section 1
                    [NSArray arrayWithObject:@"ManagedObjectStringEditor"],
                    
                    // Section 2
                    [NSArray arrayWithObjects:
                     @"ManagedObjectSingleSelectionDictionaryEditor",     // race
                     @"ManagedObjectSingleSelectionDictionaryEditor",     // klass
                     @"ManagedObjectSingleSelectionDictionaryEditor",		// sex
                     @"ManagedObjectSingleSelectionListEditor",                        // level
                     nil],
                    
                    // Section 3
                    [NSArray arrayWithObject:@"TaskListViewController"],
                    
                    // Sentinel
                    nil];
  rowArguments = [[NSArray alloc] initWithObjects:
                  
                  // Section 1
                  [NSArray arrayWithObject:[NSNull null]],
                  
                  // Section 2,
                  [NSArray arrayWithObjects:
                   // race lists  
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    raceValueMap, kKeyForMap, 
                    [NSNumber numberWithBool:YES], kSaveImmediateFlag, 
                    nil],
                   
                   // class
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    classValueMap, kKeyForMap, 
                    [NSNumber numberWithBool:YES], kSaveImmediateFlag, 
                    nil],
                   
                   // sex
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    sexValueMap, kKeyForMap, 
                    [NSNumber numberWithBool:YES], kSaveImmediateFlag, 
                    nil],
                   
                   // level  
                   [NSNull null], 
                   nil],
                  
                  // Section 3,
                  [NSNull null],
                  
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

- (NSString *)tableView:(UITableView *)tableView 
titleForHeaderInSection:(NSInteger)section {
    id theTitle = [sectionNames objectAtIndex:section];
    if ([theTitle isKindOfClass:[NSNull class]])
        return nil;
	
    return theTitle;
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [rowLabels countOfNestedArray:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *accountCellIdentifier = @"Account Detail Cell Identifier";
  static NSString *taskCellIdentifier = @"Account Detail Cell Identifier";	
  
  NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
  NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
  NSDictionary *rowValueMap = [rowValueMaps nestedObjectAtIndexPath:indexPath];
  id rowController = [rowControllers nestedObjectAtIndexPath:indexPath];
  
  NSString *cellIdentifier = nil;
  UITableViewCellStyle cellStyle;
  if ([rowController isEqual:@"TaskListViewController"]) { 
      cellIdentifier = taskCellIdentifier;
      cellStyle = UITableViewCellStyleDefault;
  }
  else {
      cellIdentifier = accountCellIdentifier;
      cellStyle = UITableViewCellStyleValue2;
  }
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:cellStyle 
                                     reuseIdentifier:cellIdentifier] autorelease];
  }
  
  // use rowController(String) to do specified action.
  if ([rowController isEqual:@"TaskListViewController"]) {
    
  } else {
      
    id<GenericValueDisplay> rowValue = [account valueForKey:rowKey];
    
    
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger section = [indexPath section];
	
	NSString *controllerClassName = [rowControllers 
                                     nestedObjectAtIndexPath:indexPath];
    NSString *rowLabel = [rowLabels nestedObjectAtIndexPath:indexPath];
    NSString *rowKey = [rowKeys nestedObjectAtIndexPath:indexPath];
    Class controllerClass = NSClassFromString(controllerClassName);
    ManagedObjectAttributeEditor *controller = [controllerClass alloc];
    controller = [controller initWithStyle:UITableViewStyleGrouped];
	
	switch (section) {
		case TableSectionName:
		case TableSectionGeneral:
			NSLog(@"table section general: %u", TableSectionGeneral);
			controller.keypath = rowKey;
			controller.managedObject = account;
			controller.labelString = rowLabel;
			break;
		case TableSectionTask:
			controller.managedObject = account;
			break;

	  default:
		break;
	}


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
  self.account = nil;
}


- (void)dealloc {
  [account release];
  [super dealloc];
}


@end

