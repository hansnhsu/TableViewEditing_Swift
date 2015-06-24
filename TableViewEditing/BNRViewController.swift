//
//  BNRViewController.swift
//  TableViewEditing
//
//  Created by Hansen Hsu on 6/24/15.
//  Copyright (c) 2015 Hansen Hsu. All rights reserved.
//

import Foundation

extension BNRViewController : UITableViewDelegate {

    public func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> ObjCBool {
        if indexPath.row >= self.items.count {
            return false;
        } else {
            return true;
        }
    }

    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> ObjCBool {
        if indexPath.row > self.items.count {
            return false;
        } else {
            return true;
        }
    }

    public func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String {
        return "Remove"
    }

    public func tableView(tableView: UITableView,
        targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath,
        toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
            if proposedDestinationIndexPath.row >= self.items.count {
                return sourceIndexPath
            } else {
                return proposedDestinationIndexPath
            }
    }
}
