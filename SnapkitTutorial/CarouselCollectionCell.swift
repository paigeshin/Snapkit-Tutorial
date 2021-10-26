//
//  CarousalCollectionCell.swift
//  SnapkitTutorial
//
//  Created by paige on 2021/10/26.
//

import UIKit

class CarouselCollectionCell: UICollectionViewCell {
    
    static let identifier = "CarouselCollectionCell"
    
    private let carouselPadding: CGFloat = 60.0
    
    var cellModel: Model? {
        didSet {
            setupUI(cellModel: cellModel)
        }
    }
    
    private lazy var carouselView: CarouselView = {
        let frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height - carouselPadding)
        let carouselView = CarouselView(frame: frame)
        contentView.addSubview(carouselView)
        carouselView.snp.makeConstraints {
            $0.edges.equalToSuperview()
//            $0.top.equalTo(contentView)
//            $0.left.equalTo(contentView)
//            $0.right.equalTo(contentView)
//            $0.bottom.equalTo(contentView).offset(carouselPadding)
        }
        return carouselView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        contentView.addSubview(button)
        button.snp.makeConstraints{
            $0.width.equalTo(30)
            $0.height.equalTo(30)
            $0.top.equalTo(carouselView.snp.bottom).offset(8)
            $0.right.equalToSuperview().inset(20)
//            $0.bottom.equalTo(contentView).offset(8)
        }
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        contentView.addSubview(label)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.top.equalTo(carouselView.snp.bottom).offset(4)
            $0.right.equalTo(likeButton.snp.left).inset(8)
        }
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.right.equalTo(likeButton.snp.left).inset(8)
        }
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct Model {
        var title: String?
        var description: String?
        var liked: Bool
        var model: CarouselView.Model
    }
    
    override func prepareForReuse() {
        cellModel = nil 
    }
    
    private func setupUI(cellModel: Model?) {
        guard let cellModel = cellModel else { return }
        carouselView.model = cellModel.model
        titleLabel.text = cellModel.title
        descriptionLabel.text = cellModel.description
        let image = cellModel.liked ? UIImage(named: "1") : UIImage(named: "2")
        likeButton.setImage(image, for: .normal)
    }
    
}
