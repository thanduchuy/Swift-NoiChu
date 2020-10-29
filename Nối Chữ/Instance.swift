//
//  Instance.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 8/28/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import UIKit
import AVFoundation
class Instance : NSObject {
    static let it = Instance()
    var temp = UIViewController()
    let transiton = SlideInTransition()
    var audioPlayer: AVAudioPlayer?
    var cmtMusic : Bool = false
    func playMusic() {
        let pathToSound = Bundle.main.path(forResource: "theme", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            cmtMusic.toggle()
            audioPlayer?.play()
        } catch {
            
        }
    }
    func stopMusic() {
        audioPlayer?.stop()
        cmtMusic.toggle()
    }
    func addBtnMenu(view: UIViewController,size: CGFloat) {
        let button = UIButton(type: .custom)
        //set image for button
        temp = view
        button.setImage(UIImage(named: "menu"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(mennuButtonPressed), for: .touchUpInside)
        //set frame
        view.navigationItem.setHidesBackButton(true, animated: true)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: size, height: size)
        button.widthAnchor.constraint(equalToConstant: size).isActive = true
        button.heightAnchor.constraint(equalToConstant: size).isActive = true
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        view.navigationItem.leftBarButtonItem = barButton
    }
    @objc func mennuButtonPressed() {
        
        guard let menuView = temp.storyboard?.instantiateViewController(identifier: "menu") as? TableViewController else {
            return
        }
        menuView.didTapMenuType = { menuType in
            self.changeView(menuType: menuType)
        }
        menuView.modalPresentationStyle = .overCurrentContext
        menuView.transitioningDelegate = self
        temp.present(menuView,animated: true)
    }
    func changeView(menuType : MenuType) {
        switch menuType {
        case .help:
            guard let homeView = self.temp.storyboard?.instantiateViewController(withIdentifier: "HelpController") as? HelpController else { return }
            self.temp.navigationController?.pushViewController(homeView, animated: true)
            break
        case .about:
            guard let homeView = self.temp.storyboard?.instantiateViewController(withIdentifier: "about") as? AboutController else { return }
            self.temp.navigationController?.pushViewController(homeView, animated: true)
            break
        case .home:
            guard let homeView = self.temp.storyboard?.instantiateViewController(withIdentifier: "home") as? ViewController else { return }
            self.temp.navigationController?.pushViewController(homeView, animated: true)
            break
        case .rank:
            guard let homeView = self.temp.storyboard?.instantiateViewController(withIdentifier: "rank") as? RankController else { return }
            self.temp.navigationController?.pushViewController(homeView, animated: true)
            break
        }
    }
}
    extension Instance : UIViewControllerTransitioningDelegate {
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            transiton.isPresenting = true
            return transiton
        }
        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            transiton.isPresenting = false
            return transiton
        }
}
