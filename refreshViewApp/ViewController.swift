//
//  ViewController.swift
//  refreshViewApp
//
//  Created by Himadri Jyoti on 05/02/17.
//  Copyright © 2017 Himadri. All rights reserved.
//

import UIKit
import ObjectMapper

struct Hotels {
    let name: String
    let place: String
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var events: [HTEvent] = [HTEvent]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.addSubview(self.refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        
        self.getEvents() {
            events in
            
            DispatchQueue.main.async {
                guard let uEvents = events, uEvents.count > 0 else {
                    self.showError(error: "Failed to get events")
                    return
                }
                
                self.events = uEvents
                
                self.tableView.reloadData()
                refreshControl.endRefreshing()
            }
            
        }
    }
    
    func showError(error: String) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let event = events[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = event.eventType.rawValue
        
        if event.eventType == .controlClick {
            cell.detailTextLabel?.text = (event as! HTEventControlClick).controlName
        }
        else {
            cell.detailTextLabel?.text = (event as! HTEventViewLoad).viewControllerName
        }
        
        return cell
    }
    
    
    func getEvents(completion: @escaping ([HTEvent]?) -> Void) {
        guard let url = URL(string: "http://ec2-35-170-198-42.compute-1.amazonaws.com:8080/all") else {
            assert(false, "wrong URL")
            completion(nil)
            return
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 60)
        urlRequest.httpMethod = "GET"
        
        var events: [HTEvent]? = [HTEvent]()
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) {
            data, response, error in
            
            guard let uResponse = response as? HTTPURLResponse, uResponse.statusCode == 200 else {
                completion(nil)
                return
            }
            
            guard let uData = data, let bodyString = String(data: uData, encoding: String.Encoding.utf8) else {
                completion(nil)
                return
            }
            
            events = Mapper<HTEvent>().mapArray(JSONString: bodyString)
            completion(events)
        }
        
        task.resume()
    }


}

