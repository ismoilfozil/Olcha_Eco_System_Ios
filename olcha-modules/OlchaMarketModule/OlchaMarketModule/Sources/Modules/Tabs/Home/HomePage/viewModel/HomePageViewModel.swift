//
//  HomeViewModel.swift
//  NewOlcha
//
//  Created by Elbek Khasanov on 04/07/22.
//

import Foundation
import Combine
import OlchaCore
import OlchaUI
import OlchaAuth
class HomePageViewModel: OldBaseViewModel {
    
    //MARK: - RESPONSES
    @Published var mainBanners: SlidersData?
    @Published var discounts: DiscountsData?
    @Published var blogs: (Int, SlidersData)?
    @Published var builders: [ComponentModel] = []
    @Published var htmlModel: HtmlModel?
    @Published var builderErrorIndex: Int?
    @Published var blogsData: SlidersData?
    @Published var blogsError: Bool?
    @Published var blog: Blog?
    @Published var filters: HomeSegmentdata?
    //MARK: - INDICATORS
    let mainBannersIndicator = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        super.init(manager: OlchaDIContainer.shared.resolve())
    }
    
    func loadBanners(withIndicator: Bool = true) {
        let api: HomeAPI = .mainBanner
        self.startRequesting(api: api,
                             indicator: withIndicator ? mainBannersIndicator : nil) { [weak self] (data: SlidersData?) in
            guard let self = self else { return }
            if let data = data {
                self.mainBanners = data
            }
        }
    }
    
    func loadDiscounts() {
        let api: HomeAPI = .discounts
        self.startRequesting(api: api) { [weak self] (data: DiscountsData?) in
            guard let self = self else { return }
            if let data = data {
                self.discounts = data
            }
        }
    }
    
    func loadBlogs(index: Int, route: String) {
        let api: RouteAPI = .route(api: route)
        self.startRequesting(api: api) { [weak self] (data: SlidersData?) in
            guard let self = self else { return }
            if let data = data {
                self.blogs = (index, data)
            }
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.builderErrorIndex = index
            self.show(error: message)
        }
    }
    
    func loadBlogs(page: Int) {
        let api: HomeAPI = .blogs(page: page)
        self.startRequesting(api: api) { [weak self] (data: SlidersData?) in
            guard let self = self else { return }
            self.blogsData = data
        } onError: { [weak self] message in
            guard let self = self else { return }
            self.blogsError = true
            self.show(error: message)
        }
    }
    
    func loadBlog(with id: Int) {
        let api: HomeAPI = .blog(id: id)
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: NewsData?) in
            guard let self = self else { return }
            self.blog = data?.blog
        }
    }
    
    func loadHomeBuilder() {
        let api: HomeAPI = .builder
        self.startRequesting(api: api) { [weak self] (data: ComponentData?) in
            guard let self = self else { return }
            self.builders = data?.builder ?? []
        }
    }
    
    func loadHtmlFile(url: String) {
        let api: HomeAPI = .html(url: url)
        self.startRequesting(api: api, centerLoader: true) { [weak self] (data: HtmlModel?) in
            guard let self = self else { return }
            self.htmlModel = data
        }
    }
    
    func loadProductFilters() {
        let api: HomeAPI = .products
        
        self.startRequesting(api: api) { [weak self] (data: HomeSegmentdata?) in
            guard let self else { return }
            filters = data
        }

    }
}
