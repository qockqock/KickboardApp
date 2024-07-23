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
        // 해당 entityType으로 지정된 Entity를 가져옴
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: entityType), in: self.context) else { return }
        // T(entity:, insertInfo:) 초기화 메서드 사용하여 newObject 생성하고 context에 삽입
        let newObject = T(entity: entity, insertInto: self.context)
        // "속성":값 순서로 newObject에 값을 set
        values.forEach {newObject.setValue($1, forKey: $0)}
        saveContext()
    }
    
    /// 일반화된 READ 메서드 - sh
    /// - Parameters:
    ///   - entityType: 어떤 엔티티를 불러올건지 결정, 예를 들어 RideData.self
    ///   - configure: 읽어온 entityType를 처리하는 클로저
    func read<T:NSManagedObject>(entityType: T.Type, configure: (T) -> Void) {
        // 해당 entityType으로 지정된 엔티티에 해당하는 NSFetchRequest 객체 생성
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        do {
            // fetch 요청 실행 결과를 result로 저장 후 configure 클로저 호출하여 처리
            let results = try self.context.fetch(fetchRequest)
            for result in results {
                configure(result)
            }
        } catch {
            // try문 실패시 오류처리
            print("데이터 읽기 실패")
        }
    }
    
    /// 일반화된  UPDATE 메서드 - sh
    /// - Parameters:
    ///   - entityType: 어떤 엔티티의 값을 변경할건지 결정
    ///   - predicate: 업데이트할 NSObject 찾기 위한 조건 설정
    ///   - values: ["Attribute":변경할 값] 형식으로 작성
    func update<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate, values: [String:Any]) {
        // 해당 entityType으로 지정된 엔티티에 해당하는 NSFetchRequest 객체 생성
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        // NSPredicate로 검색조건 설정
        fetchRequest.predicate = predicate
        do {
            // fetch 실행 성공시 result에 저장
            let results = try self.context.fetch(fetchRequest)
            for result in results {
                // result에 따라 값 변경
                values.forEach {result.setValue($1, forKey: $0)}
            }
            saveContext()
            print("문맥 업데이트 성공")
        } catch {
            // 실패시 오류메세지 출력
            print("문맥 업데이트 실패")
        }
    }
    
    /// 일반화된 DELETE 메서드 - sh
    /// - Parameters:
    ///   - entityType: 어떤 엔티티의 값을 삭제할건지 결정
    ///   - predicate: 삭제할 NSObject 찾기 위한 조건 설정
    func delete<T:NSManagedObject>(entityType: T.Type, predicate: NSPredicate) {
        // 해당 entityType으로 지정된 엔티티에 해당하는 NSFetchRequest 객체 생성
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        // NSPredicate로 검색조건 설정
        fetchRequest.predicate = predicate
        do {
            // fetch 실행 성공시 result에 저장
            let results = try self.context.fetch(fetchRequest)
            for result in results {
                // result에 대응하는 값 삭제
                self.context.delete(result)
            }
            print("문맥 삭제 성공")
        } catch {
            // try문 실패시 오류메세지 출력
            print("문맥 삭제 실패")
        }
    }
}
