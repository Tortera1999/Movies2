import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableCell") as! MovieTableViewCell
        cell.movieCollectionView.layoutIfNeeded()
        number = indexPath.section
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return genretitles.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

        let headerLabel = UILabel(frame: CGRect(x: 10, y: 2, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        headerLabel.textColor = UIColor.white
        headerLabel.text = self.genretitles[section]
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        column = indexPath.row
        print("\nthis is column ::\(column)\n")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    @IBOutlet weak var moviesTableView: UITableView!
    
   
    @IBOutlet weak var titleViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    var movies: [Movie] = []
    
    var allGenreMovies: [[Movie]] = []
    
    var genretitles: [String] = []
    
    let group = DispatchGroup()
    
    var column = 0
    var row = 0
    var number = 0;
    
    var a = 0;
    
    var b = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n view did load\n")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.reloadTableView(_:)), name: Notification.Name("notifUserDataChanged"), object: nil)
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        
        getAllMovies()
        
        
      
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("\n view did appear \n")
        getAllMovies()
        self.moviesTableView.reloadData()
        
    }
    
    
    
    @objc func getAllMovies(){
        
        while(a < 5){
            group.enter()
            if(a == 0){
                getDifferentGenreMovies(gId: ACTION_ID, name: "Action")
                b = a
            } else if(a == 1){
                getDifferentGenreMovies(gId: COMEDY_ID, name: "Comedy")
                b = a
            } else if(a == 2){
                getDifferentGenreMovies(gId: DRAMA_ID, name: "Drama")
                b = a
            } else if(a == 3){
                getDifferentGenreMovies(gId: ROMANCE_ID, name: "Romance")
                b = a
            } else if(a == 4){
                getDifferentGenreMovies(gId: THRILLER_ID, name: "Thriller")
                b = a
            }
            
            a = a + 1
        }
       
    }
    
    func getDifferentGenreMovies(gId: Int, name : String){
        DataService.instance.downloadDataBasedOnGenre(completion: { (success) in
            if(success){
                self.movies = DataService.instance.movies
                self.allGenreMovies.append(self.movies)
                
                self.genretitles.append(name)
                print(self.genretitles)
                print(self.genretitles.count)
                if(self.genretitles.count == 5){
                    self.moviesTableView.reloadData()
                }
                self.moviesTableView.reloadData()
                self.group.leave()
            }
            else{
                print("False")
            }

            
            self.group.notify(queue: .main, execute: {
                print("Finished request \(self.b)")
            })
        }, genreID: gId, keyword: "")
        
        moviesTableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadTableView(_ notif: Notification){
        moviesTableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (moviesTableView.contentOffset.y > 0)
        {
            titleViewHeightConstraint.constant = 0
            titleLabel.text = ""
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        else
        {
            titleViewHeightConstraint.constant = 77
            titleLabel.text = "MovieTracker"
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allGenreMovies[section].count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionCell", for: indexPath) as! MovieCollectionViewCell
        print(indexPath.item)
        cell.movie = allGenreMovies[number][indexPath.item]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        row = indexPath.row
//        let description = indexPath.description
//        let index = description.index(description.startIndex, offsetBy: 1)
//        let car = description[index]
//        column = Int(String(car))!
        
column = indexPath.section
        print("\(column)")
       
        self.performSegue(withIdentifier: "detailSegue", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue"){
            if let vc = segue.destination as? DetailViewController{
            vc.movie = allGenreMovies[column][row]
            }
        }
    }
}

