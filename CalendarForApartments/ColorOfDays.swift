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
    var dateOfCalendar = DateOfCalendar(date: Date())
    var arrayOfClients: [Client] = []
    var arrayForAllApertment: [[DateOfCalendar]] = []
    var arrayOfCalendarForFirstScreen: [DateOfCalendar] = []
    var arrayOfTitleDates: [String] = []





       func createDate(numbersOfDaysAfterToday: Int) -> Date {
           guard let dateInFuture = calendar.date(byAdding: .day, value: numbersOfDaysAfterToday, to: Date()) else { return Date() }
           return dateInFuture
       }
       
       func createClients() {
           let date1 = createDate(numbersOfDaysAfterToday: 2)
           let date2 = createDate(numbersOfDaysAfterToday: 5)
           let date3 = createDate(numbersOfDaysAfterToday: 10)
               

           let client1 = Client(dateOfArrival: date1, numbersOfStayingDay: 4, numberOfApartment: 1, color: .red)
           let client2 = Client(dateOfArrival: date2, numbersOfStayingDay: 8, numberOfApartment: 1, color: .gray)
           let client3 = Client(dateOfArrival: date3, numbersOfStayingDay: 5, numberOfApartment: 1, color: .brown)
           arrayOfClients.append(client1)
           arrayOfClients.append(client2)
           arrayOfClients.append(client3)
           
       }
       
       func createArraysForAllApertment() { //массив из всех квартир с календарем где даты раскрашенны в разный цвет
           
           createClients()
           for apartment in 1...12 {
               var arrayOfClientForApartment: [Client] = []
               for client in arrayOfClients{
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



           for date in allDatesArray {
               
               dateOfCalendar.date = date
               arrayOfDates.append(dateOfCalendar)
           }
               arrayOfDatesFromClient(arrayOfClient: arrayOfClientForApartment, color: .gray, arrayOfDateCalendar: &arrayOfDates)
               arrayOfDatesFromClient(arrayOfClient: arrayOfClientForApartment, color: .brown, arrayOfDateCalendar: &arrayOfDates)
               arrayOfDatesFromClient(arrayOfClient: arrayOfClientForApartment, color: .red, arrayOfDateCalendar: &arrayOfDates)


           
           
           return arrayOfDates
       }
       
       func arrayOfDatesFromClient(arrayOfClient: [Client], color: UIColor, arrayOfDateCalendar: inout [DateOfCalendar]) {
           for client in arrayOfClient{
               if client.color == color {
                  arrayOfDateCalendar = createArrayOfDates(client: client, arrayOfDateCalendar: &arrayOfDateCalendar)
               }
               
           }
       }

       
       func createArrayOfDates(client: Client, arrayOfDateCalendar: inout [DateOfCalendar]) -> [DateOfCalendar] {



           var dayStaying = 0
           var numberOfElement = -1
           
           for var date in arrayOfDateCalendar {
               numberOfElement += 1
               if self.calendar.isDate(client.dateOfArrival, inSameDayAs: date.date!) {
                   dayStaying = 1
               }
               if 1 <= dayStaying && dayStaying <= client.numbersOfStayingDay {
                   date.colorOfDate = client.color
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

   
}

