import UIKit

final class RecipeDetailViewController: UIViewController {

    private enum Layout {
        static let leadingTrailing: CGFloat = 16
        
        enum Header {
            static let height: CGFloat = 60
        }
        
        enum RecipeImage {
            static let top: CGFloat = 16
            static let height: CGFloat = 240
            static let cornerRadius: CGFloat = 16
        }
        
        enum Rating {
                    static let top: CGFloat = 12
                }

        enum InstructionsSection {
            static let top: CGFloat = 24
        }
        
        enum IngredientsSection {
            static let top: CGFloat = 32
        }
        
        enum TableView {
            static let top: CGFloat = 16
            static let cellHeight: CGFloat = 100
        }
    }

    var recipe: RecipeInfo
    
    init(recipe: RecipeInfo) {
        self.recipe = recipe
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .arrowLeft), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Recipe detail"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private let recipeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Layout.RecipeImage.cornerRadius
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private let ratingStackView: UIStackView = {
           let stackView = UIStackView()
           stackView.translatesAutoresizingMaskIntoConstraints = false
           stackView.axis = .horizontal
           stackView.alignment = .center
           stackView.spacing = 8
           return stackView
       }()

    private let starImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(systemName: "star.fill")
            imageView.tintColor = .black
            return imageView
       }()

    private let ratingLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
           label.textColor = .black
           return label
       }()
    
    private let reviewsLabel: UILabel = {
          let label = UILabel()
          label.translatesAutoresizingMaskIntoConstraints = false
          label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
          label.textColor = .gray
          return label
      }()


    private let instructionsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Instructions"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let instructionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()

    private let ingredientsTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private let ingredientsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ingredients"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()

    private let ingredientsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private let ingredientsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        addSubview()
        setupConstraints()
        setupTableView()
        setupActions()
        updateUI()
    }

    private func setupTableView() {
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: "IngredientCell")
    }

    private func setupActions() {
        backButton.addTarget(
            self,
            action: #selector(backButtonTapped),
            for: .touchUpInside
        )
    }

    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func updateUI() {
        
        let recipe = recipe
        
        recipeTitleLabel.text = recipe.title ?? "No title"
        
        let count = recipe.extendedIngredients?.count ?? 0
        ingredientsCountLabel.text = "\(count) items"
        
        setupRatingDisplay()
        
        if let imageUrlString = recipe.image, let url = URL(string: imageUrlString) {

            activityIndicator.startAnimating()
            
            loadImage(from: url) { image in
                DispatchQueue.main.async {
                    self.recipeImageView.image = image
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                }
            }
        }
        
        if let instructions = recipe.instructionsLabel {
            let steps = instructions.split(separator: "\n").map { String($0) }
            setupInstructionsViews(instructions: steps)
        }
        
        let tableHeight = CGFloat(count) * Layout.TableView.cellHeight
        ingredientsTableView.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
        ingredientsTableView.reloadData()
    }
    
    private func setupRatingDisplay() {
        
        let likes = recipe.aggregateLikes ?? 0
        let rating = 4.0 + (Double(likes) / 100.0)
        
        ratingLabel.text = String(format: "%.1f", rating )
        reviewsLabel.text = "(\(likes) Reviews)"
      }
    
    private func setupInstructionsViews(instructions: [String]) {
        instructionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, instruction) in instructions.enumerated() {
            let instructionView = createInstructionView(text: instruction)
            instructionsStackView.addArrangedSubview(instructionView)
        }
    }
    
    private func createInstructionView( text: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = text
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textLabel.textColor = .black
        textLabel.numberOfLines = 0
        
        containerView.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            textLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
        }.resume()
    }
}

// MARK: - UITableViewDataSource

extension RecipeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.extendedIngredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientTableViewCell,
              var ingredient = recipe.extendedIngredients?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.configure(with: ingredient)
        
        cell.checkButtonTapped = { [weak self] in
            guard let self = self else { return }
            ingredient.isChecked.toggle()
            self.recipe.extendedIngredients?[indexPath.row] = ingredient
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RecipeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Layout.TableView.cellHeight
    }
}

private extension RecipeDetailViewController {
    func addSubview() {
        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(headerTitleLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(recipeTitleLabel)
        contentView.addSubview(recipeImageView)
        recipeImageView.addSubview(activityIndicator)
        contentView.addSubview(ratingStackView)
        
        ratingStackView.addArrangedSubview(starImageView)
        ratingStackView.addArrangedSubview(ratingLabel)
        ratingStackView.addArrangedSubview(reviewsLabel)
        
        contentView.addSubview(instructionsTitleLabel)
        contentView.addSubview(instructionsStackView)
        contentView.addSubview(ingredientsTitleStackView)
        
        ingredientsTitleStackView.addArrangedSubview(ingredientsTitleLabel)
        ingredientsTitleStackView.addArrangedSubview(ingredientsCountLabel)
        
        contentView.addSubview(ingredientsTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
                   headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                   headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   headerView.heightAnchor.constraint(equalToConstant: Layout.Header.height),
                   
                   backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Layout.leadingTrailing),
                   backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                   backButton.widthAnchor.constraint(equalToConstant: 30),
                   backButton.heightAnchor.constraint(equalToConstant: 30),
                   
                   headerTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                   headerTitleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                   
                   scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                   scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                   
                   contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                   contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                   contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                   contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                   contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                   
                   recipeTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.leadingTrailing),
                   recipeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.leadingTrailing),
                   recipeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.leadingTrailing),
                   
                   recipeImageView.topAnchor.constraint(equalTo: recipeTitleLabel.bottomAnchor, constant: Layout.RecipeImage.top),
                   recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.leadingTrailing),
                   recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.leadingTrailing),
                   recipeImageView.heightAnchor.constraint(equalToConstant: Layout.RecipeImage.height),

                   activityIndicator.centerXAnchor.constraint(equalTo: recipeImageView.centerXAnchor),
                   activityIndicator.centerYAnchor.constraint(equalTo: recipeImageView.centerYAnchor),
                   
                   ratingStackView.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: Layout.Rating.top),
                   ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.leadingTrailing),

                   instructionsTitleLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: Layout.InstructionsSection.top),
                   instructionsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.leadingTrailing),
                   instructionsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.leadingTrailing),
                   
                   instructionsStackView.topAnchor.constraint(equalTo: instructionsTitleLabel.bottomAnchor, constant: Layout.TableView.top),
                   instructionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.leadingTrailing),
                   instructionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.leadingTrailing),
                   
                   ingredientsTitleStackView.topAnchor.constraint(equalTo: instructionsStackView.bottomAnchor, constant: Layout.IngredientsSection.top),
                   ingredientsTitleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.leadingTrailing),
                   ingredientsTitleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.leadingTrailing),
                   
                   ingredientsTableView.topAnchor.constraint(equalTo: ingredientsTitleStackView.bottomAnchor, constant: Layout.TableView.top),
                   ingredientsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.leadingTrailing),
                   ingredientsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.leadingTrailing),
                   ingredientsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.leadingTrailing)
               ])
    }
}
