//
//  ShowStoriesViewController.swift
//  HackerNews
//
//  Created by Никита Васильев on 06/10/2018.
//  Copyright © 2018 Никита Васильев. All rights reserved.
//

import UIKit
import NetworkManager
import SafariServices

class ShowStoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var stories = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        configure()
        loadData()
    }
    
    fileprivate func style() {
        tableView.backgroundColor = Color.tableBackground
        tableView.separatorColor = Color.tableSeparator
    }
    
    fileprivate func configure() {
        tableView.register(NewsTableViewCell.self)
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func loadData() {
        NetworkManager.shared.retrieve(type: .show) { [weak self] (response) in
            switch response {
            case .success(let stories):
                self?.stories = stories
                self?.tableView.reloadData()
            case .error(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}

extension ShowStoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = stories[indexPath.row]
        if let url = item.url {
            let webViewController = SFSafariViewController(url: URL(string: url)!)
            webViewController.delegate = self
            present(webViewController, animated: true)
        }
    }
}

extension ShowStoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let story = stories[indexPath.row]
        cell.title.text = stories[indexPath.row].title
        cell.info.text = "\(story.score ?? 0) points by \(story.by ?? "Unknown") - \(story.descendants ?? 0) comments"
        cell.link.text = story.url
        cell.score.text = String(story.score ?? 0)
        return cell
    }
}

extension ShowStoriesViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}