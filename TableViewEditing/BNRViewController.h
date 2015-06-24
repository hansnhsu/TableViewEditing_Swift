//
//  BNRViewController.h
//  TableViewEditing
//
//  Created by Hansen Hsu on 10/15/12.
//  Copyright (c) 2012 Hansen Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

// Need to declare publicly here to import into Swift -- wish there was a better way
@property (nonatomic, strong) NSMutableArray *items;


@end
