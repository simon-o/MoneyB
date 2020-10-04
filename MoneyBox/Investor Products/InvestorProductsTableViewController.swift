//
//  InvestorProductsTableViewController.swift
//  MoneyBox
//
//  Created by Antoine Simon on 03/10/2020.
//

import UIKit

protocol InvestorProductsTableViewControllerProtocol: AnyObject {
    func reloadTableView()
}

final class InvestorProductsTableViewController: UITableViewController {
    private let presenter:InvestorProductsPresenterProtocol
    private lazy var header: InvestorProductsHeader = {
        guard let tableView = tableView else { fatalError() }
        return InvestorProductsHeader(frame: CGRect(origin: .zero,
                                                    size: CGSize(width: tableView.frame.width,
                                                                 height: 100.0)))
    }()

    
    init(presenter: InvestorProductsPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: String(describing: InvestorProductsTableViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: String(describing: InvestorTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: InvestorTableViewCell.self))
        
        tableView?.register(UITableViewHeaderFooterView.self,
                            forHeaderFooterViewReuseIdentifier: String(describing: InvestorProductsHeader.self))
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedRowHeight = 100.0
        tableView?.keyboardDismissMode = .onDrag
        
        presenter.linkViewController(self)
        presenter.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getProductsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InvestorTableViewCell.self), for: indexPath) as? InvestorTableViewCell else {return UITableViewCell()}
        
        presenter.buildCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let account = self.presenter.getProductFor(index: indexPath.row) {
            let service = AccountService()
            let presenter = AccountPresenter(service: service, accountInfo: account) {
                self.presenter.reloadView()
            }
            let vc = AccountViewController(presenter: presenter)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }

        let dequeuedView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: InvestorProductsHeader.self))
            
        dequeuedView?.addSubview(header)
        presenter.buildHeader(header: header)
        return dequeuedView
    }
}

extension InvestorProductsTableViewController: InvestorProductsTableViewControllerProtocol {
    func reloadTableView() {
        tableView.reloadData()
    }
}
