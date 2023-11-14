//
//  EventCancellationPolicyController.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/18/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class EventCancellationPolicyController: UIViewController {

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier())
            tableView.register(EventCancellationPolicyType2Cell.nib(), forCellReuseIdentifier: EventCancellationPolicyType2Cell.reuseIdentifier())
            tableView.backgroundColor = UIColor.rgb(from: 0xd4d4d4)
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableView.automaticDimension
            tableView.tableFooterView = UIView()
        }
    }
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    lazy var datasource: [String] = {
        return [
            "Makent Hosts\nExperience & Event\nCancellation policy",
            "General Cancellation",
            "• Any experience or event, canceled within 24 hours of booking, is eligible for a full refund.",
            "• Any experience or event cancellation that is 30 days or more before the start date, is eligible for a full refund.",
            "• Cancellations less than 30 days before start date will not be eligible for a refund, unless your spot is booked and completed by another guest.",
            "• Should your spot be booked and completed by another guest, a full refund will be processed within 14 days of the experience start date.",
            "• However, if the reason for cancellation meets out Extenuating Circumstances policy, you will be refunded in full.",
            "Should any member of your party be unable to complete the account verification process within 3 days of purchase, all portions and spots for the experience or event will be canceled and fully refunded.",
            "Hosts make every effort to continue, as scheduled, with experience or events. Should bad weather conditions create an unsafe scenario for guests or hosts, a change or partial cancellation of an itinerary or activity may be the result. Should an individual experience or event be canceled by host or guest, or should an itinerary substantially change or result in a cessation of the trip, Makent will work with your host to provide an appropriate refund. To officially request a cancellation of your experience or event, please contact us."
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        datasource = [lang.makhostexpeve_Cancel,lang.general_Cancel,lang.hrs24_Refund,lang.event30_Day,lang.cancel30_Day,lang.days14_Refund,lang.cancel_Reason,lang.account_Verif,lang.hostoffr_Msg]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapCrossBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}

extension EventCancellationPolicyController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == datasource.count-1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: EventCancellationPolicyType2Cell.reuseIdentifier()) as! EventCancellationPolicyType2Cell
            cell.topSeparatorView.isHidden = true
            cell.titleLabel.text = lang.weather_Title//"Weather"
            cell.detailLabel?.text = datasource[indexPath.row]
            cell.selectionStyle = .none
            cell.detailLabel?.numberOfLines = 0
            return cell
        }else if (indexPath.row == datasource.count-2){
            let cell = tableView.dequeueReusableCell(withIdentifier: EventCancellationPolicyType2Cell.reuseIdentifier()) as! EventCancellationPolicyType2Cell
            cell.topSeparatorView.isHidden = false
            cell.titleLabel.text = lang.accountVerifi_Title//"Account Verification"
            cell.detailLabel?.text = datasource[indexPath.row]
            cell.selectionStyle = .none
            cell.detailLabel?.numberOfLines = 0
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier())
            cell?.textLabel?.text = datasource[indexPath.row]
            if indexPath.row == 0 {
                //For first IndexPath we have to max font
                cell?.textLabel?.font =  UIFont (name: Fonts.CIRCULAR_BOLD, size: 32)!
            }else if indexPath.row == 1{
                cell?.textLabel?.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: 22)!
            }else {
                cell?.textLabel?.font = UIFont (name: Fonts.CIRCULAR_LIGHT, size: 15)!
            }
            cell?.selectionStyle = .none
            cell?.textLabel?.textColor = UIColor.rgb(from: 0x474747)
            cell?.textLabel?.numberOfLines = 0
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
