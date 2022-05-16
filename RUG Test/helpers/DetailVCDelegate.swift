//
//  TableViewCellDelegate.swift
//  RUG Test
//
//  Created by Kinney Kare on 5/16/22.
//

import Foundation


protocol DetailVCDelegate: AnyObject {
    func usernameDidChange(_ detailViewController: DetailViewController, to firstName: String, to lastName: String)
}
