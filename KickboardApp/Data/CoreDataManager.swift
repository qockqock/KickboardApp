//
//  CoreDataManager.swift
//  KickboardApp
//
//  Created by 김승희 on 7/22/24.

import UIKit
import CoreData

class CoreDataManager {
    static let shared : CoreDataManager = CoreDataManager()
    var container: NSPersistentContainer!
    var context: NSManagedObjectContext!
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        self.context = self.container.viewContext
    }
    
    /// 데이터 저장 함수 - sh
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("문맥 저장 성공")
            } catch {
                print("문맥 저장 실패")
            }
        }
    }

    /// 일반화된 CREATE 메서드, T는 NSManagedObject를 상속받는 타입 - sh
    /// - Parameters:
    ///   - entityType: 어떤 엔티티를 불러올건지 결정, 예를 들어 RideData.self
    ///   - values: Attribute:Value 형식으로 값 생성, 예를 들어 ["id":UUID(), "date":Date(), "distance":3.2, ... ] 처럼 딕셔너리 형식으로 입력
    func create<T:NSManagedObject>(entityType: T.Type, values: [String:Any]) {
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: entityType), in: self.context) else { return }
        let newObject = T(entity: entity, insertInto: self.context)
        values.forEach {newObject.setValue($1, forKey: $0)}
        saveContext()
    }
    
    /// 일반화된 READ 메서드 - sh
    /// - Parameters:
    ///   - entityType: 어떤 엔티티를 불러올건지 결정, 예를 들어 RideData.self
    ///   - configure: 읽어온 entityType를 처리하는 클로저
    func read<T: NSManagedObject>(entityType: T.Type, configure: (T) -> Void) {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        do {
            let results = try self.context.fetch(fetchRequest)
            for result in results {
                configure(result)
            }
        } catch {
            print("데이터 읽기 실패")
        }
    }
    
    /// 일반화된  UPDATE 메서드 - sh
    /// - Parameters:
    ///   - entityType: 어떤 엔티티의 값을 변경할건지 결정
    ///   - predicate: 업데이트할 NSObject 찾기 위한 조건 설정
    ///   - values: ["Attribute":변경할 값] 형식으로 작성
    func update<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate, values: [String:Any]) {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        fetchRequest.predicate = predicate
        do {
            let results = try self.context.fetch(fetchRequest)
            for result in results {
                values.forEach {result.setValue($1, forKey: $0)}
            }
            saveContext()
            print("문맥 업데이트 성공")
        } catch {
            print("문맥 업데이트 실패")
        }
    }
    
    /// 일반화된 DELETE 메서드 - sh
    /// - Parameters:
    ///   - entityType: 어떤 엔티티의 값을 삭제할건지 결정
    ///   - predicate: 삭제할 NSObject 찾기 위한 조건 설정
    func delete<T:NSManagedObject>(entityType: T.Type, predicate: NSPredicate) {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        fetchRequest.predicate = predicate
        do {
            let results = try self.context.fetch(fetchRequest)
            for result in results {
                self.context.delete(result)
            }
            print("문맥 삭제 성공")
        } catch {
            print("문맥 삭제 실패")
        }
    }
    
    /// CoreData Container 초기화 메서드 - sh
    func deleteAll<T:NSManagedObject>(entityType: T.Type) {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        do {
            let results = try self.context.fetch(fetchRequest)
            for result in results {
                self.context.delete(result)
            }
            saveContext()
            print("모든 엔티티 삭제 성공")
        } catch {
            print("모든 엔티티 삭제 실패")
        }
    }
}
