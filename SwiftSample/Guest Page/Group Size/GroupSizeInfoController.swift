//
//  GroupSizeInfoController.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/10/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class GroupSizeInfoController: UIViewController {

    let cellIdentifier = "Cell"
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(GroupSizeCell.nib(), forCellReuseIdentifier: cellIdentifier)
            tableView.tableHeaderView = tableHeaderView
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableView.automaticDimension
        }
    }

    var tableHeaderView: UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.width-(40), height: 80))
        label.text = self.lang.group_Title//"Group Size"
        label.textColor = UIColor.rgb(from: 0x5C5E66)
        label.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: 24)!
        view.addSubview(label)
        return view
    }

    var experienceDetails:ExperienceRoomDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapCrossBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension GroupSizeInfoController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:GroupSizeCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)! as! GroupSizeCell
        cell.titleLabel?.text = "\(lang.thereare_Title) \(experienceDetails?.noOfGuest ?? 0) \(lang.spotexp_Available)"
        cell.titleLabel?.numberOfLines = 0
        cell.titleLabel?.textColor = UIColor.rgb(from: 0x5C5E66)
        cell.titleLabel?.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: 17)!

        cell.contentLabel?.text = lang.grpsize_Content
        cell.contentLabel?.numberOfLines = 0
        cell.contentLabel?.textColor = UIColor.rgb(from: 0x5C5E66)
        cell.contentLabel?.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: 17)!

        cell.backgroundColor = .clear
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



