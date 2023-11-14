//
//  HomeTableViewCell.swift
//  Makent
//
//  Created by Trioangle on 17/07/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

//    @IBOutlet weak var homeCollectionView: UICollectionView!
//    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var homeCollectionView1: UICollectionView!
    
    var collectionViewObserver: NSKeyValueObservation?
    
    var exploreListDictArray : [Any]?{
        didSet{
//            homeCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        homeCollectionView.dataSource = self
//        homeCollectionView.delegate = self
//        homeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        registerNib()
        addObserver()
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    func registerNib(){
//        homeCollectionView.register(UINib.init(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
//        homeCollectionView.reloadData()
//    }
    
    func addObserver() {
//        collectionViewObserver = homeCollectionView.observe(\.contentSize, changeHandler: { [weak self] (collectionView, change) in
////            self?.homeCollectionView.invalidateIntrinsicContentSize()
////            self?.heightConstraint.constant = collectionView.contentSize.height
//            self?.layoutIfNeeded()
//        })
    }
    
    deinit {
        collectionViewObserver = nil
    }
}

//extension HomeTableViewCell : UICollectionViewDataSource,UICollectionViewDelegate{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
//        print("Collections∂")
////        cell.exploreRatingCountLabel.text = "Title"
//        cell.contentView.backgroundColor = .red
//        return cell
//    }
//}
//extension HomeTableViewCell : UICollectionViewDelegateFlowLayout{
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//      return CGSize(width: (self.frame.width-30)/2,height: ((self.frame.width-30)/2)+5)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return  10
//    }
//
//}
