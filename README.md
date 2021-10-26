- SceneDelegate

```swift
//
//  SceneDelegate.swift
//  SnapkitTutorial
//
//  Created by paige on 2021/10/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let viewModel = HomeViewModel()
            let controller = HomeViewController(viewModel: viewModel)
            window.rootViewController = controller
            self.window = window
            window.makeKeyAndVisible()
        }
        
    }

}
```

- HomeViewController

```swift
//
//  ViewController.swift
//  SnapkitTutorial
//
//  Created by paige on 2021/10/26.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collection)
        collection.backgroundColor = .white
        collection.register(CarouselCollectionCell.self, forCellWithReuseIdentifier: CarouselCollectionCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.snp.makeConstraints {
            $0.edges.equalToSuperview() //match_parent for entire screen
        }
        return collection
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.reloadData()
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionCell.identifier, for: indexPath) as! CarouselCollectionCell
        cell.cellModel = viewModel.modelFor(row: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
```

- HomeViewModel

```swift
//
//  HomeViewModel.swift
//  SnapkitTutorial
//
//  Created by paige on 2021/10/26.
//

import UIKit

class HomeViewModel {
    
    private let imageNames = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    private let titles = ["Nature", "Beaches", "Outdoor", "Playground", "Fun"]
    
    // MARK: - CollectionView DataSource
    func numberOfRows() -> Int {
        return 20
    }
    
    func modelFor(row: Int) -> CarouselCollectionCell.Model {
        let randomImages = imageNames.random(amount: 3)
        let title = titles.randomElement()
        let like = [true, false].randomElement() ?? false
        let carouselModel = CarouselView.Model(images: randomImages)
        let model = CarouselCollectionCell.Model(title: title, description: "This is demo description", liked: like, model: carouselModel)
        return model
    }
    
}

extension Collection {
    
    // 몇 개 만큼 랜덤하게 잡아줄지
    private func choose(_ n: Int) -> ArraySlice<Element> {
        return shuffled().prefix(n)
    }
    
    func random(amount: Int) -> [UIImage] {
        let names = choose(amount)
        let images = names.map {
            UIImage(named: $0 as! String)!
        }
        return images
    }
    
}
```

- CarouselCollectionCell

```swift
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
```

- CarouselView

```swift
//
//  CarouselView.swift
//  SnapkitTutorial
//
//  Created by paige on 2021/10/26.
//

import UIKit

class CarouselView: UIView {
    
    var model: Model? {
        didSet {
            if let model = model {
                setupView(model: model)
            }
        }
    }
    
    private lazy var imageViewOne: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview().offset(-(frame.width / 2) - 20)
        }
        return imageView
    }()
    
    private lazy var imageViewTwo: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints {
            $0.left.equalTo(imageViewOne.snp.right).offset(1)
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalToSuperview().offset(-(frame.height / 2) - 1)
        }
        return imageView
    }()
    
    private lazy var imageViewThree: UIImageView = {
        let imageView = UIImageView()
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints {
            $0.left.equalTo(imageViewOne.snp.right).offset(1)
            $0.top.equalTo(imageViewTwo.snp.bottom).offset(1)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        return imageView
    }()
    
    private lazy var imageViews = [imageViewOne, imageViewTwo, imageViewThree]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(model: Model) {
        for (index, view) in imageViews.enumerated() {
            let hasAnotherImage = (model.images?.count) ?? 0 > index
            if hasAnotherImage {
                view.image = model.images?[index]
            }
        }
    }
    
    struct Model {
        var images: [UIImage]?
    }
    
}
```
