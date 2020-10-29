//
//  GameCell.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 9/23/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var viewLast: UIView!
    @IBOutlet weak var wordField: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var labelLast: UILabel!
    var isEdit = false
    var firstCharacter = ""
    var reload : ReLoadTable?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func reset() {
        firstLabel.text = ""
        labelLast.text = ""
        wordField.text = ""
        firstCharacter = ""
    }
    @IBAction func onSubmit(_ sender: Any) {
        if isEdit {
            var word = "\(firstCharacter) \(wordField.text!)"
            word = word.trimmingCharacters(in: .whitespacesAndNewlines)
            word = word.lowercased()
            let arr = word.components(separatedBy: " ")
            if arr.count == 2 {
                APIService.api.checkData(arr: arr)
            } else {
                viewError.isHidden = false
                viewError.shake()
            }
        }
    }
    func setStyle() {
        APIService.api.callDelegate = self
        viewFirst.layer.borderWidth = 3
        viewFirst.layer.borderColor = UIColor(named:"bd4")?.cgColor
        viewFirst.radiusCorners(corners: [.layerMinXMaxYCorner,.layerMinXMinYCorner], radius: 25)
        viewLast.layer.borderWidth = 3
        viewLast.layer.borderColor = UIColor(named:"bd4")?.cgColor
        viewLast.radiusCorners(corners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner], radius: 25)
        viewError.isHidden = true
    }
    func setValue(first:String,last:String) {
        firstCharacter = first
        firstLabel.text = firstCharacter
        isEdit = last == ""
        setStyle()
        if isEdit {
            wordField.isHidden = !isEdit
            labelLast.isHidden = isEdit
        } else {
            btnSubmit.setBackgroundImage(UIImage(named: "checked"), for: .normal)
            wordField.isHidden = !isEdit
            labelLast.text = last
            labelLast.isHidden = isEdit
        }
    }
}
extension GameCell : CallData {
    func checkData(bool: String, arr: [String]) {
        do {
            let words = try JSONDecoder().decode(Bool.self, from: bool.data(using: .utf8)!)
            if words && arr.count == 2 {
                reload?.pushData(word: Word(_id: "1", firstChacracter: arr[0], lastChacracter: arr[1]))
                reset()
                viewError.isHidden = true
            }
            else {
                viewError.isHidden = false
                viewError.shake()
            }
        } catch {
            print("Fail to Decode")
        }
    }
}
