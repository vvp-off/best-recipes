//
//  HomePresenter.swift
//  Best Recipes
//
//  Created by Дарья Балацун on 12.08.25.
//

import Foundation

protocol HomePresenterProtocol {
    var view: HomeViewProtocol? { get set }
    var trendingRecipes: [RecipeInfo] { get }
    var popularRecipes: [RecipeInfo] { get }
    var recentRecipes: [RecipeInfo] { get }
    var popularCreators: [RecipeInfo] { get }
    var categories: [String] { get }
    
    func viewDidLoad()
    func didSelectRecipe(_ recipe: RecipeInfo)
    func didTapAddButton(for recipe: RecipeInfo)
    func didSelectCategory(_ category: String)
    
    func didTapSeeAllTrending()
    func didTapSeeAllPopular()
    func didTapSeeAllRecent()
}

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    private let networkManager: NetworkManager
    private let router: MainRouterProtocol
    
    private(set) var trendingRecipes: [RecipeInfo] = []
    private(set) var popularRecipes: [RecipeInfo] = []
    private(set) var recentRecipes: [RecipeInfo] = []
    private(set) var popularCreators: [RecipeInfo] = []
    let categories = ["Breakfast", "Lunch", "Dinner", "Dessert", "Drinks", "Snacks", "Salad", "Soup", "Vegan", "Quick"]
    
    init(networkManager: NetworkManager, router: MainRouterProtocol) {
        self.networkManager = networkManager
        self.router = router
    }
    
    func viewDidLoad() {
        fetchTrendingRecipes()
        fetchPopularRecipes()
    }
    
    private func fetchTrendingRecipes() {
        networkManager.getRandomRecipes { [weak self] result in
            switch result {
            case .success(let response):
                self?.trendingRecipes = response.recipes ?? []
                self?.recentRecipes = Array(response.recipes?.shuffled().prefix(10) ?? [])
                self?.view?.displayTrendingRecipes(response.recipes ?? [])
                self?.view?.displayRecentRecipes(self?.recentRecipes ?? [])
            case .failure(let error):
                print("Error fetching trending recipes: \(error)")            }
        }
    }
    
    private func fetchPopularRecipes() {
        networkManager.getPopularRecipes { [weak self] result in
            switch result {
            case .success(let response):
                self?.popularRecipes = response.results ?? []
                self?.popularCreators = Array(response.results?.shuffled().prefix(10) ?? [])
                self?.view?.displayPopularRecipes(response.results ?? [])
                self?.view?.displayPopularCreators(self?.popularCreators ?? [])
            case .failure(let error):
                print("Error fetching popular recipes: \(error)")
            }
        }
    }
    
    func didSelectRecipe(_ recipe: RecipeInfo) {
        router.routeToDetailScreen(recipe: recipe)
    }
    
    func didTapAddButton(for recipe: RecipeInfo) {
        
    }
    
    func didSelectCategory(_ category: String) {
        
    }
    
    func didTapSeeAllPopular() {
        router.routeToSeeAllScreen(recipes: popularRecipes, sortOrder: Endpoint.SortOrder.popular)
    }
    
    func didTapSeeAllRecent() {
        router.routeToSeeAllScreen(recipes: recentRecipes, sortOrder: Endpoint.SortOrder.recent)
    }
    
    func didTapSeeAllTrending() {
        router.routeToSeeAllScreen(recipes: recentRecipes, sortOrder: Endpoint.SortOrder.trendingNow)
    }
}

