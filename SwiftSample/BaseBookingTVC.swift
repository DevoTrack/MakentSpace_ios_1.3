//
//  BaseBookingTVC.swift
//  Makent
//
//  Created by trioangle on 08/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit


enum BookingDetailsTypeEnum
{
    case trips
    case inbox
    case reservation
    var apiMethod: String {
        switch self {
        case .trips:
            return "booking_details"
        case .inbox:
            return "inbox"
        case .reservation:
            return "reservation_list"
            
        }
    }
}

class CellTrips: UITableViewCell
{
    @IBOutlet weak var datelblHeight: NSLayoutConstraint! // 20
    @IBOutlet weak var bookNowBtnWidthConstrain: NSLayoutConstraint! //75
    @IBOutlet weak var priceLblWidthConstraint: NSLayoutConstraint! // 42
    @IBOutlet weak var lblPrice: UILabel?
    @IBOutlet var lblTripStatus: UILabel?
    
    @IBOutlet var lblUserName: UILabel?
    @IBOutlet var lblTripDate: UILabel?
    @IBOutlet var lblDetails: UILabel?
    @IBOutlet var lblLocation: UILabel?
    
    @IBOutlet var imgUserThumb: UIImageView?
    @IBOutlet var btnBookNow: UIButton?
    var cellType: BookingDetailsTypeEnum!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    
    override func awakeFromNib() {
        self.initLayoutView()
    }
    
    
    func setTripsDetails(tripsModel:TripBookingModel)
    {
        self.setBasicDetails(model: tripsModel)
        self.lblUserName?.text = tripsModel.hostUserName
        self.imgUserThumb?.addRemoteImage(imageURL: tripsModel.hostThumbImage, placeHolderURL: "avatar_placeholder", isRound: true)
        if tripsModel.bookingStatus == "Available" && tripsModel.reservationStatus == "Pre-Accepted" {
            btnBookNow?.appGuestSideBtnBG()
            self.showBookNowBtn(self.lang.Book_Now)
        }else {
            self.hideBookNowBtn()
        }
    }
    func setInboxDetails(inboxModel:InboxBookingModel)
    {
        self.setTripStatus(model: inboxModel)
        self.lblUserName?.text = inboxModel.otherUserName
        inboxModel.lastMessage.isEmpty ? self.hideDateLbl() : self.showdateLbl()
        self.lblTripDate?.text = inboxModel.lastMessage
        btnBookNow?.appGuestSideBtnBG()
        self.lblDetails?.text = inboxModel.spaceLocation
        self.lblDetails?.numberOfLines = 1
//        self.lblDetails?.text = ""
        self.lblLocation?.text = inboxModel.reservationDate
        self.imgUserThumb?.addRemoteImage(imageURL: inboxModel.otherThumbImage, placeHolderURL: "avatar_placeholder", isRound: true)
        self.lblTripStatus?.text = inboxModel.reservationStatus
        print("messageRead",inboxModel.isMessageRead)
        if inboxModel.bookingStatus == "Available" && inboxModel.reservationStatus == "Pre-Accepted" {
            btnBookNow?.appGuestSideBtnBG()
//            self.showBookNowBtn(self.lang.Book_Now)
        }else {
//            self.hideBookNowBtn()
        }
        if inboxModel.isMessageRead == 0
        {
             self.showPriceLbl(result:"\("•")\(" ")\(inboxModel.currencySymbol)\(inboxModel.totalCost)")
        }
        else
        {
             self.showPriceLbl(result: "\(inboxModel.currencySymbol)\(inboxModel.totalCost)")
        }
        self.hideBookNowBtn()
        
    }
    func setReservationDetails(reservationModel:ReservationBookingModel)
    {
        self.setBasicDetails(model: reservationModel)
        self.lblUserName?.text = reservationModel.otherUserName
        btnBookNow?.appHostSideBtnBG()
        self.imgUserThumb?.addRemoteImage(imageURL: reservationModel.otherThumbImage, placeHolderURL: "avatar_placeholder", isRound: true)
        if reservationModel.reservationStatus == "Pending" {
            self.showBookNowBtn(self.lang.preAccepted)
        }else {
            self.hideBookNowBtn()
        }
    }
    
    private func hideBookNowBtn() {
        self.btnBookNow?.isHidden = true
        self.bookNowBtnWidthConstrain.constant = 0
    }
    
    private func showBookNowBtn(_ result:String) {
        self.btnBookNow?.isHidden = false
        self.btnBookNow?.setTitle(result, for: .normal)
    }
    
    
    func showdateLbl(){
        self.lblTripDate?.isHidden = false
        self.datelblHeight.constant = self.lblTripDate?.intrinsicContentSize.height ?? 20
    }
    
    func hideDateLbl() {
        self.lblTripDate?.isHidden = true
        self.datelblHeight.constant = 0
    }
    
    func showPriceLbl(result:String) {
        self.lblPrice?.isHidden = false
        self.lblPrice?.text = result
        self.lblPrice?.appGuestTextColor()
        self.priceLblWidthConstraint.constant = self.lblPrice?.intrinsicContentSize.width ?? 42
    }
    
    func hidePriceLbl() {
        self.lblPrice?.isHidden = true
        self.priceLblWidthConstraint.constant = 0
    }
    
    private func setBasicDetails(model:BaseBookingModel) {
        self.lblTripDate?.text = model.reservationDate
        self.lblDetails?.text = model.spaceName
        self.lblLocation?.text = model.spaceLocation
        self.hidePriceLbl()
        self.showdateLbl()
        self.setTripStatus(model: model)
        
    }
    
    private func setTripStatus(model:BaseBookingModel){
        lblTripStatus?.textColor = Constants().setTripStatusColor(model)
        self.lblTripStatus?.text = Constants().setTripStatus(model)
    }
    
    private func initLayoutView() {
        btnBookNow?.cornerRadius = 3.0
        
        lblUserName?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblDetails?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblTripDate?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblLocation?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        lblPrice?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .right)
        
    }
}
