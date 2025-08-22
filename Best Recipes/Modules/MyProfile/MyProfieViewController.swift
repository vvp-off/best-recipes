import UIKit

final class MyProfileViewController: UIViewController {

    private enum Layout {
        static let leadingTrailing: CGFloat = 16
        static let emptyStateLabelLeadingTrailing: CGFloat = 20

        enum Header {
            static let height: CGFloat = 10
        }

        enum ProfileImage {
            static let top: CGFloat = 24
            static let size: CGFloat = 120
        }

        enum Section {
            static let top: CGFloat = 40
        }

        enum CollectionView {
            static let top: CGFloat = 20
            static let cellHeight: CGFloat = 200
        }
    }

    private var recipes: [RecipeInfo] = []

    init() {
        super.init(nibName: nil, bundle: nil)
        loadRecipesFromUserDefaults()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let headerTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My Profile"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .profile)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Layout.ProfileImage.size / 2
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .systemGray5
        return imageView
    }()

    private let recipesTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My Recipes"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()

    private lazy var recipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RecipeCardCell.self, forCellWithReuseIdentifier: "RecipeCardCell")
        return collectionView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Вы еще не создали ни одного рецепта.\nСоздайте свой первый рецепт!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)

        addSubview()
        setupConstraints()
        updateUI()

        setupProfileImageTap()
        setupSwipeToDelete()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecipesFromUserDefaults()
        updateUI()
    }
}

private extension MyProfileViewController {
    func setupProfileImageTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfileImage))
        profileImageView.addGestureRecognizer(tapGesture)
    }

    @objc func changeProfileImage() {
        let alert = UIAlertController(
            title: "Выберите фото профиля",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Камера",
                style: .default,
                handler: { _ in
                    self.openImagePicker(sourceType: .camera)
                })
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Галерея",
                style: .default,
                handler: { _ in
                    self.openImagePicker(sourceType: .photoLibrary)
                })
        )
        
        alert.addAction(
            UIAlertAction(
                title: "Отмена",
                style: .cancel,
                handler: nil
            )
        )
        
        present(alert, animated: true)
    }

    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}

private extension MyProfileViewController {
    func loadRecipesFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "savedRecipes") else {
            recipes = []
            return
        }

        do {
            recipes = try JSONDecoder().decode([RecipeInfo].self, from: data)
            recipes.forEach { recipe in
                print("   - \(recipe.title ?? "Без названия") (ID: \(recipe.id))")
            }
        } catch {
            print("Ошибка загрузки рецептов из UserDefaults: \(error)")
            recipes = []
        }
    }

    func saveRecipesToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(recipes)
            UserDefaults.standard.set(data, forKey: "savedRecipes")
            print("Сохранено \(recipes.count) рецептов в UserDefaults")
        } catch {
            print("Ошибка сохранения рецептов в UserDefaults: \(error)")
        }
    }

    func updateUI() {
        recipesCollectionView.reloadData()
        updateEmptyState()
        updateCollectionViewHeight()
    }

    func updateEmptyState() {
        emptyStateLabel.isHidden = !recipes.isEmpty
        recipesCollectionView.isHidden = recipes.isEmpty
    }

    func updateCollectionViewHeight() {
        let rowCount = max(1, recipes.count)
        let totalHeight = CGFloat(rowCount) * Layout.CollectionView.cellHeight + CGFloat(max(0, rowCount - 1)) * 16
        let minHeight: CGFloat = 200
        
        recipesCollectionView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = max(totalHeight, minHeight)
            }
        }
        view.layoutIfNeeded()
    }
}

private extension MyProfileViewController {
    func setupSwipeToDelete() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeftGesture.direction = .left

        recipesCollectionView.addGestureRecognizer(longPressGesture)
        recipesCollectionView.addGestureRecognizer(swipeLeftGesture)
    }

    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: recipesCollectionView)

        switch gesture.state {
        case .began:
            guard let indexPath = recipesCollectionView.indexPathForItem(at: point) else { return }
            showDeleteConfirmation(for: indexPath)
        default:
            break
        }
    }

    @objc func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        let point = gesture.location(in: recipesCollectionView)
        guard let indexPath = recipesCollectionView.indexPathForItem(at: point) else { return }
        showDeleteConfirmation(for: indexPath)
    }

    func showDeleteConfirmation(for indexPath: IndexPath) {
        let recipe = recipes[indexPath.item]
        let alert = UIAlertController(
            title: "Удалить рецепт",
            message: "Вы уверены, что хотите удалить рецепт \"\(recipe.title ?? "Без названия")\"?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.deleteRecipe(at: indexPath)
        })

        present(alert, animated: true)
    }

    func deleteRecipe(at indexPath: IndexPath) {

        recipes.remove(at: indexPath.item)
        saveRecipesToUserDefaults()
        recipesCollectionView.performBatchUpdates({
            recipesCollectionView.deleteItems(at: [indexPath])
        }) { [weak self] _ in
            self?.updateUI()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MyProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let editedImage = info[.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MyProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCardCell", for: indexPath) as? RecipeCardCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: recipes[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: Layout.CollectionView.cellHeight)
    }
}

// MARK: - Setup Constraints

private extension MyProfileViewController {
    func addSubview() {
        view.addSubview(headerView)
        headerView.addSubview(headerTitleLabel)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(profileImageView)
        contentView.addSubview(recipesTitleLabel)
        contentView.addSubview(recipesCollectionView)
        contentView.addSubview(emptyStateLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: Layout.Header.height),

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

            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.ProfileImage.top),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.leadingTrailing),
            profileImageView.widthAnchor.constraint(equalToConstant: Layout.ProfileImage.size),
            profileImageView.heightAnchor.constraint(equalToConstant: Layout.ProfileImage.size),

            recipesTitleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: Layout.Section.top),
            recipesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.leadingTrailing),
            recipesTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.leadingTrailing),

            recipesCollectionView.topAnchor.constraint(equalTo: recipesTitleLabel.bottomAnchor, constant: Layout.CollectionView.top),
            recipesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.leadingTrailing),
            recipesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.leadingTrailing),
            recipesCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.leadingTrailing),
            recipesCollectionView.heightAnchor.constraint(equalToConstant: Layout.CollectionView.cellHeight),

            emptyStateLabel.centerXAnchor.constraint(equalTo: recipesCollectionView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: recipesCollectionView.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: recipesCollectionView.leadingAnchor, constant: Layout.emptyStateLabelLeadingTrailing),
            emptyStateLabel.trailingAnchor.constraint(equalTo: recipesCollectionView.trailingAnchor, constant: -Layout.emptyStateLabelLeadingTrailing)
        ])
    }
}
