//
//  ViewController.swift
//  tips
//
//  Created by YouGotToFindWhatYouLove on 12/5/15.
//  Copyright © 2015 Candy. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var barSeparator: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var subView: UIView!
    
    var tipPercentages = [0.18, 0.2, 0.22]
    var subViewOriginY: CGFloat = 0
    var billFieldActive = false
    
    var previousAmountSize = 0
    var backSpaceSound: AVAudioPlayer = AVAudioPlayer()
    var enterSound: AVAudioPlayer = AVAudioPlayer()
    var clearSound: AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        appDelegate.myViewController = self
        
        imageView.animationImages = [
            
            UIImage(named: "merryChristmas.jpg")!,
            UIImage(named: "newYear.jpg")!,
            UIImage(named: "resolutions.jpg")!
        ]
        imageView.animationDuration = 5
        imageView.startAnimating()
        
        tipLabel.text = "$0.00"
        totalLabel.text="$0.00"
        self.billField.becomeFirstResponder()
        
        subViewOriginY = subView.center.y
        self.subView.center.y += self.view.bounds.height
        previousAmountSize = billField.text!.characters.count;

        let backSpaceSoundLocation = NSBundle.mainBundle().pathForResource("bubblePop2", ofType: ".mp3")

        let enterSoundLocation = NSBundle.mainBundle().pathForResource("bubblePop1", ofType: ".mp3")
        let clearSoundLocation = NSBundle.mainBundle().pathForResource("clearSound", ofType: ".mp3")
        
        do {
            backSpaceSound = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: backSpaceSoundLocation!))
            enterSound = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: enterSoundLocation!))
            clearSound = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: clearSoundLocation!))
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            
        }
        
        catch {
            print(error)
        }
        backSpaceSound.prepareToPlay()
        enterSound.prepareToPlay()
        clearSound.prepareToPlay()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaultTipIndex = defaults.integerForKey("defaultTipIndex")
        
        tipControl.selectedSegmentIndex = defaultTipIndex
        setTipAndToTal()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func onEditingChanged(sender: AnyObject) {
        
        if (billFieldActive == false ) {
            UIView.animateWithDuration(0.5, animations: {
                self.subView.center.y = self.subViewOriginY
            })
            billFieldActive = true
        }
        
        setSubView()
        setTipAndToTal()
        
        if(sender.tag == 9) {
            let currentAmountSize = billField.text!.characters.count
            
            if (previousAmountSize > currentAmountSize) {
                backSpaceSound.play()
                
            } else {
                enterSound.play()
            }
            
            if (currentAmountSize == 0) {
                previousAmountSize = 0
            } else {
                previousAmountSize = currentAmountSize
            }
        }
        
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    
    @IBAction func clearAmount(sender: AnyObject) {
        clearSound.play()
        clear()
        
    }
    
    func clear() {
        billField.text = ""
        tipLabel.text = "$0.00"
        totalLabel.text="$0.00"
        previousAmountSize = 0
        
        setSubView()

    }
    
    func setTipAndToTal() {
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let billAmount = NSString(string: billField.text!).doubleValue
        
        let tip = billAmount * tipPercentage
        
        let total = billAmount + tip
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        currencyFormatter.locale = NSLocale.currentLocale()
        tipLabel.text = currencyFormatter.stringFromNumber(tip)!
        totalLabel.text = currencyFormatter.stringFromNumber(total)!

    }
    
    // hide subView if no bill amount has been entered yet
    func setSubView() {
        if billField.text == "" {
            UIView.animateWithDuration(0.5, animations: {
                self.subView.center.y += self.view.bounds.height

            })
            billFieldActive = false
        }
    }
    
    
    
    

    
    
    
}

