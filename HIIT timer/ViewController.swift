//
//  ViewController.swift
//  HIIT timer
//
//  Created by Jasica Wong on 5/25/18.
//  Copyright © 2018 Jasica Wong. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var countSec = 15
    var rest = 15
    var set = 1
    var workoutTime = 0
    var timer = Timer()
    let workoutSound: SystemSoundID = 1054
    let restSound: SystemSoundID = 1109
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    
    @IBOutlet weak var showLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    
    @IBAction func workoutBar(_ sender: UISlider) {
        workoutTime = Int(sender.value)
        timeLabel.text = ("\(workoutTime) secs")
    }
    @IBAction func setBar(_ sender: UISlider) {
        set = Int(sender.value)
        setLabel.text = ("\(set) sets")
    }
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startButtonPressed(_ sender: Any) {
        setsLabel.text = "Remaining Sets: \(set - 1)"
        rest = 15
        countSec = workoutTime
        workout()
        startButton?.isEnabled = false
        set -= 1
    }
    
    @IBAction func stopButtonPressed(_ sender: Any) {
        timer.invalidate()
        countSec = 0
        rest = 0
        set = 0
        timerLabel.text = ("0 secs")
        startButton?.isEnabled = true
    }
    
    func workout(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        showLabel.text = "Workout!"
        AudioServicesPlaySystemSound(workoutSound)
    }
    func runRest(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.restTime)), userInfo: nil, repeats: true)
        showLabel.text = "Rest"
        AudioServicesPlaySystemSound(restSound)
    }
    @objc func updateTimer(){
        
        countSec -= 1
        timerLabel.text = ("\(countSec) secs")
        if countSec < 1 {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            timer.invalidate()
            runRest()
        }
    }
    @objc func restTime(){
        rest -= 1
        timerLabel.text = ("\(rest) secs")
        if rest < 1 {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            timer.invalidate()
            startButton?.isEnabled = true
            if set > 0{
                rest = 15
                startButtonPressed(self)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

