
//  ViewController.swift
//  pkmPhoneBook

import UIKit
import SnapKit
import CoreData

class MainViewController: UIViewController {
    
    var container: NSPersistentContainer!
    var contactList: [Contact] = []

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "친구 목록"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var listTableView: UITableView = {
       let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        configureUI()
        setConstraints()
        loadContacts()
    }
    // 메인화면 띄울 때마다 이름 기준으로 가나다순 정렬
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        contactList.sort {
            ($0.name) < ($1.name)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [
            titleLabel,
            addButton,
            listTableView
        ].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
        }
    }
    
    // '추가' 버튼 액션
    @objc
    private func buttonTapped() {
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.delegate = self
        self.navigationController?.pushViewController(phoneBookVC, animated: true)
    }
}
// 테이블뷰 관련
extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    // 테이블뷰 셀 크기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    // 테이블뷰 행 갯수 임시
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactList.count
    }
    // 테이블뷰 셀에 데이터 표시
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let contact = contactList[indexPath.row]
        
        cell.configureCell(with: contact)
        return cell
    }
    // 테이블뷰 셀을 선택했을 때 사용될 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contactList[indexPath.row]
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.contactData = selectedContact
        // 데이터를 다시 전달 받기 위에 델리게이트 연결
        phoneBookVC.delegate = self
        // 인덱스 전달
        phoneBookVC.contactIndex = indexPath.row
        
        self.navigationController?.pushViewController(phoneBookVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// Add델리게이트 관련
extension MainViewController: AddDataDelegate {
    
    // 추가 버튼 누를 때 사용되는 델리게이트 함수
    func addContact(contact: Contact) {
        contactList.append(contact)
        saveContacts(data: contact)
        listTableView.reloadData()
    }
    // 셀 누르고 수정할 때 사용되는 델리게이트 함수
    func editContact(contact: Contact, at index: Int) {
        //  기존 데이터와 수정한 데이터 구분
        let originalContact = contactList[index]
        
        updateContact(currentContact: originalContact, updateContact: contact)
        contactList[index] = contact
        
        listTableView.reloadData()
    }
}

// CoreData 데이터 관리
extension MainViewController {
     // creat
    func saveContacts(data: Contact) {
        guard let entity = NSEntityDescription.entity(forEntityName: "PkmPhoneBook", in: self.container.viewContext) else { return }
        let newContact = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        newContact.setValue(data.imageData, forKey: "profileImage")
        newContact.setValue(data.name, forKey: "name")
        newContact.setValue(data.phoneNumber, forKey: "phoneNumber")
        newContact.setValue(data.id.uuidString, forKey: "contactID")
        
        do {
            try self.container.viewContext.save()
            print("연락처 저장 성공")
        } catch {
            print("연락처 저장 실패")
        }
    }
    // read
    func loadContacts() {
        
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PkmPhoneBook")
            guard let fetchedObjects = try? self.container.viewContext.fetch(fetchRequest) else { return }
            
            contactList.removeAll()
            
            for coreDataContact in fetchedObjects {
                guard let name = coreDataContact.value(forKey: "name") as? String,
                      let phoneNumber = coreDataContact.value(forKey: "phoneNumber") as? String,
                      let idString = coreDataContact.value(forKey: "contactID") as? String,
                      let contactUUID = UUID(uuidString: idString)
                else { continue }
                
                let contact = Contact(
                    id: contactUUID,
                    imageData: coreDataContact.value(forKey: "profileImage") as? Data,
                    name: name,
                    phoneNumber: phoneNumber
                )
                contactList.append(contact)
            }
        listTableView.reloadData()
        }
    // update
    func updateContact(currentContact: Contact, updateContact: Contact) {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "PkmPhoneBook")
        let predicate = NSPredicate(format: "contactID == %@", currentContact.id.uuidString)
        
        fetchRequest.predicate = predicate
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                data.setValue(updateContact.imageData, forKey: "profileImage")
                data.setValue(updateContact.name, forKey: "name")
                data.setValue(updateContact.phoneNumber, forKey: "phoneNumber")
                
                try self.container.viewContext.save()
                print("데이터 수정 완료")
                 break
            }
        } catch {
            print("데이터 수정 실패")
        }
    }
    
}


