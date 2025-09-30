
import UIKit
import SnapKit

class PhoneBookViewController: UIViewController {
    
    weak var delegate: AddDataDelegate?
    // mainView에서 가져온 데이터 선언
    var contactData: Contact?
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 100
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.clipsToBounds = true          // 원 밖의 이미지 잘리게
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
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()
    let phoneTextField: UITextField = {
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
        
        if let contact = contactData {
            receivedData(contact: contact)
        } else {
        }
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
    
    // main뷰에서 받은 데이터 넣는 함수
    private func receivedData(contact: Contact) {
        profileImageView.image = contact.image
        nameTextField.text = contact.name
        phoneTextField.text = contact.phoneNumber
        self.navigationItem.title = contact.name
    }
    
    
    // '랜덤 이미지 생성'버튼 액션
    @objc
    private func didTappedRandom() {
        print("랜덤 생성")

        fetchData { [weak self] pokemon in
            guard let self = self else { return }
            guard let pokemon = pokemon else { return }
            
            if let urlSting = pokemon.sprites.frontDefault,
               let url = URL(string: urlSting) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    guard let data = data else {
                        print("이미지 데이터 없음")
                        return
                    }
                    guard let image = UIImage(data: data) else {
                        print("이미지 변환 실패")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }.resume()
            } else {
                print("이미지 URL을 찾을 수 없음")
            }
        }
    }
    
    // '적용'버튼 액션
    @objc
    private func didTappedSave(_ sender: UIButton) {
        
        guard let nameText = nameTextField.text, !nameText.isEmpty else { return }
        guard let phoneText = phoneTextField.text, !phoneText.isEmpty else { return }
        guard let profileImage = profileImageView.image else { return }
        // Contact struct 내부 수정으로 image -> imageData로 변경
        let profileData = profileImage.jpegData(compressionQuality: 1.0)
        
        let newContact = Contact(imageData: profileData, name: nameText, phoneNumber: phoneText)
        
        delegate?.addContact(contact: newContact)
        
        self.navigationController?.popViewController(animated: true)
    }
}
// fetchData 함수
extension PhoneBookViewController {
    
    private func fetchData(completion: @escaping (PokemonData?) -> Void) {
        
        let randomID = Int.random(in: 1..<1010)
        
        // URL 구성요소
        let scheme = "https"
        let host = "pokeapi.co"
        let path = "/api/v2/pokemon/\(randomID)"
        
        let method = "GET"
        
        // URL 만들기
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        guard let url = components.url else { return }
        
        // request 만들기
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let pokemon = try JSONDecoder().decode(PokemonData.self, from: data)
                completion(pokemon)
                
            } catch {
                print("데이터 에러")
                completion(nil)
            }
        }.resume()
    }
    
}
