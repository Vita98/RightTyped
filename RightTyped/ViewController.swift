//
//  ViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/05/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var answersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureView()
        configureAnswersTableView()
    }
    
    private func configureView(){
        self.view.backgroundColor = .backgroundColor
    }
    
    private func configureAnswersTableView(){
        answersTableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "answerTableViewCellID")
        answersTableView.dataSource = self
        answersTableView.delegate = self
        answersTableView.backgroundColor = .none
        
        guard let headerView : HomeHeaderView = HomeHeaderView.instanceFromNib(withNibName: "HomeHeaderView") else { return }
        headerView.backgroundColor = .backgroundColor
        answersTableView.tableHeaderView = headerView
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerTableViewCellID", for: indexPath) as! AnswerTableViewCell
        let item = vector[indexPath.row % vector.count]
        cell.answerLabel.text = item
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: false)
        }
    }
}


