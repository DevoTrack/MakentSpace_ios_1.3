//
//  WhosComingController.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/9/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class WhosComingController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(WhosComingTypeACell.nib(), forCellReuseIdentifier: WhosComingTypeACell.reuseIdentifier())
            tableView.register(WhosComingTypeBCell.nib(), forCellReuseIdentifier: WhosComingTypeBCell.reuseIdentifier())
            tableView.register(WhosComingTypeCCell.nib(), forCellReuseIdentifier: WhosComingTypeCCell.reuseIdentifier())
            tableView.tableHeaderView = tableHeaderView
        }
    }
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var tableHeaderView: UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.width-(40), height: 80))
        label.text = lang.who_ComingTitle//"Who's coming?"
        label.textColor = UIColor.rgb(from: 0x5C5E66)
        label.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: 24)!
        view.addSubview(label)
        return view
    }

    lazy var guestArray: [Guest] = [
        Guest(
            firstName: Constants().GETVALUE(keyname: APPURL.USER_FIRST_NAME) as String,
            lastName: Constants().GETVALUE(keyname: APPURL.USER_LAST_NAME) as String,
            email: "",
            profilePicture: Constants().GETVALUE(keyname: APPURL.USER_IMAGE_THUMB) as String
        )
    ]

    var checkAvailablityModel: CheckDateAvailablity!
    var experienceDetails: ExperienceRoomDetails!
    var datePicked: String!
    var toRemoveTheSelf:Guest!
    var selectedIndexPathRow : Int!
    
    @IBOutlet weak var nxt_Btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toRemoveTheSelf = guestArray.first
        NotificationCenter.default.addObserver(self, selector: #selector(WhosComingController.keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WhosComingController.keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        self.nxt_Btn.setTitle(self.lang.next_Tit, for: .normal)
        nxt_Btn.appGuestSideBtnBG()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapNext(_ sender: Any) {
        let exBookingController = UIStoryboard(name: "ExperienceDetails", bundle: nil).instantiateViewController(withIdentifier: "ExBookingController") as! ExBookingController
        exBookingController.strRoomID = (experienceDetails?.experienceId!)!
        exBookingController.handPickedGuests = guestArray.filter{$0.firstName != toRemoveTheSelf.firstName && $0.lastName != toRemoveTheSelf.lastName}
        exBookingController.availablityModel = checkAvailablityModel
        exBookingController.strHostUserId = (experienceDetails.hostUserId?.description)!
        exBookingController.datePicked = datePicked
        exBookingController.experienceDetails = experienceDetails
        self.navigationController?.pushViewController(exBookingController, animated: true)
    }

    // MARK: Keyboard Notifications

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            self.tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        })
    }

}

extension WhosComingController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestArray.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { //Me
            let cell = tableView.dequeueReusableCell(withIdentifier: WhosComingTypeACell.reuseIdentifier()) as! WhosComingTypeACell
            let guest = guestArray[indexPath.row]
            cell.nameLabel.text = guest.fullName
            
            cell.profileImageView.addRemoteImage(imageURL: guest.profilePicture ?? "", placeHolderURL: "")
                //.sd_setImage(with: URL(string: guest.profilePicture!))
            return cell
        }else if indexPath.row == guestArray.count { //Add guest
            let cell:WhosComingTypeCCell = tableView.dequeueReusableCell(withIdentifier: WhosComingTypeCCell.reuseIdentifier()) as! WhosComingTypeCCell
            cell.titleLabel.text = self.lang.addanogues_Title
            if (experienceDetails?.noOfGuest)! > guestArray.count   {
                cell.addGuestButton.addTarget(self, action: #selector(didTapAddGuest), for: .touchUpInside)
                cell.addGuestButton.isHidden = false
                cell.addGuestButton.setTitle(self.lang.addgues_Tit, for: .normal)
                cell.titleLabel.isHidden = false
                cell.lineView.isHidden = false
            }
            else{
                cell.addGuestButton.isHidden = true
                cell.titleLabel.isHidden = true
                cell.lineView.isHidden = true
            }
            return cell
        }else { //Guest
            let cell:WhosComingTypeBCell = tableView.dequeueReusableCell(withIdentifier: WhosComingTypeBCell.reuseIdentifier()) as! WhosComingTypeBCell
            cell.nameLabel.text = guestArray[indexPath.row].fullName
            cell.editButton.setTitle(self.lang.edtgues_Tit , for: .normal)
            cell.guest = guestArray[indexPath.row]
            cell.editButton.addTarget(self, action: #selector(self.didTapEditGuest(sender:)), for: .touchUpInside)
//            cell.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPathRow = indexPath.row
    }
    

    @objc func didTapAddGuest() {
        pushAddGuestScreenWith()
    }

    func didEditGuest(guest: Guest) {
        
        pushAddGuestScreenWith(guest)
    }
//    editButton.addTarget(self, action: #selector(didTapEditGuest), for: .touchUpInside)
    @objc func didTapEditGuest(sender:UIButton) {
        let cell = sender.superview?.superview as? WhosComingTypeBCell
        let buttonIndexPath = tableView.indexPath(for: cell!)
        print(buttonIndexPath?.row as Any)
        selectedIndexPathRow = buttonIndexPath?.row
        pushAddGuestScreenWith(cell?.guest)
//        starRating = StarRating.star2.rawValue
//        isFromRestoSelected = true
//        UIView.performWithoutAnimation {
//            let loc = ratingTableView.contentOffset
//            ratingTableView.reloadRows(at: [buttonIndexPath!], with: UITableViewRowAnimation.none)
//            ratingTableView.contentOffset = loc
//        }
    }

    private func pushAddGuestScreenWith(_ guest: Guest? = nil) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "GuestPage", bundle: nil)
            let addGuestController = storyBoard.instantiateViewController(withIdentifier: "AddGuestController") as! AddGuestController
            addGuestController.delegate = self
            if let guest = guest {
                addGuestController.guestNumber = "\(lang.guest_Title) \(String(describing: selectedIndexPathRow!+1))"
                addGuestController.toRemoveGuest = guest
            }else {
                addGuestController.guestNumber = "\(lang.guest_Title) \(guestArray.count+1)"
            }
            navigationController?.pushViewController(addGuestController, animated: true)
    }

}

extension WhosComingController: GuestEditingProtocol {
    func didAdd(guest: Guest?) {
        if let guest = guest {
            let matches = guestArray.filter({$0.fullName == guest.fullName})
            if matches.count == 0 {
                guestArray.append(guest)
                let indexPath = IndexPath(row: guestArray.count-1, section: 0)
               
                self.tableView.insertRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
            }
        }else {
            self.tableView.reloadData()
        }
    }
    func didRemove(guest: Guest) {
        if let index = guestArray.index(of: guest) {
            guestArray.remove(at: index)
            let indexPath = IndexPath(row: index, section: 0)
            print(indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
//            if (experienceDetails?.noOfGuest)! > guestArray.count  {
//
//            }
            self.tableView.reloadData()

        }
    }
}


