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
