//
//  ClientStringModel.swift
//  CalendarForApartments
//
//  Created by Виталий Косинов on 17/06/2020.
//  Copyright © 2020 Виталий Косинов. All rights reserved.
//

import UIKit
import Firebase

struct ClientString {
    var dateOfArrivalString: String
    var numbersOfStayingDay: Int
    var numberOfApartment: Int
    var typeOfBooking: String
    var details: String
    let ref: DatabaseReference?
    
    init(dateOfArrivalString: String, numberOfStayindDay: Int, numberOfApartment: Int, typeOfBooking: String, details: String) {
        self.dateOfArrivalString = dateOfArrivalString
        self.numbersOfStayingDay = numberOfStayindDay
        self.numberOfApartment = numberOfApartment
        self.typeOfBooking = typeOfBooking
        self.details = details
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String : AnyObject]
        dateOfArrivalString = snapshotValue["dateOfArrivalString"] as! String
        numbersOfStayingDay = snapshotValue["numbersOfStayingDay"] as! Int
        numberOfApartment = snapshotValue["numberOfApartment"] as! Int
        typeOfBooking = snapshotValue["typeOfBooking"] as! String
        details = snapshotValue["details"] as! String
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["dateOfArrivalString" : dateOfArrivalString, "numbersOfStayingDay" : numbersOfStayingDay, "numberOfApartment" : numberOfApartment, "typeOfBooking" : typeOfBooking, "details" : details]
    }
}

