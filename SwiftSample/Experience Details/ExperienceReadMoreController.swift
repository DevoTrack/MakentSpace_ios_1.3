//
//  ExperienceReadMoreController.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/22/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ExperienceReadMoreController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
            tableView.estimatedRowHeight = 44.0
            tableView.rowHeight = UITableView.automaticDimension
        }
    }

    var titleString: String!
    var subTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension ExperienceReadMoreController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        if indexPath.row == 0 {
            cell.textLabel?.text = titleString
            cell.textLabel?.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: 24)!
            cell.textLabel?.textColor = UIColor.rgb(from: 0x5C5E66)
        }else {
            cell.textLabel?.text = subTitle
            cell.textLabel?.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: 17)!
            cell.textLabel?.textColor = UIColor.rgb(from: 0x474747)
        }
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
