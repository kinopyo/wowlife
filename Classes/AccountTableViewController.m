//
//  AccountTableViewController.m
//  WowLife
//
//  Created by Wowzolo on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AccountTableViewController.h"
#import "AddAccountViewController.h"
#import "AccountDetailViewController.h"
#import "ClassCell.h"
#import "WowLifeAppDelegate.h"

@implementation AccountTableViewController
@synthesize accountArray;
@synthesize addAccountViewController;
@synthesize accountDetailViewController;
@synthesize fetchedResultsController = _fetchedResultsController;
//, managedObjectContext;

#pragma mark -
#pragma mark View lifecycle

-(IBAction)addAccount{
//	NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//	NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
//	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
//    
//    NSError *error;
//    if (![context save:&error])
//        NSLog(@"Error saving entity: %@", [error localizedDescription]);
//    
//    detailController.account = newManagedObject;
//    [self.navigationController pushViewController:detailController animated:YES];
	
	
	if (self.addAccountViewController == nil) {
		AddAccountViewController *childController = [[AddAccountViewController alloc] initWithNibName:@"AddAccountView" bundle:nil];
		self.addAccountViewController = childController;
		[childController release];
	}
	addAccountViewController.title = @"Add Account";
	[self.navigationController pushViewController:addAccountViewController animated:YES];
}

-(IBAction)toggleEdit{
	[self.tableView setEditing:!self.tableView.editing animated:YES];
    
    if (self.tableView.editing)
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    else
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
}

- (void)viewDidLoad {

/*	
	self.title = NSLocalizedString(@"Accounts", @"tooltip?");
	
	// TODO get from persistent
	if (accountArray == nil){
		//NSMutableArray *array = [[NSArray alloc] initWithObjects:@"ming", @"Unmercey", @"Feng7", nil];
		NSString *path = [[NSBundle mainBundle] pathForResource:@"computers" 
                                                         ofType:@"plist"];
        NSMutableArray *array = [[NSMutableArray alloc] 
                                 initWithContentsOfFile:path];
		
		self.accountArray = array;
		[array release];	
	}
*/	
	
	[super viewDidLoad];
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error loading data", @"Error loading data") 
                                                        message:[NSString stringWithFormat:@"Error was: %@, quitting.", [error localizedDescription]]
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Aw, Nuts", @"Aw, Nuts")
                                              otherButtonTitles:nil];
        [alert show];
		
	}
	

	
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
								  target:self
								  action:@selector(addAccount)];
    self.navigationItem.leftBarButtonItem = addButton;
    [addButton release];
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
								   initWithTitle:@"Edit"
								   style:UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(toggleEdit)];
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    NSUInteger count = [[self.fetchedResultsController sections] count];
    if (count == 0) {
        count = 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray *sections = [self.fetchedResultsController sections];
    NSUInteger count = 0;
    if ([sections count]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        count = [sectionInfo numberOfObjects];
    }
    return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ClassCellIdentifier = @"ClassCell";
    
    ClassCell *cell = (ClassCell *)[tableView dequeueReusableCellWithIdentifier:ClassCellIdentifier];
    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ClassCellIdentifier] autorelease];
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClassCell"
													 owner:self options:nil];
		for (id oneObject in nib)
			if ([oneObject isKindOfClass:[ClassCell class]])
				cell = (ClassCell *)oneObject;
		
    }
	
	NSManagedObject *oneAccount = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.name.text = [oneAccount valueForKey:@"name"];
	
	
    // Configure the cell...
//	cell.textLabel.text = [self.accountArray objectAtIndex:row];
//	cell.name.text = [self.accountArray objectAtIndex:row];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.classImageView.image = [UIImage imageNamed:@"class-rogue.png"];
	cell.raceImageView.image = [UIImage imageNamed:@"race_bloodelf_female.jpg"];
	cell.showsReorderControl = YES;
	
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



#pragma mark -
#pragma mark Table View Data Source Methods
// For delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
	forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    [self.accountArray removeObjectAtIndex:row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
					withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSInteger row = [indexPath row];
	if (self.accountDetailViewController == nil) {
		AccountDetailViewController *detailViewController = [[AccountDetailViewController alloc] initWithNibName:@"AccountDetailView" bundle:nil];
		self.accountDetailViewController = detailViewController;
		[detailViewController release];
	}
	accountDetailViewController.title = [NSString stringWithFormat:@"%@'s Progress", [accountArray objectAtIndex:row]];
	[self.navigationController pushViewController:accountDetailViewController animated:YES];
	
	
}

// For moving
/*
UITableViewCellEditingStyleNone,
UITableViewCellEditingStyleDelete,
UITableViewCellEditingStyleInsert
*/
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	NSUInteger fromRow = [fromIndexPath row];
    NSUInteger toRow = [toIndexPath row];
    
    id object = [[accountArray objectAtIndex:fromRow] retain];
    [accountArray removeObjectAtIndex:fromRow];
    [accountArray insertObject:object atIndex:toRow];
    [object release];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark -
#pragma mark Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // The typecast on the next line is not ordinarily necessary, however without it, we get a warning about
    // the returned object not conforming to UITabBarDelegate. The typecast quiets the warning so we get
    // a clean build.
    WowLifeAppDelegate *appDelegate = (WowLifeAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
	
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:managedObjectContext];
    
/*    
    NSUInteger tab = [tabBar.items indexOfObject:tabBar.selectedItem];
    if (tab == NSNotFound) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        tab = [defaults integerForKey:kSelectedTabDefaultsKey];
    }
    
    NSString *sectionKey = nil;
    switch (tab) {
            // Notice that the kByName and kBySecretIdentity Code are nearly identical - refactoring opportunity?
        case kByName: {
            NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"secretIdentity" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            [sortDescriptor1 release];
            [sortDescriptor2 release];
            [sortDescriptors release];
            sectionKey = @"name";
            break;
        }
        case kBySecretIdentity:{
            NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"secretIdentity" ascending:YES];
            NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, sortDescriptor2, nil];
            [fetchRequest setSortDescriptors:sortDescriptors];
            [sortDescriptor1 release];
            [sortDescriptor2 release];
            [sortDescriptors release];
            sectionKey = @"secretIdentity";
            break;
        }
        default:
            break;
            
    }
*/ 
	NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
   	[fetchRequest setEntity:entity];
	[fetchRequest setFetchBatchSize:20];
    
	
	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest    
                                                                          managedObjectContext:managedObjectContext 
                                                                            sectionNameKeyPath:nil 
                                                                                     cacheName:@"Account"];
    frc.delegate = self;
    _fetchedResultsController = frc;
    
	[fetchRequest release];
    
	return _fetchedResultsController;
}    

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    exit(-1); 
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
	self.accountArray = nil;
	self.addAccountViewController = nil;
	self.accountDetailViewController = nil;
}


- (void)dealloc {
	// release created property
	[accountArray release];
	[addAccountViewController release];
	[accountDetailViewController release];
    [super dealloc];
}


@end

