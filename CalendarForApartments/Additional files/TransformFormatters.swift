//
//  TransformFormatters.swift
//  CalendarForApartments
//
//  Created by Виталий Косинов on 13/06/2020.
//  Copyright © 2020 Виталий Косинов. All rights reserved.
//

import UIKit

class TransformFormatters {
    
    static func fronStringToDate(dateString: String) -> Date? {
        
        var arrayOfCharacter: [String] = []
        
        for chracter in dateString {
            guard Int(String(chracter)) != nil else { return nil }
            arrayOfCharacter.append(String(chracter))
        }
        guard arrayOfCharacter.count == 8 else { return nil }
        
        var dateComponents = DateComponents()
        dateComponents.day = Int(arrayOfCharacter[0] + arrayOfCharacter[1])
        dateComponents.month = Int(arrayOfCharacter[2] + arrayOfCharacter[3])
        dateComponents.year = Int(arrayOfCharacter[4] + arrayOfCharacter[5] + arrayOfCharacter[6] + arrayOfCharacter[7])
        
        guard let date = Calendar.current.date(from: dateComponents) else { return nil }
        
        let moscowDate = Calendar.current.date(byAdding: .hour, value: 3, to: date)
        return moscowDate
    }
    
    static func fromStringToColor(typeOfBooking: String) -> UIColor {
        var color: UIColor
        switch typeOfBooking {
        case "Airbnb":
            color = UIColor(red: 250/255.0, green: 17/255.0, blue: 0/255.0, alpha: 1)
        case "Booking":
            color = UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1)
        case "Проживает сейчас":
            color = UIColor(red: 70/255.0, green: 200/255.0, blue: 67/255.0, alpha: 1)
        case "Бронь по предоплате":
            color = UIColor(red: 254/255.0, green: 232/255.0, blue: 0/255.0, alpha: 1)
        case "Бронь без предоплаты":
            color = UIColor(red: 198/255.0, green: 198/255.0, blue: 200/255.0, alpha: 1)
        default:
            color = .white
        }
        return color
    }
    
    static func fromColorToString(color: UIColor) -> String {
        let typeOfBooking: String
        switch color {
        case .red:
            typeOfBooking = "Airbnb"
        case .blue:
            typeOfBooking = "Booking"
        case .green:
            typeOfBooking = "Проживает сейчас"
        case .yellow:
            typeOfBooking = "Бронь по предоплате"
        case .gray:
            typeOfBooking = "Бронь без предоплаты"
        default:
            typeOfBooking = "Неизвестно"
        }
        return typeOfBooking
    }
    
    static func fromClientStringToClient(clientString: ClientString) -> Client {
        var client = Client(dateOfArrival: Date(), numbersOfStayingDay: 0, numberOfApartment: 0, color: .red, details: "")
        client.dateOfArrival = TransformFormatters.fronStringToDate(dateString: clientString.dateOfArrivalString)!
        client.numbersOfStayingDay = clientString.numbersOfStayingDay
        client.numberOfApartment = clientString.numberOfApartment
        client.color = TransformFormatters.fromStringToColor(typeOfBooking: clientString.typeOfBooking)
        client.details = clientString.details
        return client
    }
}
