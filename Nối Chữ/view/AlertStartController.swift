//
//  AlertStartController.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 9/21/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import Foundation
import UIKit
class AlertStartController : UIView,UITextFieldDelegate {
    
    static let instance = AlertStartController()
    var centerY : Bool = true
    @IBOutlet weak var imageView: UIView!
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var submitBtn: NSLayoutConstraint!
    @IBOutlet weak var wordField: UITextField!
    var reload : ReLoadTable?
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertStartView", owner: self, options: nil)
        setStyle()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        wordField.delegate = self
        self.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.parentView.addGestureRecognizer(gesture)
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        wordField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        wordField.resignFirstResponder()
        return true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setStyle() {
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        alertView.isHidden = true
        childView.blink(a: 0.0,i: 1.0,time:1.0)
    }
    func showAlert() {
        let keyWindow = UIApplication.shared.connectedScenes
            .lazy
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }
        keyWindow?.addSubview(parentView)
        APIService.api.callDelegate = self
    }
    
    @IBAction func onClickBtn(_ sender: Any) {
        var word = ""
        if let text = wordField.text {
            word = text.trimmingCharacters(in: .whitespacesAndNewlines)
            word = word.lowercased()
            let arr = word.components(separatedBy: " ")
            if arr.count != 2 {
                alertView.isHidden = false
                alertView.shake()
            } else {
                alertView.isHidden = true
                APIService.api.checkData(arr: arr)
            }
        }
    }
    @objc func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.centerY {
                self.childView.frame.origin.y -= keyboardSize.height / 2.5
            }
        }
        centerY = false
    }
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !self.centerY  {
                self.childView.frame.origin.y += keyboardSize.height / 2.5
            }
        }
        centerY = true
    }
}
extension AlertStartController : CallData {
    func checkData(bool: String, arr: [String]) {
        do {
            let words = try JSONDecoder().decode(Bool.self, from: bool.data(using: .utf8)!)
            if words {
                alertView.isHidden = true
                wordField.text = ""
                reload?.addData(word: Word(_id: "1", firstChacracter: arr[0], lastChacracter: arr[1]))
                parentView.removeFromSuperview()
            } else {
                alertView.isHidden = false
                alertView.shake()
            }
        } catch {
            print("Fail to Decode")
        }
    }
    
    
}
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    func blink(a:CGFloat,i:CGFloat,time:Double) {
        self.alpha = a
        UIView.animate(withDuration: time, animations: {self.alpha = i}, completion: nil)
    }
}
