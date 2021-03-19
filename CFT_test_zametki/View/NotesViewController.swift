//
//  ViewController.swift
//  CFT_test_zametki
//
//  Created by Anatoliy Mamchenko on 17.03.2021.
//

import UIKit

import SnapKit

let cellIdentifire = "MyCell"

class NotesViewController: UIViewController {
    
    let createNoteViewController = CreateNoteViewController()
    var database = Database()
    
    // MARK: CREATE UI
    lazy private var tableViewNotes: UITableView = {
        var tableView = UITableView()
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        database.complition = { [weak self] in
            self?.tableViewNotes.setEditing(false, animated: true)
            self?.tableViewNotes.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.getArrayOfObject()
        cofigureUI()
        configConstraints()
        setGradientBackground()
        tableViewNotes.delegate = self
        tableViewNotes.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil) // делаем нотификацию для обновление таблицы
    }
    
    @objc func loadList(notification: NSNotification){
        database.getArrayOfObject()
        self.tableViewNotes.reloadData() // метод нотификации
    }
    
     //MARK: Create gradient layer for tableview background
    private func setGradientBackground() {
        let tableViewBackgroundView = UIView()
        let colorTop =  UIColor(red: 255.0/255.0, green: 149.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 0.8]
        tableViewNotes.backgroundView = tableViewBackgroundView
        tableViewNotes.backgroundView?.layer.addSublayer(gradientLayer)
    }
    
    // MARK: SetupUI Elements and add target to button
    private func cofigureUI () {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "CFT Notes Test"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddingNotesViewController))
    }
        
    @objc private func showAddingNotesViewController () {
        navigationController?.pushViewController(createNoteViewController, animated: false)
    }
    
    //MARK: Constraints Configuration
    private func configConstraints () {
        view.addSubview(tableViewNotes)
        
        tableViewNotes.snp.makeConstraints { (make ) in
            make.top.equalTo(self.view.snp.top)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return database.arrayOfNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! NotesTableViewCell
        cell.backgroundColor = .clear
        cell.layer.borderWidth = 1
        cell.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        // меняем констреинты в зависимости от того есть у нас картинка в заметке или нет 
        switch database.arrayOfNotes[indexPath.row].thing {
                case .have:
                    cell.configConstraintsForNoteWithImage()
                case .notHave:
                    cell.configConstraintsForNoteWithoutImage()
        }
        cell.titleLabel.text = database.arrayOfNotes[indexPath.row].title
        cell.noteLabel.text = database.arrayOfNotes[indexPath.row].note
        if let data = database.arrayOfNotes[indexPath.row].imageData {
            cell.imageViewer.image = UIImage(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let array = database.arrayOfNotes[indexPath.row]
                self.database.arrayOfNotes.remove(at: indexPath.row)
                self.tableViewNotes.deleteRows(at: [indexPath], with: .automatic)
            database.deleteObject(id: array.id)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch database.arrayOfNotes[indexPath.row].thing {
        case .notHave:
            return 150
        case .have:
            return 400
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arraWithIndex = database.arrayOfNotes[indexPath.row]
        createNoteViewController.titleTextfield.text = arraWithIndex.title
        createNoteViewController.noteTextfield.text = arraWithIndex.note
        if let passData = database.arrayOfNotes[indexPath.row].imageData  {
            createNoteViewController.imageViewer.image = UIImage(data: passData)
        }
        self.navigationController?.pushViewController(createNoteViewController, animated: false)
    }
}


