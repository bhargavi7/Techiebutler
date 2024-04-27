//
//  ViewController.swift
//  APIParsing
//
//  Created by Bhargavi on 26/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tbl : UITableView!
    var listOfItems : [ResponseObject] = []
    var reachedEndOfItems = false
    let itemsPerBatch = 10
    var userIdIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "List"

    }

    override func viewWillAppear(_ animated: Bool) {
        if listOfItems.count == 0 {
            self.loadMoreItems()
        }
    }

    // MARK: - Custom functions
    func loadMoreItems(_ isInitialLoad: Bool = true) {
        // don't bother doing another db query if already have everything
        guard !self.reachedEndOfItems else { return }
    
        WebService.sharedInstance.postRequest(url: WebAPI.url, queryString: "?userId=\(self.userIdIndex)") { respObj, errStr in
            if errStr.isEmpty {
                if respObj.count > 0 {
                    print("loaded batch for userid \(self.userIdIndex)")
                    
                    self.listOfItems.append(contentsOf: respObj)
                    
                    DispatchQueue.main.async {
                        if isInitialLoad {
                            self.tbl.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .fade)
                        }
                        else {
                            self.tbl.reloadData()
                        }
                    }
                    
                    // check if this was the last of the data
                    if respObj.count < self.itemsPerBatch {
                        self.reachedEndOfItems = true
                        print("reached end Of the Items...")
                    }
                    
                    // reset the offset for the next data query
                    self.userIdIndex += 1
                }
                else // remove this case when it can load as per index not as per userid
                {
                    self.reachedEndOfItems = true
                    print("reached end Of the Items...")
                }
            }
        }
    }
    
    func loadCommentsfor(_ postId: Int, _ listIndex: Int) {
        
        WebService.sharedInstance.postDetailRequest(url: WebAPI.url, queryString: "/\(postId)/comments") { respDetailObj, errStr in
            if errStr.isEmpty {
                if respDetailObj.count > 0 {
                    //print("loaded details FROM API for postid \(postId) and SAVED those data for this post id, API WON'T BE CALLED for next time for this post")
                    self.listOfItems[listIndex].details = respDetailObj
                    
                    DispatchQueue.main.async {
                        self.tbl.beginUpdates()
                        self.tbl.reloadRows(at: [IndexPath(row: listIndex, section: 0)], with: .fade)
                        self.tbl.endUpdates()
                        
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailVC") as? DetailVC
                        vc?.listOfDetails = respDetailObj
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                    
                    
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomListCell", for: indexPath) as! CustomListCell
        var obj = self.listOfItems[indexPath.row]
        
        cell.lblId.text = String(obj.id)
        cell.lblTitle.text = obj.title
        
        
        if obj.details.count>0 {
            cell.backgroundColor = UIColor.lightGray
        }
        else {
            cell.backgroundColor = UIColor.white
        }
        cell.accessoryType = .disclosureIndicator
        
        if indexPath.row == self.listOfItems.count - 1 {
            self.loadMoreItems(false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.reachedEndOfItems { return }
        // need to pass your indexpath then it showing your indicator at bottom
        tableView.addLoading(indexPath) {
            // add your code here
            // append Your array and reload your tableview
            tableView.stopLoading() // stop your indicator
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        if self.listOfItems[indexPath.row].details.count > 0 {
            print("No need to call api, data is cached already. Go Ahead and render it.")
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailVC") as? DetailVC
            vc?.listOfDetails = self.listOfItems[indexPath.row].details
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        else {
            self.loadCommentsfor(self.listOfItems[indexPath.row].id, indexPath.row)
        }
    }
    
    /*
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            self.loadMoreItems(false)
        }
    }
    */
}
