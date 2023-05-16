//
//  ViewController.swift
//  SnacksNavBar
//
//  Created by Ts SaM on 16/5/2023.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBOutlet var navBar: UIView!
  @IBOutlet var plusButton: UIButton!
  
  private var isExpanded = false
  private var selectedImages: [String] = []
  private var stackView: UIStackView!
  private var tableView: UITableView!
  
  
  @IBAction func plusButtonTapped(_ sender: Any) {
    print("plus icon pressed")
    isExpanded.toggle()
    
    doAnimate()
  }
  
  private func doAnimate() {
    let rotationAngle: CGFloat = isExpanded ? .pi/4 : 0
    let viewHeight: CGFloat = isExpanded ? 200 : 88
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
      self.navBar.frame.size.height = viewHeight
      self.plusButton.imageView?.transform = CGAffineTransform(rotationAngle: rotationAngle)
      self.stackView.isHidden = !self.isExpanded
    }, completion: nil)
  }
  
  
  private func setupStackView() {
    // Create a stack view
    stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 8
    //    stackView.backgroundColor = .blue
    
    // Create image views
    let imageView1 = createImageView(named: "oreos")
    let imageView2 = createImageView(named: "pizza_pockets")
    let imageView3 = createImageView(named: "pop_tarts")
    let imageView4 = createImageView(named: "popsicle")
    let imageView5 = createImageView(named: "ramen")
    
    [imageView1, imageView2, imageView3, imageView4, imageView5].forEach { imageView in
      stackView.addArrangedSubview(imageView)
    }
    
    // Add stack view to the navigation bar
    navBar.addSubview(stackView)
    
    // Configure stack view constraints
    stackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: 16),
      stackView.trailingAnchor.constraint(equalTo: navBar.trailingAnchor, constant: -16),
      stackView.centerYAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -60),
      stackView.heightAnchor.constraint(equalToConstant: 100),
    ])
    
    // Initially hide the stack view
    stackView.isHidden = true
  }
  
  private func createImageView(named imageName: String) -> UIImageView {
    let imageView = UIImageView(image: UIImage(named: imageName))
    imageView.contentMode = .scaleAspectFit
    imageView.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
    imageView.addGestureRecognizer(tapGesture)
    imageView.accessibilityIdentifier = imageName
    stackView.addArrangedSubview(imageView)
    return imageView
  }
  
  
  private func setupTableView() {
    // Create a table view
    tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
//    tableView.backgroundColor = .black
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NumberCell")
    
    // Add table view as a subview
    view.addSubview(tableView)
    
    // Configure table view constraints
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  @objc private func imageViewTapped(_ gesture: UITapGestureRecognizer) {
    print("image tapped")
    guard let imageView = gesture.view as? UIImageView,
          let imageName = imageView.accessibilityIdentifier else {
      return
    }
    print("Name : \(imageName)")
    selectedImages.append(imageName)
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    plusButton.backgroundColor = .white
    //    view.backgroundColor = .white
    //    doAnimate()
    setupStackView()
    setupTableView()
    
    
    //
    //    // Create a UIView to simulate the navigation bar
    //    let navBar = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 88))
    //    navBar.backgroundColor = UIColor(hex: "#DDDDDD")
    //    view.addSubview(navBar)
    //
    //    // Add a button to the right corner of the navigation bar
    //    let addButton = UIButton(type: .system)
    //    addButton.frame = CGRect(x: navBar.frame.width - 60, y: 20, width: 60, height: navBar.frame.height)
    //    addButton.setTitle("+", for: .normal)
    //    addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
    //    addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
    //    navBar.addSubview(addButton)
    //
    //    // Adjust the layout to account for the navigation bar
    //    navBar.translatesAutoresizingMaskIntoConstraints = false
    //    navBarHeightConstraint = navBar.heightAnchor.constraint(equalToConstant: 88)
    //    NSLayoutConstraint.activate([
    //      navBar.topAnchor.constraint(equalTo: view.topAnchor),
    //      navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    //      navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    //      navBarHeightConstraint
    //    ])
    
  }
  //
  //  @objc private func addButtonTapped(_ sender: UIButton) {
  //    print("HELLO")
  ////    isExpanded.toggle()
  ////
  ////    UIView.animate(withDuration: 0.3) {
  ////      self.navBarHeightConstraint.constant = self.isExpanded ? 200 : 88
  ////      self.view.layoutIfNeeded()
  ////    }
  //  }
  
  
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedImages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NumberCell", for: indexPath)
    let imageName = selectedImages[indexPath.row]
    cell.textLabel?.text = imageName
    return cell
  }
  
}

// Extension to create UIColor from a hex string
//extension UIColor {
//  convenience init(hex: String) {
//    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
//
//    if hexString.hasPrefix("#") {
//      hexString.remove(at: hexString.startIndex)
//    }
//
//    var rgbValue: UInt64 = 0
//    Scanner(string: hexString).scanHexInt64(&rgbValue)
//
//    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
//    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
//    let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
//
//    self.init(red: red, green: green, blue: blue, alpha: 1.0)
//  }
//}
