//
//  AccountDetailViewController.h
//  WowLife
//
//  Created by Wowzolo on 10-12-3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@class Account;

@interface AccountDetailViewController : UITableViewController {
    Account *account;
	
@private   
    NSArray         *sectionNames;
    NSArray         *rowLabels;
    NSArray         *rowKeys;
    NSArray         *rowValueMaps;
    NSArray         *rowControllers;
    NSArray         *rowArguments;
    NSDictionary    *raceValueMap;
    NSDictionary    *classValueMap;
	NSDictionary    *sexValueMap;
}
@property (nonatomic, retain) Account *account;

@end
