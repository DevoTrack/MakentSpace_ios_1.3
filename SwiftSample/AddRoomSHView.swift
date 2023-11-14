//
//  AddRoomSHView.swift
//  Makent
//
//  Created by trioangle on 17/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class AddRoomSHView: UIView {

    @IBOutlet weak var roomNamelbl : UILabel!
    @IBOutlet weak var bedCountLbl : UILabel!
    @IBOutlet weak var addBedsBtn : UIButton!
    
    
    @IBOutlet weak var bedDetailLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bedDetailLbl.text = ""
        addBedsBtn.appHostSideBtnBG()
    }
    
    class func initViewFromXib()-> AddRoomSHView
    {
        let nib = UINib(nibName: "AddRoomSHView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil)[0] as! AddRoomSHView
        return view
    }
}
