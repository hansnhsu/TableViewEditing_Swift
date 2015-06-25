//
//  BNRViewController.m
//  TableViewEditing
//
//  Created by Hansen Hsu on 10/15/12.
//  Copyright (c) 2012 Hansen Hsu. All rights reserved.
//
//  This sample code provides three user interfaces to edit a tableView
//  Add and Edit buttons are available in both the navigation controller at top and a toolbar at the bottom
//  Additionally, when in Editing mode, a special row is inserted at the end labeled "Add Item" that is tappable to add an item

#import "BNRViewController.h"
#import "TableViewEditing-Swift.h"

@interface BNRViewController ()

@end

@implementation BNRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(addItem:)];
    self.navItem.rightBarButtonItem = self.editButtonItem;

    self.addToolbarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Item"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(addItem:)];

    self.flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    // self.editButtonItem is already being used by the navigation bar
    // so we can't reuse it for the toolbar, otherwise it will disappear from the nav bar
    // so we have to create our own

    self.editToolbarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(toggleEditingMode:)];
    [self.editToolbarButtonItem setWidth:50.0];

    NSArray *toolbarItems = @[self.addToolbarButtonItem, self.flexibleSpace, self.editToolbarButtonItem];
    [self.toolbar setItems:toolbarItems];

    [self setItems:[@[@"Item 1", @"Item 2", @"Item 3"] mutableCopy]];
    [self setEditing:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
