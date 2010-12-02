//
//  AccountDetailViewController.h
//  WowLife
//
//  Created by Wowzolo on 10-12-3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AccountDetailViewController : UITableViewController {
    NSManagedObject *account;
	
@private   
    NSArray         *sectionNames;
    NSArray         *rowLabels;
    NSArray         *rowKeys;
    NSArray         *rowControllers;
    NSArray         *rowArguments;
}
@property (nonatomic, retain) NSManagedObject *account;

@end