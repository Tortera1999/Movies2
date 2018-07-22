import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var marioPictures: [String] = []
    
    var genretitles: [String] = ["Comedy", "Action", "Romance", "Kids", "Hi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marioPictures = ["mario1.jpg", "mario2.png", "mario3.jpeg", "mario4.png"]
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        moviesTableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableCell") as! MovieTableViewCell
        //cell.genreTitle.text = genretitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return marioPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        cell.moviePosterPic.image = UIImage(named: marioPictures[indexPath.row])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
