//
//  MainViewController.swift
//  CalendarForApartments
//
//  Created by Виталий Косинов on 10/06/2020.
//  Copyright © 2020 Виталий Косинов. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    let colorOfDays = ColorOfDays()
   
    let itemPerRow: CGFloat = 7
    let itemPerColumn: CGFloat = 12
    let sectionInsets = UIEdgeInsets(top: 2.5, left: 5, bottom: 2.5, right: 5)
    
    @IBOutlet var datesLabel: [UILabel]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorOfDays.datesForTitle()
        updateDatesLabel()
        dateInLabel()
        collectionView.dataSource = self
        collectionView.delegate = self
        colorOfDays.createArrayOfCalendarForFirstScreen()
        // Do any additional setup after loading the view.
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
        }
    }
}
