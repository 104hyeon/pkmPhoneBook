
import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    static let id = "TableViewCell"

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        return imageView
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureUI() {
        [
            profileImageView,
            nameLabel,
            phoneNumberLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(60)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        phoneNumberLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    // 테이블뷰 셀 데이터 임시
    public func configureCell(
        image: UIImage? = nil,
        name: String = "name",
        phoneNumber: String = "010-1111-2222"
    ) {
//        guard let image = profileImageView.image else {
//            return profileImageView.backgroundColor = .white
//        }
//                
        profileImageView.image = image
        nameLabel.text = name
        phoneNumberLabel.text = phoneNumber
        
    }

}


    



