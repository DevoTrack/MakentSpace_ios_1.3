//
//  OwnerDetailMapTVC.swift
//  Makent
//
//  Created by trioangle on 06/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation


class OwnerDetailMapTVC: UITableViewCell {
    
    @IBOutlet weak var maplayerImageView: UIImageView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    override func awakeFromNib() {
        print("OwnerDetailMap")
        self.maplayerImageView.image = Constants.maplayer
        self.maplayerImageView.tintColor = UIColor.appGuestThemeColor
    }
    func setMapInfo(roomDetailDict : SpaceDetailData)
    {
        locationLabel?.text = "\(roomDetailDict.locationData.city)\(" , ")\(roomDetailDict.locationData.state)"
        locationLabel?.layer.shadowColor = UIColor.black.cgColor;
        locationLabel?.layer.shadowOffset = CGSize(width:0, height:1.0);
        locationLabel?.layer.shadowOpacity = 0.5;
        locationLabel?.layer.shadowRadius = 1.0;
        locationLabel?.layer.cornerRadius = 5
        locationLabel?.clipsToBounds = true
        let Width = 640
        let Height = 620
        let mapImageUrl = "https://maps.googleapis.com/maps/api/staticmap?center="
        let key = "&key=" +  GOOGLE_MAP_API_KEY
        let latlong = String(format:"\(roomDetailDict.locationData.latitude), \(roomDetailDict.locationData.longitute)")
        let mapUrl  = mapImageUrl + latlong
        let size = "&size=" +  "\(Int(Width))" + "x" +  "\(Int(Height))"
        let positionOnMap = "&markers=size:mid|color:red|" + latlong
        let staticImageUrl = mapUrl + size + positionOnMap + key
        if let urlStr = staticImageUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)! as NSString?{
            mapImageView.addRemoteImage(imageURL: urlStr as String, placeHolderURL: "")
                //.sd_setImage(with: NSURL(string: urlStr as String)! as URL, placeholderImage:UIImage(named:"car_default_no_photos"))
        }
    }
}
