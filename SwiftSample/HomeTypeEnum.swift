//
//  HomeTypeEnum.swift
//  Makent
//
//  Created by trioangle on 05/08/19.
//  Copyright © 2019 Vignesh Palanivel. All rights reserved.
//

import Foundation
enum HomeType {
    case home
    case experiance
    case experianceCategory(_ category : ExploreCat?)
    case all
    case onFilterSearch
    case showAll(_ key : String?)
    var language : LanguageProtocol
    {
        return Language.getCurrentLanguage().getLocalizedInstance()
    }
}
extension HomeType : Equatable
{
    static public func == (lhs: HomeType, rhs: HomeType) -> Bool {
        switch (lhs, rhs) {
        case (.home,   .home):
            return true
        case (.experiance,   .experiance):
            return true
        case (.experianceCategory(let value1),.experianceCategory(let value2)):
            guard let left = value1,let right = value2 else {
                return true
            }
            return left.id == right.id
        case (.all,   .all):
            return true
        case (.showAll(let value1),.showAll(let value2)):
            guard let left = value1,let right = value2 else {return true}
            return left.lowercased() == right.lowercased()
        case (.onFilterSearch,.onFilterSearch):
            return true
        default:
            return false
        }
    }
}
extension HomeType{
    var shouldHideMapFilter : Bool
    {
        switch self {
//        case .all,.experianceCategory,.onFilterSearch:
//            return true
//        case .showAll,.home,.experiance:
//            return false
//        }
            case .all,.experianceCategory,.onFilterSearch,.experiance:
 //            return true
             return false
           case .showAll,.home:
            return true
 //           return false
        }
    }
    
    var getSearchLabelText : String
    {
        switch self {
        case .showAll(let key):
            guard let _key = key else{fallthrough}
            //            if _key.contains(self.language.anywhere_Tit){
            //                print("##$$$",key)
            //                return _key
            //            }else{
            return " • \(_key)"
        //            }
        case .all,.onFilterSearch:
            return ""
        case .home:
            return " • \(self.language.Homes)"
        case .experianceCategory(let category):
            guard let _category = category else
            {
                fallthrough
            }
            //return " • \(self.language.Experiences) • \(_category.name)"
            //return " • \(_category.name)"
            return ""
        case .experiance:
           // return " • \(self.language.Experiences)"
            return ""
        }
    }
    
    var getSearchTextColor : UIColor{
        switch self {
        case .all,.onFilterSearch:
            return .gray
        default:
            return .black
        }
    }
    var getIconName : String
    {
        switch self {
        case .all:
            return "search.png"
        case .experiance:
            return "search.png"
        case .onFilterSearch:
            return "searchBack.png"
        default:
            return "searchBack.png"
        }
    }
    var getFilterTitleArray : [FilterStruct]{
        print("getFilterTitleArray")
        var array = [FilterStruct]()
        let guest = FilterStruct(title: self.language.guests, isApplyFilter: false, type: .guest)
        let date = FilterStruct(title: self.language.date, isApplyFilter: false, type: .date)
        let filter = FilterStruct(title: self.language.filter, isApplyFilter: false, type: .filter)
        switch self {
        case .home:
            array = [date, guest, filter]
        case .showAll( _):
            array = [date, guest, filter]
        case .experiance:
            //array = [date, guest]
            array = [date, guest, filter]
        default:
           // array = [date, guest]
            array = [date, guest, filter]
          //  array = []
        }
        if let filteredDates = SharedVariables.sharedInstance.getFilteredDatesDisplayName(){
            array[0] = FilterStruct(title: filteredDates, isApplyFilter: true, type: .date)
        }
        return array
    }
}
struct FilterStruct {
    var title:String
    var isApplyFilter:Bool
    var type:FilterType
}
enum FilterType {
    case date
    case guest
    case filter
}
