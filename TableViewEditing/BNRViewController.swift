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

    @IBAction func addItem(sender: AnyObject) -> () {
        let newItem = NSString(format:"Item %lu", self.items.count+1)
        self.items.addObject(newItem)

        let ip : NSIndexPath = NSIndexPath(forRow:self.items.count - 1, inSection:0)

        self.tableView.insertRowsAtIndexPaths([ip], withRowAnimation:.Automatic)
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
            } else {
                // Do nothing
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
