//
//  MainViewController.swift
//  CalendarForApartments
//
//  Created by Виталий Косинов on 10/06/2020.
//  Copyright © 2020 Виталий Косинов. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    let colorOfDays = ColorOfDays()
    var clientsString: [ClientString] = []
    var clients: [Client] = []
    var ref: DatabaseReference!
    let itemPerRow: CGFloat = 7
    let itemPerColumn: CGFloat = 12
    let sectionInsets = UIEdgeInsets(top: 2.5, left: 5, bottom: 2.5, right: 5)
    
    @IBOutlet var datesLabel: [UILabel]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference(withPath: "clientsString")
        colorOfDays.datesForTitle()
        updateDatesLabel()
        dateInLabel()
        collectionView.dataSource = self
        collectionView.delegate = self
        colorOfDays.completeArrayForFirstScreen()
        // Do any additional setup after loading the view.
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
            
            self?.colorOfDays.createClients(clientsString: self!.clientsString)
            self?.colorOfDays.createArrayOfCalendarForFirstScreen()
            self?.clients = self!.colorOfDays.clients
            self?.collectionView.reloadData()
            
            

        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    

    
    func dateInLabel() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

            return 84
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = colorOfDays.arrayOfCalendarForFirstScreen[indexPath.item].colorOfDate
            return cell
    }

    func updateDatesLabel() {
        var numberOfElementInArray = 0
        for oneDateLabel in datesLabel {
            oneDateLabel.text = colorOfDays.arrayOfTitleDates[numberOfElementInArray]
            numberOfElementInArray += 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calendarSegue" {
            let calendarViewController = segue.destination as! CalendarViewController
            let indexPath = collectionView.indexPathsForSelectedItems?.first
            var apartment: Int
            calendarViewController.delegate = self
            
            switch indexPath!.item {
                
            case 0...6:
                apartment = 1
            case 7...13:
                apartment = 2
            case 14...20:
                apartment = 3
            case 21...27:
                apartment = 4
            case 28...34:
                apartment = 5
            case 35...41:
                apartment = 6
            case 42...48:
                apartment = 7
            case 49...55:
                apartment = 8
            case 56...62:
                apartment = 9
            case 63...69:
                apartment = 10
            case 70...76:
                apartment = 11
            case 77...83:
                apartment = 12
            default:
                apartment = 0
            }
        calendarViewController.apartment = apartment
            for client in colorOfDays.clients {
                if client.numberOfApartment == apartment {
                    calendarViewController.clients.append(client)
                }
            }
            for clientString in clientsString {
                if clientString.numberOfApartment == apartment {
                    calendarViewController.clientsString.append(clientString)
                }
            }
            
        }
    }
}

extension MainViewController: CalendarViewControllerDelegate {
    func updateCollection(apartment: Int, selectedRow: [Int], clientsStringForApartment: [ClientString], newClienstString: [ClientString]) {



//        for editRow in selectedRow {
//            var numberOfAllClients = -1
//            var numberOfClientsForApartment = -1
//            for clientString in self.clientsString {
//                numberOfAllClients += 1
//                if clientString.numberOfApartment == apartment {
//                    numberOfClientsForApartment += 1
//                    if numberOfClientsForApartment == editRow {
//                        self.clientsString[numberOfAllClients] = clientsStringForApartment[editRow]
//                        self.clients[numberOfAllClients] = TransformFormatters.fromClientStringToClient(clientString: self.clientsString[numberOfAllClients])
//
//                    }
//                }
//            }
//
//        }
        var numberOfClientForAllApartments = -1
        var numberOfClientForApartments = -1
        for clientString in clientsString {
            numberOfClientForAllApartments += 1
            if clientString.numberOfApartment == apartment {
               numberOfClientForApartments += 1
                if clientsStringForApartment.count - 1 >= numberOfClientForApartments {
                    clientsString[numberOfClientForAllApartments] = clientsStringForApartment[numberOfClientForApartments]
                } else {
                    clientsString.remove(at: numberOfClientForAllApartments)
                    numberOfClientForAllApartments -= 1
                }
            }
        }
        for newClientString in newClienstString {
            self.clientsString.append(newClientString)
        }
        
        colorOfDays.createClients(clientsString: clientsString)
        self.clients = colorOfDays.clients
        colorOfDays.createArrayOfCalendarForFirstScreen()
        collectionView.reloadData()
        
        
    }
    



}
