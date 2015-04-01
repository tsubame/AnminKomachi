//
//  TextSampleViewController.swift
//  AnminKomachi
//
//  Created by hideki on 2015/03/07.
//  Copyright (c) 2015年 Tsubaki. All rights reserved.
//

import Foundation
import UIKit

class TextSampleViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var _fadeLabel2: FadeLabel!
    
    @IBOutlet weak var _popupView: SpringView!

    @IBOutlet weak var _hourPickerView: UIPickerView!
    
    @IBOutlet weak var _minutePickerView: UIPickerView!
    
    // ピッカービューの項目のループ回数 偶数を指定
    let _pickerLoopCount = 20
    // ピッカービューの分の表示間隔
    let _minuteInterval = 5
    
    // _hourPickerViewに表示する項目
    var _itemsOfHourPicker = [Int]()
    // _minutePickerViewに表示する項目
    var _itemsOfMinutePicker = [Int]()
    
    // アラームのセット時刻 NSDate
    var _alarmDate: NSDate? // = NSDate()

    // ピッカービューの行の高さ、フォントサイズ 画面サイズによって可変
    var _pickerRowHeight: CGFloat = 100
    var _pickerFontSize: CGFloat  = 100

    // ピッカービュー（時刻）のインデックス
    var _selectedHourIndex = 0
    // ピッカービュー（分）のインデックス
    var _selectedMinuteIndex = 0
    
    
    //var _hourPickerItems   = [String]()
    //var _minutePickerItems = [String]()
    //var _alarmHour: String?   = ""
    //var _alarmMinute: String? = ""
    
    
    // ラベル作成
    func makeFadeLabel() {
        _fadeLabel2.outlineSize  = 1.0
        _fadeLabel2.textColor    = UIColor.whiteColor()
        _fadeLabel2.outlineColor = UIColor.darkGrayColor()
        
        // ぼかした影 offsetを0にするとグローエフェクトになる
        _fadeLabel2.layer.shadowColor   = UIColor.blackColor().CGColor
        _fadeLabel2.layer.shadowRadius  = 0.5
        _fadeLabel2.layer.shadowOpacity = 0.3 //0.3
        _fadeLabel2.layer.shadowOffset  = CGSizeMake(1.0, 1.0)
        _fadeLabel2.layer.masksToBounds = false
    }
    
    //===========================================================
    // ピッカー関連
    //===========================================================
    
    // ピッカービュー（時刻、分）をまとめて生成
    func makePickers() {
        // デバイスの縦幅を取得
        let screenWidth = NSUserDefaults.standardUserDefaults().integerForKey("screenWidth")
        // ピッカービューの行の高さ、フォントサイズ設定
        _pickerRowHeight = CGFloat(screenWidth / 4)
        _pickerFontSize  = _pickerRowHeight * 0.8
        // 各行に表示する項目を作成
        makePickerItems()

        _hourPickerView.delegate   = self
        _minutePickerView.delegate = self
        
        // ピッカービューのインデックスを中央付近に
        selectNearbyCenterOfPicker()
        // ピッカービューのインデックスをアラーム時刻に
        if _alarmDate != nil {
            selectAlarmTimeOfPicker(_alarmDate!)
        }
    }
    
    // ピッカービューに表示する項目を生成
    func makePickerItems() {
        // ピッカービュー（時刻）に表示する項目を作成 0〜23 × 数ループ分
        for i in 0..<_pickerLoopCount {
            for h in 0...23 {
                _itemsOfHourPicker.append(h)
            }
        }
        
        // ピッカービュー（分）に表示する項目を作成 0〜59を数分刻みに × 数ループ分
        for i in 0..<_pickerLoopCount {
            for var m = 0; m < 60; m += _minuteInterval {
                _itemsOfMinutePicker.append(m)
            }
        }
    }
    
    // ピッカービューの選択項目から日付を取得する。時、分以外は適当な値
    func getNSDateFromPicker(hour: Int, minute: Int) -> NSDate {
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let date = calendar.dateWithEra(1, year: 2015, month: 1, day: 1, hour: hour, minute: minute, second: 0, nanosecond: 0)

        return date!
    }
    
    // ピッカービューの中央付近の0:00を選択
    func selectNearbyCenterOfPicker() {
        _selectedHourIndex  = _itemsOfHourPicker.count / 2
        _selectedMinuteIndex = _itemsOfMinutePicker.count / 2
        
        // ループ回数が偶数でなければ
        if _pickerLoopCount % 2 != 0 {
            _selectedHourIndex   -= _selectedHourIndex
            _selectedMinuteIndex -= (60 / _minuteInterval) / 2
        }
        _hourPickerView.selectRow(_selectedHourIndex, inComponent: 0, animated: false)
        _minutePickerView.selectRow(_selectedMinuteIndex, inComponent: 0, animated: false)
    }
    
    // NSDate型の変数を受け取って、ピッカービューの選択項目を変更
    func selectAlarmTimeOfPicker(date: NSDate) {
        let calendar = NSCalendar(identifier: NSGregorianCalendar)!
        let hour   = calendar.component(.HourCalendarUnit, fromDate: date)
        let minute = calendar.component(.MinuteCalendarUnit, fromDate: date)

        // 0時が選択されているのでhourの数インデックスを進める
        _selectedHourIndex += hour
        _hourPickerView.selectRow(_selectedHourIndex, inComponent: 0, animated: false)
        
        for var m = 0; m < 60; m += _minuteInterval {
            if (m == minute) {
                _minutePickerView.selectRow(_selectedMinuteIndex, inComponent: 0, animated: false)
                break
            }
            _selectedMinuteIndex++
        }
    }
    
    //===========================================================
    // アクション
    //===========================================================
    
    // セットボタンが押された時
    @IBAction func _setButtonClicked(sender: AnyObject) {
        _selectedHourIndex   = _hourPickerView.selectedRowInComponent(0)
        _selectedMinuteIndex = _minutePickerView.selectedRowInComponent(0)
        
        let hour   = _itemsOfHourPicker[_selectedHourIndex]
        let minute = _itemsOfMinutePicker[_selectedMinuteIndex]
        println("\(hour):\(minute)にアラームをセットします")
        // アラーム時刻を書き込み
        let alarmDate = getNSDateFromPicker(hour, minute: minute)
        let pref = NSUserDefaults.standardUserDefaults()
        pref.setObject(alarmDate, forKey: "alarmDate")
        pref.synchronize()
        
        _popupView.animation = "fadeOut"
        _popupView.animate()
        
        dispachAfterByDouble(1.0, {
            self._popupView.hidden = true
        })
    }
    
    @IBAction func _alarmButtonClicked(sender: AnyObject) {
        let w = _popupView.frame.width
        let h = _popupView.frame.height
        let x = _popupView.bounds.origin.x
        let y = _popupView.bounds.origin.y
        
        //_popupView.frame = CGRectMake(50, 30, w, h)
        //println(_popupView.frame)
        _popupView.hidden = false
        _popupView.animation = "squeezeDown"
        _popupView.animate()
    }
    
    //===========================================================
    // UI
    //===========================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 向き設定　必要？
        var pref = NSUserDefaults.standardUserDefaults()
        pref.setObject("landscape", forKey: "orientation")
        pref.synchronize()
        // アラーム時刻を取得
        var date: NSDate? = pref.valueForKey("alarmDate") as NSDate?
        if date != nil {
            _alarmDate = date!
        }
        
        makePickers()
        
        //println(_minutePickerItems)
        /*
        // ピッカーの選択を中央に
        var hourIndex = _pickerLoopCount / 2 * 24
        _hourPickerView.selectRow(hourIndex, inComponent: 0, animated: false)
        
        _alarmHour   = pref.stringForKey("alarmHour")
        _alarmMinute = pref.stringForKey("alarmMinute")

        let alarmMinute = _alarmMinute!
        
        println("アラームのセット時刻は\(_alarmHour):\(_alarmMinute)")
        
        _selectedHourIndex = hourIndex
        //
        for h in 0...23 {
            var hour = _hourPickerItems[h]
            if hour == _alarmHour {
                println("一致！")
                _selectedHourIndex = hourIndex + h
                _hourPickerView.selectRow(hourIndex + h, inComponent: 0, animated: false)
            }
        }
        
        var minuteIndex = _minutePickerItems.count / 2
        println(minuteIndex)
        _selectedMinuteIndex = minuteIndex
        
        for m in 0..<60 / _minuteInterval {
            var minute = _minutePickerItems[m]
            if minute == alarmMinute {
                println("一致！")
                _selectedMinuteIndex = minuteIndex
                _minutePickerView.selectRow(minuteIndex, inComponent: 0, animated: false)
                break
            }
            minuteIndex++
        }*/
    }
    
    // 回転の許可
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // タッチ
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let text = "こんばんは。今日も1日お疲れ様でした。"
        _fadeLabel2.showTextWithFade(text)
        println(text)
        
        for touch: AnyObject in touches {
            var t: UITouch = touch as UITouch
            
            println(t.view.tag)
            if t.view.tag != 100 {
                _popupView.hidden = true
            }
        }
    }
    
    //===========================================================
    // UIPickerViewDelegate
    //===========================================================
    
    //　行の高さ　可変にすべき
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(_pickerRowHeight)
    }
    
    // ピッカーの各行の生成
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var cell = UIView(frame: CGRectMake(0, 0, _pickerRowHeight, _pickerRowHeight))
        // ラベル生成
        var label = UILabel()
        label.frame = CGRectMake(0, 0, _pickerRowHeight, _pickerRowHeight)
        label.font  = UIFont(name: "Arial", size: _pickerFontSize)
        // それぞれのピッカーで処理分岐
        if pickerView.restorationIdentifier == "hourPickerView" {
            var h = _itemsOfHourPicker[row]
            if h < 10 {
                label.text = " \(h)"
            } else {
                label.text = "\(h)"
            }
        } else {
            var m = _itemsOfMinutePicker[row]
            if m < 10 {
                label.text = "0\(m)"
            } else {
                label.text = "\(m)"
            }
        }
        
        cell.addSubview(label)
        
        return cell
    }
    
    // セルの選択
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //println("selected.")
        if pickerView.restorationIdentifier == "hourPickerView" {
            _selectedHourIndex   = row
        } else {
            _selectedMinuteIndex = row
        }
    }
    
    //===========================================================
    // UIPickerViewDataSource
    //===========================================================
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 5
        
        if pickerView.restorationIdentifier == "hourPickerView" {
            count = _itemsOfHourPicker.count
        } else {
            count = _itemsOfMinutePicker.count
        }
        
        return count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
}