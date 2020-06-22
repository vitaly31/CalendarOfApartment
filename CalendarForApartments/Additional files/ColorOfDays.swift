//
//  ColorOfDays.swift
//  CalendarForApartments
//
//  Created by Виталий Косинов on 05/06/2020.
//  Copyright © 2020 Виталий Косинов. All rights reserved.
//

import UIKit

class ColorOfDays {
    
    
    let calendar = Calendar.current
    var clients: [Client] = []
    var arrayForAllApertment: [[DateOfCalendar]] = []
    var arrayOfCalendarForFirstScreen: [DateOfCalendar] = []
    var arrayOfTitleDates: [String] = []
    
    func createClients(clientsString: [ClientString]) {
        
        clients.removeAll()
        for clientString in clientsString {
            let client = TransformFormatters.fromClientStringToClient(clientString: clientString)
            
            clients.append(client)
        }
    }
    
    func completeArrayForFirstScreen() {
        
        let allDatesArray: [Date] = dates(dateOfArrival: Date(), numbersOfStayingDay: 85)
        
        var dateOfCalendar = DateOfCalendar(date: Date())
        for date in allDatesArray {
            dateOfCalendar.date = date
            arrayOfCalendarForFirstScreen.append(dateOfCalendar)
        }
    }
    
    func createArraysForAllApertment() { //массив из всех квартир с календарем где даты раскрашенны в разный цвет
        arrayForAllApertment.removeAll()
        for apartment in 1...12 {
            var arrayOfClientForApartment: [Client] = []
            for client in clients {
                if client.numberOfApartment == apartment {
                    arrayOfClientForApartment.append(client)
                }
            }
            let arrayForApertment = createMainArray(arrayOfClientForApartment: arrayOfClientForApartment)
            
            arrayForAllApertment.append(arrayForApertment)
        }
    }
    
    func createMainArray(arrayOfClientForApartment: [Client]) -> [DateOfCalendar] {
        
        var arrayOfDates: [DateOfCalendar] = []
        let allDatesArray: [Date] = dates(dateOfArrival: Date(), numbersOfStayingDay: 62)
        
        var dateOfCalendar = DateOfCalendar(date: Date())
        for date in allDatesArray {
            dateOfCalendar.date = date
            arrayOfDates.append(dateOfCalendar)
        }
        
        arrayOfDatesFromClient(arrayOfClient: arrayOfClientForApartment, color: UIColor(red: 198/255.0, green: 198/255.0, blue: 200/255.0, alpha: 1), arrayOfDateCalendar: &arrayOfDates)
        arrayOfDatesFromClient(arrayOfClient: arrayOfClientForApartment, color: UIColor(red: 254/255.0, green: 232/255.0, blue: 0/255.0, alpha: 1), arrayOfDateCalendar: &arrayOfDates)
        arrayOfDatesFromClient(arrayOfClient: arrayOfClientForApartment, color: UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1), arrayOfDateCalendar: &arrayOfDates)
        arrayOfDatesFromClient(arrayOfClient: arrayOfClientForApartment, color: UIColor(red: 250/255.0, green: 17/255.0, blue: 0/255.0, alpha: 1), arrayOfDateCalendar: &arrayOfDates)
        arrayOfDatesFromClient(arrayOfClient: arrayOfClientForApartment, color: UIColor(red: 70/255.0, green: 200/255.0, blue: 67/255.0, alpha: 1), arrayOfDateCalendar: &arrayOfDates)
        
        return arrayOfDates
    }
    
    func arrayOfDatesFromClient(arrayOfClient: [Client], color: UIColor, arrayOfDateCalendar: inout [DateOfCalendar]) {
        let sortedClients = arrayOfClient.sorted { $0.dateOfArrival < $1.dateOfArrival }
        var numberOfClientsOneColor = 0
        for client in sortedClients {
            if client.color == color {
                numberOfClientsOneColor += 1
                arrayOfDateCalendar = createArrayOfDates(client: client, arrayOfDateCalendar: &arrayOfDateCalendar, numberOfClientsOneColor: numberOfClientsOneColor)
            }
        }
    }
    
    func createArrayOfDates(client: Client, arrayOfDateCalendar: inout [DateOfCalendar], numberOfClientsOneColor: Int) -> [DateOfCalendar] {
        
        var dayStaying = 0
        var numberOfElement = -1
        
        for var date in arrayOfDateCalendar {
            numberOfElement += 1
            if self.calendar.isDate(client.dateOfArrival, inSameDayAs: date.date) {
                dayStaying = 1
            }
            if 1 <= dayStaying && dayStaying <= client.numbersOfStayingDay {
                if numberOfClientsOneColor % 2 == 0 {
                    date.colorOfDate = colorOfEvenClients(client: client)
                } else {
                    date.colorOfDate = client.color
                }
                arrayOfDateCalendar[numberOfElement] = date
                
                dayStaying += 1
            }
        }
        return arrayOfDateCalendar
    }
    
    func dates(dateOfArrival: Date, numbersOfStayingDay: Int) -> [Date] {
        var arrayOfDatesStaying: [Date] = [dateOfArrival]
        for day in 1...numbersOfStayingDay {
            let date = Calendar.current.date(byAdding: .day, value: day, to: Date())
            arrayOfDatesStaying.append(date!)
        }
        return arrayOfDatesStaying
    }
    
    func createArrayOfCalendarForFirstScreen() {
        arrayOfCalendarForFirstScreen.removeAll()
        createArraysForAllApertment()
        for calendarForApartment in arrayForAllApertment {
            var days = 1
            for date in calendarForApartment {
                arrayOfCalendarForFirstScreen.append(date)
                days += 1
                if days > 7 {
                    break
                }
            }
        }
    }
    
    func datesForTitle() {
        for numberOfDaysAfterToday in 0...7 {
            let date = calendar.date(byAdding: .day, value: numberOfDaysAfterToday - 1, to: Date())
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM"
            let monthAndDay = dateFormatter.string(from: date!)
            let weekDateFormatter = DateFormatter()
            weekDateFormatter.locale = Locale(identifier: "ru_Ru")
            weekDateFormatter.dateFormat = "EEEEEE"
            let weekday = weekDateFormatter.string(from: date!)
            let capitalizedWeekday = weekday.capitalized
            let fullDate = monthAndDay + " " + capitalizedWeekday
            arrayOfTitleDates.append(fullDate)
        }
    }
    func colorOfEvenClients(client: Client) -> UIColor {
        var colorOfEvenClient = UIColor.white
        switch client.color {
        case UIColor(red: 198/255.0, green: 198/255.0, blue: 200/255.0, alpha: 1):
            colorOfEvenClient = UIColor(red: 111/255.0, green: 113/255.0, blue: 122/255.0, alpha: 1)
        case UIColor(red: 254/255.0, green: 232/255.0, blue: 0/255.0, alpha: 1):
            colorOfEvenClient = UIColor(red: 197/255.0, green: 181/255.0, blue: 0/255.0, alpha: 1)
        case UIColor(red: 0/255.0, green: 0/255.0, blue: 255/255.0, alpha: 1):
            colorOfEvenClient = UIColor(red: 0/255.0, green: 0/255.0, blue: 192/255.0, alpha: 1)
        case UIColor(red: 250/255.0, green: 17/255.0, blue: 0/255.0, alpha: 1):
            colorOfEvenClient = UIColor(red: 178/255.0, green: 9/255.0, blue: 0/255.0, alpha: 1)
        case UIColor(red: 70/255.0, green: 200/255.0, blue: 67/255.0, alpha: 1):
            colorOfEvenClient = UIColor(red: 70/255.0, green: 200/255.0, blue: 67/255.0, alpha: 1)
        default:
            colorOfEvenClient = UIColor.white
        }
        return colorOfEvenClient
        
    }
}

