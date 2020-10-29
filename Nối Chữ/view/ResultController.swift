//
//  ResultController.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 9/27/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import Foundation
import UIKit
class ResultController: UIView {
    
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnGoback: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    static let instance = ResultController()
    var status = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertResultView", owner: self, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAlert(fail: Bool,point: Int) {
        
        let keyWindow = UIApplication.shared.connectedScenes
            
            .lazy
            
            .filter { $0.activationState == .foregroundActive }
            
            .compactMap { $0 as? UIWindowScene }
            
            .first?
            
            .windows
            
            .first { $0.isKeyWindow }
        
        keyWindow?.addSubview(parentView)
        setStyle(fail: fail, point: point)
    }
    func setStyle(fail: Bool,point: Int) {
        
        if fail {
            
            btnGoback.backgroundColor = hexStringToUIColor(hex: "903749")
            
            viewMain.layer.backgroundColor = hexStringToUIColor(hex: "e84545").cgColor
            
            image.image = UIImage(named:"game-over")
            
            titleLabel.text = "Bạn đã... Thua!"
            
            titleLabel.textColor = UIColor.white
            
            pointLabel.textColor = hexStringToUIColor(hex: "f67280")
            
        } else {
            
            btnGoback.backgroundColor = hexStringToUIColor(hex: "1fab89")
            
            viewMain.layer.backgroundColor = hexStringToUIColor(hex: "9df3c4").cgColor
            
            image.image = UIImage(named:"game-over")
            
            titleLabel.text = "Bạn đã... Chiến Thắng!"
            
            titleLabel.textColor = hexStringToUIColor(hex: "62d2a2")
            
            pointLabel.textColor = hexStringToUIColor(hex: "62d2a2")
            
        }
        pointLabel.text = "\(point) Điểm"
        viewMain.layer.cornerRadius = 10
        btnGoback.layer.cornerRadius = 25
    }
    @IBAction func goBackView(_ sender: Any) {
        GameController.instance.goBackView()
        parentView.removeFromSuperview()
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        
        
        if (cString.hasPrefix("#")) {
            
            cString.remove(at: cString.startIndex)
            
        }
        
        
        
        if ((cString.count) != 6) {
            
            return UIColor.gray
            
        }
        
        
        
        var rgbValue:UInt32 = 0
        
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        
        
        return UIColor(
            
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            
            alpha: CGFloat(1.0)
            
        )
    }
}
