//
//  SimilarListingDelegate.swift
//  Makent
//
//  Created by trioangle on 06/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
//MAKR:Delegate method for Similar List
protocol SimilarListDelegate
{
    func onSimilarListTapped(strRoomID: String)
    func onWishList(index: Int, sender: UIButton)
}
