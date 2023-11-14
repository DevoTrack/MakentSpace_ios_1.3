//
//  CategorySelectionController.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/18/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

protocol CategorySelectable: class {
    func didSelectCategory(categories:[HostExperienceCategories])
}

var lastSelectedCategories = [HostExperienceCategories]()
var datasource:[HostExperienceCategories] = []

class CategorySelectionController: UIViewController {
    
    public weak var delegate: CategorySelectable?
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier())
        }
    }
    @IBOutlet weak var btnNext: UIButton! {
        didSet {
//            btnNext.isUserInteractionEnabled = lastSelectedCategories.isEmpty ? false : true
//            btnNext.backgroundColor = lastSelectedCategories.isEmpty ? UIColor.white.withAlphaComponent(0.5) : UIColor.white
            btnNext.layer.cornerRadius = btnNext.frame.size.height/2
        }
    }
    
    var tableHeaderView: UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        view.backgroundColor = UIColor.rgb(from: 0x00A699)
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.width-(40), height: 80))
        label.text = lang.sel_cats//Select Category"
        label.textColor = .white
        label.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: 32)!
        view.addSubview(label)
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.whtto_Do.text = self.lang.whattodo_Tit
        getCategories()
        btnNext.nextButtonImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTapped(_ sender:UIButton!) {
        datasource.forEach { $0.isSelected = false }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapNextBtn(_ sender: Any) {
        let categories = datasource.filter{$0.isSelected == true}
        lastSelectedCategories = categories
        self.delegate?.didSelectCategory(categories: categories)
        navigationController?.popViewController(animated: true)
    }
    
    func showProgressInWindow(viewCtrl:UIViewController , showAnimation:Bool)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewProgress = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        viewProgress.isShowLoaderAnimaiton = showAnimation
        viewProgress.view.tag = Int(123456)
        appDelegate.window?.isUserInteractionEnabled = true
        appDelegate.window?.addSubview(viewProgress.view)
    }
    
    func removeProgressInWindow(viewCtrl:UIViewController)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        DispatchQueue.main.async {
            appDelegate.window?.viewWithTag(Int(123456))?.removeFromSuperview()
            appDelegate.window?.isUserInteractionEnabled = true
        }
    }
    
    func getCategories() {
        
        showProgressInWindow(viewCtrl: self, showAnimation: true)
        
        var dicts = [AnyHashable: Any]()
        
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        
        MakentAPICalls().GetRequest(dicts, methodName: APPURL.METHOD_HOST_EXPERIENCE_CATEGORY as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let responseModel = response as! ExCategoryModel
            
            OperationQueue.main.addOperation {
                if responseModel.statusCode == "1" {
                    datasource = responseModel.hostExperienceCategories ?? []
                    for(index, category) in datasource.enumerated() {
                        if lastSelectedCategories.filter({category.internalIdentifier == $0.internalIdentifier}).count != 0 {
                            datasource[index].isSelected = true
                        }
                    }
                    self.tableView.reloadData()
                } else {
                    if responseModel.successMessage == "token_invalid" || responseModel.successMessage == "user_not_found" || responseModel.successMessage == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
                self.removeProgressInWindow(viewCtrl: self)
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.removeProgressInWindow(viewCtrl: self)
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }
    
}

extension CategorySelectionController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier())
        cell?.textLabel?.text = datasource[indexPath.row].name
        cell?.textLabel?.textColor = datasource[indexPath.row].isSelected ? UIColor.white : UIColor.rgb(from: 0x474747)
        cell?.textLabel?.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: 22)!
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = datasource[indexPath.row]
        category.isSelected = !category.isSelected
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
}
