//
//  ViewController.swift
//  BusTimerJSON
//
//  Created by Leonard Choo on 2018/10/27.
//  Copyright © 2018 team-sfcbustimer. All rights reserved.
//
import UIKit

struct Direction: Decodable{
    let shosfc: [Day]?
    let sfcsho: [Day]?
}

struct Day: Decodable{
    let weekday: [Bus]?
    let sat: [Bus]?
    let sun: [Bus]?
}

struct Bus: Decodable{
    let h7: Int?
    let h8: Int?
    let h9: Int?
    let h10: Int?
    let h11: Int?
    let h12: Int?
    let h13: Int?
    let h14: Int?
    let h15: Int?
    ...
    let h23: Int?
    
    
}

struct MinType: Decodable{
    let m: Int?
    let type: String?
    ここもenumの形でやらないといけない
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let jsonUrlString = "https://api.myjson.com/bins/y7ito" // before 11/9
        let jsonUrlString = "https://api.myjson.com/bins/17bvz2"
        guard let url = URL(string: jsonUrlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            //         let dataAsString = String(data: data, encoding: .utf8)
            //            print(dataAsString)
            do {
                //  Swift 4
                let busTimer = try JSONDecoder().decode(Direction.self, from: data)
                
                print(busTimer)
                
                
                //below is the {h, m, type} version before 11/9
//                print(busTimer)
//                print(busTimer.shosfc)
//                print("Sho->SFC, Weekday: ", busTimer.shosfc?[0].weekday)
//                print("Sho->SFC, Saturday: ", busTimer.shosfc?[1].sat)
//                print(busTimer.shosfc?[1].sat?[0])
//                print((busTimer.shosfc?[1].sat?[0].h)!) // ! gets rid of the Optional. () to wrap.
//                let busMin = (busTimer.shosfc?[1].sat?[0].m)!
//                print(busMin)
//                print((busTimer.shosfc?[1].sat?[0].type)!)
                
                //write functions to get busNum, get hh, mm etc?
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
        }.resume()
        
    }


}

