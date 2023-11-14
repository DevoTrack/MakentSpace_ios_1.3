//
//  ExprienceMeetSelectionViewController.swift
//  Slawomir
//
//  Created by trioangle on 13/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

protocol GoogleLocationUpdateExperience {
    func getGoogledata(_ model:GoogleTitleModel)
}


class ExprienceMeetSelectionViewController: UIViewController {

    @IBOutlet weak var selectionTableView: UITableView!
    var googleDelegate:GoogleLocationUpdateExperience?
    
    var totalModelArray = [GoogleTitleModel]()
    var isSelected : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   

}
extension ExprienceMeetSelectionViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetSelectionTVC") as! MeetSelectionTVC
        let model = self.totalModelArray[indexPath.row]
        cell.titleLbl.text = model.title
        cell.subTitleLbl.text = model.subTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.totalModelArray[indexPath.row]
        self.isSelected = true
        self.dismiss(animated: true) {
            self.googleDelegate?.getGoogledata(model)
            
        }
    }
    
    
}


class MeetSelectionTVC: UITableViewCell {
    
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        subTitleLbl.customFont(.medium)
        titleLbl.customFont(.bold)
    }
}
