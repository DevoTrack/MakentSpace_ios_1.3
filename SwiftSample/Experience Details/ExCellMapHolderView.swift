//
//  ExCellMapHolderView.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/22/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ExCellMapHolderView: UITableViewCell
{
    @IBOutlet weak var mapLayerColor: UIImageView!
    @IBOutlet var imgMapDetails: UIImageView!
    @IBOutlet var lblLocationName: UILabel?
    @IBOutlet weak var lblCityName: UILabel!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    func setMapInfo(modelRooms : ExperienceRoomDetails)
    {
//        lblLocationName?.text = modelRooms.locaitonName
//        lblLocationName?.layer.shadowColor = UIColor.black.cgColor;
//        lblLocationName?.layer.shadowOffset = CGSize(width:0, height:1.0);
//        lblLocationName?.layer.shadowOpacity = 0.5;
//        lblLocationName?.layer.shadowRadius = 1.0;
//        lblLocationName?.layer.cornerRadius = 5
//        lblLocationName?.clipsToBounds = true

        lblCityName.text = "\(lang.wher_wlmeet) \(modelRooms.locaitonName ?? "") - \(modelRooms.cityName ?? "")"
        lblCityName.layer.shadowColor = UIColor.black.cgColor;
        lblCityName.layer.shadowOffset = CGSize(width:0, height:1.0);
        lblCityName.layer.shadowOpacity = 0.5;
        lblCityName.layer.shadowRadius = 1.0;
        lblCityName.layer.cornerRadius = 5
        lblCityName.clipsToBounds = true
        mapLayerColor.image = Constants.maplayer
        mapLayerColor.tintColor = UIColor.appGuestThemeColor.withAlphaComponent(0.8)

        let Width = 640
        let Height = 620
        let mapImageUrl = "https://maps.googleapis.com/maps/api/staticmap?center="
        let latlong = String(format:"%@ , %@",modelRooms.locLatitude!,modelRooms.locLongitude!)
        let key = "&key=" + GOOGLE_MAP_API_KEY
        let mapUrl  = mapImageUrl + latlong
        let size = "&size=" +  "\(Int(Width))" + "x" +  "\(Int(Height))"
        let positionOnMap = "&markers=size:mid|color:red|" + latlong
        let staticImageUrl = mapUrl + size + positionOnMap + key

        if let urlStr = staticImageUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! as NSString?{
            //            print(urlStr)
            imgMapDetails.addRemoteImage(imageURL: urlStr as String, placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: urlStr as String) as! URL, placeholderImage:UIImage(named:"room_default_no_photos"))
        }
    }
}
