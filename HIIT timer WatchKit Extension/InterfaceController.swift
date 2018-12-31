//
//  InterfaceController.swift
//  HIIT timer WatchKit Extension
//
//  Created by Jasica Wong on 5/25/18.
//  Copyright © 2018 Jasica Wong. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class InterfaceController: WKInterfaceController {
    
    var countSec = 15
    var rest = 15
    var set = 1
    var workoutTime = 0
    var timer = Timer()
//    var isTimerRunning = false
//    var workoutSession : HKWorkoutSession?
    
    @IBOutlet var timeLabel: WKInterfaceLabel!
    @IBOutlet var setLabel: WKInterfaceLabel!
    
    @IBAction func workoutBar(_ value: Float) {
        workoutTime = Int(Float(value))
        timeLabel.setText("\(workoutTime) secs")
    }
    @IBOutlet var timerLabel: WKInterfaceLabel!
    
    @IBAction func setBar(_ value: Float) {
        set = Int(Float(value))
        setLabel.setText("\(set) sets")
    }
    @IBOutlet var startButton: WKInterfaceButton!
    @IBAction func startButtonPressed() {
        print(set)
        countSec = workoutTime
        rest = 15
        workout()
        startButton?.setEnabled(false)
        set -= 1
    }
    
    func workout(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(InterfaceController.updateTimer)), userInfo: nil, repeats: true)
    }
    func runRest(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(InterfaceController.restTime)), userInfo: nil, repeats: true)
    }
    @objc func updateTimer(){
        
        countSec -= 1
        timerLabel.setText("\(countSec) secs")
        if countSec < 1 {
            WKInterfaceDevice.current().play(.notification)
            timer.invalidate()
            runRest()
        }
    }
    @objc func restTime(){
        rest -= 1
        timerLabel.setText("\(rest) secs")
        if rest < 1 {
            WKInterfaceDevice.current().play(.directionUp)
            timer.invalidate()
            startButton?.setEnabled(true)
            if set > 0{
                startButtonPressed()
                rest = 15
            }
        }
    }
    
    @IBAction func stopButtonPressed() {
        timer.invalidate()
        countSec = 0
        rest = 0
        timerLabel.setText("0 secs")
        startButton?.setEnabled(true)
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
