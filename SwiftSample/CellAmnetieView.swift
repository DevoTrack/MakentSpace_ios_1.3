//
//  CellAmnetieView.swift
//  Makent
//
//  Created by trioangle on 06/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class CellAmenitiesView: UITableViewCell
{
    @IBOutlet var lblAmenities: UILabel?
    @IBOutlet var imgAminityOne: UILabel?
    @IBOutlet var imgAminityTwo: UILabel?
    @IBOutlet var imgAminityThree: UILabel?
    @IBOutlet var imgAminityFour: UILabel?
    var delegate: AmenitiesCellDelegate?
    var arrimg = ["A","B","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    func setAmenitiesData(roomDetailDict : [String:Any])
    {
        lblAmenities?.textColor = k_AppThemeColor
        if (roomDetailDict["amenities_values"] as? [[String:Any]] ?? [[String:Any]]()).count <= 4 {
            
            self.lblAmenities?.isHidden = true
        }else {
            
            self.lblAmenities?.text = "+\((roomDetailDict["amenities_values"] as? [[String:Any]] ?? [[String:Any]]()).count - 4)"
        }
        
        let amenityArray = [imgAminityOne, imgAminityTwo, imgAminityThree, imgAminityFour]
        
        for i in 0..<(roomDetailDict["amenities_values"] as? [[String:Any]] ?? [[String:Any]]()).count {
            
            if i < 4 {
                if (((roomDetailDict["amenities_values"] as? [[String:Any]] ?? [[String:Any]]())[i] as [String:Any])["icon"] as? String)?.count == 1 {
                    amenityArray[i]?.text = ((roomDetailDict["amenities_values"] as? [[String:Any]] ?? [[String:Any]]())[i] )["icon"] as? String
                }
                else {
                    amenityArray[i]?.text = "t"
                }
            }
            else {
                break
            }
            
        }
        
    }
    
    @IBAction func onAmenitiesTapped(sender:UIButton)
    {
        delegate?.onAmenitiesTapped(index: sender.tag)
    }
    
}
