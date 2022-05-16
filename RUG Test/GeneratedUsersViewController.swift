import UIKit

class GeneratedUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DetailVCDelegate {
    
    // MARK: - Variable & Contstant Declarations
    private var results: [Result] = []
    private var currentIndexPath: IndexPath?
    private let urlString = K.URL.urlString
    private let refreshControl = UIRefreshControl()
   
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - ViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    //MARK: - View Layout Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        let rightBarButton = UIBarButtonItem(title: K.BarButtonTitle.generateUser, style: .plain, target: self, action: #selector(rightBarButtonTapped))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setupTableView() {
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let imageURLString = results[indexPath.row].picture.large
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: imageURLString)
        cell.myLabel.text = "\(results[indexPath.row].name.first)  \(results[indexPath.row].name.last)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        currentIndexPath = indexPath
        vc.configure(with: results[indexPath.row].picture.large)
        vc.firstName.text = ("\(results[indexPath.row].name.first)")
        vc.lastName.text = ("\(results[indexPath.row].name.last)")
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Protocol Method
    func usernameDidChange(_ detailViewController: DetailViewController, to firstName: String, to lastName: String) {
        if let currentIndexPath = currentIndexPath {
            results[currentIndexPath.row].name.first = firstName
            results[currentIndexPath.row].name.last = lastName
        }
    }
    
    // MARK: - View Controller methods
    @objc func rightBarButtonTapped(_ sender: UIBarButtonItem!) {
        fetchRandomUser()
    }
    
    @objc func callPullToRefresh(){
        DetailViewController().delegate = self
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    // TODO: - Put this method in its own file
    func fetchRandomUser() {
        //unwrap the url to verify it is correct.
        guard let url = URL(string: urlString) else {
            print("Invalid url string")
            return
        }
        //create your URLSession
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let this = self else { return }
            guard let data = data, error == nil else {
                print(error ?? "Unable to unwrap data from api call.")
                return
            }
            //if we are successful
            do {
                let jsonResult = try JSONDecoder().decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    this.results += jsonResult.results
                    
                    this.tableView.reloadData()
                }
            } catch {
                print("Not able to decode the data.")
            }
        }
        
        task.resume()
    }
}

