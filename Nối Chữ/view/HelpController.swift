//
//  HelpController.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 8/28/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import UIKit

class HelpController: UIViewController {
    var list = [
        "Người chơi đầu tiên sẽ đưa ra một từ , thường 2 âm tiết trở lên",
        "Người thứ hai sẽ dùng chính âm tiết cuối đó để tạo thành từ mới có nghĩa",
        "Bây giờ người chơi đầu phải đối lại, dùng âm cuối của người thứ hai để tạo ra từ có nghĩa"
    ];
    @IBOutlet weak var tableHelp: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Instance.it.addBtnMenu(view: self, size: 50)
        tableHelp.delegate = self
        tableHelp.dataSource = self
        tableHelp.backgroundColor = UIColor(named: "help")
    }
    

    

}
extension HelpController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "HelpCell") as! HelpCell
        cell.setCell(index: indexPath.row+1, content: list[indexPath.row])
        cell.circleLabel()
        cell.setStyle()
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        cell.backgroundColor = UIColor.clear
        return cell
    }
}
