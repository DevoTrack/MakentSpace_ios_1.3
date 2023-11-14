//
//  ProgressIndicatorView.swift
//  Makent
//
//  Created by trioangle on 18/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ProgressIndicatorView: UIView {
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var progressBarWidth: NSLayoutConstraint!
    @IBOutlet weak var progressBarStackView: UIStackView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        progressBar.trackTintColor = .white
        progressBar.tintColor = .systemRed
    }
    
    var timer = Timer()
    var poseDuration = 3
    var indexProgressBar = 0
    var currentPoseIndex = 0
        // initialise the display
    
    func callProgressBar()
    {
        // display the first pose
        getNextPoseData()
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setProgressBar), userInfo: nil, repeats: true)
    }
    
    func getNextPoseData()
    {
        // do next pose stuff
        currentPoseIndex += 1
        print(currentPoseIndex)
    }
    
    @objc func setProgressBar()
    {
        if indexProgressBar == poseDuration
        {
            getNextPoseData()
            
            // reset the progress counter
            indexProgressBar = 0
            currentPoseIndex = 0
        }
        // update the display
        // use poseDuration - 1 so that you display 20 steps of the the progress bar, from 0...19
        progressBar.progress = Float(indexProgressBar) / Float(poseDuration - 1)
        progressBar.tintColor = .systemRed
        // increment the counter
        indexProgressBar += 1
    }
  
}
