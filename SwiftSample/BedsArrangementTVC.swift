//
//  BedsArrangementTVC.swift
//  Makent
//
//  Created by trioangle on 17/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
protocol BedTypeShowAllClickedDelegate {
    func tappedShowAll(_ model:[BedTypeModel],title:String)
}

class BedsArrangementTVC: UITableViewCell {
    
    @IBOutlet weak var bedTypeCollectionView: UICollectionView!
    
  //  @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bedTypeCVHeightConstraint: NSLayoutConstraint!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var bed_room_beds = [[BedTypeModel]]()
    var titleArray = [String]()
   
    var showAllDelegate:BedTypeShowAllClickedDelegate?
    override func awakeFromNib() {
        bedTypeCollectionView.dataSource = self
        bedTypeCollectionView.delegate = self
       // titleLabel.customFont(.bold)
    }
}
extension BedsArrangementTVC:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bed_room_beds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bedsArrangementCVC", for: indexPath) as! BedsArrangementCVC
        
        cell.contentView.cornerRadius = 3
        cell.contentView.border(0.5, .black)
        let bedsTypeDictArray = self.bed_room_beds[indexPath.row]
        cell.total_bedsArray = bedsTypeDictArray
//        if self.isCommonBeds && indexPath.row == bed_room_beds.count - 1 {
//
//
//            cell.bedTitleLabel.text = self.lang.commonSpace
//        }else {
       //     cell.bedTitleLabel.text = self.titleArray[indexPath.row]
            
//        }
        if bedsTypeDictArray.count < 5 {
            
            cell.showAllLabel.isHidden = true
        }else {
            cell.showAllLabel.isHidden = false
            cell.showAllLabel.text = "+\(bedsTypeDictArray.count-4)"
        }
        
        
        cell.showAllLabel.addTap {
            self.showAllDelegate?.tappedShowAll(bedsTypeDictArray, title: cell.bedTitleLabel.text!)
        }
        cell.itemCollectionView.reloadData()
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    


    
}

class BedsArrangementCVC: UICollectionViewCell,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var bedTitleLabel: UILabel!
    
    @IBOutlet weak var showAllLabel: UILabel!
    
    override func awakeFromNib() {
        self.showAllLabel.customFont(.bold, textColor: .appTitleColor)
        self.bedTitleLabel.customFont(.bold)
        
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
    }
    
    var total_bedsArray = [BedTypeModel]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return total_bedsArray.count > 4 ? 4: total_bedsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bedTypeItemCVC", for: indexPath) as! BedTypeItemCVC
        let model = total_bedsArray[indexPath.row]
        cell.itemLabel.text = "\(model.count) \(model.name)"
        cell.itemImageView.addRemoteImage(imageURL: model.icon, placeHolderURL: "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2)-10, height: collectionView.frame.height/2)
    }
    
    
    
}


class BedTypeItemCVC: UICollectionViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    override func awakeFromNib() {
        self.itemLabel.customFont(.medium)
    }
}


class BedTypeModel {
    let id : Int
    let name : String
    let icon : String
    
    var count = 0
    var iconURL : URL?{
        return URL(string: self.icon)
    }
    init(_ json : JSONS) {
        self.id = json.int("id")
        self.name = json.string("name")
        self.icon = json.string("icon")
        self.count = json.int("count")
    }
}

