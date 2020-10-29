//
//  HelpCell.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 8/29/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import UIKit

class HelpCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var indexLabel: UILabel!
    var index = 0;
    static var instance = HelpCell()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setCell(index: Int,content: String ) {
        contentLabel.text = content
        indexLabel.text = "\(index)"
    }
    func circleLabel() {
        indexLabel.backgroundColor = UIColor.white
        indexLabel.layer.masksToBounds = true
        indexLabel.layer.borderWidth = 2
        indexLabel.layer.borderColor = UIColor(named: "help")?.cgColor
        indexLabel.layer.cornerRadius = indexLabel.bounds.height / 2
        let margins = view.layoutMarginsGuide
        indexLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -20).isActive = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = CGRect(x: 20,y : 0, width: contentView.bounds.width - 40, height: contentView.bounds.height - 20 )
        contentView.backgroundColor = UIColor.white
        contentView.clipsToBounds = false
    }
    func setStyle() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 2
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.borderColor = UIColor.clear.cgColor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            
            // your colour or highlighted here
            indexLabel.textColor = UIColor(named: "select")
            indexLabel.layer.borderColor = UIColor(named: "select")?.cgColor
            contentLabel.textColor = UIColor(named: "select")
        } else {
            // your color or highlited here
            indexLabel.textColor = UIColor(named: "help")
            indexLabel.layer.borderColor = UIColor(named: "help")?.cgColor
            contentLabel.textColor = UIColor(named: "help")
        }
    }
    
}

