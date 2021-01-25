//
//  ProfileViewController.swift
//  AssesmentProfileModule
//
//  Created by Govindharaj Murugan on 23/01/21.
//


import UIKit
import AssesmentModels
import Kingfisher
import LoadingIndicatorView

let LoadingIndicatorView = LoadingView.getView()

public class ProfileViewController: BaseViewController {
    
//    @IBOutlet weak var view: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var lblPublicRepos: UILabel!
    @IBOutlet weak var lblPublicGist: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblUpdatedDate: UILabel!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblNoUserData: UILabel!
    
    @IBOutlet weak var tableViewFollow: UITableView!
//    @IBOutlet weak var btnShare: UIBarButtonItem!
    
    public var userDetails = Item()
    
    lazy var viewModel: ProfileViewModel = {
        return ProfileViewModel()
    }()
    
    // MARK:- ViewController Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageViewAvatar.layer.roundedCorner()
        
        self.viewModel.userDetails = self.userDetails
        
        self.segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        self.segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)

        self.lblNoUserData.isHidden = true
        self.configureTableView()
        
        self.initViewModel()
        
        ThemeModel.setUpTheme()
        
        self.updateThemeChanges()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveNotification(_:)), name: .notificationThemeChange, object: nil)
        
    }
    
   
    
    public init() {
        super.init(nibName: "ProfileViewController", bundle: Bundle(for: ProfileViewController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func receiveNotification(_ notification: NSNotification) {
        if let isDark = notification.userInfo?["theme"] as? Bool {
            if isDark {
                ThemeModel.changeTheme(.dark)
            } else {
                ThemeModel.changeTheme(.light)
            }
        }
        self.updateThemeChanges()
    }
    
    @objc func updateThemeChanges() {
        
        self.tableViewFollow.reloadData()
        self.view.backgroundColor = ThemeModel.viewBgColor
        self.tableViewFollow.backgroundColor = ThemeModel.viewBgColor
        self.viewHeader.backgroundColor = ThemeModel.bgColor
        self.lblPublicRepos.textColor = ThemeModel.textColor
        self.lblPublicGist.textColor = ThemeModel.textColor
        self.lblFollowers.textColor = ThemeModel.textColor
        self.lblFollowing.textColor = ThemeModel.textColor
        self.lblUpdatedDate.textColor = ThemeModel.textColor
        self.lblNoData.textColor = ThemeModel.textColor
        self.lblNoUserData.textColor = ThemeModel.textColor
        self.segmentedController.backgroundColor = ThemeModel.segmentBGColor
        
        navigationController?.navigationBar.barTintColor = ThemeModel.viewBgColor
        navigationController?.navigationBar.tintColor = ThemeModel.textColor
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ThemeModel.textColor]
    }
    
    func configureTableView() {
        self.lblNoData.isHidden = true
        self.tableViewFollow.dataSource = self
        self.tableViewFollow.delegate = self
        self.tableViewFollow.tableFooterView = UIView()
        self.tableViewFollow.separatorStyle = .none
        self.tableViewFollow.register(UINib(nibName: "FollowerTableViewCell", bundle: Bundle(for: FollowerTableViewCell.self)), forCellReuseIdentifier: "FollowerTableViewCell")
    }
    
    private func initViewModel() {

        self.viewModel.updateUI = {
            DispatchQueue.main.async { [weak self] in
                self?.updateUI()
            }
        }
        
        self.viewModel.reloadTableViewClosure = {
            DispatchQueue.main.async { [weak self] in
                self?.tableViewFollow.reloadData()
            }
        }

        self.viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    LoadingIndicatorView.show()
                }else {
                    LoadingIndicatorView.hide()
                }
            }
        }

        self.viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message)
                }
            }
        }
        
        self.viewModel.initFetchUserDetails()
        self.viewModel.fetchFollowers()
        self.viewModel.fetchFollowing()
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func updateUI() {
        
        if let userObj = self.viewModel.user {
            self.lblNoUserData.isHidden = true
            let url = URL(string: userObj.avatarURL )
            self.imageViewAvatar.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"))
            self.title = userObj.name
            
            if userObj.followers == 0  {
                self.lblFollowers.isHidden = true
            } else {
                self.lblFollowers.text = "Followers : \(userObj.followers)"
            }
            if userObj.following == 0  {
                self.lblFollowing.isHidden = true
            } else {
                self.lblFollowing.text = "Following : \(userObj.following)"
            }
            if userObj.publicRepos == 0  {
                self.lblPublicRepos.isHidden = true
            } else {
                self.lblPublicRepos.text = "Public repos : \(userObj.publicRepos )"
            }
            if userObj.publicGists == 0  {
                self.lblPublicGist.isHidden = true
            } else {
                self.lblPublicGist.text = "Public gist : \(userObj.publicGists )"
            }
            
            let date = Date().convertStringToDate(userObj.updatedAt)
            let strDate = date.convertDateToString()
            if strDate != "" {
                self.lblUpdatedDate.text = "Updated: \(strDate)"
            } else {
                self.lblUpdatedDate.isHidden = true
            }
            
        } else {
//            let url = URL(string: self.viewModel.userDetails.avatarURL)
//            self.imageViewAvatar.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"))
            self.title = self.viewModel.userDetails.login
            
            self.lblNoUserData.isHidden = false
            self.lblFollowers.isHidden = true
            self.lblFollowing.isHidden = true
            self.lblPublicRepos.isHidden = true
            self.lblPublicGist.isHidden = true
            self.lblUpdatedDate.isHidden = true
        }
        
    }
    
    func convertStringToDate(_ str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: str)!
    }
    
    // MARK:- UIClick action
    @IBAction func btnShare_Click(_ sender: Any) {
        let image = self.imageViewAvatar.image
        let textToShare = "Welcome to Git profile"
        let gitUrl = self.viewModel.user?.avatarURL
        let objectsToShare = [textToShare, image as Any, gitUrl as Any] as [Any]
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func segmentedController_Click(_ sender: Any) {
        self.tableViewFollow.reloadData()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.segmentedController.selectedSegmentIndex == 0 {
            guard self.viewModel.numberOfFollowerCells > 0 else {
                self.lblNoData.isHidden = false
                self.lblNoData.text = "No followers found"
                return 0
            }
            self.lblNoData.isHidden = true
            return self.viewModel.numberOfFollowerCells
        } else  {
            guard self.viewModel.numberOfFollowingCells > 0 else {
                self.lblNoData.isHidden = false
                self.lblNoData.text = "Not following anyone"
                return 0
            }
            self.lblNoData.isHidden = true
            return self.viewModel.numberOfFollowingCells
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.rowHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let userCell = tableView.dequeueReusableCell(withIdentifier: "FollowerTableViewCell") as? FollowerTableViewCell else {
            fatalError("Cell does not exist in storyboard")
        }
        userCell.setUpCell(self.viewModel.getCellViewModel(at: indexPath, segmentIndex: self.segmentedController.selectedSegmentIndex))
        return userCell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableViewFollow.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.segmentedController.selectedSegmentIndex == 0 {
            if indexPath.row == self.viewModel.numberOfFollowerCells - 1 {
                self.viewModel.fetchFollowers()
            }
        } else {
            if indexPath.row == self.viewModel.numberOfFollowingCells - 1 {
                self.viewModel.fetchFollowing()
            }
        }
    }
    
}
