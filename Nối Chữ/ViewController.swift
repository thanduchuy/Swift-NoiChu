//
//  ViewController.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 8/28/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var musicButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var keyView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Instance.it.addBtnMenu(view: self,size: 50)
        assignbackground()
        styleView()
        Instance.it.playMusic()
    }
    func styleView() {
        logo.layer.masksToBounds = true
        logo.layer.cornerRadius = 100
        musicButton.backgroundColor = UIColor(named: "bgBtn")
        musicButton.layer.borderWidth = 5
        musicButton.layer.borderColor = UIColor(named: "bdBtn")?.cgColor
        musicButton.clipsToBounds = true
        musicButton.layer.cornerRadius = musicButton.bounds.size.height/2
        keyView.layer.cornerRadius = keyView.bounds.size.height/2
        keyView.layer.masksToBounds = true
        keyView.dropShadow(color: UIColor(named: "bdBtn")!, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: keyView.bounds.size.height/2, scale: true)
        playButton.backgroundColor = UIColor(named: "bdBtn")
        playButton.layer.cornerRadius = 5
    }
    @IBAction func clickMusicButton(_ sender: Any) {
        musicButton.alpha = 0.0
        if Instance.it.cmtMusic {
            Instance.it.stopMusic()
            UIButton.animate(withDuration: 1.0) {
                self.musicButton.alpha = 1.0
                self.musicButton.setImage(UIImage(named: "nomusic"), for: .normal)
            }
        } else {
            Instance.it.playMusic()
            UIButton.animate(withDuration: 1.0) {
                self.musicButton.alpha = 1.0
                self.musicButton.setImage(UIImage(named: "music"), for: .normal)
            }
        }
    }
    func assignbackground(){
         let background = UIImage(named: "post")

         var imageView : UIImageView!
         imageView = UIImageView(frame: view.bounds)
    imageView.contentMode =  UIView.ContentMode.scaleAspectFill
         imageView.clipsToBounds = true
         imageView.image = background
         imageView.center = view.center
         view.addSubview(imageView)
         self.view.sendSubviewToBack(imageView)
     }
}

extension UIView {
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
       layer.masksToBounds = false
       layer.shadowColor = color.cgColor
       layer.shadowOpacity = opacity
       layer.shadowOffset = offSet
       layer.shadowRadius = radius

       layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
       layer.shouldRasterize = true
       layer.rasterizationScale = scale ? UIScreen.main.scale : 1
     }
}
