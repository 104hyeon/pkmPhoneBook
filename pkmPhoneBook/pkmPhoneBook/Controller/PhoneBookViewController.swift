
import UIKit
import SnapKit

final class PhoneBookViewController: UIViewController {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 100
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()
    private lazy var randomButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(didTappedRandom), for: .touchUpInside)
        return button
    }()
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        setupNavigationBar()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [
            profileImageView,
            randomButton,
            nameTextField,
            phoneTextField
        ].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        randomButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(randomButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        phoneTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameTextField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
    }
    // 내비게이션바 아이템 추가
    private func setupNavigationBar() {
        self.navigationItem.title = "연락처 추가"
        let saveButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(didTappedSave))
        
        self.navigationItem.rightBarButtonItem = saveButton
    }
    // '랜덤 이미지 생성'버튼 액션
    @objc
    private func didTappedRandom() {
        print("랜덤 생성")
    }
    // '적용'버튼 액션
    @objc
    private func didTappedSave() {
        print("적용 완료")
        self.navigationController?.popViewController(animated: true)
    }
    
}
