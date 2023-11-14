//
//  PriceBreakDownData.swift
//  Makent
//
//  Created by trioangle on 23/10/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation

class PriceBreakDownData
{
    var priceBrkData = [PriceBrkData]()
    
    init(priceJson : JSONS)
    {
        self.priceBrkData.removeAll()
        priceJson.array("data").forEach { (temp) in
            let model = PriceBrkData(priceBrkDataJson: temp)
            self.priceBrkData.append(model)
        }
    }
}

class PriceBrkData
{
    var  key   = String()
    var  value = String()
    init(priceBrkDataJson : JSONS) {
        self.key = priceBrkDataJson.string("key")
        self.value = priceBrkDataJson.string("value")
    }
}
