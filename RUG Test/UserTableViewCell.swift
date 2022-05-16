//
//  UserTableViewCell.swift
//  RUG Test
//
//  Created by Kinney Kare on 5/13/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Variable & Contstant Declarations
    static let identifier = K.ReusableIdentifier.userTableViewCell
    
    private var isImage = true
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 0.01
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.clipsToBounds = true
        return imageView
    }()
    
     let myLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - init methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(myImageView)
        contentView.addSubview(myLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: layout subviews method
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        //Created an image size to adjust the image depending on the cell height (if that should change)
        let imageSize = contentView.frame.size.height - 6
        let contentViewHeight = contentView.frame.size.height
        let contentViewWidth = contentView.frame.size.width
        
        myImageView.frame = CGRect(x: 20, y: 4, width: imageSize, height: imageSize)
        myImageView.layer.cornerRadius = imageSize / 2
        myLabel.frame = CGRect(x: 25 + imageSize, y: 0, width: contentViewWidth - 20 - imageSize , height: contentViewHeight)
    }
    
    
    // TODO: - I have this same function in two files. I need to put in its own file and reuse it as needed. 
    func configure(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let this = self else { return }
            guard let data = data, error == nil else {
                this.isImage = false
                return
            }
            
            //now we can create the image with this "task"/data
            
            DispatchQueue.main.async {
                if this.isImage {
                    let image = UIImage(data: data)
                    this.myImageView.image = image
                } else {
                    this.myImageView.image = UIImage(named: K.ImageAssets.noImage)
                }
            }
        }
        task.resume()
    }
}
