//
//  ViewController.swift
//  EDLoader
//
//  Created by edoohwang on 7/28/16.
//  Copyright © 2016 edoohwang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    lazy var datas: [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.ed_topLoader = EDLoader(target: self, action: #selector(loadMoreData))
        tableView.ed_topLoader.beginLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func loadMoreData() {
        for _ in 0...10 {
            datas.insert(random(), atIndex: 0)
        }
        tableView.reloadData()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.tableView.ed_topLoader.endRefresh()
        }
    }
    
    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = "\(datas[indexPath.item])"
        return cell
    }



}