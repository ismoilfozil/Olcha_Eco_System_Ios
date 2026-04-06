//
//  BrandPageViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 20/07/22.
//

import Foundation
import Combine
import OlchaUI
import OlchaCore
import OlchaAuth
class BrandPageViewModel: OldBaseViewModel {
  
    @Published var sliders: BrandSlidersData?
    @Published var categories: LoadingState<CatData, BaseErrorType> = .standart
    @Published var brands: (Int, ManufacturersData?)?
    @Published var brandsErrorIndex: Int?
    
    let brandsCenterLoading = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    
    func loadBrandCategories(with id: Int) {
        categories = .loading
        let api: BrandAPI = .categories(brandID: id)
        self.startRequesting(api: api) { [weak self] (data: CatData?) in
            guard let self = self else { return }
            categories = .success(data)
        } onError: { [weak self] error in
            guard let self else { return }
            categories = .failure(.init(message: error))
        }
    }
    
    func loadLetterBrands(_ letter: String,
                          index: Int = -1,
                          page: Int = 1) {
        let api: BrandAPI = .brands(letter: letter, page: page)
        brandsCenterLoading.send(true)
        self.startRequesting(api: api) { [weak self] (data: ManufacturersData?) in
            guard let self = self else { return }
            
            self.brandsCenterLoading.send(false)
            self.brands = (index, data)
            
        } onError: { [weak self] message in
            guard let self = self else { return }
            
            self.brandsCenterLoading.send(false)
            self.show(error: message)
            self.brandsErrorIndex = index
        }
    }
    
    func loadBrandSliders(with slug: String) {
        let api: BrandAPI = .sliders(slug: slug)
        self.startRequesting(api: api) { [weak self] (data: BrandSlidersData?) in
            guard let self = self else { return }
            self.sliders = data
        }
    }
    
    func getLetterBrands() -> [LetterBrandModel] {
        return [
            .init(letter: "0 - 9"),
            .init(letter: "A"),
            .init(letter: "B"),
            .init(letter: "C"),
            .init(letter: "D"),
            .init(letter: "E"),
            .init(letter: "F"),
            .init(letter: "G"),
            .init(letter: "H"),
            .init(letter: "I"),
            .init(letter: "J"),
            .init(letter: "K"),
            .init(letter: "L"),
            .init(letter: "M"),
            .init(letter: "N"),
            .init(letter: "O"),
            .init(letter: "P"),
            .init(letter: "Q"),
            .init(letter: "R"),
            .init(letter: "S"),
            .init(letter: "T"),
            .init(letter: "U"),
            .init(letter: "V"),
            .init(letter: "X"),
            .init(letter: "Y"),
            .init(letter: "Z"),
            .init(letter: "А - Я")
        ]
    }
}
