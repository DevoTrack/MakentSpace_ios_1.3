//
//  SelectionViewController.swift
//  Makent
//
//  Created by trioangle on 19/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    @IBOutlet weak var selectionTableView: UITableView!
    
    var listModelArray = [BedTypeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionTableView.dataSource = self
        selectionTableView.delegate = self
        let backButton = UIButton(type: .custom)
        backButton.transform = self.getAffine
        backButton.addTarget(self, action: #selector(self.onBackTapped(sender:)), for: .touchUpInside)
        self.addbackButton(sender: backButton, senderTitle: "Q", senderFontName: Fonts.MAKENT_LOGO_FONT1)
        
        selectionTableView.tableFooterView = UIView()
    }
    

    @objc func onBackTapped(sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

class SelecTVC: UITableViewCell {
    
    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}

extension SelectionViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selecTVC") as! SelecTVC
        let model = self.listModelArray[indexPath.row]
        cell.titleLabel.customFont(.medium)
        
        cell.titleLabel.text = "\(model.count) \(model.name)"
        cell.selectImageView.addRemoteImage(imageURL: model.icon, placeHolderURL: "")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
