//
//  RaceSingleSelectionListEditor.m
//  WowLife
//
//  Created by Wowzolo on 10-12-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RaceSingleSelectionListEditor.h"
#import "Convertor.h"

@implementation RaceSingleSelectionListEditor

-(IBAction)save {
    UITableViewCell *selectedCell = [self.tableView 
                                     cellForRowAtIndexPath:lastIndexPath];
    NSString *raceText = selectedCell.textLabel.text;
	NSNumber *raceValue = [Convertor raceValue:raceText];
	
	NSLog(@"Race is %@, value is %d", raceValue, raceValue);
	
    [self.managedObject setValue:raceValue forKey:self.keypath];
    NSError *error;
    if (![self.managedObject.managedObjectContext save:&error])
        NSLog(@"Error saving: %@", [error localizedDescription]);
    
    [self.navigationController popViewControllerAnimated:YES];
}

// TODO 这里和super冲突，要好好重构下。。
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
	
	
	[self save];
}

@end
