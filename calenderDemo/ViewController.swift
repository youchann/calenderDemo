//
//  ViewController.swift
//  calenderDemo
//
//  Created by yutaro on 2018/10/08.
//  Copyright © 2018年 yutaro. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet weak var calender: FSCalendar!
    var selectedDate = Date()
    private var realm: Realm!
    private var schedule: Results<Schedule>!
    private var token: NotificationToken!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        
        //test追加(追加の際は日付と時刻に注意!)
//        let today_date = Date()
//        let calendar = Calendar(identifier: .gregorian)
//        let today_date_rounded =  roundDate(today_date, calendar: calendar)
//        let Item = [Schedule(value: ["title": "test", "memo": "test", "startDate": today_date_rounded, "endDate": today_date_rounded])]
//        try! self.realm.write {
//            self.realm.add(Item)
//            print("addSuccessed", Item)
//        }
        print(realm.objects(Schedule.self))
//
//        //リロード
        self.tableView.reloadData()
        // デリゲートの設定
//        self.calendar.dataSource = self
//        self.calendar.delegate = self
        
    }
    
    //データの更新するごとに実行する処理
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // RealmのScheduleを取得し，更新を監視
        realm = try! Realm()
//        token = schedule.observe { [weak self] _ in
//            self!.tableView.reloadData()
//        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        
        return nil
    }
    
    // Dateから年日月を抽出する関数
    func roundDate(_ date: Date, calendar cal: Calendar) -> Date {
        return cal.date(from: DateComponents(year: cal.component(.year, from: date), month: cal.component(.month, from: date), day: cal.component(.day, from: date)))!
    }
    
    //選択された日付に対する処理
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        //日付の取得(なぜか1日前が取得されるので調節した)
        selectedDate = date
        let calendar = Calendar.current
        selectedDate = calendar.date(byAdding: .day, value: 1, to: selectedDate)!
        self.tableView.reloadData()
    }
    
    
    //最初のテーブル表示
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let result = realm.objects(Schedule.self).filter("startDate <= %@ AND %@ <= endDate", selectedDate, selectedDate)
        print(selectedDate)
        return result.count
    }
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell", for: indexPath)
        let result = realm.objects(Schedule.self).filter("startDate <= %@ AND %@ <= endDate", selectedDate, selectedDate)
        let item = result[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }
    
    //スケジュール詳細への画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("a")
        let vc = storyboard?.instantiateViewController(withIdentifier: "detail")
        navigationController?.pushViewController(vc!, animated: true)
        print("a")
    }

    
    
}

