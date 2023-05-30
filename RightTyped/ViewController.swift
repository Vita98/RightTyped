//
//  ViewController.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/05/23.
//

import UIKit

class ViewController: UIViewController {

    //Variables used to stop the table view to bounce on top
    var firstScroll : Bool = true
    var scrolloffset: CGFloat = 0
    
    @IBOutlet weak var tableShadowView: UIView!
    @IBOutlet weak var answersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureView()
        configureAnswersTableView()
        configureHeaderView()
    }
    
    private func configureView(){
        self.view.backgroundColor = .backgroundColor
    }
    
    private func configureAnswersTableView(){
        answersTableView.register(UINib(nibName: "AnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "answerTableViewCellID")
        answersTableView.dataSource = self
        answersTableView.delegate = self
        answersTableView.backgroundColor = .white
        answersTableView.clipsToBounds = true
        answersTableView.layer.cornerRadius = 45
        answersTableView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        
        tableShadowView.dropShadow(shadowType: .ContentView)
        tableShadowView.layer.cornerRadius = 45
        tableShadowView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    
    private func configureHeaderView(){
        guard let headerView : HomeHeaderView = HomeHeaderView.instanceFromNib(withNibName: HomeHeaderView.NIB_NAME) else { return }
        headerView.configureView()
        
        tableShadowView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: tableShadowView.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: tableShadowView.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: tableShadowView.trailingAnchor).isActive = true
        answersTableView.contentInset = .init(top: headerView.frame.height, left: 0, bottom: 0, right: 0)
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
}


