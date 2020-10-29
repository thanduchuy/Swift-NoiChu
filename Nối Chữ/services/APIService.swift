//
//  APIService.swift
//  Nối Chữ
//
//  Created by Huy Than Duc on 9/3/20.
//  Copyright © 2020 Huy Than Duc. All rights reserved.
//

import Foundation
import Alamofire

protocol DataDelegate {
    func changeArray(arr: String)
}
protocol CallData {
    func checkData(bool: String,arr:[String])
}
class APIService {
    static let api  = APIService()
    var dataDelegate : DataDelegate?
    var callDelegate : CallData?
    func feactchData() {
        AF.request("http://192.168.0.101:8081/featch").response { res in
            print(res.data)
            
            let data = String(data: res.data!, encoding: .utf8)
            self.dataDelegate?.changeArray(arr: data!)
            
        }
    }
    func addData(first:String,last: String) {
        let url = "http://192.168.0.101:8081/create"
        let param = ["firstChacracter":first,
                     "lastChacracter":last]
        if let jsonData = try? JSONEncoder().encode(param) {
            
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            AF.request(request).responseJSON {
                (response) in
            }
        }
    }
    func checkData(arr: [String]){
        let url = "http://172.16.34.154:8081/check"
        let param = ["firstChacracter":arr[0],
                     "lastChacracter":arr[1]]
        if let jsonData = try? JSONEncoder().encode(param) {
            
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            AF.request(request).responseJSON {
                (res) in
                let data = String(data: res.data!, encoding: .utf8)
                self.callDelegate?.checkData(bool: data!,arr: arr)
            }
        }
    }
    func findData(first: String) {
        let url = "http://172.16.34.154:8081/find"
        let param = ["firstChacracter":first]
        if let jsonData = try? JSONEncoder().encode(param) {
            
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            AF.request(request).responseJSON {
                (res) in
                let data = String(data: res.data!, encoding: .utf8)
                self.dataDelegate?.changeArray(arr: data!)
            }
        }
    }
}
