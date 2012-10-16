//
//  BNRViewController.m
//  TableViewEditing
//
//  Created by Hansen Hsu on 10/15/12.
//  Copyright (c) 2012 Hansen Hsu. All rights reserved.
//

#import "BNRViewController.h"

@interface BNRViewController ()
{
    NSMutableArray *_items;
}
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UIBarButtonItem *addToolbarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *flexibleSpace;
@property (nonatomic, strong) UIBarButtonItem *editToolbarButtonItem;

@end

@implementation BNRViewController
@synthesize items=_items;

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

    [self setItems:[@[@"Item 1", @"Item 2", @"Item 3"] mutableCopy]];
    [self setEditing:YES animated:YES];

    NSArray *toolbarItems = @[self.addToolbarButtonItem, self.flexibleSpace, self.editToolbarButtonItem];
    [self.toolbar setItems:toolbarItems];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];

    NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.items count] inSection:0];

    if (editing) {
        [self.tableView insertRowsAtIndexPaths:@[ip]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.editToolbarButtonItem setTitle:@"Done"];
        [self.editToolbarButtonItem setStyle:UIBarButtonItemStyleDone];
    } else {
        [self.tableView deleteRowsAtIndexPaths:@[ip]
                              withRowAnimation:UITableViewRowAnimationFade];
        [self.editToolbarButtonItem setTitle:@"Edit"];
        [self.editToolbarButtonItem setStyle:UIBarButtonItemStyleBordered];
    }
}

- (void)toggleEditingMode:(id)sender
{
    if ([self isEditing]) {

        [self setEditing:NO animated:YES];
    } else {

        [self setEditing:YES animated:YES];
    }
}

- (IBAction)addItem:(id)sender
{
    [self.items addObject:[NSString stringWithFormat:@"Item %d", [self.items count]+1]];

    NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.items count]-1 inSection:0];

    [self.tableView insertRowsAtIndexPaths:@[ip]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.tableView isEditing]) {
        return [self.items count] + 1;
    } else {
        return [self.items count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }

    NSString *item = nil;
    if (indexPath.row == [self.items count]) {
        [[cell textLabel] setText:@"Add Item"];
    } else {
        item = [self.items objectAtIndex:indexPath.row];
        [[cell textLabel] setText:item];
    }

    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.items count]) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleInsert;
    }
}

- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:indexPath.row];

        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self addItem:self.tableView];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    [self moveItemAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    } else {
        NSString *item = [self.items objectAtIndex:from];

        [self.items removeObjectAtIndex:from];
        [self.items insertObject:item atIndex:to];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.items count]) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > [self.items count]) {
        return NO;
    } else {
        return YES;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView
        targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
                             toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.row >= [self.items count]) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

@end
