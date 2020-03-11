//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

final class MainViewController: ViewController {
  struct Row {
    var name: String
    var vcType: UIViewController.Type
  }

  let rows = [
    Row(name: "UIView", vcType: UIViewVC.self),
    Row(name: "UIActivityIndicatorView", vcType: UIActivityIndicatorViewVC.self),
    Row(name: "UIButton", vcType: UIButtonVC.self),
    Row(name: "UIPageControl", vcType: UIPageControlVC.self)
  ]

  lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()

  override func loadView() {
    view = tableView
  }
}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    rows.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let row = rows[indexPath.row]

    let cell = UITableViewCell()
    cell.textLabel?.text = row.name
    cell.accessoryType = .disclosureIndicator
    return cell
  }
}

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = rows[indexPath.row]
    let viewController = row.vcType.init()
    show(viewController, sender: self)
  }
}
