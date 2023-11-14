//
//  CellRulesHolderView.swift
//  Makent
//
//  Created by trioangle on 06/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation


class CellRulesHolderView: UITableViewCell
{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var buttonTitle: UIButton!
    
    var delegate: RulesDelegate?
    
    @IBAction func onButtonAction(_ sender: Any) {
        delegate?.onRulesBlocksTapped(index: buttonTitle.tag, title: buttonTitle.currentTitle!)
    }
    
}
