import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var movies: [Movie] = []
    
    var allGenreMovies: [[Movie]] = []
    
    var genretitles: [String] = []
    
    let group = DispatchGroup()
    
    var number = 0;
    
    var a = 0;
    
    var b = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.reloadTableView(_:)), name: Notification.Name("notifUserDataChanged"), object: nil)
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        
        
        getAllMovies()
        
        
        //self.moviesTableView.reloadData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
//                print(self.number)x
                //self.number = self.number + 1
//                print(self.allGenreMovies)
                
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
        }, genreID: gId)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadTableView(_ notif: Notification){
        moviesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableCell") as! MovieTableViewCell
        //cell.movieCollectionView.reloadData()
        cell.movieCollectionView.layoutIfNeeded()
        number = indexPath.section
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return genretitles.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return genretitles[section]
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
        
        self.performSegue(withIdentifier: "detailSegue", sender: self)
//        print(indexPath.row)
//        print(indexPath.section)
//        print(indexPath.item)
//        print(allGenreMovies[indexPath.section][indexPath.item].toString())
//
//        var a = 0
//        var b = 0
//        while(a < 5){
//            print("Row")
//            print(a)
//            while(b < 5){
//                print(allGenreMovies[a][b].toString())
//                b = b + 1
//            }
//            a = a + 1
//            b = 0
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue"){
            let vc = segue.destination as! DetailViewController
            vc.movie = allGenreMovies[1][1]
        }
    }
}

