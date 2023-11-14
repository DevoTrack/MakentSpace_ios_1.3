//
//  PopoverViewController.swift
//  Makent
//
//  Created by trioangle on 25/09/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit
protocol PopoverViewControllerDelegate {
    func messageData(selectedData: BasicStpData)
}

class PopoverViewController: UIViewController {
    
    

    @IBOutlet weak var PopTableView: UITableView!
    
    
   
    var spaceType = [BasicStpData]()
    
    var isType = Bool()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.localizedInstance()
    var popDel:PopoverViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Mark:- Getting Space Type Values Service
    
        self.PopTableView.reloadData()
        
    }
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PopoverViewController : UITableViewDataSource,UITableViewDelegate{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.spaceType.count > 0 else {
            return 0
        }
        return self.spaceType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopCellTVC", for: indexPath) as! PopCellTVC
        guard self.spaceType.count > indexPath.row else {
            return cell
        }
        let dataVal = spaceType[indexPath.row]
        cell.typeName.font = UIFont(name: Fonts.CIRCULAR_BOOK, size: 15.0)
        cell.typeName.text = dataVal.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dataVal = spaceType[indexPath.row]
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.tintColor = UIColor.appHostThemeColor
            cell.accessoryType = dataVal.name != "" ? .checkmark : .none
        }
        self.popDel?.messageData(selectedData: dataVal)
        self.dismiss(animated: true, completion: nil)
       
    }
    
}
class PopCellTVC : UITableViewCell{
    
    @IBOutlet weak var typeName: UILabel!
}
