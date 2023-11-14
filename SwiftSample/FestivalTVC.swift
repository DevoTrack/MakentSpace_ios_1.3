//
//  FestivalTVC.swift
//  Makent
//
//  Created by trioangle on 26/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class FestivalTVC : UITableViewCell
{
  
    @IBOutlet weak var priceTitleLbl: UILabel!
    @IBOutlet weak var priceParentView: UIView!
    @IBOutlet weak var festivalHeightCVC: NSLayoutConstraint!
    
    @IBOutlet weak var festivalCVC: UICollectionView!
    
    var festivalData : SpaceDetailData!
   
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    override func awakeFromNib()
    {
        festivalCVC.delegate = self
        festivalCVC.dataSource = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.festivalHeightCVC.constant = self.festivalCVC.collectionViewLayout.collectionViewContentSize.height
        print("$$$$ reuse height:", self.festivalHeightCVC.constant)
    }
    
}

extension FestivalTVC: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Festival Collectionview cell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FestivalCVCID", for: indexPath) as! FestivalCollectionViewCell
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        //cell.backgroundColor = .red
        print("currency symbol",Currency.shared.findSymbol(currencyCode: festivalData.spaceActivities[indexPath.row].currency_code))
        cell.pricingImg.addRemoteImage(imageURL: festivalData.spaceActivities[indexPath.row].image_url
            , placeHolderURL: "", isRound: false)
        cell.pricingTitle.text   = festivalData.spaceActivities[indexPath.row].activity_name
        cell.pricingValues.text  = String("\(self.lang.hourly_Rate)\(" : ")\(Currency.shared.findSymbol(currencyCode: festivalData.spaceActivities[indexPath.row].currency_code))\(festivalData.spaceActivities[indexPath.row].hourly) \n\(self.lang.full_Day_Rate)\(" : ")\(Currency.shared.findSymbol(currencyCode: festivalData.spaceActivities[indexPath.row].currency_code))\(festivalData.spaceActivities[indexPath.row].full_day) \n\(self.lang.minimum_Booking_Hours)\(" : ")\(festivalData.spaceActivities[indexPath.row].min_hours)")
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  festivalData.spaceActivities.count
    }
}

extension FestivalTVC: UICollectionViewDelegate
{
    
    
}

//extension FestivalTVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        print("Coming into the size of the intex")
//        let padding: CGFloat =  10
//        let collectionViewSize = collectionView.frame.size.width - padding
//
//        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
//    }
//}

class FestivalCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var pricingTitle: UILabel!
    
    @IBOutlet weak var pricingImg: UIImageView!
    
    @IBOutlet weak var pricingValues: UILabel!
    
}

class Currency {
    static let shared: Currency = Currency()
    
    private var cache: [String:String] = [:]
    
    func findSymbol(currencyCode:String) -> String {
        if let hit = cache[currencyCode] { return hit }
        guard currencyCode.count < 4 else { return "" }
        
        let symbol = findSymbolBy(currencyCode)
        cache[currencyCode] = symbol
        
        return symbol
    }
    
    private func findSymbolBy(_ currencyCode: String) -> String {
        var candidates: [String] = []
        let locales = NSLocale.availableLocaleIdentifiers
        
        for localeId in locales {
            guard let symbol = findSymbolBy(localeId, currencyCode) else { continue }
            if symbol.count == 1 { return symbol }
            candidates.append(symbol)
        }
        
        return candidates.sorted(by: { $0.count < $1.count }).first ?? ""
    }
    
    private func findSymbolBy(_ localeId: String, _ currencyCode: String) -> String? {
        let locale = Locale(identifier: localeId)
        return currencyCode.caseInsensitiveCompare(locale.currencyCode ?? "") == .orderedSame
            ? locale.currencySymbol : nil
    }
}

extension String {
    var currencySymbol: String { return Currency.shared.findSymbol(currencyCode: self) }
}
