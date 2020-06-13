//
//  AddClientTableViewController.swift
//  CalendarForApartments
//
//  Created by Виталий Косинов on 12/06/2020.
//  Copyright © 2020 Виталий Косинов. All rights reserved.
//

import UIKit

protocol AddClientTableViewControllerDelegate {
    func updateClient(client: Client)
}

class AddClientTableViewController: UITableViewController {
    
    var typesOfBooking = ["Airbnb", "Booking", "Проживает сейчас", "Бронь по предоплате", "Бронь без предоплаты"]
    
    var selectedElement: String?

    let clientVewController = ClientsViewController()
    var delegate: AddClientTableViewControllerDelegate?
    var editSegue = false
    var client = Client(dateOfArrival: Date(), numbersOfStayingDay: 0, numberOfApartment: 0, color: .white, details: "")
    var dateOfArrivalString = ""
 //   var dataIsRight = false
   
    @IBOutlet weak var dataArrivalTextField: UITextField!
    @IBOutlet weak var numberOfDaysStayingTextField: UITextField!
    @IBOutlet weak var typeOfBookingTextField: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        choiseUIElement()
        createToolBar()
        if dateOfArrivalString != "" {
            dataArrivalTextField.text = dateOfArrivalString
        }
        if editSegue == true {
            updateTextFields()
        }
        
        saveButton.isEnabled = false
        detailTextView.text = """
        Количество человек:

        Сумма предоплаты:

        Возможно ли переселить на другую кваритру:
                
        Другие подробности:
        """
        enableSaveButton()
}
    
    @IBAction func textChanged(_ sender: UITextField) {
        enableSaveButton()
    }
    
    
    func enableSaveButton() {
        let dateOfArrival = dataArrivalTextField.text ?? ""
        let numberOfDaysStaying = numberOfDaysStayingTextField.text ?? ""
        
        saveButton.isEnabled = !dateOfArrival.isEmpty && !numberOfDaysStaying.isEmpty
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
//        guard segue.identifier == "saveSegue" else { return }
//        let dateOfArrival = dataArrivalTextField.text ?? ""
//        let numberOfDaysStaying = numberOfDaysStayingTextField.text ?? ""
//        let typeOfBooking = typeOfBookingTextField.text ?? ""
//
//
//        guard let date = TransformFormatters.fronStringToDate(dateString: dateOfArrival) else {
//            let dateAlert = UIAlertController(title: "Неправильный формат даты", message: "Введите дату в формате ДДММГГГГ без точек, пробелов и других символов", preferredStyle: .alert)
//            let OKAction = UIAlertAction(title: "OK", style: .default)
//            dateAlert.addAction(OKAction)
//
//
//            present(dateAlert, animated: true, completion: nil)
//            return }
//
//        client.dateOfArrival = date
//
//        guard let number = Int(numberOfDaysStaying) else {
//
//            let alert = UIAlertController(title: "Введите количество дней проживания", message: " Введите количество дней проживания числом", preferredStyle: .alert)
//            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//            alert.addAction(OKAction)
//
//            present(alert, animated: true)
//            return
//        }
//
//        client.numbersOfStayingDay = number
//
//        let color = TransformFormatters.fromStringToColor(typeOfBooking: typeOfBooking)
//        if color == .white {
//
//            let alert = UIAlertController(title: "Тип брони не выбран", message: "Выберите откуда бронирование", preferredStyle: .alert)
//            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//            alert.addAction(OKAction)
//
//            present (alert, animated: true)
//
//            return
//        }
//
//        client.color = color
//
//        let details = detailTextView.text ?? ""
//        client.details = details

   //     dataIsRight = true
        
        
        
        
        

        
//    }
    
    func updateTextFields() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMYYYY"
        let dateOfArrival = dateFormatter.string(from: client.dateOfArrival)
        dataArrivalTextField.text = dateOfArrival
        numberOfDaysStayingTextField.text = String(client.numbersOfStayingDay)
        let typeOfBooking = TransformFormatters.fromColorToString(color: client.color)
        typeOfBookingTextField.text = typeOfBooking
        detailTextView.text = client.details
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        
        let dateOfArrival = dataArrivalTextField.text ?? ""
        let numberOfDaysStaying = numberOfDaysStayingTextField.text ?? ""
        let typeOfBooking = typeOfBookingTextField.text ?? ""

        
        guard let date = TransformFormatters.fronStringToDate(dateString: dateOfArrival) else {
            let dateAlert = UIAlertController(title: "Неправильный формат даты", message: "Введите дату в формате ДДММГГГГ без точек, пробелов и других символов", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            dateAlert.addAction(OKAction)
            
            
            present(dateAlert, animated: true, completion: nil)
            return }
        
        client.dateOfArrival = date
        
        guard let number = Int(numberOfDaysStaying) else {
            
            let alert = UIAlertController(title: "Введите количество дней проживания", message: " Введите количество дней проживания числом", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
            alert.addAction(OKAction)
            
            present(alert, animated: true)
            return
        }
        
        client.numbersOfStayingDay = number
        
        let color = TransformFormatters.fromStringToColor(typeOfBooking: typeOfBooking)
        if color == .white {
            
            let alert = UIAlertController(title: "Тип брони не выбран", message: "Выберите откуда бронирование", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(OKAction)
            
            present (alert, animated: true)
            
            return
        }
        
        client.color = color
        
        let details = detailTextView.text ?? ""
        client.details = details
        
        
        delegate?.updateClient(client: client)
        
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {

        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    func choiseUIElement() {
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        typeOfBookingTextField.inputView = elementPicker

        elementPicker.backgroundColor = UIColor(red: 198/255.0, green: 198/255.0, blue: 200/255.0, alpha: 1)

        
    }
    
    func createToolBar(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        typeOfBookingTextField.inputAccessoryView = toolBar
        
        toolBar.tintColor = .black
        toolBar.barTintColor = UIColor(red: 198/255.0, green: 198/255.0, blue: 200/255.0, alpha: 1)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}

extension AddClientTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typesOfBooking.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typesOfBooking[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedElement = typesOfBooking[row]
        typeOfBookingTextField.text = selectedElement
        typeOfBookingTextField.textColor = .black
        typeOfBookingTextField.font = UIFont.systemFont(ofSize: 18)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerViewLabel = UILabel()
        
        if let currentLabel = view as? UILabel {
            pickerViewLabel = currentLabel
        } else {
            pickerViewLabel = UILabel()
        }
        
        pickerViewLabel.textColor = .black
        pickerViewLabel.textAlignment = .center
        pickerViewLabel.font = UIFont(name: "AppleSDGothicNoo-Regular", size: 20)
        pickerViewLabel.text = typesOfBooking[row]
        
        return pickerViewLabel
    }
    
}
