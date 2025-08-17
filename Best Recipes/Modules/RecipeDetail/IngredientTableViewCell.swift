import UIKit

final class IngredientTableViewCell: UITableViewCell {

    private enum Layout {
        static let containerTopBottom: CGFloat = 7
        static let containerLeadingTrailing: CGFloat = 0
        static let iconLeading: CGFloat = 16
        static let iconSize: CGFloat = 52
        static let iconCornerRadius: CGFloat = 8
        static let nameLeadingFromIcon: CGFloat = 24
        static let nameLabelSize: CGFloat = 120
        static let checkButtonTrailing: CGFloat = 16
        static let checkButtonSize: CGFloat = 24
        static let checkButtonCornerRadius: CGFloat = 12
        static let checkButtonBorderWidth: CGFloat = 2
        static let labelTrailingFromCheckButton: CGFloat = 24
        static let cellCornerRadius: CGFloat = 12
        static let containerHeight: CGFloat = 76
    }

    var checkButtonTapped: (() -> Void)?

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = Layout.cellCornerRadius
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = Layout.iconCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private let checkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Layout.checkButtonCornerRadius
        button.addTarget(
            self,
            action: #selector(checkButtonAction),
            for: .touchUpInside
        )
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with ingredient: ExtendedIngredient) {
        nameLabel.text = ingredient.name ?? "Unknown"
        
        if let amount = ingredient.amount, let unit = ingredient.unit {
            amountLabel.text = "\(amount) \(unit)"
        } else {
            amountLabel.text = ""
        }
        
        if let url = URL(string: ingredient.imageURL) {
            loadImage(from: url, into: iconImageView)
        } else {
            iconImageView.image = UIImage(systemName: "photo")
        }
        
        if ingredient.isChecked {
            checkButton.setImage(UIImage(resource: .iconcCircleRed), for: .normal)
        } else {
            checkButton.setImage(UIImage(resource: .iconcCircleBlack), for: .normal)
        }
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    private func loadImage(from url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }.resume()
    }

    @objc private func checkButtonAction() {
        checkButtonTapped?()
    }
}


// MARK: - Setup Constraints

private extension IngredientTableViewCell {
    func addSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(amountLabel)
        containerView.addSubview(checkButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.containerTopBottom),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.containerLeadingTrailing),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.containerLeadingTrailing),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.containerTopBottom),
            containerView.heightAnchor.constraint(equalToConstant: Layout.containerHeight),

            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Layout.iconLeading),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: Layout.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: Layout.iconSize),

            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Layout.nameLeadingFromIcon),
            nameLabel.widthAnchor.constraint( equalToConstant: Layout.nameLabelSize),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            amountLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: -Layout.labelTrailingFromCheckButton),
            amountLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor, constant: Layout.labelTrailingFromCheckButton),

            checkButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Layout.checkButtonTrailing),
            checkButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: Layout.checkButtonSize),
            checkButton.heightAnchor.constraint(equalToConstant: Layout.checkButtonSize)
        ])
    }
}
