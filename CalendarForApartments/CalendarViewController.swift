//
//  CalendarViewController.swift
//  
//
//  Created by Виталий Косинов on 03/06/2020.
//

import UIKit
import Koyomi

class CalendarViewController: UIViewController, KoyomiDelegate {
     public enum SelectionMode {
         case single(style: Style), multiple(style: Style), sequence(style: SequenceStyle), none
    }
    
    let colorOfDays = ColorOfDays()
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var monthButton: UIButton!
    @IBInspectable  public  var selectedStyleColor : UIColor?
         public enum SelectedTextState { case change(UIColor), keeping }
         public var selectedDayTextState: SelectedTextState?
         public enum SequenceStyle { case background, circle, semicircleEdge, line }
         public enum Style { case background, circle, line }
    
     
     // default selectionMode is single, circle style
     public var selectionMode: SelectionMode = .single(style: .circle)
     
     // call selectionStyle
   

    public enum MonthType { case previous, current, next }
    @IBOutlet weak var koyomi: Koyomi!
    override func viewDidLoad() {
        super.viewDidLoad()

        koyomi.calendarDelegate = self

        colorOfDays.createArray() {completionHendler in
            for date in completionHendler {
                print(date.colorOfDate)
                       }
            
        }
        selectDates()
   //     monthButton.titleLabel?.text = "Следующий месяц"
        monthButton.setTitle("Следующий месяц", for: .normal)
        monthButton.layer.cornerRadius = 10
        changeButton.layer.cornerRadius = 10
        addButton.layer.cornerRadius = 10
        koyomi.display(in: .current)
        koyomi.isHiddenOtherMonth = true
      //  let currentDateString = koyomi.currentDateString()
        koyomi.weeks = ("ВС", "ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ")
        koyomi.selectionMode = .sequence(style: .circle)
        koyomi.selectedDayTextState = .change(.white)
        koyomi.style = .blue
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
        
        let today = Date()

        //let weekLaterDay = Calendar.current.date(components.day, matchesComponents: today)
        let weekLaterDay = Calendar.current.date(byAdding: .day, value: 7, to: today)
        koyomi.setDayBackgrondColor(.black, of: today, to: weekLaterDay)
        koyomi.select(date: today, to: weekLaterDay)
    }
    
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        
        let timeZone = TimeZone(identifier: "Europe/Moscow")
        let moscowDay = Calendar.current.dateComponents(in: timeZone!, from: date!)
        print(moscowDay)
    }
    // change month
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
