//
//  DetailVC.swift
//  APIParsing
//
//  Created by Bhargavi on 27/04/24.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet var tblDetail : UITableView!
    var listOfDetails : [ResponseDetailObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        tblDetail.rowHeight = UITableView.automaticDimension
//        tblDetail.estimatedRowHeight = 200
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        self.tblDetail.reloadData()
    }
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! DetailCell
        let obj = self.listOfDetails[indexPath.row]
        
        cell.lblPostId.text = String(obj.postId)
        cell.lblId.text = String(obj.id)
        cell.lblName.text = obj.name
        cell.lblEmail.text = obj.email
        cell.lblBody.text = obj.body
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
       
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 177.0
//    }
}



