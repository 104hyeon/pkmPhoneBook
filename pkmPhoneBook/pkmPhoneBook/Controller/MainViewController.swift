
//  ViewController.swift
//  pkmPhoneBook

import UIKit
import SnapKit

class MainViewController: UIViewController {

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
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
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
    private func buttonTapped(_ sender: UIButton) {
        self.navigationController?.pushViewController(PhoneBookViewController(), animated: true)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    // 테이블뷰 셀 크기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    // 테이블뷰 행 갯수 임시
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell()
        return cell
    }
    
    
    
}
