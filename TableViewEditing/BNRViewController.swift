//
//  BNRViewController.swift
//  TableViewEditing
//
//  Created by Hansen Hsu on 6/24/15.
//  Copyright (c) 2015 Hansen Hsu. All rights reserved.
//

import Foundation

extension BNRViewController : UITableViewDelegate {

}

public extension BNRViewController {

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
