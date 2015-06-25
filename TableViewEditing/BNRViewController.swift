//
//  BNRViewController.swift
//  TableViewEditing
//
//  Created by Hansen Hsu on 6/24/15.
//  Copyright (c) 2015 Hansen Hsu. All rights reserved.
//
//  This sample code provides three user interfaces to edit a tableView
//  Add and Edit buttons are available in both the navigation controller at top and a toolbar at the bottom
//  Additionally, when in Editing mode, a special row is inserted at the end labeled "Add Item" that is tappable to add an item

import Foundation

extension BNRViewController : UITableViewDelegate {

}

public extension BNRViewController {

    override func viewDidLoad() -> () {
        super.viewDidLoad()

        self.navItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem:.Add,
            target:self,
            action:"addItem:")

        self.navItem.rightBarButtonItem = self.editButtonItem()

        self.addToolbarButtonItem = UIBarButtonItem.init(title:"Add Item",
            style:UIBarButtonItemStyle.Bordered,
            target:self,
            action:"addItem:")

        self.flexibleSpace = UIBarButtonItem.init(barButtonSystemItem:.FlexibleSpace,
            target:nil, action:nil)

        // self.editButtonItem is already being used by the navigation bar
        // so we can't reuse it for the toolbar, otherwise it will disappear from the nav bar
        // so we have to create our own

        self.editToolbarButtonItem = UIBarButtonItem.init(title:"Edit",
            style:UIBarButtonItemStyle.Bordered,
            target:self,
            action:"toggleEditingMode:")

        self.editToolbarButtonItem.width = 50.0

        self.toolbar.items = [self.addToolbarButtonItem, self.flexibleSpace, self.editToolbarButtonItem]
        self.items = ["Item 1", "Item 2", "Item 3"]
        self.setEditing(true, animated:false)
    }

    override func didReceiveMemoryWarning() -> () {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func setEditing(editing: Bool, animated: Bool) -> () {
        super.setEditing(editing, animated:animated)
        self.tableView.setEditing(editing, animated:animated)

        let ip : NSIndexPath = NSIndexPath(forRow:self.items.count, inSection:0)

        let animation : UITableViewRowAnimation = animated ? UITableViewRowAnimation.Left : UITableViewRowAnimation.None

        if editing {
            self.tableView.insertRowsAtIndexPaths([ip], withRowAnimation:animation)
            self.editToolbarButtonItem.title = "Done"
            self.editToolbarButtonItem.style = UIBarButtonItemStyle.Done
        } else {
            self.tableView.deleteRowsAtIndexPaths([ip], withRowAnimation:animation)
            self.editToolbarButtonItem.title = "Edit"
            self.editToolbarButtonItem.style = UIBarButtonItemStyle.Bordered
        }
    }

    func toggleEditingMode(AnyObject) -> () {
        if self.editing {
            self.setEditing(false, animated:true)
        } else {
            self.setEditing(true, animated:true)
        }
    }

    @IBAction func addItem(sender: AnyObject) -> () {
        let newItem = NSString(format:"Item %lu", self.items.count+1)
        self.items.addObject(newItem)

        let ip : NSIndexPath = NSIndexPath(forRow:self.items.count - 1, inSection:0)

        self.tableView.insertRowsAtIndexPaths([ip], withRowAnimation:.Automatic)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableView.editing {
            return self.items.count + 1
        } else {
            return self.items.count
        }

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        if let c = self.tableView.dequeueReusableCellWithIdentifier("UITableViewCell") as? UITableViewCell {
            cell = c
        } else {
            cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier:"UITableViewCell")
        }

        if indexPath.row == self.items.count {
            cell.textLabel?.text = "Add Item"  // Final item of tableView when in editing mode allows user to tap to Add Item
        } else {
            if let item = self.items[indexPath.row] as? String {
                cell.textLabel?.text = item
            } else {
                cell.textLabel?.text = "Item X"
            }
        }
        return cell
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row < self.items.count {
            return UITableViewCellEditingStyle.Delete
        } else {
            return UITableViewCellEditingStyle.Insert
        }
    }

    func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) -> () {

            if editingStyle == UITableViewCellEditingStyle.Delete {
                self.items.removeObjectAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:.Automatic)
            } else if editingStyle == UITableViewCellEditingStyle.Insert {
                self.addItem(self.tableView)
            }
    }

    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath,
        toIndexPath: NSIndexPath) -> () {
            self.moveItemAtIndex(fromIndexPath.row, toIndex:toIndexPath.row)
    }

    func moveItemAtIndex(from: Int, toIndex to: Int) -> () {
        if from == to {
            return
        } else {
            if let item : String = self.items[from] as? String {
                self.items.removeObjectAtIndex(from)
                self.items.insertObject(item, atIndex:to)
            }
        }
    }

    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> ObjCBool {
        if indexPath.row >= self.items.count {
            return false;
        } else {
            return true;
        }
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> ObjCBool {
        if indexPath.row > self.items.count {
            return false;
        } else {
            return true;
        }
    }

    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String {
        return "Remove"
    }

    func tableView(tableView: UITableView,
        targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath,
        toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
            if proposedDestinationIndexPath.row >= self.items.count {
                return sourceIndexPath
            } else {
                return proposedDestinationIndexPath
            }
    }
}
