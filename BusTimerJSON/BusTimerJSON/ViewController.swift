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
	let saturday: [Bus]?
	let holiday: [Bus]?
}

struct Bus: Decodable{
	let hour: Int?
	let min: Int?
	let type: String?
}

func getDate() -> String{
	let date = Date()
	let dateFormatter = DateFormatter()
	dateFormatter.dateStyle = .medium
	dateFormatter.timeStyle = .none
	dateFormatter.locale = Locale(identifier: "ja_JP")
	dateFormatter.timeZone = TimeZone(abbreviation: "JST")
	let today = dateFormatter.string(from: date)
	return today
}

func getDateTime() -> String{
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .short
    dateFormatter.locale = Locale(identifier: "ja_JP")
    dateFormatter.timeZone = TimeZone(abbreviation: "JST")
    let today = dateFormatter.string(from: date)
    return today
}

func getToday() -> Int{
	let date = Date()
	let calendar = Calendar.current
	let weekday = calendar.component(.weekday, from: date)
//    print("Weekday \(weekday)") // 1, 2, 3, .... 2 is Monday
	return weekday
}

func isHoliday(today:String, holidays:[String]) -> Bool {
	var result = false
	for i in holidays {
		if(today == i){
			result = true
		}
	}
	return result
}

func identifyDay(today:String, holidays:[String]){
	let weekday = getToday()
	if(isHoliday(today: today, holidays: holidays)){
		print("Holiday スケジュール")
	} else if(weekday == 1){
		print("Sunday スケジュール")
	} else if(weekday == 7){
		print("Saturday スケジュール")
	} else {
		print("Weekday スケジュール")
	}
}

func strToDate(str:String)-> Date?{
//    print("str",str)
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy/MM/dd H:mm"
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX") //王道パターン
	let date = dateFormatter.date(from: str)
//    print(dateFormatter.string(from: date!)) //値自体は変わらない
	return date
}


class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		var today = getDate()
        // match for formatting of holiday with api data
        today = today.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
		let jsonUrlString = "https://holidays-jp.github.io/api/v1/date.json"
		guard let url = URL(string: jsonUrlString) else {return}
		
		URLSession.shared.dataTask(with: url) { (data, response, err) in
			guard let data = data else { return }
			do {
				let response = try JSONDecoder().decode([String: String].self, from: data)
				let keys = Array(response.keys)
				
				// check whether today is weekday, sat, or holiday
				identifyDay(today: today, holidays: keys)
				
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
			
			}.resume()
		
//            let jsonUrlString2 = "https://api.myjson.com/bins/y7ito"
//            let jsonUrlString2 = "https://api.myjson.com/bins/6bs9i"
            let jsonUrlString2 = "https://api.myjson.com/bins/17tlbs"
			guard let url2 = URL(string: jsonUrlString2) else {return}
			URLSession.shared.dataTask(with: url2) { (data, response, err) in
				guard let data = data else { return }
				//         let dataAsString = String(data: data, encoding: .utf8)
				//            print(dataAsString)
				do {
					let busTimer = try JSONDecoder().decode(Direction.self, from: data)
                    let bus = busTimer.shosfc?[0].weekday?[0]
//                    print(bus ?? "default")
                    let busHour = (bus?.hour)!
                    let busMin = (bus?.min)!
                    let busType = bus?.type
//                    print("\(busHour), \(busMin), \(busType)") // 7, 10, ""
//                    let sampleStr = "2018/12/18 \(busHour):\(busMin)"
//                    let date = strToDate(str: sampleStr)
//                    print(date) // `print` will display this in UTC

                     // Test main logic with sample user inputs
                     let userDirection = "shosfc"
                     let userWeek = "weekday"
                     var currDateTime = getDateTime()
//                     currDateTime = dateFormatter.string(from: currDateTime)
                     let userDate = strToDate(str: currDateTime)

                     //direction
                    if(userDirection == "shosfc"){
                        if(userWeek == "weekday"){
                            // list of weekday buses
                            let busList = busTimer.shosfc?[0].weekday
                            for bus in busList!{
                                let busTimeStr = "2018/12/18 \((bus.hour)!):\((bus.min)!)"
                                let busTimeObj = strToDate(str:busTimeStr)
                                if busTimeObj! > userDate!{
                                    print("Found next bus at \(busTimeObj)")
                                    break
                                }
                            }

                        }
                    }

					
	
				} catch let jsonErr {
					print("Error serializing json:", jsonErr)
				}
	
				}.resume()
		
	}
	
	
}
