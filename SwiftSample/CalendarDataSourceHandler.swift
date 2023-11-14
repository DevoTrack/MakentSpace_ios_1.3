//
//  CalendarDataSourceHandler.swift
//  Makent
//
//  Created by trioangle on 05/11/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
import UIKit



typealias TimeDataSource<T> = [Time : T?]
typealias HourlyDataSource<T> = [Date : TimeDataSource<T>]
typealias UnAvail = [Date.Day:[Time]]

class HourlyCalandarHandler<T> : NSObject{
    
    
    private var dataSource : HourlyDataSource<T> = [:]
    private var days : [Date]
    private let calendarCollection : UICollectionView
    
    init(_ collectionView : UICollectionView){
        self.calendarCollection = collectionView
        self.dataSource.removeAll()
        self.days = []
        super.init()
        let currentDate = Date()
        let months = currentDate.monthsInYear()
        for month in months{
            for date in month.getDatesForMonth(){
                days.append(date)
            }
        }
        self.calendarCollection.reloadData()
        
    }
    
    
    //MARK:-UDF
    func goToMonth(_ month : Date){
        let lang = Language.getCurrentLanguage()
        if  var index = self.days.compactMap({$0.month}).firstIndex(of: month.month){
           
            index += month.day + 2
            
            print("firstIndex:",self.days.compactMap({$0.month}).firstIndex(of: month.month))
            guard self.days.indices.contains( index) else{return}
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.calendarCollection.scrollToItem(at: IndexPath(item: index, section: 0),
                                                     at: .right,
                                                     animated: true)
            }
        }
    }
    func addNextYear(){
        
        let toIndex = self.days.count - 1
        guard let lastDate = self.days.last,
            let dateFromOneYearApart =
            Calendar.current.date(byAdding: .year, value: 3, to: lastDate) else{return}
        let prevDate = Calendar.current.date(byAdding: .day, value: 1, to: lastDate)!
        let months = prevDate.monthsInYear()
        print("MonthsCount:",months.count)
        print("MonthValues:",months)
        
        for month in months{
            
            for date in month.getDatesForMonth(){
                print("MonthDays:",month.getDatesForMonth())
                days.append(date)
            }
        }
//        let months = dateFromOneYearApart.monthsInYear()
//        for month in months{
//            for date in month.getDatesForMonth(){
//                if !self.days.contains(obj: date){
//                    days.append(date)
//                }
//            }
//        }
//        self.calendarCollection.reloadData()
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
//            self.calendarCollection.scrollToItem(at: IndexPath(item: toIndex,
//                                                               section: 0),
//                                                 at: .right,
//                                                 animated: false)
//        }
        
    }
    func addPreviousYear(){
        let toIndex = self.days.count - 1
        guard let fistDate = self.days.first,
            let dateFromOneYearBefore =
            Calendar.current.date(byAdding: Calendar.Component.year, value: -1, to: fistDate) else{return}
        
        let months = dateFromOneYearBefore.monthsInYear()
        var newPrefixDate = [Date]()
        for month in months{
            for date in month.getDatesForMonth(){
                if !self.days.contains(obj: date){
                    newPrefixDate.append(date)
                }
            }
        }
        self.days = newPrefixDate + self.days
        self.calendarCollection.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.calendarCollection.scrollToItem(at: IndexPath(item: toIndex,
                                                               section: 0),
                                                 at: .right,
                                                 animated: false)
        }
    }
}
//MARK:- getter setters
extension HourlyCalandarHandler{
    var dateCount : Int{
        return self.days.count
    }
    func date(for index : Int) -> Date?{
        return self.days.value(atSafeIndex: index)
    }
    func hour(for index : Int) -> Time?{
        return Time(forIndex: index)
    }
    /**
     get Data<T> for indexPath
     - Author: Abishek Robin
     - Parameters:
     - index: IndexPath
     */
    func getData(for index : IndexPath) -> T?{
        
        guard let date = self.days.value(atSafeIndex: index.item) else {
            return nil
        }
        let time = Time(forIndex: index.section)
        return self.getData(for: date, time: time)
    }
    /**
     set Data<T> for indexPath
     - Author: Abishek Robin
     - Parameters:
     - value : T
     - index: IndexPath
     */
    func setData(_ value : T?,for index : IndexPath){
        guard let date = self.days.value(atSafeIndex: index.item) else {
            return
        }
        let time = Time(forIndex: index.section)
        return self.setData(value, for: date, time: time)
    }
    /**
     get Data<T> for indexPath
     - Author: Abishek Robin
     - Parameters:
     - date: Date
     - time: Time
     */
    func getData(for date : Date,time : Time) -> T?{
        if let item = dataSource[date]?[time]{
            return item
        }
        return nil
    }
    /**
     set Data<T> for indexPath
     - Author: Abishek Robin
     - Parameters:
     - value: T
     - date: Date
     - time: Time
     */
    func setData(_ value : T? ,for date : Date,time : Time){
        var timeData : TimeDataSource<T> = [:]
        if let oldTimeData = self.dataSource[date]{
            timeData = oldTimeData
        }
        timeData[time] = value
        
        self.dataSource[date] = timeData
        
    }
}

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
