
//  ViewController.swift
//  pkmPhoneBook

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    var contactList: [Contact] = []
    let contactKey = "contactList"
    
    
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
        configureUI()
        setConstraints()
        loadContacts()
    }
    
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

extension MainViewController: UITableViewDelegate, UITableViewDataSource, AddDataDelegate {
    // 테이블뷰 셀 크기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    // 테이블뷰 행 갯수 임시
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let contact = contactList[indexPath.row]
        
        cell.configureCell(with: contact)
        return cell
    }
    
    func addContact(contact: Contact) {
        contactList.append(contact)
        saveContacts()
        listTableView.reloadData()
    }
    // 테이블뷰 셀을 선택했을 때 사용될 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contactList[indexPath.row]
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.contactData = selectedContact
                
        self.navigationController?.pushViewController(phoneBookVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // UserDefault 저장 및 불러오기
    func saveContacts() {
        do {
            let encoded = try JSONEncoder().encode(contactList)
            UserDefaults.standard.set(encoded, forKey: contactKey)
            print("연락처 저장 성공")
        } catch {
            print("연락처 저장 실패")
        }
    }

    func loadContacts() {
        guard let savedData = UserDefaults.standard.data(forKey: contactKey) else {
            print("저장된 데이터 없음")
            return
        }
        do {
            let decoded = try JSONDecoder().decode([Contact].self, from: savedData)
            self.contactList = decoded
            self.listTableView.reloadData()
            print("연락처 불러오기 성공")
            
        } catch {
            print("연락처 불러오기 실패:", error)
        }
    }
}


