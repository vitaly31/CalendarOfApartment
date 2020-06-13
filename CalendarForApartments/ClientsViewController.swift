//
//  ClientsViewController.swift
//  CalendarForApartments
//
//  Created by Виталий Косинов on 12/06/2020.
//  Copyright © 2020 Виталий Косинов. All rights reserved.
//

import UIKit



class ClientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    

    var apartment = 0
    var dateOfArival = Date()
    var clients: [Client] = []
    var addClient = false

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Клиенты на \(apartment) квартиру"
        tableView.delegate = self
        tableView.dataSource = self
        
        if addClient == true {
            guard let addViewController = storyboard?.instantiateViewController(withIdentifier: "AddClient") as? AddClientTableViewController else { return }
            

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMYYYY"
            addViewController.dateOfArrivalString = dateFormatter.string(from: dateOfArival)
            addViewController.delegate = self
            show(addViewController, sender: nil)

        }

    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as! ClientTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        let date = clients[indexPath.row].dateOfArrival
        let dateOfArrival = dateFormatter.string(from: date)
        cell.dateArrivalLabel.text = "Дата заезда: \(dateOfArrival)"
        cell.numberOfDaysStayingLabel.text = "Количество дней: \(String(clients[indexPath.row].numbersOfStayingDay))"
        
        let typeOfBooking = TransformFormatters.fromColorToString(color: clients[indexPath.row].color)
        cell.typeOfBookingLabel.text = "Бронирование: \(typeOfBooking)"
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationViewController = segue.destination as! UINavigationController
        let addClientViewController = navigationViewController.topViewController as! AddClientTableViewController
        addClientViewController.delegate = self
        guard segue.identifier == "editCleint" else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        let date = clients[indexPath.row].dateOfArrival
        addClientViewController.client.dateOfArrival = date
        addClientViewController.client.numbersOfStayingDay = clients[indexPath.row].numbersOfStayingDay
        addClientViewController.client.color = clients[indexPath.row].color
        addClientViewController.client.details = clients[indexPath.row].details
        addClientViewController.editSegue = true
    }
}

extension ClientsViewController: AddClientTableViewControllerDelegate {
    
    func updateClient(client: Client) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            clients[selectedIndexPath.row] = client
            clients[selectedIndexPath.row].numberOfApartment = apartment
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
            let newIndexPath = IndexPath(row: clients.count, section: 0)
            clients.append(client)
            clients[clients.count - 1].numberOfApartment = apartment
            
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
}
