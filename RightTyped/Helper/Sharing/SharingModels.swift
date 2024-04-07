//
//  SharingModels.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 05/11/23.
//

import Foundation
import CoreData

protocol Serializable: Codable{
    func jsonEncode() -> Data?
    static func jsonDecode(_ data: Data) -> Self?
}

extension Serializable {
    func jsonEncode() -> Data? { return try? JSONEncoder().encode(self) }
    static func jsonDecode(_ data: Data) -> Self? { return try? JSONDecoder().decode(Self.self, from: data)}
}

protocol QRCodable: Serializable {}
protocol Fileable: Serializable {}

let objectPossibilities: [Serializable.Type] = [AnswerShareModel.self, CategoryShareModel.self]


struct AnswerShareModel: QRCodable, Fileable {
    public var title: String
    public var descr: String?
    
    init(from manAnsw: Answer){
        self.title = manAnsw.title
        if manAnsw.title == manAnsw.descr {
            self.descr = nil
        } else {
            self.descr = manAnsw.descr
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title =        "1"
        case descr =        "2"
    }
    
    func toManagedObject() -> Answer {
        let answ = Answer(entity: Answer.entity(), insertInto: nil)
        answ.descr = self.descr ?? self.title
        answ.title = self.title
        return answ
    }
}

struct CategoryShareModel: QRCodable, Fileable {
    public var maxAnswers: Int64
    public var name: String
    public var answers: [AnswerShareModel]?
    
    init(){
        self.maxAnswers = 0
        self.name = ""
        self.answers = nil
    }
    
    init(from manCat: Category){
        self.name = manCat.name
        self.maxAnswers = manCat.maxAnswers
        self.answers = convertAnswers(manCat.answers?.allObjects as? [Answer])
    }
    
    private func convertAnswers(_ answers: [Answer]?) -> [AnswerShareModel]? {
        guard let answers = answers else { return nil }
        return answers.map({AnswerShareModel(from: $0)})
    }
    
    public func checkAnswers() -> Bool {
        guard let answersCount = answers?.count else { return false }
        if UserDefaultManager.shared.getProPlanStatus() { return true }
        else { return answersCount <= MAXIMUM_ANSWERS_FOR_CATEGORIES }
    }
    
    enum CodingKeys: String, CodingKey {
        case maxAnswers =   "3"
        case answers =      "4"
        case name =         "5"
    }
}
