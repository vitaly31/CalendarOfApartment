//
//  CalendarViewController.swift
//  
//
//  Created by Виталий Косинов on 03/06/2020.
//

import UIKit
import Koyomi


class CalendarViewController: UIViewController, KoyomiDelegate {
    
    var clientsString:[ClientString] = []
    var apartment = 0
    var dateOfArrrival = Date()
    var clients: [Client] = []
    var newClientsString: [ClientString] = []
    
    @IBInspectable  public  var selectedStyleColor : UIColor?
    
    public enum SelectedTextState { case change(UIColor), keeping }
    public var selectedDayTextState: SelectedTextState?
    public enum Style { case background, circle, line }
    public var selectionMode: SelectionMode = .single(style: .circle)
    public enum MonthType { case previous, current, next }
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBOutlet weak var koyomi: Koyomi!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        koyomi.calendarDelegate = self
        
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
            self.monthButton.setTitle("Текущий месяц", for: .normal)
        } else {
            koyomi.display(in: .current)
            self.monthButton.setTitle("Следующий месяц", for: .normal)
        }
    }
    
    func selectDates() {
        for client in clients {
            let dateOfLeaving = Calendar.current.date(byAdding: .day, value: client.numbersOfStayingDay - 1, to: client.dateOfArrival)
            koyomi.setDayBackgrondColor(UIColor(red: 255/255.0, green: 95/255.0, blue: 202/255.0, alpha: 1), of: client.dateOfArrival, to: dateOfLeaving)
        }
    }
    
    func koyomi(_ koyomi: Koyomi, currentDateString dateString: String) {
        
        let currentDateString = koyomi.currentDateString(withFormat: "MM/yyyy")
        monthLabel.text = currentDateString
    }
    
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        
        if let selectDate = date {
            dateOfArrrival = Calendar.current.date(byAdding: .hour, value: 3, to: selectDate)!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let clientsViewController = segue.destination as! ClientsViewController
        clientsViewController.apartment = apartment
        clientsViewController.delegate = self
        
        if segue.identifier == "addSegue" {
            clientsViewController.addClient = true
            clientsViewController.dateOfArival = dateOfArrrival
        }
    }
}


extension CalendarViewController: ClientsViewControllerDelegate {
    func updateCalendar(clientsString: [ClientString]) {
        
        self.clientsString = clientsString
        
        for clientString in clientsString {
            self.clients.append(TransformFormatters.fromClientStringToClient(clientString: clientString))
        }
        self.selectDates()
        koyomi.reloadData()
    }
}









