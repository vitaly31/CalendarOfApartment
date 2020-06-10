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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
}
