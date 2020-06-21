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
    func updateCalendar(selectedRow: [Int], clientsString: [ClientString], newClientsString: [ClientString])
}

class ClientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    

    var apartment = 0
    var dateOfArival = Date()
    var clientsString: [ClientString] = []
    var clients:[Client] = []
    var addClient = false
    var editSegue = false
    var selectedRow: [Int] = []
    var delegate: ClientsViewControllerDelegate?
    var newClientsString: [ClientString] = []
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
                _clientsString.append(clientString)
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
        cell.dateArrivalLabel.text = "Дата заезда: \(dateString)" //добавить точки убрать год
        
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
    @IBAction func editClient(_ sender: UIButton) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editButton.isEnabled = true
        detailLabel.text = clientsString[indexPath.row].details
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.updateCalendar(selectedRow: selectedRow, clientsString: clientsString, newClientsString: newClientsString)
    }
    

}

extension ClientsViewController: AddClientTableViewControllerDelegate {

    func updateClient(clientString: ClientString, editSegue: Bool, selectedIndexPath: IndexPath) {
        detailLabel.text = ""

        if editSegue == true {
            let clientString1 = self.clientsString[selectedIndexPath.row]
            clientString1.ref?.updateChildValues(["dateOfArrivalString" : clientString.dateOfArrivalString, "numbersOfStayingDay" : clientString.numbersOfStayingDay, "typeOfBooking" : clientString.typeOfBooking, "details" : clientString.details])
            print("yes")

//            clientsString[selectedIndexPath.row] = clientString
//            clientsString[selectedIndexPath.row].numberOfApartment = apartment
//            selectedRow.append(selectedIndexPath.row)



//            var numberOfAllClient = -1
//            var numberOfClientInApartment = -1
//            for var client in colorOfDays.clients {
//                numberOfAllClient += 1
//                if client.numberOfApartment == apartment{
//                    numberOfClientInApartment += 1
//                    if numberOfClientInApartment == selectedIndexPath.row {
//                        client = colorOfDays.editClient(clientString: clientString)
//                        colorOfDays.clients[numberOfAllClient] = client
 //                   }

  //              }
 //           }
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
//            let newIndexPath = IndexPath(row: clientsString.count, section: 0)
//            clientsString.append(clientString)
//            clientsString[clientsString.count - 1].numberOfApartment = apartment
//            newClientsString.append(clientString)
//            tableView.insertRows(at: [newIndexPath], with: .fade)
//            let clientRef = ref.childByAutoId()
//            clientRef.setValue(clientString.convertToDictionary())

        }
    }


}
