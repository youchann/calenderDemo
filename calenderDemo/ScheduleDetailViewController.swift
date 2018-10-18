//
//  ScheduleDetailViewController.swift
//  calenderDemo
//
//  Created by yutaro on 2018/10/14.
//  Copyright © 2018年 yutaro. All rights reserved.
//

import UIKit
import RealmSwift

class ScheduleDetailViewController: UIViewController {

    var scheduleList: Results<Schedule>!
    var rowNum:Int!
    var selectedDate:Date!
    private var realm: Realm!
    
    @IBOutlet weak var scheduleTitle: UILabel!
    @IBOutlet weak var scheduleStartDay: UILabel!
    @IBOutlet weak var scheduleEndDay: UILabel!
    @IBOutlet weak var scheduleMemo: UITextView!
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //なぜか日付が+1されているので調整
        let calendar = Calendar.current
        selectedDate = calendar.date(byAdding: .day, value: -1, to: selectedDate)!
        let startDate = calendar.date(byAdding: .day, value: -1, to: scheduleList[rowNum].startDate)!
        let endDate = calendar.date(byAdding: .day, value: -1, to: scheduleList[rowNum].endDate)!

        //date型をstring型に変更し、ナビゲーションバーのタイトルへ表示
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let titleDate = dateFormatter.string(from: selectedDate)
        
        //選択されたオブジェクトのdate型をstring型に変更
        dateFormatter.dateFormat = "MM/dd"
        let stringStartDate = dateFormatter.string(from: startDate)
        let stringEndDate = dateFormatter.string(from: endDate)


        //ナビゲーションバーの表示
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = titleDate
        
        //選択された予定の表示
        scheduleTitle.text = scheduleList[rowNum].title
        scheduleStartDay.text = stringStartDate
        scheduleEndDay.text = stringEndDate
        scheduleMemo.text = scheduleList[rowNum].memo
        

        }
    
    
    //削除ボタンを押した時の処理
    @IBAction func deleteSchedule(_ sender: Any) {
        
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "予定の削除", message: "本当に削除しますか?", preferredStyle:  UIAlertController.Style.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            
            //削除
            self.realm = try! Realm()
            try! self.realm.write {
                self.realm.delete(self.scheduleList[self.rowNum])
            }
            
            //カレンダー画面へ戻る
            self.navigationController?.popViewController(animated: true)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)

        
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
