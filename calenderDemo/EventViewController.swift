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
    var selectedStartDay = Date()
    var selectedEndDay = Date()
    
    private var realm: Realm!
    private var schedule: Results<Schedule>!
    private var token: NotificationToken!

    
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
            selectedStartDay = datePicker.date
        } else {
            endDayField.text = "\(formatter.string(from: datePicker.date))"
            selectedEndDay = datePicker.date
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
        
        //メモ以外のtextfieldが空でないかの確認
        
        if !(titleField.text?.isEmpty)! || !(startDayField.text?.isEmpty)! || !(endDayField.text?.isEmpty)! {
            
            //埋まっている場合→保存処理
            let addedTitle = titleField.text
            let addedMemo = memoField.text
            
            let calendar = Calendar(identifier: .gregorian)
            
            //日付の加算(なぜか1日前が取得されるので)
            selectedStartDay = calendar.date(byAdding: .day, value: 1, to: selectedStartDay)!
            selectedEndDay = calendar.date(byAdding: .day, value: 1, to: selectedEndDay)!

            //roundDateで日付を整形
            let start_date_rounded =  roundDate(selectedStartDay, calendar: calendar)
            let end_date_rounded =  roundDate(selectedEndDay, calendar: calendar)
            
            let Item = [Schedule(value: ["title": addedTitle!, "memo": addedMemo!, "startDate": start_date_rounded, "endDate": end_date_rounded])]
            
            //保存
            realm = try! Realm()
            try! self.realm.write {
                self.realm.add(Item)
                print("addSuccessed", Item)
            }
            //前のページへ戻る
            dismiss(animated: true, completion: nil)
            
        } else {
            
            //空の場合→アラート表示
            let title = "保存できません"
            let message = "入力されていない箇所があります"
            let okText = "ok"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okayButton)
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    

    // Dateから年日月を抽出する関数
    func roundDate(_ date: Date, calendar cal: Calendar) -> Date {
        return cal.date(from: DateComponents(year: cal.component(.year, from: date), month: cal.component(.month, from: date), day: cal.component(.day, from: date)))!
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
