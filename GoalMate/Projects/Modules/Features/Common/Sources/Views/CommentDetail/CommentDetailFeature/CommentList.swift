//
//  CommentList.swift
//  FeatureComment
//
//  Created by Importants on 2/24/25.
//

import ComposableArchitecture
import Data
import SwiftUI
import UIKit
import Utils

struct CommentList: UIViewRepresentable {
    let comments: IdentifiedArrayOf<CommentContent>
    let endDate: Date
    let onLoadMore: () -> Void
    let onLongPress: (CommentContent, (CGFloat, CGFloat)) -> Void

    init(
        comments: IdentifiedArrayOf<CommentContent>,
        endDate: Date,
        onLoadMore: @escaping () -> Void,
        onLongPress: @escaping (CommentContent, (CGFloat, CGFloat)) -> Void
    ) {
        self.comments = comments
        self.endDate = endDate
        self.onLoadMore = onLoadMore
        self.onLongPress = onLongPress
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.showsVerticalScrollIndicator = false
        tableView.transform = CGAffineTransform(rotationAngle: .pi)
        return tableView
    }

    func updateUIView(_ tableView: UITableView, context: Context) {
        context.coordinator.parent = self
        tableView.reloadData()
    }

    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource {
        var parent: CommentList
        var isLoadingMore = false
        init(_ parent: CommentList) {
            self.parent = parent
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return parent.comments.count
        }
        func tableView(
            _ tableView: UITableView,
            cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "CommentCell",
                for: indexPath) as? CommentCell
            else { return UITableViewCell() }
            let comment = parent.comments[indexPath.row]
            var shouldShowDate = false
            if let currentCommentDate = comment.commentedAt {
                if indexPath.row + 1 < parent.comments.count {
                    let belowComment = parent.comments[indexPath.row + 1]
                    if let belowCommentDate = belowComment.commentedAt {
                        let currentDate = currentCommentDate
                            .parseAndDisplayDate().toDate()
                        let belowDate = belowCommentDate
                            .parseAndDisplayDate().toDate()
                        shouldShowDate = !Calendar.current.isDate(
                            currentDate,
                            inSameDayAs: belowDate
                        )
                    } else {
                        shouldShowDate = true
                    }
                } else {
                    shouldShowDate = true
                }
            }
            cell.configure(
                with: comment,
                endDate: parent.endDate,
                showDateStack: shouldShowDate)
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            cell.onLongPress = { [weak self] (minY, maxY) in
                guard let self = self else { return }
                self.parent.onLongPress(comment, (minY, maxY))
            }
            if indexPath.row == parent.comments.count - 3 {
                parent.onLoadMore()
            }
            return cell
        }
    }
}

class CommentCell: UITableViewCell {
    private let containerView = UIView()
    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private let dateStackView = UIStackView()
    private let dateLabelView = UIView()
    private let dateLabel = UILabel()
    private let dplusLabelView = UIView()
    private let dplusLabel = UILabel()
    private var writerRole: CommentContent.WriterRole
    private var containerBottomConstraint: NSLayoutConstraint?
    private var bubbleTopConstraint: NSLayoutConstraint?
    private var stackViewTopConstraint: NSLayoutConstraint?
    private var stackToBubbleConstraint: NSLayoutConstraint?
    private var stackViewCenterXConstraint: NSLayoutConstraint?
    private var bubbleLeadingConstraint: NSLayoutConstraint?
    private var bubbleTrailingConstraint: NSLayoutConstraint?
    private var longPressGesture: UILongPressGestureRecognizer!
    var onLongPress: ((CGFloat, CGFloat) -> Void)?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.writerRole = .mentor
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGestures() {
        longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.3
        bubbleView.addGestureRecognizer(longPressGesture)
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        containerBottomConstraint = containerView.bottomAnchor.constraint(
             equalTo: contentView.bottomAnchor, constant: -16)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16)
        ])
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.layer.cornerRadius = 24
        containerView.addSubview(bubbleView)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        messageLabel.font = IFont.Pretendard.regular.value.font(size: 16)
        bubbleView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(
                equalTo: bubbleView.topAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(
                equalTo: bubbleView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(
                equalTo: bubbleView.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(
                equalTo: bubbleView.bottomAnchor, constant: -20)
        ])
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        dateStackView.axis = .horizontal
        dateStackView.spacing = 6
        dateStackView.alignment = .center
        containerView.addSubview(dateStackView)
        dateLabel.font = IFont.Pretendard.medium.value.font(size: 14)
        dateLabel.textColor = Asset.Assets.Grey.grey700.color
        dateStackView.addArrangedSubview(dateLabel)
        dplusLabelView.backgroundColor = UIColor(hex: "FFE223")
        dplusLabelView.translatesAutoresizingMaskIntoConstraints = false
        dplusLabelView.layer.cornerRadius = 4
        dplusLabelView.clipsToBounds = true
        dplusLabel.font = IFont.Pretendard.semiBold.value.font(size: 12)
        dplusLabel.textColor = Asset.Assets.Grey.grey800.color
        dplusLabel.textAlignment = .center
        dplusLabel.translatesAutoresizingMaskIntoConstraints = false
        dplusLabel.textAlignment = .center
        dplusLabelView.addSubview(dplusLabel)
        dateStackView.addArrangedSubview(dplusLabelView)
        stackViewTopConstraint = dateStackView.topAnchor.constraint(
            equalTo: containerView.topAnchor)
        stackViewCenterXConstraint = dateStackView.centerXAnchor.constraint(
            equalTo: containerView.centerXAnchor)
        bubbleTopConstraint = bubbleView.topAnchor.constraint(
            equalTo: containerView.topAnchor)
        stackToBubbleConstraint = bubbleView.topAnchor.constraint(
            equalTo: dateStackView.bottomAnchor, constant: 16)
        bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor)
        bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor)
        bubbleTopConstraint?.isActive = true
        NSLayoutConstraint.activate([
            bubbleView.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor),
            bubbleView.widthAnchor.constraint(
                lessThanOrEqualTo: containerView.widthAnchor, multiplier: 0.75),
            dplusLabel.topAnchor.constraint(
                equalTo: dplusLabelView.topAnchor, constant: 2),
            dplusLabel.leadingAnchor.constraint(
                equalTo: dplusLabelView.leadingAnchor, constant: 4),
            dplusLabel.trailingAnchor.constraint(
                equalTo: dplusLabelView.trailingAnchor, constant: -4),
            dplusLabel.bottomAnchor.constraint(
                equalTo: dplusLabelView.bottomAnchor, constant: -2)
        ])
    }
    
    func configure(
        with comment: CommentContent,
        endDate: Date,
        showDateStack: Bool = false) {
        self.writerRole = comment.writerRole ?? .mentor
        if let commentText = comment.comment {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = messageLabel.font.lineHeight * 0.3
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: paragraphStyle
            ]
            messageLabel.attributedText = NSAttributedString(
                string: commentText,
                attributes: attributes)
        } else {
            messageLabel.text = nil
        }
        messageLabel.text = comment.comment
        bubbleLeadingConstraint?.isActive = false
        bubbleTrailingConstraint?.isActive = false
        bubbleTopConstraint?.isActive = false
        stackViewTopConstraint?.isActive = false
        stackToBubbleConstraint?.isActive = false
        stackViewCenterXConstraint?.isActive = false
        containerBottomConstraint?.isActive = false
        if comment.writerRole == .mentor {
            messageLabel.textColor = Asset.Assets.Grey.grey700.color
            bubbleView.backgroundColor = Asset.Assets.Grey.grey50.color
            bubbleLeadingConstraint?.isActive = true
            containerBottomConstraint?.constant = -44
            if let commentedAt = comment.commentedAt,
                showDateStack {
                dateStackView.isHidden = false
                dplusLabel.text = ""
                let text = commentedAt
                    .parseAndDisplayDate()
                    .convertDateString(
                    fromFormat: "yyyy-MM-dd",
                    toFormat: "yyyy년 M월 dd일"
                )
                dateLabel.text = text
                let date = commentedAt
                    .parseAndDisplayDate()
                let dDay = date.calculateDday(
                    endDate: endDate.getString(format: "yyyy-MM-dd"))
                dplusLabel.text = "\(dDay)"
                stackViewTopConstraint?.isActive = true
                stackViewCenterXConstraint?.isActive = true
                stackToBubbleConstraint?.isActive = true
            } else {
                dateStackView.isHidden = true
                bubbleTopConstraint?.isActive = true
            }
        } else {
            messageLabel.textColor = Asset.Assets.Grey.grey900.color
            bubbleView.backgroundColor = Asset.Assets.Primary.primary600.color
            bubbleTrailingConstraint?.isActive = true
            containerBottomConstraint?.constant = -16
            if let commentedAt = comment.commentedAt, showDateStack {
                dateStackView.isHidden = false
                dplusLabel.text = ""
                let text = commentedAt
                    .parseAndDisplayDate()
                    .convertDateString(
                    fromFormat: "yyyy-MM-dd",
                    toFormat: "yyyy년 M월 dd일"
                )
                dateLabel.text = text
                let date = commentedAt
                    .parseAndDisplayDate()
                let dDay = date.calculateDday(
                    endDate: endDate.getString(format: "yyyy-MM-dd"))
                dplusLabel.text = "\(dDay)"
                stackViewTopConstraint?.isActive = true
                stackViewCenterXConstraint?.isActive = true
                stackToBubbleConstraint?.isActive = true
            } else {
                dateStackView.isHidden = true
                bubbleTopConstraint?.isActive = true
            }
        }
        containerBottomConstraint?.isActive = true
        // 레이아웃 갱신
        setNeedsLayout()
        layoutIfNeeded()
    }
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard self.writerRole == .mentee else { return }
        if gestureRecognizer.state == .began {
            let cellFrame = self.frame
            if let tableView = self.superview as? UITableView, let window = window {
                let cellRectInWindow = tableView.convert(cellFrame, to: window)
                let minY = cellRectInWindow.minY
                let maxY = cellRectInWindow.maxY
                print(bubbleView.frame.height)
                let containerTopPadding: CGFloat = 16
                let dateStackHeight = dateStackView.frame.height
                let dateStackBottomPadding: CGFloat = 16
                let bubbleViewTopSpacing =
                containerTopPadding + dateStackHeight + dateStackBottomPadding
                onLongPress?(minY + bubbleViewTopSpacing, maxY)
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        messageLabel.attributedText = nil
        dateLabel.text = nil
        dplusLabel.text = nil
        dateStackView.isHidden = true
        writerRole = .mentor

        bubbleLeadingConstraint?.isActive = false
        bubbleTrailingConstraint?.isActive = false
        bubbleTopConstraint?.isActive = false
        stackViewTopConstraint?.isActive = false
        stackToBubbleConstraint?.isActive = false
        stackViewCenterXConstraint?.isActive = false
        containerBottomConstraint?.isActive = false
    }
}
