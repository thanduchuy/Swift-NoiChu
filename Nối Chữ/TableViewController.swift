//
//  TableViewController.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 8/28/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import UIKit
enum MenuType:Int {
    case home
    case rank
    case help
    case about
}
class TableViewController: UITableViewController {
    var didTapMenuType: ((MenuType) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
        dismiss(animated: true) { [weak self] in
            self?.didTapMenuType?(menuType)
        }
    }
}
