//
//  PickerSampleViewController.swift
//  AnminKomachi
//
//  Created by hideki on 2015/03/31.
//  Copyright (c) 2015年 Tsubaki. All rights reserved.
//

import Foundation
import UIKit
//import SQLite

class PickerSampleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //@IBOutlet weak var _datePicker: UIDatePicker!

    @IBOutlet weak var _hourPicker: UIPickerView!
    
    @IBOutlet weak var _minutePicker: UIPickerView!
    
    var _hourItems   = [Int]()
    var _minuteItems = [Int]()
    
    //===========================================================
    // 画面遷移
    //===========================================================
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    // 画面遷移 戻り
    @IBAction func returnToHome(segue: UIStoryboardSegue) {

    }
    
    //===========================================================
    // UI
    //===========================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //_datePicker.delegate = self
        _hourPicker.delegate = self
        _minutePicker.delegate = self
        //_picker.
        
        for i in 0...23 {
            _hourItems.append(i)
        }

        for i in 0...59 {
            if i % 5 == 0 {
                _minuteItems.append(i)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    // 回転の許可
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // ステータスバーを非表示
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /*
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        
    }*/
    
    //===========================================================
    // UIPickerViewDelegate
    //===========================================================
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        println("test.")
        
        return 120 //200
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var cell = UIView(frame: CGRectMake(0, 0, 120, 120))
        var label = UILabel()
        label.frame = CGRectMake(0, 0, 120, 120)
        label.font = UIFont(name: "Arial", size: 100)

        
        if pickerView.tag == 10 {
            var i = _hourItems[row]
            if i < 10 {
                label.text = " \(i)"
            } else {
                label.text = "\(i)"
            }
        } else {
            var i = _minuteItems[row]
            if i < 10 {
                label.text = "0\(i)"
            } else {
                label.text = "\(i)"
            }
        }
        
        cell.addSubview(label)
        return cell
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("selected.")
    }
    
    //===========================================================
    // UIPickerViewDataSource
    //===========================================================
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        
        if pickerView.tag == 10 {
            count = _hourItems.count
        } else {
            count = _minuteItems.count
        }
        
        return count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
}