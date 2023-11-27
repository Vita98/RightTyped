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
//    func decode()
}

extension Serializable {
    func jsonEncode() -> Data? { return try? JSONEncoder().encode(self) }
}

protocol QRCodable: Serializable {}
protocol Fileable: Serializable {}

let objectPossibilities: [Serializable.Type] = [AnswerShareModel.self, CategoryShareModel.self]


struct AnswerShareModel: QRCodable, Fileable {
    public var title: String
    public var descr: String
    public var enabled: Bool
    
    init(from manAnsw: Answer){
        self.descr = manAnsw.descr
        self.title = manAnsw.title
        self.enabled = manAnsw.enabled
    }
    
    init() {
        self.title = ""
        self.descr = ""
        self.enabled = false
    }
}

struct CategoryShareModel: QRCodable, Fileable {
    public var maxAnswers: Int64
    public var name: String
    public var answers: [AnswerShareModel]?
    public var enabled: Bool
    
    init(){
        self.maxAnswers = 0
        self.name = ""
        self.answers = nil
        self.enabled = false
    }
    
    init(from manCat: Category){
        self.name = manCat.name
        self.maxAnswers = manCat.maxAnswers
        self.enabled = manCat.enabled
        self.answers = convertAnswers(manCat.answers?.allObjects as? [Answer])
    }
    
    private func convertAnswers(_ answers: [Answer]?) -> [AnswerShareModel]? {
        guard let answers = answers else { return nil }
        return answers.map({AnswerShareModel(from: $0)})
    }
}
