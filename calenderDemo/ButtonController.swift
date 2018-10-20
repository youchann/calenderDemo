//
//  ButtonController.swift
//  calenderDemo
//
//  Created by yutaro on 2018/10/10.
//  Copyright © 2018年 yutaro. All rights reserved.
//

import UIKit

// global
var globalDate:Date = Date()

class ButtonController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //ナビゲーションバーの非表示
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    //追加ボタンを押した時の処理
    @IBAction func onClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SecondController = storyboard.instantiateViewController(withIdentifier: "Insert") as! EventViewController
        
        present(SecondController, animated: true, completion: nil)
    }
    
    
    //push画面遷移から戻ってきた時
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //ナビゲーションバーの非表示
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
