//
//  Model.swift
//  CalendarForApartments
//
//  Created by Виталий Косинов on 05/06/2020.
//  Copyright © 2020 Виталий Косинов. All rights reserved.
//

import UIKit

struct Client {
    let dateOfArrival: Date
    let numbersOfStayingDay: Int
    let numberOfApartment: Int
    let color: UIColor
    var datesOfStaying: [Date]?
}
