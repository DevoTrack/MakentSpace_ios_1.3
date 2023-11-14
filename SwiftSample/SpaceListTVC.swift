//
//  SpaceListTVC.swift
//  Makent
//
//  Created by trioangle on 30/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SpaceListTVC: UITableViewCell {

    @IBOutlet weak var spaceImage: UIImageView!
    
    @IBOutlet weak var spaceName: UILabel!
    @IBOutlet weak var listView: UIView!
    
    @IBOutlet weak var lblListSts: UILabel!
    @IBOutlet weak var spaceStatus: UILabel!
    
    @IBOutlet weak var lblFinshList: UILabel!
    
    @IBOutlet weak var lblCompltSts: UILabel!
    
    @IBOutlet weak var lblStepsLft: UILabel!
    
    @IBOutlet weak var prgsList: UIProgressView!
    
    
    @IBOutlet weak var imgVwNext: UIImageView!
    @IBOutlet weak var viewListType: UIView!
    
    @IBOutlet weak var tfListtype: DropDown!
    
    
    
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.prgsList.tintColor = UIColor.appHostThemeColor
        self.prgsList.transform = self.prgsList.transform.scaledBy(x: 1, y: 3)
        self.imgVwNext.transform = self.getAffine
        self.lblListSts.TextFont()
    }
    
    //Mark:- Space Listed Data
    func listedDataDisplay(_ listedData : BasicStpData){
        
        if listedData.status == "" || listedData.status == "Listed" || listedData.status == "Unlisted"{
            self.viewListType.layer.borderWidth = 0.8
            self.lblListSts.layer.borderWidth = 0.0
        }else{
            self.viewListType.layer.borderWidth = 0.0
            self.lblListSts.layer.borderWidth = 0.8
        }
        
        self.spaceName.text = listedData.name
        self.spaceImage.clipsToBounds = true
        let val = listedData.completed // Need to do calculation in Model for progress issue while scrolling val == 100 && (spaceListValue.adminStatus == "Listed" || spaceListValue.adminStatus == "Unlisted")
       
        
        self.prgsList.setProgress(Float(Float(val)/100.0), animated: true)
        self.lblStepsLft.text = ""
        self.lblFinshList.text = ""
        self.lblListSts.text = listedData.status
        self.lblCompltSts.text = self.lang.youarTitle + " \(val.localize)% " + self.lang.ofthrTitle
        //cell.spaceStatus.text = spaceListValue.adminStatus
        
        self.spaceImage.addRemoteImage(imageURL: listedData.photoName, placeHolderURL: "")
    }
    
    //Mark:- Space UnListed Data
    func unListedDataDisplay(_ unListedData : BasicStpData){
        self.spaceName.text = unListedData.name
        self.spaceImage.clipsToBounds = true
        let val = unListedData.completed // Need to do calculation in Model for progress issue while scrolling
        
        self.viewListType.isHidden = true
        self.lblListSts.isHidden = false
        self.tfListtype.text = ""
        if unListedData.status == "" || unListedData.status == "Listed" || unListedData.status == "Unlisted"{
            self.viewListType.layer.borderWidth = 0.8
            self.lblListSts.layer.borderWidth = 0.0
        }else{
            self.viewListType.layer.borderWidth = 0.0
            self.lblListSts.layer.borderWidth = 0.8
        }
        self.lblListSts.text = unListedData.status
        
        self.prgsList.setProgress(Float(Float(val)/100.0), animated: true)
        if val < 100 {
            self.lblFinshList.text = self.lang.fnshTitle
        }else{
            self.lblFinshList.text = ""
        }
        self.lblCompltSts.text = self.lang.youarTitle + " \(val.localize)% " + self.lang.ofthrTitle
        let rmnStps = unListedData.remain_Stps
        if rmnStps > 0{
            if rmnStps == 1{
                self.lblStepsLft.text = rmnStps.localize + " " + self.lang.mrStpTit
                
            }else{
                self.lblStepsLft.text = rmnStps.localize + " " + self.lang.mrStpsTit
                
            }
        }else{
            self.lblStepsLft.text = ""
        }
        //cell.spaceStatus.text = spaceUnListValue.adminStatus
        self.spaceImage.addRemoteImage(imageURL: unListedData.photoName, placeHolderURL: "")
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
