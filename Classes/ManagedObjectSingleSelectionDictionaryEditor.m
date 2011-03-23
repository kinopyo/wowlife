//
//  ManagedObjectSingleSelectionDictionaryEditor.m
//  WowLife
//
//  Created by 朴　起煥 on 11/03/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ManagedObjectSingleSelectionDictionaryEditor.h"

@implementation ManagedObjectSingleSelectionDictionaryEditor
@synthesize map;
@synthesize list;

-(IBAction)save {
    UITableViewCell *selectedCell = [self.tableView 
                                     cellForRowAtIndexPath:lastIndexPath];
    NSString *newValue = selectedCell.textLabel.text;
	NSLog(@"new value  %@", newValue);
    
    // Key is unique, so it can be retrived at index 0.
    NSString *keyInMap = [[map allKeysForObject:newValue] objectAtIndex:0];
    
    NSLog(@"key in map %@", keyInMap);
    [self.managedObject setValue:keyInMap forKey:self.keypath];

	[self validateAndPop];
}

- (void)viewDidLoad {
    list = [map allValues];
    [list retain];
}

- (void)viewWillAppear:(BOOL)animated 
{
    NSNumber *currentValue = [self.managedObject valueForKey:self.keypath];
    
    NSLog(@"current value %@", currentValue);
    
    NSString *value = [map objectForKey:currentValue];
    
    for (NSString *oneItem in list) {
        if ([oneItem isEqualToString:value]) {
            NSUInteger newIndex[] = {0, [list indexOfObject:oneItem]};
            
            NSLog(@"index of indexPath %u", [list indexOfObject:oneItem]);
            
            NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:
                                    newIndex length:2];
            [lastIndexPath release];
            lastIndexPath = newPath;
            break;
        }
    }
    
    [super viewWillAppear:animated];
}
- (void)dealloc {
    [map release];
    [lastIndexPath release];
    [list release];
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int newRow = [indexPath row];
    int oldRow = [lastIndexPath row];
    
    if (newRow != oldRow || newRow == 0) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: lastIndexPath]; 
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        [lastIndexPath release];
        lastIndexPath = indexPath;	
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *GenericManagedObjectListSelectorCell = @"GenericManagedObjectListSelectorCell";

    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:GenericManagedObjectListSelectorCell];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                       reuseIdentifier:GenericManagedObjectListSelectorCell] autorelease];
    }

    NSUInteger row = [indexPath row];
    NSUInteger oldRow = [lastIndexPath row];


    cell.textLabel.text = NSLocalizedString([list objectAtIndex:row], @"SingleSelectionDecionary");
    if (row == 0){
        NSLog(@"last index path row: %u", oldRow);
    }
    cell.accessoryType = (row == oldRow && lastIndexPath != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}
@end
