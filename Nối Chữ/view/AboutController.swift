//
//  AboutController.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 8/28/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import UIKit

class AboutController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var logo: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Instance.it.addBtnMenu(view: self, size: 50)
        // Do any additional setup after loading the view.
        let margins = view.layoutMarginsGuide
        logo.topAnchor.constraint(equalTo: margins.topAnchor, constant: -15).isActive = true
        logo.backgroundColor = UIColor.white
        logo.layer.cornerRadius = logo.bounds.height / 2
        logo.layer.masksToBounds = true
         contentView.clipsToBounds = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
