/**
* ReviewDetailVC.swift
*
* @package Makent
* @author Trioangle Product Team
* @version - Stable 1.0
* @link http://trioangle.com
*/

import UIKit
import MessageUI
import Social

class ReviewDetailVC : UIViewController,UITableViewDelegate, UITableViewDataSource, ViewOfflineDelegate {
    
    @IBOutlet weak var subHeaderView: UIView!
    @IBOutlet var tableReview: UITableView!
    @IBOutlet var tblHeaderView: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblTotalReview: UILabel!
    @IBOutlet var lblTotalRating: UILabel!

    @IBOutlet var lblAccuracy : UILabel!
    @IBOutlet var lblCheckIn : UILabel!
    @IBOutlet var lblCleanliness : UILabel!
    @IBOutlet var lblCommunication: UILabel!
    @IBOutlet var lblLocation : UILabel!
    @IBOutlet var lblvalue : UILabel!
  
    @IBOutlet weak var subHeaderHeight: NSLayoutConstraint! //202
    var nPageNumber : Int = 1
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    var strRoomId : String = ""
    var appDelegate  = UIApplication.shared.delegate as! AppDelegate
    var reviewModel : ReviewsModel!
    var isFromExprience = Bool()

    override func viewDidLoad()
    {
        super.viewDidLoad()
            self.navigationController?.isNavigationBarHidden = true
        tableReview.isHidden = true

//        tableReview.tableHeaderView = tblHeaderView
        if self.isFromExprience {
            print("from experience")
            self.getExperienceReviewDetails()
            
        }else {
             print("not from experience")
            self.getReviewDetails(pageNumber : nPageNumber)
        }
        lblTotalRating.appGuestTextColor()
        lblAccuracy.appGuestTextColor()
        lblCheckIn.appGuestTextColor()
        lblCleanliness.appGuestTextColor()
        lblCommunication.appGuestTextColor()
        lblLocation.appGuestTextColor()
        lblvalue.appGuestTextColor()
    }
    
    //MARK: INTERNET OFFLINE DELEGATE METHOD
    /*
     Here Calling the API again
     */
    internal func RetryTapped()
    {
        self.getReviewDetails(pageNumber : nPageNumber)
    }
    
    func getExperienceReviewDetails() {
        var dicts = [String: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
        dicts["host_experience_id"] = strRoomId
        dicts["page"] = String(format:"%d", nPageNumber)
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: "experience_review_detail", paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                self.reviewModel = ReviewsModel(json: responseDict)
                self.updateReviewPageInfo()
//                self.arrReviewData.removeAllObjects()
//                responseDict.array("data").forEach({ (tempJSON) in
//                    let reviewmodel = ReviewsModel(json: tempJSON).initiateReviewData(responseDict: tempJSON as NSDictionary)
//                    self.arrReviewData.add(reviewmodel)
//                })
//                let reviewData = ReviewsModel(json: responseDict)
//                reviewData.total_review = responseDict.int("reviews_count").description as NSString
//                reviewData.ratingValue = responseDict.int("rating_value").description as NSString
//                self.updateReviewPageInfo(modelReview: reviewData)
            }else {
                self.appDelegate.createToastMessage(responseDict.statusMessage, isSuccess: false)
            }
        }
    }
    
    func getReviewDetails(pageNumber : Int)
    {
//        if !MakentSupport().checkNetworkIssue(self, errorMsg: "")
//        {
//            return
//        }
//
//        MakentSupport().showProgressInWindow(viewCtrl: self, showAnimation: true)
        var dicts = [String: Any]()
        dicts["token"] = Constants().GETVALUE(keyname: APPURL.USER_ACCESS_TOKEN)
       // dicts["room_id"] = strRoomId
        dicts["space_id"] = strRoomId
        dicts["page"] = String(format:"%d", pageNumber)
        WebServiceHandler.sharedInstance.getToWebService(wsMethod: APPURL.METHOD_REVIEW_LIST, paramDict: dicts, viewController: self, isToShowProgress: true, isToStopInteraction: true) { (responseDict) in
            if responseDict.isSuccess {
                self.reviewModel = ReviewsModel(json: responseDict)
                self.updateReviewPageInfo()
            }else {
                self.sharedAppDelegete.createToastMessage(responseDict.statusMessage)
            }
        }
        
//        MakentAPICalls().GetRequest(dicts,methodName: METHOD_REVIEW_LIST as NSString, forSuccessionBlock:{(_ response: Any) -> Void in
//            let reviewData = response as! ReviewsModel
//            print("reviewData...",reviewData)
//            OperationQueue.main.addOperation {
////                MakentSupport().removeProgress(viewCtrl: self)
//                MakentSupport().removeProgressInWindow(viewCtrl: self)
//                if reviewData.status_code  == "1"
//                {
//                    self.arrReviewData.addObjects(from: (reviewData.arrReviewData as NSArray) as! [Any])
//                    self.updateReviewPageInfo(modelReview: reviewData)
//                }
//                else
//                {
//                    if reviewData.success_message == "token_invalid" || reviewData.success_message == "user_not_found" || reviewData.success_message == "Authentication Failed"
//                    {
//                        self.appDelegate.logOutDidFinish()
//                        return
//                    }
//                }
//            }
//        }, andFailureBlock: {(_ error: Error) -> Void in
//            OperationQueue.main.addOperation {
//                _ = MakentSupport().checkNetworkIssue(self, errorMsg: self.lang.network_ErrorIssue)
//            }
//        })
    }
    
    func updateReviewPageInfo()
    {
        tableReview.isHidden = false
        
        lblTotalReview.text = String(format:(reviewModel.total_review == "1") ? "%@ \(self.lang.rev_Title)" : "%@ \(self.lang.revs_Title)", reviewModel.total_review)
        lblTotalReview.appGuestTextColor()
        lblTotalRating.text = MakentSupport().createRatingStar(ratingValue: reviewModel.ratingValue) as String //modelReview.value
        //MakentSupport().createRatingStar(ratingValue: "5") as String
        lblTotalRating.appGuestTextColor()
        if !self.isFromExprience {
            self.subHeaderHeight.constant = 202
             self.subHeaderView.isHidden = false
            lblAccuracy.text = MakentSupport().createRatingStar(ratingValue: reviewModel.accuracy_value) as String
            lblAccuracy.appGuestTextColor()
            lblCheckIn.text = MakentSupport().createRatingStar(ratingValue: reviewModel.check_in_value) as String
            lblCheckIn.appGuestTextColor()
            lblCleanliness.text = MakentSupport().createRatingStar(ratingValue: reviewModel.cleanliness_value) as String
            lblCleanliness.appGuestTextColor()
            lblCommunication.text = MakentSupport().createRatingStar(ratingValue: reviewModel.communication_value) as String
            lblCommunication.appGuestTextColor()
            lblLocation.text = MakentSupport().createRatingStar(ratingValue: reviewModel.location_value) as String
            lblLocation.appGuestTextColor()
            lblvalue.text = MakentSupport().createRatingStar(ratingValue: reviewModel.value) as String
            lblvalue.appGuestTextColor()
        }else {
            self.subHeaderHeight.constant = 0
            self.subHeaderView.isHidden = true
        }
        
        tableReview.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
//        return UITableView.automaticDimension
        let reviewModel = self.reviewModel.userDetails[indexPath.row]
        let height = MakentSupport().onGetStringHeight(((self.view?.frame.size.width)!-40), strContent: (reviewModel.review_message), font: UIFont (name: Fonts.CIRCULAR_LIGHT, size: 17)!)
        return height + 105
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = reviewModel {
            return model.userDetails.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:ReviewDetailCell = tableReview.dequeueReusableCell(withIdentifier: "ReviewDetailCell") as! ReviewDetailCell
        let model = reviewModel.userDetails[indexPath.row]
        

        cell.setReviewData(modelReview : model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: [indexPath.row], animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.tblHeaderView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isFromExprience {
            return 70
        }
        return UITableView.automaticDimension
    }
    @IBAction func onBackTapped(_ sender:UIButton!)
    {
        dismiss(animated: true, completion: nil)
    }

    func showProgress()
    {
        let loginPageView = k_MakentStoryboard.instantiateViewController(withIdentifier: "ProgressHud") as! ProgressHud
        loginPageView.willMove(toParent: self)
        loginPageView.view.tag = 1234
        self.view.addSubview(loginPageView.view)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

