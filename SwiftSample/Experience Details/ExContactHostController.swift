//
//  ExContactHostController.swift
//  Makent
//
//  Created by Ranjith Kumar on 12/7/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

class ExContactHostController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.keyboardDismissMode = .interactive
            tableView.estimatedRowHeight = 70
            tableView.rowHeight = UITableView.automaticDimension
            tableView.tableFooterView = UIView()
        }
    }
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var modelRoomDetails:ExperienceRoomDetails!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var sendMessageBtn: UIButton! {
        didSet {
            sendMessageBtn.isEnabled = false
            sendMessageBtn.setTitleColor(UIColor.rgb(from: 0x5C5E66).withAlphaComponent(0.5), for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ContactHostTypeACell", bundle: nil), forCellReuseIdentifier: "ContactHostTypeACell")
        tableView.register(UINib(nibName: "ExcontactHostTypeBCell", bundle: nil), forCellReuseIdentifier: "ExcontactHostTypeBCell")
        self.sendMessageBtn.setTitle(self.lang.send_MsgTit, for: .normal)
    }


    @IBAction func didTapSendMessage(_ sender: Any) {
        sendMessage()
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

    func sendMessage() {
        showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [AnyHashable: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        let cell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as!ExcontactHostTypeBCell
        dicts["message"] = cell.editTaskValue.text
         dicts["list_type"] = "Experiences"
        dicts["host_experience_id"] = "\(modelRoomDetails.experienceId!)"
        MakentAPICalls().GetRequest(dicts, methodName: APPURL.METHOD_EXPERIENCE_CONTACTHOST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
            let responseModel = response as! GeneralModel
            OperationQueue.main.addOperation {
                if responseModel.status_code == "1" {
                    self.removeProgressInWindow(viewCtrl: self)
                    //success
                    self.removeProgressInWindow(viewCtrl: self)
                    let msg = "\(self.lang.contreq_Send) \(self.modelRoomDetails.hostUserName ?? "")"
                    self.appDelegate.createToastMessage(msg, isSuccess: true)
                    self.navigationController?.popViewController(animated: true)

                } else {
                    self.removeProgressInWindow(viewCtrl: self)
                    if responseModel.success_message == "token_invalid" || responseModel.success_message == "user_not_found" || responseModel.success_message == "Authentication Failed"
                    {
                        self.appDelegate.logOutDidFinish()
                        return
                    }
                }
            }
        }, andFailureBlock: {(_ error: Error) -> Void in
            OperationQueue.main.addOperation {
                self.removeProgressInWindow(viewCtrl: self)
                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
            }
        })
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension ExContactHostController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:ContactHostTypeACell = tableView.dequeueReusableCell(withIdentifier: "ContactHostTypeACell")! as! ContactHostTypeACell
            cell.firstLabel.text = "\(lang.need_More) \(Constants().GETVALUE(keyname: APPURL.USER_FIRST_NAME) as String) \(Constants().GETVALUE(keyname: APPURL.USER_LAST_NAME) as String) ?"
            cell.profilePicture.addRemoteImage(imageURL: modelRoomDetails.hostUserImage ?? "", placeHolderURL: "")
                //.sd_setImage(with: URL(string: modelRoomDetails.hostUserImage!))
            return cell
        }else {
            let cell:ExcontactHostTypeBCell = tableView.dequeueReusableCell(withIdentifier: "ExcontactHostTypeBCell")! as! ExcontactHostTypeBCell
            cell.editTaskValue.isEditable = true
            cell.editTaskValue.delegate = self
            cell.editTaskValue.placeholder = lang.write_Mess
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension ExContactHostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let currentOffset = self.tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        self.tableView.setContentOffset(currentOffset, animated: false)

        if (textView as! KMPlaceholderTextView).placeholder == lang.write_Mess {
            if textView.text.isValidString() == true {
                sendMessageBtn.isEnabled = false
                sendMessageBtn.setTitleColor(UIColor.rgb(from: 0x5C5E66).withAlphaComponent(0.5), for: .normal)
            }else {
                sendMessageBtn.isEnabled = true
                sendMessageBtn.setTitleColor(UIColor.rgb(from: 0x5C5E66), for: .normal)
            }
        }
    }
}

extension String {
    func isValidString() -> Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
