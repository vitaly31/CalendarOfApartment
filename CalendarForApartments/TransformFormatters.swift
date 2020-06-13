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
            color = .red
        case "Booking":
            color = .blue
        case "Проживает сейчас":
            color = .green
        case "Бронь по предоплате":
            color = .yellow
        case "Бронь без предоплаты":
            color = .gray
        default:
            color = .white
        }
        return color
    }
    
    static func fromDateToString(date: Date) -> String {
        
        let day = Calendar.current.component(.day, from: date)
        let month = Calendar.current.component(.month, from: date)
        let year = Calendar.current.component(.year, from: date)
        let dateString = String(day) + String(month) + String(year)
        return dateString
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
}
