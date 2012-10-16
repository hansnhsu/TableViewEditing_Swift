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
@end

@implementation BNRViewController
@synthesize items=_items;

//- (id)init
//{
//    return [self initWithStyle:UITableViewStylePlain];
//}
//
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        _items = [NSMutableArray array];
//    }
//
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [self.tableView addSubview:navBar];
//
//    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"TableView Editing"];
//    [navBar setItems:@[navItem]];
//    self.navItem = navItem;

    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];

    UIBarButtonItem *rightBarButtonItem = self.editButtonItem;

    self.navItem.leftBarButtonItem = leftBarButtonItem;
    self.navItem.rightBarButtonItem = rightBarButtonItem;

//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0
//                                                                     , self.tableView.frame.size.height - self.tableView.frame.origin.y - 22.0,
//                                                                     self.tableView.frame.size.width,
//                                                                     44.0)];
//    [toolbar setItems:@[leftBarButtonItem, self.editButtonItem]];
//    [self.tableView addSubview:toolbar];
//
//    [self.tableView setSectionFooterHeight:44.0];
//
//    [self.tableView setSectionHeaderHeight:44.0];

    [self setItems:[@[@"Item 1", @"Item 2", @"Item 3"] mutableCopy]];
    [self setEditing:YES animated:YES];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44.0)];
//        return headerView;
//    }
//    return nil;
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
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
    return [self.items count] + 1;
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
        [[cell textLabel] setText:@"Add item"];
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
