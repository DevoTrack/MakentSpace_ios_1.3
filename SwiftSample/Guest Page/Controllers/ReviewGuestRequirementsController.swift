//
//  ReviewGuestRequirementsController.swift
//  Makent
//
//  Created by Ranjith Kumar on 12/19/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ReviewGuestRequirementsController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(GuestPageCellTypeA.nib(), forCellReuseIdentifier: GuestPageCellTypeA.reuseIdentifier())
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier())
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var experienceDetails: ExperienceRoomDetails?
    var checkAvailablityModel: CheckDateAvailablity!
    var datePicked: String!
    var arrTitle = [String]()
    var arrDescription = [String]()

    @IBOutlet weak var nxt_Btn: UIButton!
    //
//    let keys =  [
//        "Review Guest Requirements",
//        "Alhocol",
//        "From the host",
//        "Who can come"
//    ]
//    let values = [
//        "",
//        "This experience includes alcohol. ONly guests who meet the legal drinking age will be served alcoholic beverages.",
//        "Describe yourself and tell guests how you came to be passsionate about hosting this experience. Decribe yourself and tell guests how you came to be passionate about hosting.",
//        "Guest can come"]

    override func viewDidLoad() {
        super.viewDidLoad()
        if experienceDetails!.minimumAge != ""{
            arrTitle.append((experienceDetails?.minimumAgeHeading)!)
            arrDescription.append((experienceDetails?.minimumAge)!)
        }
        self.nxt_Btn.setTitle(self.lang.next_Tit, for: .normal)
        nxt_Btn.appHostTextColor()
        if experienceDetails!.alcohol != "" {
            arrTitle.append((experienceDetails?.alcoholHeading)!)
            arrDescription.append((experienceDetails?.alcohol)!)
        }
        if experienceDetails!.additionalRequirements != "" {
            arrTitle.append((experienceDetails?.additionalHeading)!)
            arrDescription.append((experienceDetails?.additionalRequirements)!)
        }
        if experienceDetails!.whoCanCome != "" {
            arrTitle.append((experienceDetails?.whoCanComeHeading)!)
            arrDescription.append((experienceDetails?.whoCanCome)!)
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func didTapBackBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapAccept(_ sender: Any) {
        let whosComingScene = UIStoryboard(name: "GuestPage", bundle: nil).instantiateViewController(withIdentifier: "WhosComingController") as! WhosComingController
        whosComingScene.checkAvailablityModel = checkAvailablityModel
        whosComingScene.experienceDetails = experienceDetails
        whosComingScene.datePicked = datePicked
        self.navigationController?.pushViewController(whosComingScene, animated: true)
    }

}

extension ReviewGuestRequirementsController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return arrTitle.count != 0 ? arrTitle.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier())
            cell?.textLabel?.text = lang.guestRequire_Title//"Review Guest Requirements"
            cell?.textLabel?.font =  UIFont (name: Fonts.CIRCULAR_BOLD, size: 32)!
            cell?.textLabel?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            cell?.selectionStyle = .none
            cell?.textLabel?.textColor = UIColor.rgb(from: 0x474747)
            cell?.textLabel?.numberOfLines = 0
            return cell!
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: GuestPageCellTypeA.reuseIdentifier()) as! GuestPageCellTypeA
            cell.titleLabel.text = arrTitle[indexPath.row]
            cell.descriptionLabel.text = arrDescription[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}


