
import UIKit
import Foundation

protocol AddDataDelegate: AnyObject {
    // "추가"버튼 누를 때 사용
    func addContact(contact: Contact)
    // 셀 누르고 수정할 때 사용
    func editContact(contact: Contact, at index: Int)
    }
