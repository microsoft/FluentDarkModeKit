//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

final class MainViewController: ViewController {
  private static var windowCount = 0

  struct Row {
    var name: String
    var vcType: UIViewController.Type
  }

  let rows = [
    Row(name: "UIView", vcType: UIViewVC.self),
    Row(name: "UIActivityIndicatorView", vcType: UIActivityIndicatorViewVC.self),
    Row(name: "UIButton", vcType: UIButtonVC.self),
    Row(name: "UILabel", vcType: UILabelVC.self),
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

    title = "\(MainViewController.windowCount)"
    MainViewController.windowCount += 1
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.leftBarButtonItems = [
      UIBarButtonItem(
        title: "Replace",
        style: .plain,
        target: self,
        action: #selector(replaceNewWindow)
      ),
      UIBarButtonItem(
        title: "Spawn",
        style: .plain,
        target: self,
        action: #selector(spawnNewWindow)
      )
    ]
  }

  @objc private func replaceNewWindow() {
    let window = AppDelegate.createNewWindow(with: view.window!)
    window.makeKeyAndVisible()
    (UIApplication.shared.delegate as? AppDelegate)?.window = window
  }

  @objc private func spawnNewWindow() {
    guard #available(iOS 13.0, *) else { return }

    let userActivity = NSUserActivity(activityType: "window")
    UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
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
    let vc = row.vcType.init()
    show(vc, sender: self)
  }
}
