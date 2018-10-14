//
//  EventViewController.swift
//  calenderDemo
//
//  Created by yutaro on 2018/10/10.
//  Copyright © 2018年 yutaro. All rights reserved.
//

import UIKit
import RealmSwift

class EventViewController: UIViewController, UIToolbarDelegate, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var startDayField: UITextField!
    @IBOutlet weak var endDayField: UITextField!
    @IBOutlet weak var memoField: UITextView!
    var toolBar:UIToolbar!
    var datePicker: UIDatePicker = UIDatePicker()
    var startOrEnd = true

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // ピッカー設定
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current

        // UIToolBarの設定
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black

        let toolBarBtn      = UIBarButtonItem(title: "完了", style: .plain , target: self, action: #selector(done))
        let toolBarBtnToday = UIBarButtonItem(title: "今日", style: .plain , target: self, action: #selector(today))

        toolBar.items = [toolBarBtn, toolBarBtnToday]

        // インプットビュー設定
        startDayField.inputView = datePicker
        startDayField.inputAccessoryView = toolBar
        endDayField.inputView = datePicker
        endDayField.inputAccessoryView = toolBar
    }
    
    
    //UIDatePicker「完了」ボタンの処理
    @objc func done() {
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if startOrEnd == true {
            startDayField.text = "\(formatter.string(from: datePicker.date))"
            let selectedStartDay = datePicker.date
        } else {
            endDayField.text = "\(formatter.string(from: datePicker.date))"
            let selectedEndDay = datePicker.date
        }
    }
    
    //UIDatePicker「今日」ボタンの処理
    @objc func today() {
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if startOrEnd == true {
            startDayField.text = "\(formatter.string(from: Date()))"
        } else {
            endDayField.text = "\(formatter.string(from: Date()))"
        }
    }
    
    //startDayFieldをタップした時
    @IBAction func tappedStartField(_ sender: Any) {
        startOrEnd = true
    }
    
    //endDayFieldをタップした時
    @IBAction func tappedEndField(_ sender: Any) {
        startOrEnd = false
    }
    
    
    //戻るボタンの処理
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //追加ボタンの処理
    @IBAction func addSchedule(_ sender: Any) {
        
        //前のページへ戻る
        dismiss(animated: true, completion: nil)
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
