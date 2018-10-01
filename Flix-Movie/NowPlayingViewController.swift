//
//  NowPlayingViewController.swift
//  Flix-Movie
//
//  Created by Binod Pokhrel on 10/1/18.
//  Copyright © 2018 Baivab Pokhrel. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var movies : [[String: Any]] = []
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource=self
        tableView.rowHeight = 229

        // Do any additional setup after loading the view.
    }
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        
        fetchMovies()
    }


    
    func fetchMovies(){
        let url=URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request=URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String:Any]]
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                
                
                
                
            }
        }
        task.resume()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return movies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let trycell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        let title=movie["title"] as! String
        let overview=movie["overview"] as! String
        
        trycell.titleLabel.text = title
        trycell.overviewLabel.text = overview
        
        let posterPathString=movie["poster_path"] as! String
        let baseURLString="https://image.tmdb.org/t/p/w500"
        
        let posterURl = URL(string: baseURLString+posterPathString)!
        trycell.posterImageView.af_setImage(withURL: posterURl)
        
        
        return trycell
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
