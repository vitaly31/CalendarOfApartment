//
//  CalendarViewController.swift
//  
//
//  Created by Виталий Косинов on 03/06/2020.
//

import UIKit
import Koyomi

class CalendarViewController: UIViewController, KoyomiDelegate {
   
    let colorOfDays = ColorOfDays()
    var calendarOfClientsForAppartment: [Client] = []
    var apartment = 0
    var dateOfArrrival = Date()
    
    func createCalendarOfClientsForApartment() {
        colorOfDays.createArraysForAllApertment()

        if apartment > 0 && apartment <= 12 {
            for client in colorOfDays.arrayOfClients {
                if client.numberOfApartment == apartment {
                    calendarOfClientsForAppartment.append(client)
                }
            }
        }
    }
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBInspectable  public  var selectedStyleColor : UIColor?
    
    public enum SelectedTextState { case change(UIColor), keeping }
    public var selectedDayTextState: SelectedTextState?
    public enum SequenceStyle { case background, circle, semicircleEdge, line }
    public enum Style { case background, circle, line }
    
    public var selectionMode: SelectionMode = .single(style: .circle)
     
    public enum MonthType { case previous, current, next }
    @IBOutlet weak var koyomi: Koyomi!
    override func viewDidLoad() {
        super.viewDidLoad()

        koyomi.calendarDelegate = self
    
        createCalendarOfClientsForApartment()
        selectDates()
        monthButton.setTitle("Следующий месяц", for: .normal)
        monthButton.layer.cornerRadius = 10
        changeButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
        koyomi.display(in: .current)
        koyomi.isHiddenOtherMonth = true
        koyomi.weeks = ("ВС", "ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ")
        koyomi.selectionMode = .single(style: .circle)
        koyomi.selectedDayTextState = .change(.white)
        koyomi.style = .blue
        self.title = "Календарь по \(apartment) квартире"
        
    }
    
    @IBAction func changeMonth(_ sender: UIButton) {
        if monthButton.titleLabel?.text == "Следующий месяц" {
            koyomi.display(in: .next)
  //          self.monthButton.titleLabel?.text = "Текущий месяц"
            self.monthButton.setTitle("Текущий месяц", for: .normal)
        } else {
            koyomi.display(in: .current)
    //        self.monthButton.titleLabel?.text = "Следующий месяц"
            self.monthButton.setTitle("Следующий месяц", for: .normal)
        }
    }
    
    func selectDates() {
        

        for client in calendarOfClientsForAppartment {
            let dateOfLeaving = Calendar.current.date(byAdding: .day, value: client.numbersOfStayingDay - 1, to: client.dateOfArrival)
            koyomi.setDayBackgrondColor(UIColor(red: 255/255.0, green: 95/255.0, blue: 202/255.0, alpha: 1), of: client.dateOfArrival, to: dateOfLeaving)
            
        }

        
  //      }
        
        
    }
    
    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
    
        let currentDateString = koyomi.currentDateString(withFormat: "MM/yyyy")
        monthLabel.text = currentDateString
        
    }
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        
  //      let timeZone = TimeZone(identifier: "Europe/Moscow")
        if let selectDate = date {
//            let moscowDay = Calendar.current.dateComponents(in: timeZone!, from: selectDate)
            dateOfArrrival = Calendar.current.date(byAdding: .hour, value: 3, to: selectDate)!
            print(dateOfArrrival)
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let clientsViewController = segue.destination as! ClientsViewController
        clientsViewController.apartment = apartment
        if segue.identifier == "addSegue" {
            clientsViewController.addClient = true
            clientsViewController.dateOfArival = dateOfArrrival
        }
    }

}
