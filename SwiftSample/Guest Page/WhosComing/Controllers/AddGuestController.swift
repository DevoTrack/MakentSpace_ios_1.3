//
//  AddGuestController.swift
//  Makent
//
//  Created by Ranjith Kumar on 9/10/18.
//  Copyright © 2018 Vignesh Palanivel. All rights reserved.
//

import UIKit

enum GuestInputType: Int {
    case firstName = 0
    case lastName = 1
    case email = 2
}

protocol GuestEditingProtocol: class {
    func didAdd(guest: Guest?)
    func didRemove(guest: Guest)
}

class AddGuestController: UIViewController {

    public weak var delegate: GuestEditingProtocol?
    @IBOutlet weak var animatedImgBooking: FLAnimatedImageView!
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(AddGuestFirstNameCell.nib(), forCellReuseIdentifier: AddGuestFirstNameCell.reuseIdentifier())
            tableView.register(AddGuestLastNameCell.nib(), forCellReuseIdentifier: AddGuestLastNameCell.reuseIdentifier())
            tableView.register(AddGuestEmailCell.nib(), forCellReuseIdentifier: AddGuestEmailCell.reuseIdentifier())
            tableView.tableHeaderView = tableHeaderView
            tableView.keyboardDismissMode = .interactive
        }
    }
    @IBOutlet weak var removeGuestBtn: UIButton! {
        didSet {
            if toRemoveGuest != nil {
                removeGuestBtn.isEnabled = true
                removeGuestBtn.alpha = 1.0
            }else {
                removeGuestBtn.alpha = 0.4
                removeGuestBtn.isEnabled = false
            }
        }
    }

    var tableHeaderView: UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.width-(40), height: 60))
        label.text = guestNumber
        label.textColor = UIColor.rgb(from: 0x5C5E66)
        label.font = UIFont (name: Fonts.CIRCULAR_BOLD, size: 24)!
        view.addSubview(label)

        let subtitle = UILabel(frame: CGRect(x: 20, y: label.frame.maxY, width: view.frame.width-(40), height: 80))
        subtitle.text = lang.addguest_Title//"Keep your guests in the loop. Add their email and we'll send them the itineary."
        subtitle.numberOfLines = 0
        subtitle.textColor = UIColor.rgb(from: 0x5C5E66)
        subtitle.font = UIFont (name: Fonts.CIRCULAR_LIGHT, size: 17)!
        view.addSubview(subtitle)
        return view
    }
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 4.0
        }
    }

    var guestNumber: String!
    var toRemoveGuest: Guest?
    var roomId: String!
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate

    lazy var guestInputType: [GuestInputType] = {
        return [.firstName,.lastName,.email]
    }()

    lazy var toolbar: UIToolbar = {
        let toolBar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [
        UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
        UIBarButtonItem(title: self.lang.done_Title, style: .plain, target: self, action: #selector(didTapDone))
        ]
        toolBar.sizeToFit()
        return toolBar
    }()

    var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
        self.saveButton.setTitle(self.lang.save_Tit, for: .normal)
        self.removeGuestBtn.setTitle(self.lang.rem_Tit, for: .normal)
        removeGuestBtn.appHostTextColor()
        saveButton.appGuestSideBtnBG()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        let firstNameIndexPath = IndexPath(item: GuestInputType.firstName.rawValue, section: 0)
        let lastNameIndexPath = IndexPath(item: GuestInputType.lastName.rawValue, section: 0)
        let emailIndexPath = IndexPath(item: GuestInputType.email.rawValue, section: 0)
        let firstNameCell = tableView.cellForRow(at: firstNameIndexPath) as! AddGuestFirstNameCell
        let lastNameCell = tableView.cellForRow(at: lastNameIndexPath) as! AddGuestLastNameCell
        let emailCell = tableView.cellForRow(at: emailIndexPath) as! AddGuestEmailCell

        if firstNameCell.txtField.text?.isEmpty == true {
            showAlert(withMessage: lang.first_NameError)
        }else if lastNameCell.txtField.text?.isEmpty == true {
            showAlert(withMessage: lang.last_NameError)
        }else if (emailCell.txtField.text?.count)! > 0 {
            if MakentSupport().isValidEmail(testStr: emailCell.txtField.text!) == false {
                showAlert(withMessage: lang.email_Error)
            }else {
                if toRemoveGuest != nil {
                    toRemoveGuest?.firstName = firstNameCell.txtField.text!
                    toRemoveGuest?.lastName = lastNameCell.txtField.text!
                    toRemoveGuest?.email = emailCell.txtField.text!
                    self.delegate?.didAdd(guest: nil)
                }else {
                    self.delegate?.didAdd(
                        guest: Guest(
                            firstName: firstNameCell.txtField.text!,
                            lastName: lastNameCell.txtField.text!,
                            email: emailCell.txtField.text!
                    ))
                }
                self.navigationController?.popViewController(animated: true)
            }
        }else {
            if toRemoveGuest != nil {
                toRemoveGuest?.firstName = firstNameCell.txtField.text!
                toRemoveGuest?.lastName = lastNameCell.txtField.text!
                toRemoveGuest?.email = emailCell.txtField.text!
                self.delegate?.didAdd(guest: nil)
            }else {
                self.delegate?.didAdd(
                    guest: Guest(
                        firstName: firstNameCell.txtField.text!,
                        lastName: lastNameCell.txtField.text!,
                        email: emailCell.txtField.text!
                ))
            }
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func didTapDone() {
        self.view.endEditing(true)
    }

    @IBAction func removeBtnAction(_ sender: Any) {
        if let guest = toRemoveGuest {
            let editGuestAlert = UIAlertController(title: k_AppName, message:"\(lang.want_DeleteAlert)'\(guest.fullName)'", preferredStyle: .alert)
            editGuestAlert.addAction(UIAlertAction(title: lang.cancel_Title, style: .cancel, handler: nil))
            editGuestAlert.addAction(UIAlertAction(title: lang.done_Title, style: .destructive, handler: { alert -> Void in
                self.delegate?.didRemove(guest: guest)
                self.navigationController?.popViewController(animated: true)
            }))
            present(editGuestAlert, animated: true, completion: nil)
        }
    }

    @IBAction func didTapCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func showAlert(withMessage: String) {
        let alert = UIAlertController(title: k_AppName, message: withMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: lang.ok_Title, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject],
        kbSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)

        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets

        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height

        if !aRect.contains(activeField!.frame.origin) {
            self.tableView.scrollRectToVisible(activeField!.frame, animated: true)
        }
    }

    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
}

extension AddGuestController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guestInputType.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case GuestInputType.firstName.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddGuestFirstNameCell.reuseIdentifier()) as! AddGuestFirstNameCell
            cell.txtField.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            if let guest = toRemoveGuest {
                cell.txtField.text = guest.firstName
            }
            cell.frstname_Lbl.text = self.lang.firstname_Tit
            cell.txtField.delegate = self
            cell.txtField.inputAccessoryView = toolbar
            return cell
        case GuestInputType.lastName.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddGuestLastNameCell.reuseIdentifier()) as! AddGuestLastNameCell
            cell.txtField.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            if let guest = toRemoveGuest {
                cell.txtField.text = guest.lastName
            }
            cell.lstname_Lbl.text = self.lang.lastname_Tit
            cell.txtField.inputAccessoryView = toolbar
            cell.txtField.delegate = self
            return cell
        case GuestInputType.email.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddGuestEmailCell.reuseIdentifier()) as! AddGuestEmailCell
            cell.txtField.textAlignment = Language.getCurrentLanguage().getTextAlignment(align: .left)
            if let guest = toRemoveGuest {
                cell.txtField.text = guest.email
            }
            cell.email_Lbl.text = self.lang.email_Opt
            cell.txtField.inputAccessoryView = toolbar
            cell.txtField.delegate = self
            return cell
        default:
            fatalError("Does not match Enum")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }


}

extension AddGuestController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }

}

