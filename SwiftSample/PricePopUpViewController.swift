//
//  PricePopUpViewController.swift
//  Makent
//
//  Created by trioangle on 13/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class PricePopUpViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    var popupText = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.appGuestViewBGColor()
        self.titleLbl.customFont(.medium, textColor: .white)
        self.titleLbl.text = popupText

        // Do any additional setup after loading the view.
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
