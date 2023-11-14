//
//  Extensions.swift
//  Makent
//
//  Created by trioangle on 31/07/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
import CoreLocation

extension Array{
    func value(atSafeIndex index : Int) -> Element?{
        if self.indices ~= index{
            return self[index]
        }
        return nil
    }
    
    func find(includedElement: @escaping ((Element) -> Bool)) -> Int? {
        for arg in self.enumerated(){
            let (index,item) = arg
            if includedElement(item) {
                return index
            }
        }
        
        return nil
    }
    
//    func findB(includedElement: Element) -> Int? {
////        for arg in self.enumerated(){
////            let (index,item) = arg
////            if includedElement(item) {
////                return index
////            }
////        }
//        var lowerIndex = 0;
//        var upperIndex = self.count - 1
//        
//        while (true) {
//            let currentIndex = (lowerIndex + upperIndex)/2
//            if(self[currentIndex] == includedElement) {
//                return currentIndex
//            } else if (lowerIndex > upperIndex) {
//                return nil
//            } else {
//                if (self[currentIndex] > includedElement) {
//                    upperIndex = currentIndex - 1
//                } else {
//                    lowerIndex = currentIndex + 1
//                }
//            }
//        }
//        
//        return nil
//    }
    
    
    func binarySearch<T:Comparable>(inputArr:Array<T>, searchItem: T) -> Int? {
        var lowerIndex = 0;
        var upperIndex = inputArr.count - 1
        
        while (true) {
            let currentIndex = (lowerIndex + upperIndex)/2
            if(inputArr[currentIndex] == searchItem) {
                return currentIndex
            } else if (lowerIndex > upperIndex) {
                return nil
            } else {
                if (inputArr[currentIndex] > searchItem) {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
    }

    
    func anySatisfy(_ condition : @escaping (Element) -> Bool) -> Bool{
        for element in self{
            if condition(element){
                return true
            }
        }
        return false
    }
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
    
    mutating func appendAtBeginning(newItem : Element){
        let copy = self
        self = []
        self.append(newItem)
        self.append(contentsOf: copy)
    }
}
extension CLLocationCoordinate2D{
    func isEqual(_ coords : CLLocationCoordinate2D) -> Bool{
        return self.latitude == coords.latitude && self.longitude == coords.longitude
    }
}


