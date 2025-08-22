import UIKit

final class RecipeCardCell: UICollectionViewCell {
    
    private enum Layout {
        static let cornerRadius: CGFloat = 12
        static let padding: CGFloat = 12
        static let height: CGFloat = 200
    }

    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Layout.cornerRadius
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        view.layer.cornerRadius = Layout.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private let ratingContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        recipeImageView.image = nil
        recipeImageView.backgroundColor = .clear
        titleLabel.text = nil
        infoLabel.text = nil
        ratingLabel.text = nil
    }

    func configure(with recipe: RecipeInfo) {
        titleLabel.text = recipe.title
        
        let ingredientsCount = recipe.extendedIngredients?.count ?? 0
        let timeText = recipe.readyInMinutes != nil ? "\(recipe.readyInMinutes!) min" : nil
        infoLabel.text = "\(ingredientsCount) Ingredients" + (timeText != nil ? "   |   \(timeText!)" : "")
        
        ratingLabel.text = "5.0"
        
        loadRecipeImage(recipe: recipe)
    }
    
    private func loadRecipeImage(recipe: RecipeInfo) {
        guard let imagePath = recipe.image else {
            setDefaultImage()
            return
        }

        if imagePath.hasPrefix("http") {
            loadImageFromURL(imagePath)
        } else {
            loadImageFromDocuments(fileName: imagePath)
        }
    }
    
    private func loadImageFromDocuments(fileName: String) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagePath = documentsPath.appendingPathComponent(fileName)

        guard FileManager.default.fileExists(atPath: imagePath.path) else {
            setDefaultImage()
            return
        }

        guard let image = UIImage(contentsOfFile: imagePath.path) else {
            setDefaultImage()
            return
        }

        recipeImageView.image = image
        recipeImageView.backgroundColor = .clear
    }
    
    private func loadImageFromURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            setDefaultImage()
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.setDefaultImage()
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    self.setDefaultImage()
                    return
                }

                self.recipeImageView.image = image
                self.recipeImageView.backgroundColor = .clear
            }
        }.resume()
    }
    
    private func setDefaultImage() {
        recipeImageView.image = UIImage(resource: .media)
        recipeImageView.backgroundColor = .clear
    }
}

// MARK: - Setup Constraints

private extension RecipeCardCell {
    func addSubviews() {
        contentView.addSubview(recipeImageView)
        contentView.addSubview(overlayView)

        contentView.addSubview(ratingContainer)
        ratingContainer.addSubview(starImageView)
        ratingContainer.addSubview(ratingLabel)

        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            overlayView.topAnchor.constraint(equalTo: recipeImageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: recipeImageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor),

            ratingContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.padding),
            ratingContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.padding),

            starImageView.leadingAnchor.constraint(equalTo: ratingContainer.leadingAnchor, constant: 6),
            starImageView.centerYAnchor.constraint(equalTo: ratingContainer.centerYAnchor),
            starImageView.widthAnchor.constraint(equalToConstant: 14),
            starImageView.heightAnchor.constraint(equalToConstant: 14),

            ratingLabel.leadingAnchor.constraint(equalTo: starImageView.trailingAnchor, constant: 4),
            ratingLabel.trailingAnchor.constraint(equalTo: ratingContainer.trailingAnchor, constant: -6),
            ratingLabel.topAnchor.constraint(equalTo: ratingContainer.topAnchor, constant: 4),
            ratingLabel.bottomAnchor.constraint(equalTo: ratingContainer.bottomAnchor, constant: -4),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.padding),
            titleLabel.bottomAnchor.constraint(equalTo: infoLabel.topAnchor, constant: -6),

            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.padding),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.padding),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.padding)
        ])
    }
}
