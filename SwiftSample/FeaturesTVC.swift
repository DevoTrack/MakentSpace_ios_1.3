//
//  FeaturesTVC.swift
//  Makent
//
//  Created by trioangle on 24/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

protocol FeatureCellDelegate {
    func updateMoreModel(section:sectionHeader)
}

class FeaturesTVC : UITableViewCell
{
    
    @IBOutlet weak var featureCV: UICollectionView!
    
    @IBOutlet weak var featureCVheight: NSLayoutConstraint!
    
    @IBOutlet weak var headerTitle: UILabel!
    var delegate:FeatureCellDelegate?
    var moreTappedBoolean = false
    var headerTitleArray = [DetailSectionHeader]()
   
    var spaceDetailsModel  : SpaceDetailData!
    
    var selectedTitleValues:sectionHeader = sectionHeader.features
     let lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func awakeFromNib()
    {
        featureCV.delegate = self
        featureCV.dataSource = self
       
    }
    
    func addedHeaderTitle()
    {
        print("FeaturesData..",spaceDetailsModel)
        if spaceDetailsModel != nil
        {
            headerTitleArray.removeAll()


//            if selectedTitleValues == .features
//            {
//                if !spaceDetailsModel.guestAccess.isEmpty
//                {
//                    let model = DetailSectionHeader(title: .guestAccess, subDetailsArray: spaceDetailsModel.guestAccess, isMoreTapped: false)
//                    headerTitleArray.append(model)
//                }
//                if !spaceDetailsModel.specialFeatures.isEmpty
//                {
//                    let model = DetailSectionHeader(title: .specialFeatures, subDetailsArray: spaceDetailsModel.specialFeatures, isMoreTapped: false)
//                    headerTitleArray.append(model)
//                }
//
//                if !spaceDetailsModel.spaceRules.isEmpty
//                {
//                    let model = DetailSectionHeader(title: .spaceRules, subDetailsArray: spaceDetailsModel.spaceRules, isMoreTapped: false)
//                    headerTitleArray.append(model)
//                }
//
//                if !spaceDetailsModel.spaceStyle.isEmpty
//                {
//                    let model = DetailSectionHeader(title: .spaceStyle, subDetailsArray: spaceDetailsModel.spaceStyle, isMoreTapped: false)
//                    headerTitleArray.append(model)
//                }
//            }
//
            if selectedTitleValues == .theSpace
            {
                 if !spaceDetailsModel.theSpace.isEmpty
                {
                    let model = DetailSectionHeader(title: .theSpace, subDetailsArray: spaceDetailsModel.theSpace, isMoreTapped: false)
                    headerTitleArray.append(model)
                }
            }
            
            else
            {
                if !spaceDetailsModel.availabilityTimes.isEmpty
                {
                    let model = DetailSectionHeader(title: .theSpaceAvailability, subDetailsArray: spaceDetailsModel.availabilityTimes, isMoreTapped: false)
                    headerTitleArray.append(model)
                }
            }
        }
        else
        {
            print("null values")
            return
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.featureCVheight.constant = self.featureCV.collectionViewLayout.collectionViewContentSize.height
        print("$$$$ reuse height: ", self.featureCVheight.constant)
    }
    
}

struct DetailSectionHeader {
    var title : sectionHeader
    var subDetailsArray = [Space2Type]()
    var isMoreTapped = Bool()
}

//struct DetailAvailabilitySectionHeader {
//    var title : sectionHeader
//    var subDetailsAvailabilityArray = [AvailabilityTime]()
//}

enum sectionHeader: String
{
    case guestAccess                   =  "Guest Access"
    case serviceOffered                =  "Services Offered"
    case specialFeatures               =  "Special Features"
    case spaceRules                    =  "Space Rules"
    case spaceStyle                    =  "Space Style"
    case theSpace                      =  "The Space"
    case theSpaceAvailability          =  "Space Availability"
    case theotherservices              =  "Other Services"
    case features = "Features"
}

extension FeaturesTVC: UICollectionViewDelegate
{

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        print("Coming into the size of the intex")
//        let padding: CGFloat =  20
//        let collectionViewSize = collectionView.frame.size.width - padding
//
//        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
//    }
    
}

extension FeaturesTVC: UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("count",headerTitleArray.count)
//        if selectedTitleValues == "Available Time"
//        {
//             return headerAvailabilityTitleArray.count
//        }
//        else
//        {
            return headerTitleArray.count
//        }
        //return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize(width: collectionView.frame.width, height: 40.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        print(selectedTitleValues)
        if selectedTitleValues == .theSpace
        {
            return CGSize(width: collectionView.frame.width, height: 0.0)
        }
        else if selectedTitleValues == .features
        {
            let model = headerTitleArray[section]
            print(model.title)
            
            if model.title == sectionHeader.spaceStyle
            {
                return CGSize(width: collectionView.frame.width, height: 0.0)
            }
            
            if model.title == sectionHeader.serviceOffered
            {
                return CGSize(width: collectionView.frame.width, height: 0.0)
            }
            
            return CGSize(width: collectionView.frame.width, height: 0.7)
        }
        else if selectedTitleValues == .theSpaceAvailability
        {
            return CGSize(width: collectionView.frame.width, height: 0.0)
        }
        else
        {
            return CGSize(width: collectionView.frame.width, height: 0.7)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeaderViewID", for: indexPath) as! CollectionHeaderView
            sectionHeader.featureHeaderLable.text = self.headerTitleArray[indexPath.section].title.rawValue
            return sectionHeader
        }
        if kind == UICollectionView.elementKindSectionFooter
        {
            let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionFootViewID", for: indexPath) as! CollectionFootView
            return sectionFooter
        }
        
         return UICollectionReusableView()
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return headerTitleArray[section].rawValue
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if moreTappedBoolean == false
//        {
//            return  5
//        }
//        else
//        {
//            return  10
//        }
        if selectedTitleValues == .features
        {
            if self.headerTitleArray[section].title == .theotherservices
            {
                return 1
            }
            if self.headerTitleArray[section].subDetailsArray.count > 5 && !self.headerTitleArray[section].isMoreTapped
            {
                return 6
            }
        }
        return  self.headerTitleArray[section].subDetailsArray.count

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Feature Collectionview cell")
        print("other srvice values",headerTitleArray[indexPath.section].title.rawValue)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeatureCVCID", for: indexPath) as! FeatureCollectionViewCell
        cell.featureImg.image = UIImage(named: "favorites")
       // cell.imageWidthConstraint.constant = 15

        cell.guestValues.customFont(.medium)
        if selectedTitleValues == .theSpace
        {
            
            let model  = headerTitleArray[indexPath.section].subDetailsArray[indexPath.row]
            cell.guestValues.text = "\(model.id) : \(model.name)"
            
            cell.featureImg.isHidden = false
            return cell
        }
            
      else  if selectedTitleValues == .features
        {
            if indexPath.row > 4 && !headerTitleArray[indexPath.section].isMoreTapped {
               
                cell.guestValues.text = "+\(self.lang.mr_Tit)"
                cell.imageWidthConstraint.constant = 0
                
                cell.guestValues.appTextPinkColor()
                cell.featureImg.isHidden = true
            }
           
            else if headerTitleArray[indexPath.section].title == .theotherservices
            {
                print("Other services",self.spaceDetailsModel.serviceExtra)
                cell.guestValues.text = "\(self.spaceDetailsModel.serviceExtra)"
               // cell.guestValues.text = "\(self.spaceDetailsModel.serviceExtra )\(self.lang.redmore_Title)"
//                cell.imageWidthConstraint.constant = 0
//                cell.featureImg.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                cell.featureImg.isHidden = true
               
                return cell
            }
            else
            {
                let model        = headerTitleArray[indexPath.section].subDetailsArray[indexPath.row]
                cell.guestValues.text = model.name
               
                cell.featureImg.isHidden = false
            }
            return cell
        }
        
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvaiableTimeDetailsCVCID", for: indexPath) as! AvaiableTimeDetailsCVC
            let model        = headerTitleArray[indexPath.section].subDetailsArray[indexPath.row]
            cell.timeTitleLbl.text = model.id
            cell.timeTitleLbl.customFont(.medium)
            cell.timeValueLbl.text = model.name
            cell.timeValueLbl.customFont(.medium)
            cell.featureImg.isHidden = false
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedTitleValues == .features {
            if let cell = collectionView.cellForItem(at: indexPath) as? FeatureCollectionViewCell {
                if cell.guestValues.text == "+\(self.lang.mr_Tit)" {
                    self.delegate?.updateMoreModel(section: headerTitleArray[indexPath.section].title)
                }
            }
        }
    }
    
}

extension FeaturesTVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        print("Coming into the size of the intex")
        let padding: CGFloat =  30
        let collectionViewSize = collectionView.frame.size.width - padding
        if selectedTitleValues == .theSpace
        {
            return CGSize(width: collectionViewSize, height: padding)
        }
        else if selectedTitleValues == .features
        {
            if indexPath.row > 5 && !self.headerTitleArray[indexPath.section].isMoreTapped {
                return CGSize(width: collectionViewSize/2, height: padding)
            }else
            {
                
                if headerTitleArray[indexPath.section].title == .theotherservices
                {
                    let height = MakentSupport().onGetStringHeight(collectionView.contentSize.width, strContent: self.spaceDetailsModel.serviceExtra as NSString, font: UIFont(name: Fonts.CIRCULAR_BOOK, size: 16)!)
                   // return CGSize(width: collectionViewSize, height: height)
                    return CGSize(width: collectionViewSize, height: height + 10)
                }
                else
                {
                    let model = headerTitleArray[indexPath.section].subDetailsArray[indexPath.row].name
                    let height = MakentSupport().onGetStringHeight(collectionView.contentSize.width, strContent: model as NSString, font: UIFont(name: Fonts.CIRCULAR_BOOK, size: 16)!)
                    return CGSize(width: collectionViewSize/2, height: height + 10)
                }
                
            }
            
        }
        else if selectedTitleValues == .theSpaceAvailability
        {
            let model = headerTitleArray[indexPath.section].subDetailsArray[indexPath.row].name
            
            let height = MakentSupport().onGetStringHeight(collectionView.contentSize.width, strContent: model as NSString, font: UIFont(name: Fonts.CIRCULAR_BOOK, size: 16)!)
            return CGSize(width: collectionViewSize, height: height + 10)
        }
        return CGSize(width: collectionViewSize, height: collectionViewSize/5)

    }
}

class FeatureCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var guestValues: UILabel!
    
    @IBOutlet weak var featureImg: UIImageView!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    
}

class AvaiableTimeDetailsCVC:UICollectionViewCell {
    @IBOutlet weak var timeTitleLbl: UILabel!
    
    @IBOutlet weak var featureImg: UIImageView!
    
    @IBOutlet weak var timeValueLbl: UILabel!
    
}


class CollectionHeaderView : UICollectionReusableView
{
    
    @IBOutlet weak var featureHeaderLable: UILabel!
}

class CollectionFootView : UICollectionReusableView
{
    
    @IBOutlet weak var footerLineView: UIView!
}
