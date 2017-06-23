//
//  ViewController.swift
//  MultiAsyncProcessingSample
//
//  Created by Shota Nakagami on 2017/06/21.
//  Copyright © 2017年 Shota Nakagami. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doMultiAsyncProcess()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doMultiAsyncProcess() {
        let dispatchGroup = DispatchGroup()
        // 直列キュー / attibutes指定なし
        //let dispatchQueue = DispatchQueue(label: "queue")
        
        // 並列キュー / attribute指定あり(.concurrent）
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        
        for i in 1...5 {
            dispatchGroup.enter()
            dispatchQueue.async(group: dispatchGroup) {
                [weak self] in
                self?.asyncProcess(number: i) {
                    (number: Int) -> Void in
                    print("#\(number) End")
                    dispatchGroup.leave()
                }
            }
        }
        
        // 全ての非同期処理完了後にメインスレッドで処理
        dispatchGroup.notify(queue: .main) {
            print("All Process Done!")
        }
    }
    
    // 非同期処理
    func asyncProcess(number: Int, completion: (_ number: Int) -> Void) {
        print("#\(number) Start")
        sleep((arc4random() % 100 + 1) / 100)
        completion(number)
    }
    
}

