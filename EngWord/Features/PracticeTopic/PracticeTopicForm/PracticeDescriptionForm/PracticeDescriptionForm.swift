//
//  PracticeDescriptionForm.swift
//  EngWord
//
//  Created by hieu nguyen on 24/02/2023.
//

import UIKit

class PracticeDescriptionForm: UIView, PracticeFormView {
    
    func showTurnResult(msg: NSAttributedString?, result: TurnResult, quizResult: QuizResult) {
        delegate?.practiceForm(
            self,
            msg: msg,
            result: result,
            quizResult: quizResult)
    }

    weak var delegate: PracticeFormDelegate?

    func updateRoundProgress(value: Float) {}

    @IBOutlet weak var tableView: ResizeTableView!
    @IBOutlet weak var collectionView: UICollectionView!

    private var tableCellRects: [Int: CGRect] = [:]

    var contentView: PracticeDescriptionForm {
        return self
    }

    var presenter: PracticeDescriptionPresenter?

    func displayCard(card: (Card)?) {
        
    }

    typealias T = PracticeDescriptionPresenter
    typealias U = PracticeDescriptionForm

    var originPosition: CGPoint!
    var draggingView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerRow(TextTableCell.self)

        collectionView.dataSource = self
        collectionView.delegate = self
        if let collectionViewFlowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

        collectionView.registerCellType(TextCollectionCell.self)
    }

    func moveToNextCard() {
        let visibleTableCells = tableView.visibleCells
        for cell in visibleTableCells {
            UIView.animate(withDuration: 0.5, delay: 0.2) {
                cell.alpha = 0.0
                self.layoutIfNeeded()
            }
        }

        let visibleCollectionCells = collectionView.visibleCells
        for cell in visibleCollectionCells {
            UIView.animate(withDuration: 0.5, delay: 0.2) {
                cell.alpha = 0.0
                self.layoutIfNeeded()
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(700), execute: {
            self.tableView.reloadData()
            self.collectionView.reloadData()
        })
    }

    func showRoundResultPass() {

    }

    func showRoundResultFail() {

    }
}

extension PracticeDescriptionForm: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getAnswersOfCards().count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueCell(TextCollectionCell.self, for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.setTitle(text: presenter!.getAnswersOfCards()[indexPath.item])
        cell.delegate = self
        cell.tag = indexPath.item
        cell.showAnswerLabel()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath) {
            cell.transform = CGAffineTransform(
                translationX: collectionView.bounds.width,
                y: cell.frame.origin.y)
            UIView.animate(
                withDuration: 0.5,
                delay: 0.3 * Double(indexPath.row),
                options: [.curveEaseInOut]) {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }
        }
}

extension PracticeDescriptionForm: TextCollectionCellDelegate {

    func textCollectionCell(
        _ cell: TextCollectionCell,
        draging view: UIView,
        text: String,
        gesture: UIPanGestureRecognizer
    ) {
        switch gesture.state {
            case .began:
                originPosition = gesture.location(in: self)
                draggingView.frame.size = cell.containerView.bounds.size
                draggingView.center = CGPoint(x: originPosition.x, y: originPosition.y)

                let label = UILabel(frame: draggingView.bounds)
                label.font = Fonts.regularText
                label.textColor = Colors.mainText
                label.textAlignment = .center
                label.text = cell.getTextOfCell()
                draggingView.backgroundColor = Colors.cellBackground
                draggingView.addCornerRadius()
                draggingView.addSubview(label)

                cell.hideContentView()
                addSubview(draggingView)

                if let visibleCells = tableView.visibleCells as? [TextTableCell],
                   !visibleCells.isEmpty {
                    var yyyy = tableView.convert(
                        visibleCells[0].frame.origin,
                        to: UIScreen.main.coordinateSpace).y
                    let xxxx = tableView.convert(
                        visibleCells[0].frame.origin,
                        to: UIScreen.main.coordinateSpace).x
                    for cell in visibleCells {
                        tableCellRects[cell.index] = CGRect(
                            x: xxxx,
                            y: yyyy,
                            width: cell.bounds.width,
                            height: cell.bounds.height
                        )
                        yyyy += cell.contentView.bounds.height
                    }
                }
            case .changed:
                let gesturePosition = gesture.location(in: self)
                draggingView.backgroundColor = Colors.cellBackground
                draggingView.center = CGPoint(
                    x: gesturePosition.x,
                    y: gesturePosition.y)
                for index in tableCellRects.keys {
                    let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? TextTableCell
                    if gesturePosition.y <= tableCellRects[index]!.minY + tableCellRects[index]!.height - 80
                        && gesturePosition.y >= tableCellRects[index]!.minY - 80 {
                        cell?.isHover = true
                    } else {
                        cell?.isHover = false
                    }
                }
            case .cancelled:
                break
            case .ended:
                if let hoveredCell = (tableView.visibleCells as? [TextTableCell])?.filter({ $0.isHover }).last {
                    guard !hoveredCell.alreadyAnswered else {
                        self.backAnswerToPosition(of: cell)
                        return
                    }
                    hoveredCell.answer(text)
                    tableView.beginUpdates()
                    tableView.endUpdates()
                    draggingView.subviews.forEach {
                        $0.removeFromSuperview()
                    }
                    draggingView.removeFromSuperview()

                    presenter?.answer(hoveredCell.card, answer: text)
                    cell.isPairedWithQuestion = true
                } else {
                    self.backAnswerToPosition(of: cell)
                }
            default: break
        }
    }

    private func backAnswerToPosition(of cell: TextCollectionCell) {
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.draggingView.center = self.originPosition
            self.layoutIfNeeded()
        } completion: { isFinish in
            cell.showAnswerLabel()
            guard isFinish else { return }
            self.draggingView.subviews.forEach {
                $0.removeFromSuperview()
            }
            self.draggingView.removeFromSuperview()
        }
    }
}

extension PracticeDescriptionForm: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getPracticeCards().count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(TextTableCell.self, for: indexPath) else {
            return UITableViewCell()
        }
        cell.setCard(card: presenter?.getCard(at: indexPath.row), indexPath: indexPath)
        cell.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.3 * Double(indexPath.row),
            options: [.curveEaseInOut]) {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }
    }
}
