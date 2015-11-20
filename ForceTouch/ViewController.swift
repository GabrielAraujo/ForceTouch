//
//  ViewController.swift
//  ForceTouch
//
//  Created by Gabriel Araujo on 20/11/15.
//  Copyright © 2015 Innuv. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    /*Outlets*/
    @IBOutlet weak var forceLabel: UILabel!
    
    /* Variables */
    let imgView:UIImageView = UIImageView()
    var imgActive = false
    let sound =  NSBundle.mainBundle().URLForResource("BreakingSound", withExtension: "mp3")!
    var beepPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Touches */
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !imgActive {
            if let touch = touches.first {
                if #available(iOS 9.0, *) {
                    if traitCollection.forceTouchCapability == UIForceTouchCapability.Available {
                        if touch.force >= touch.maximumPossibleForce {
                            forceLabel.text = "OMFG you are HULK"
                            self.addPicture(touch)
                            self.addDoubleTap(self.view)
                            playMySound()
                        } else {
                            let force = touch.force/touch.maximumPossibleForce
                            let grams = force * 385
                            let roundGrams = Int(grams)
                            forceLabel.text = "\(roundGrams) grams"
                        }
                    }
                }
            }
        }
    }
    
    /* Helper */
    func addPicture(_touch:UITouch) {
        let img = UIImage(named: "brokenGlass")
        imgView.image = img!
        let point:CGPoint = _touch.locationInView(self.view)
        imgView.frame = CGRect(x: point.x - (img!.size.width/2), y: point.y - (img!.size.height/2), width: img!.size.width, height: img!.size.height)
        self.addDoubleTap(imgView)
        self.view.addSubview(imgView)
        self.view.sendSubviewToBack(imgView)
        imgActive = true
    }
    
    func removePicture(){
        self.imgView.removeFromSuperview()
        imgActive = false
        forceLabel.text = ""
    }
    
    func addDoubleTap (_view:UIView){
        let doubleTap = UITapGestureRecognizer(target: self, action: "removePicture")
        doubleTap.numberOfTapsRequired = 2
        _view.addGestureRecognizer(doubleTap)
    }
    
    func playMySound(){
        do {
            self.beepPlayer = try AVAudioPlayer(contentsOfURL: self.sound)
            self.beepPlayer.prepareToPlay()
            self.beepPlayer.play()
        }catch {
            print("Error plying audio")
        }
    }
}

