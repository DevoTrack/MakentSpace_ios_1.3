//
//  HostStepPriceTVC.swift
//  Makent
//
//  Created by trioangle on 30/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

protocol UpdateHostPriceToViewController {
    func updateHostPrice(isError:Bool)
}

class HostStepPriceTVC: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    
    @IBOutlet weak var hourlyRateParentView: UIView!
    @IBOutlet weak var hourlyRateTitleLbl: UILabel!
    @IBOutlet weak var hourlyRateView: UIView!
    @IBOutlet weak var hourlyCurrencyLbl: UILabel!
    @IBOutlet weak var hourlyRateTF: UITextField!
    
    @IBOutlet weak var minHoursParentView: UIView!
    @IBOutlet weak var minHoursTitleLbl: UILabel!
    
    @IBOutlet weak var minHoursView: UIView!
    @IBOutlet weak var minusBtnOutlet: UIButton!
    @IBOutlet weak var plusBtnOutlet: UIButton!
    @IBOutlet weak var minusLineLbl: UILabel!
    @IBOutlet weak var plusLineLbl: UILabel!
    @IBOutlet weak var minHoursLbl: UILabel!
    
    @IBOutlet weak var fullDayParentView: UIView!
    @IBOutlet weak var fullDayTitleLbl: UILabel!
    @IBOutlet weak var fullDayView: UIView!
    @IBOutlet weak var fullDayCurrencyLbl: UILabel!
    @IBOutlet weak var fullDayTF: UITextField!
    
    
    @IBOutlet weak var viewParentWeekly: UIView!
    @IBOutlet weak var lblWeeklyRate: UILabel!
    
    @IBOutlet weak var viewWeekly: UIView!
    
    @IBOutlet weak var lblWeeklyCurrency: UILabel!
    
    @IBOutlet weak var tfWeekly: UITextField!
    
    @IBOutlet weak var viewParentMonthly:UIView!
    
    @IBOutlet weak var lblMonthlyRate:UILabel!
    
    @IBOutlet weak var viewMonthly:UIView!
    
    @IBOutlet weak var lblMonthlyCurrency:UILabel!
    
    @IBOutlet weak var tfMonthly : UITextField!
    
    var priceDelegate:UpdateHostPriceToViewController?
    let maxPriceRange:Int = 4
    var currentSelectedPrice = Int()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.customFont(.bold)
        
        hourlyRateTitleLbl.customFont(.medium)
        hourlyCurrencyLbl.customFont(.bold, textColor: .white)
        hourlyCurrencyLbl.appHostBGColor()
        lblWeeklyCurrency.customFont(.bold, textColor: .white)
        lblWeeklyCurrency.appHostBGColor()
        lblMonthlyCurrency.customFont(.bold, textColor: .white)
        lblMonthlyCurrency.appHostBGColor()
        hourlyRateTF.tintColor = .appHostThemeColor
        fullDayTF.tintColor = .appHostThemeColor
        
        
        minHoursTitleLbl.customFont(.medium)
        minHoursLbl.customFont(.bold)
        
        
        minusBtnOutlet.appHostTextColor()
        minusBtnOutlet.setTitle("-", for: .normal)
        plusBtnOutlet.appHostTextColor()
        plusBtnOutlet.setTitle("+", for: .normal)
        plusLineLbl.appHostBGColor()
        minusLineLbl.appHostBGColor()
        
        fullDayTitleLbl.customFont(.medium)
        fullDayCurrencyLbl.customFont(.bold, textColor: .white)
        fullDayCurrencyLbl.appHostBGColor()
        
        
        
        self.borderView(hourlyRateView)
        self.borderView(minHoursView)
        self.borderView(fullDayView)
        self.borderView(viewWeekly)
        self.borderView(viewMonthly)
        
        
    }
    
    
    func borderView(_ view:UIView) {
        view.border(2, .appHostThemeColor)
        view.cornerRadius = 8
    }
    
    func setModelDetails(_ model:ActivityPrice) {
        let symbol = (model.currency_symbol as  String).stringByDecodingHTMLEntities
        self.titleLbl.text = model.activity_name
        self.titleImageView.addRemoteImage(imageURL: model.image_url, placeHolderURL: "")
        self.minHoursLbl.text = model.min_hours.description
        self.hourlyCurrencyLbl.text = symbol
        self.lblWeeklyCurrency.text = symbol
        self.lblMonthlyCurrency.text = symbol
        self.fullDayCurrencyLbl.text = symbol
        if model.full_day == 0 {
            self.fullDayTF.text = ""
        }else {
             self.fullDayTF.text = model.full_day.description
        }
        if model.hourly == 0 {
            self.hourlyRateTF.text = ""
        }
        else {
             self.hourlyRateTF.text = model.hourly.description
        }
        if model.weekly == 0 {
            self.tfWeekly.text = ""
        }
        else {
            self.tfWeekly.text = model.weekly.description
        }
        if model.monthly == 0 {
            self.tfMonthly.text = ""
        }
        else {
            self.tfMonthly.text = model.monthly.description
        }
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
    
    
}
