//
//  DataUtils.swift
//  BusTimerJSON
//
//  Created by 笠原悠生人 on 2019/03/13.
//  Copyright © 2019 team-sfcbustimer. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataUtils{
	class func saveData(){
		// Get bus timetable
		let BusJsonUrlString = "https://api.myjson.com/bins/1brbhu" // almost final data with type 19 added.
		// let BusJsonUrlString = "https://api.myjson.com/bins/10zfwo" // before type 2
		guard let busUrl = URL(string: BusJsonUrlString) else {return}
		URLSession.shared.dataTask(with: busUrl) { (data, response, err) in
			guard let data = data else { return }
			// storing data directly without parsing
			UserDefaults.standard.set(data, forKey: "timetable")
			}.resume() //end of url session
		
		let holidaysJsonUrlString = "https://holidays-jp.github.io/api/v1/date.json"
		guard let dateUrl = URL(string: holidaysJsonUrlString) else {return}
		URLSession.shared.dataTask(with: dateUrl) { (data, response, err) in
			guard let data = data else { return }
			UserDefaults.standard.set(data, forKey: "holidays")
			}.resume() //end of url session
	}
	
	class func checkData(){
		if let timetableData = UserDefaults.standard.data(forKey: "timetable"){
			do{
				let json = try JSON(data: timetableData)
				print(json)
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
		} else {
			print("no timetable data stored")
		}
		
		if let holidaysData = UserDefaults.standard.data(forKey: "holidays"){
			do{
				let json = try JSON(data: holidaysData)
				print(json)
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
		} else {
			print("no holidays data stored")
		}
	}
	
	class func DeleteData(){
		UserDefaults.standard.removeObject(forKey: "timetable")
		UserDefaults.standard.removeObject(forKey: "holidays")
	}
	
	class func parseHolidaysJson() -> (JSON){
		var json = JSON()
		if let holidaysData = UserDefaults.standard.data(forKey: "holidays"){
			do{
				json = try JSON(data: holidaysData)
				print(json)
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
		} else {
			print("no holidays data stored")
		}
		return json
	}
	
	class func parseTimetableJson() -> (JSON){
		var json = JSON()
		if let timetableData = UserDefaults.standard.data(forKey: "timetable"){
			do{
				json = try JSON(data: timetableData)
				print(json)
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
		} else {
			print("no timetable data stored")
		}
		return json
	}
	
}