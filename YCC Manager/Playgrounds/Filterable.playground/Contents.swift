import Cocoa

struct Person {
    var name: String
    var mobileNumber: Int
}

protocol FilterableTableContent {
    var primaryField: String { get }
    var secondaryField: String { get }
}

extension Person: FilterableTableContent {
    var primaryField: String {
        return name
    }
    
    var secondaryField: String {
        return String(mobileNumber)
    }
}


let persons: [FilterableTableContent] = [
    Person(name: "Vikram Raj Gopinathan", mobileNumber: 9958235698),
    Person(name: "Kirthika Vikram", mobileNumber: 9871318150),
    Person(name: "Nirmal Raj Gopinathan", mobileNumber: 1234567890),
    Person(name: "Kalpana Nirmal", mobileNumber: 2345678901),
    Person(name: "Naishadha Nirmal", mobileNumber: 3456789012),
    Person(name: "Makshidha Nirmal", mobileNumber: 4567890123)
]


let str = "98"
let items =  persons.filter { item in
    if item.primaryField.lowercased().contains(str.lowercased()) {
        return true
    }
    return item.secondaryField.lowercased().contains(str.lowercased())
}
items



let text = "Vikram Raj" as NSString

let ran = text.range(of: "ra")
ran

let ranb = text.range(of: "bz")
ranb.lowerBound == NSNotFound
