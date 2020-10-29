//
//  GameController.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 9/3/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import UIKit
protocol ReLoadTable {
    func addData(word: Word)
    func pushData(word: Word)
}
class GameController: UIViewController {
    @IBOutlet weak var viewScore: UIView!
    @IBOutlet weak var viewTurn: UIView!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelTurn: UILabel!
    @IBOutlet weak var gameTBView: UITableView!
    @IBOutlet weak var labelPoint: UILabel!
    static let instance = GameController()
    var words = [Word]()
    var temp = [Word]()
    var story = UIViewController()
    var point = 1
    var gameTimer : Timer? = nil {
        willSet {
            gameTimer?.invalidate()
        }
    }
    var time = 29
    var yourTurn = true
    var centerY : Bool = true
    var wordField = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        APIService.api.dataDelegate = self
        AlertStartController.instance.showAlert()
        AlertStartController.instance.reload = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        view.addGestureRecognizer(gesture)
        setStyle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        words.removeAll()
    }
    @objc func someAction(_ sender:UITapGestureRecognizer){
        view.endEditing(true)
    }
    func goBackView() {
        words.removeAll()
        stopTimerTest()
        AlertStartController.instance.showAlert()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gameTimer?.invalidate()
    }
    func checkResult() {
        if !self.yourTurn {
            ResultController.instance.showAlert(fail: true, point: point)
        }
    }
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            gameTBView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height+50, right: 0)
            
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            gameTBView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    func scrollBottomTable() {
        let scrollPoint = CGPoint(x: 0, y: self.gameTBView.contentSize.height - self.gameTBView.frame.size.height+50)
        self.gameTBView.setContentOffset(scrollPoint, animated: false)
    }
    func startTime() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ timer in
            self.labelTime.text = "\(self.time)"
            self.labelTime.textColor = self.time<11 ? UIColor.red : UIColor.black
            self.time -= 1
            if self.time < 0  {
                self.checkResult()
                self.labelTurn.text = self.yourTurn ? "Lượt của bạn" : "Lượt của đối thủ"
                self.time = 30
                self.yourTurn.toggle()
            }
        }
    }
    func stopTimerTest() {
        gameTimer = nil
    }
    func setStyle() {
        // style scoreView
        viewScore.addRightBorderWithColor(color: UIColor(named: "bdBtn")!, width: 3)
        viewScore.addBottomBorderWithColor(color: UIColor(named: "bdBtn")!, width: 3)
        viewScore.roundCorners([.allCorners], radius: 5)
        // style turnView
        viewTurn.layer.borderColor = UIColor(named: "bd4")?.cgColor
        viewTurn.layer.borderWidth = 3
        viewTurn.radiusCorners(corners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner], radius: 20)
        // style timeView
        viewTime.layer.borderColor = UIColor(named: "bd4")?.cgColor
        viewTime.layer.borderWidth = 5
        viewTime.layer.cornerRadius = viewTime.bounds.height/2
        // style tableView
        gameTBView.backgroundColor = UIColor.clear
        gameTBView.delegate = self
        gameTBView.dataSource = self
    }
    func changeTurn() {
        self.labelTurn.text = self.yourTurn ? "Lượt của bạn" : "Lượt của đối thủ"
        self.time = 30
        self.yourTurn.toggle()
    }
}

extension GameController: DataDelegate {
    func changeArray(arr: String) {
        do {
            temp = try JSONDecoder().decode([Word].self, from: arr.data(using: .utf8)!)
            if self.yourTurn && temp.count == 0 {
                ResultController.instance.showAlert(fail: false, point: point)
            } else {
                let random = Int.random(in: 0..<temp.endIndex)
                let time = Double.random(in: 5...10)
                let word = temp[random]
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    self.words.append(word)
                    self.words.append(Word(_id: "1", firstChacracter: word.lastChacracter, lastChacracter: ""))
                    self.changeTurn()
                    self.gameTBView.reloadData()
                    self.scrollBottomTable()
                }
            }
        } catch {
            print("Fail to Decode")
        }
    }
}
extension GameController : ReLoadTable {
    func pushData(word: Word) {
        words[words.count-1] = word
        point += 1
        labelPoint.text = "\(point)"
        APIService.api.findData(first: word.lastChacracter)
        self.changeTurn()
        gameTBView.reloadData()
        scrollBottomTable()
    }
    
    func addData(word: Word) {
        words = [Word]()
        time = 29
        yourTurn = true
        stopTimerTest()
        words.append(word)
        APIService.api.findData(first: word.lastChacracter)
        gameTBView.reloadData()
        startTime()
    }
    
}
extension GameController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameCell
        let word = words[indexPath.row]
        cell.setValue(first: word.firstChacracter,last: word.lastChacracter)
        cell.reload = self
        cell.backgroundColor = UIColor.clear
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let word = words[indexPath.row]
        if word.lastChacracter == "" {
            return 100
        } else {
            return 65
        }
    }
}
extension UIView {
    func radiusCorners(corners:CACornerMask, radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = corners
    }
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
