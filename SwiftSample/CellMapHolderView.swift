//
//  CellMapHolderView.swift
//  Makent
//
//  Created by trioangle on 06/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class CellMapHolderView: UITableViewCell
{
    @IBOutlet var imgMapDetails: UIImageView!
    @IBOutlet var lblLocationName: UILabel?
    func setMapInfo(roomDetailDict: [String:Any])
    {
        lblLocationName?.text = roomDetailDict["locaiton_name"] as? String ?? String()
        lblLocationName?.layer.shadowColor = UIColor.black.cgColor;
        lblLocationName?.layer.shadowOffset = CGSize(width:0, height:1.0);
        lblLocationName?.layer.shadowOpacity = 0.5;
        lblLocationName?.layer.shadowRadius = 1.0;
        lblLocationName?.layer.cornerRadius = 5
        lblLocationName?.clipsToBounds = true
        let Width = 640
        let Height = 620
        let mapImageUrl = "https://maps.googleapis.com/maps/api/staticmap?center="
        let key = "&key=" +  " -- Your Map Key --" //GOOGLE_MAP_API_KEY
        let latlong = String(format:"\(String(describing: roomDetailDict["loc_latidude"])), \(String(describing: roomDetailDict["loc_longidude"]))")
        let mapUrl  = mapImageUrl + latlong
        let size = "&size=" +  "\(Int(Width))" + "x" +  "\(Int(Height))"
        let positionOnMap = "&markers=size:mid|color:red|" + latlong
        let staticImageUrl = mapUrl + size + positionOnMap + key
        if let urlStr = staticImageUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! as NSString?{
            imgMapDetails.addRemoteImage(imageURL: urlStr as String, placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: urlStr as String)! as URL, placeholderImage:UIImage(named:"car_default_no_photos"))
        }
    }
}
