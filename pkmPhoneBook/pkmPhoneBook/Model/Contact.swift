// Contact struct 파일 분리

import UIKit

struct Contact: Codable {
    let imageData: Data?
    let name: String
    let phoneNumber: String
    // UIImage Codable 사용하기 위해 data타입으로 변경
    var image: UIImage? {
        guard let imageData = imageData else { return nil }
        return UIImage(data: imageData)
    }
}
