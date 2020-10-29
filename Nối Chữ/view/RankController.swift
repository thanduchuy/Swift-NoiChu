//
//  RankController.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 8/28/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import UIKit

class RankController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Instance.it.addBtnMenu(view: self, size: 50)
        contentView.dropShadow()
        let margins = view.layoutMarginsGuide
        contentView.topAnchor.constraint(equalTo: margins.topAnchor, constant: contentView.frame.height*3.5).isActive = true
        animation()
    }
    func animation() {
        UIImageView.animate(withDuration: 1.5, animations: {
            var frame = self.logoImage.frame
            frame.size.height = 200
            frame.size.width = 200
            self.logoImage.frame = frame
            self.logoImage.center = self.bottomView.center
        })
    }
}
extension UIView {
     func dropShadow(scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.5
      layer.shadowOffset = CGSize(width: -1, height: 1)
      layer.shadowRadius = 3
        layer.cornerRadius = 5
      layer.shadowPath = UIBezierPath(rect: bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
