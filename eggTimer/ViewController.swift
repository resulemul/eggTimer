//
//  ViewController.swift
//  eggTimer
//
//  Created by Resul Emül on 7/24/20.
//  Copyright © 2020 NeviPlay. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer?
    

    @IBOutlet weak var textShower: UILabel!
    @IBOutlet weak var timerBar: UIProgressView!
    
    var cookingTime: Int?
    var timer = Timer()
    var stabilCookingTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func eggButtonTapped(_ sender: UIButton) {
        if timer.isValid { // create the alert
            
                let alert = UIAlertController(title: "Do you want to clear current timer", message: "Timer is currently counting down! if you want to rearrange timer pleare click Rearrange", preferredStyle: UIAlertController.Style.alert)

                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Rearrange", style: UIAlertAction.Style.default, handler: { (action) in
                    self.timer.invalidate()
                    if let eggHardness = sender.titleLabel?.text {
                        self.textShower.text = "The Timer is Ready to Cooking \(eggHardness) Egg"
                               switch eggHardness {
                               case "Hard": self.cookingTime = 9 * 60
                               case "Medium": self.cookingTime = 7 * 60
                               case "Soft": self.cookingTime = 5 * 60
                               default: self.cookingTime = 0
                               }
                           }
                    
                }))
                alert.addAction(UIAlertAction(title: "Contunio as Current", style: UIAlertAction.Style.cancel, handler: { (action) in
                    return
                }))

                // show the alert
            self.present(alert, animated: true, completion: nil) } else {
                                   
                                    if let eggHardness = sender.titleLabel?.text {
                                        self.textShower.text = "The Timer is Ready to Cooking \(eggHardness) Egg"
                                               switch eggHardness {
                                               case "Hard": self.cookingTime = 9 * 60
                                               case "Medium": self.cookingTime = 7 * 60
                                               case "Soft": self.cookingTime = 5 * 60
                                               default: self.cookingTime = 0
                                               }
                                           }
        }
        
       
       
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if timer.isValid{return}
        if cookingTime == 0 || cookingTime == nil {return}
        
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            stabilCookingTime = cookingTime ?? 0
            textShower.text = "\(cookingTime ?? 0) seconds to Done"
        
    }
    
    @objc func updateCounter() {
        if var counter = cookingTime {
    if counter > 1 {
        textShower.text = "\(counter-1) seconds to Done"
        timerBar.progress = Float(counter-1) / Float(stabilCookingTime)
        print(counter / stabilCookingTime)
        
        
        counter -= 1
        cookingTime = counter
            }else if counter > 0 { textShower.text = "Done!!!"
        cookingTime = 0
        timerBar.progress = 0.0
                playSound()
                timer.invalidate()
            }
        }
    }
    func playSound() {
        guard let url = Bundle.main.url(forResource: "Ring_Bell", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
