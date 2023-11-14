//
//  GuestRequirementController.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/8/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class GuestRequirementController: UIViewController {
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(GuestPageCellTypeA.nib(), forCellReuseIdentifier: GuestPageCellTypeA.reuseIdentifier())
            tableView.register(GuestPageCellTypeB.nib(), forCellReuseIdentifier: GuestPageCellTypeB.reuseIdentifier())
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableView.automaticDimension
            tableView.tableHeaderView = tableHeaderView
        }
    }

    var tableHeaderView: UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.width-(40), height: 80))
        label.text =  lang.guestreq_Title
        //"Guest Requirements"
        label.textColor = UIColor.rgb(from: 0x5C5E66)
        label.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: 24)!
        view.addSubview(label)
        return view
    }

    var experienceDetails: ExperienceRoomDetails?
    var arrTitle = [String]()
    var arrDescription = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        if experienceDetails!.minimumAge != ""{
            arrTitle.append((experienceDetails?.minimumAgeHeading)!)
            arrDescription.append((experienceDetails?.minimumAge)!)
        }
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

}


extension GuestRequirementController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count != 0 ? arrTitle.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: GuestPageCellTypeA.reuseIdentifier()) as! GuestPageCellTypeA
            cell.titleLabel.text = arrTitle[indexPath.row]
            cell.descriptionLabel.text = arrDescription[indexPath.row]
            return cell
//        }else {
//            let cell:GuestPageCellTypeB = tableView.dequeueReusableCell(withIdentifier: GuestPageCellTypeB.reuseIdentifier()) as! GuestPageCellTypeB
//            cell.lblTerms.delegate = self
//            return cell
//        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension GuestRequirementController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        UIApplication.shared.openURL(url)
    }
}

