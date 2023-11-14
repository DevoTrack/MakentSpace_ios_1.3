//
//  ReviewsPageController.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/18/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

struct Review {
    let picture: String
    let user: String
    let postedOn: String
    let review: String
}

class ReviewsPageController: UIViewController {
    
    let Lang = Language.getCurrentLanguage().getLocalizedInstance()

    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(ReviewPageCell.nib(), forCellReuseIdentifier: ReviewPageCell.reuseIdentifier())
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableView.automaticDimension
            tableView.tableFooterView = UIView()
        }
    }

    var tableHeaderView: UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.width-(40), height: view.frame.height))
        label.text = Lang.reviews_Title //Reviews
        label.textColor = UIColor.rgb(from: 0x474747)
        label.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: 32)!
        view.addSubview(label)
        return view
    }

    lazy var datasource: [Review] = {
        return
            [
                Review(
                    picture: "www.google.com",
                    user: "Alex",
                    postedOn: "June 2, 2018",
                    review: "Any experience or event, canceled within 24 hours of booking, is eligible for a full refund."),
                Review(
                    picture: "www.google.com",
                    user: "Alex",
                    postedOn: "June 2, 2018",
                    review: "Any experience or event, canceled within 24 hours of booking, is eligible for a full refund."),
                Review(
                    picture: "www.google.com",
                    user: "Alex",
                    postedOn: "June 2, 2018",
                    review: "Any experience or event, canceled within 24 hours of booking, is eligible for a full refund."),
                Review(
                    picture: "www.google.com",
                    user: "Alex",
                    postedOn: "June 2, 2018",
                    review: "Any experience or event, canceled within 24 hours of booking, is eligible for a full refund.")
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ReviewsPageController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewPageCell.reuseIdentifier()) as! ReviewPageCell
        let review = datasource[indexPath.row]
        cell.nameLabel.text = review.user
        cell.postedOnLabel.text = review.postedOn
        cell.reviewLabel.text = review.review
        cell.profileImageView.backgroundColor = cell.nameLabel.textColor
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableHeaderView.frame.height
    }
}
