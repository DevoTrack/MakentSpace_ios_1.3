//
//  DescriptionsDetailPageVC.swift
//  Crewmates
//
//  Created by Trioangle on 10/09/18.
//  Copyright © 2018 Mounika. All rights reserved.
//

import UIKit

class DescriptionsDetailPageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var arrTempDescription = [String]()
    var arrTempTitle = [String]()
    @IBOutlet weak var desc_Title: UILabel!
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var backButtonOutlet: UIButton!
  let lang = Language.getCurrentLanguage().getLocalizedInstance()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Detail Descriptions")
        self.navigationController?.isNavigationBarHidden = true
        detailTableView.rowHeight = UITableView.automaticDimension
        detailTableView.estimatedRowHeight = 80
        self.desc_Title.text = self.lang.det_Desc
        detailTableView.tableFooterView = UIView()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrTempDescription.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        cell.titleLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.descriptionLabel.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
        cell.titleLabel.text = arrTempTitle[indexPath.row]
        cell.descriptionLabel.text = arrTempDescription[indexPath.row]
        print("Details Descriptions",arrTempDescription[indexPath.row])
        cell.titleLabel.font = UIFont (name: Fonts.CIRCULAR_BOOK, size: 18)
        cell.descriptionLabel.font = UIFont (name: Fonts.CIRCULAR_LIGHT, size: 18)
        cell.descriptionLabel.sizeToFit()
        cell.descriptionLabel.numberOfLines = 0
        return cell
    }
   
}
class CustomTableViewCell : UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

}
