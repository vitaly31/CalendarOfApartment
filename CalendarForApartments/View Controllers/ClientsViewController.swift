//
//  ClientsViewController.swift
//  CalendarForApartments
//
//  Created by Виталий Косинов on 12/06/2020.
//  Copyright © 2020 Виталий Косинов. All rights reserved.
//

import UIKit
import Firebase

protocol ClientsViewControllerDelegate {
    func updateCalendar(clientsString: [ClientString])
}

class ClientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var apartment = 0
    var dateOfArival = Date()
    var clientsString: [ClientString] = []
    var addClient = false
    var editSegue = false
    var delegate: ClientsViewControllerDelegate?
    var ref: DatabaseReference!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref = Database.database().reference(withPath: "clientsString")
        editButton.layer.cornerRadius = 10
        editButton.isEnabled = false
        self.title = "Клиенты на \(apartment) квартиру"
        tableView.delegate = self
        tableView.dataSource = self
        
        if addClient == true {
            guard let addViewController = storyboard?.instantiateViewController(withIdentifier: "AddClient") as? AddClientTableViewController else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMYYYY"
            addViewController.clientString.dateOfArrivalString = dateFormatter.string(from: dateOfArival)
            addViewController.apartment = apartment
            addViewController.delegate = self
            show(addViewController, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value) { [weak self] (snapshot) in
            var _clientsString: [ClientString] = []
            for item in snapshot.children {
                let clientString = ClientString(snapshot: item as! DataSnapshot)
                if clientString.numberOfApartment == self?.apartment {
                    _clientsString.append(clientString)
                }
            }
            self?.clientsString = _clientsString
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientsString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientTableViewCell
        
        let dateOfArrivalString = clientsString[indexPath.row].dateOfArrivalString
        var charaktersArray: [String] = []
        for charakter in dateOfArrivalString {
            charaktersArray.append(String(charakter))
        }
        let dateString = charaktersArray[0] + charaktersArray[1] + "." + charaktersArray[2] + charaktersArray[3]
        cell.dateArrivalLabel.text = "Дата заезда: \(dateString)"
        
        cell.numberOfDaysStayingLabel.text = "Количество дней: \(String(clientsString[indexPath.row].numbersOfStayingDay))"
        
        let typeOfBooking = clientsString[indexPath.row].typeOfBooking
        cell.typeOfBookingLabel.text = "Бронирование: \(typeOfBooking)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let clientString = clientsString[indexPath.row]
        clientString.ref?.removeValue()
        clientsString.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationViewController = segue.destination as! UINavigationController
        let addClientViewController = navigationViewController.topViewController as! AddClientTableViewController
        addClientViewController.delegate = self
        addClientViewController.apartment = apartment
        guard segue.identifier == "editCleint" else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        
        let dateOfArrivalString = clientsString[indexPath.row].dateOfArrivalString
        addClientViewController.clientString.dateOfArrivalString = dateOfArrivalString
        
        addClientViewController.clientString.numbersOfStayingDay = clientsString[indexPath.row].numbersOfStayingDay
        
        addClientViewController.clientString.typeOfBooking = clientsString[indexPath.row].typeOfBooking
        
        addClientViewController.clientString.details = clientsString[indexPath.row].details
        
        addClientViewController.editSegue = true
        addClientViewController.selectedIndexPath = indexPath
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editButton.isEnabled = true
        detailLabel.text = clientsString[indexPath.row].details
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateCalendar(clientsString: clientsString)
    }
}

extension ClientsViewController: AddClientTableViewControllerDelegate {
    
    func updateClient(clientString: ClientString, editSegue: Bool, selectedIndexPath: IndexPath) {
        detailLabel.text = ""
        
        if editSegue == true {
            let clientString1 = self.clientsString[selectedIndexPath.row]
            clientString1.ref?.updateChildValues(["dateOfArrivalString" : clientString.dateOfArrivalString, "numbersOfStayingDay" : clientString.numbersOfStayingDay, "typeOfBooking" : clientString.typeOfBooking, "details" : clientString.details])
            
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        }
    }
}
