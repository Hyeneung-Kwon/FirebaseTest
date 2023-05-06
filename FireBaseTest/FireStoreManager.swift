import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FireStoreManager: ObservableObject {
    @Published var title: String = ""
    @Published var maintext: String = ""
    @Published var status: String = "아직 매칭 안됨"
    @Published var liveData: String = "라이브데이터"
    @Published var dataDict: [String: String] = [:]
    var documentname = ""

    func fetchData(documentinput : String) {
        
        documentname = documentinput
        
        if (documentname == ""){
            documentname = " "
        }
        
        self.title = "데이터 받아오는 중..."
        self.maintext = "데이터 받아오는 중..."
        
        let db = Firestore.firestore()
        let docRef = db.collection("firstCollection").document(documentname)
        docRef.getDocument { (document, error) in
            guard error == nil else {
                self.title = "데이터 받아오기 실패!"
                self.maintext = ":("
                print("Error")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    print("data", data)
                    self.title = data["title"] as? String ?? ""
                    self.maintext = data["maintext"] as? String ?? ""
                }
            }
            else{
                self.title = "No DATA"
                self.maintext = "데이터가 없습니다!"
            }
        }
    }
    
        func addData(title: String, maintext: String, collectionName: String, documentinput: String) {
            let db = Firestore.firestore()
            let docref = db.collection(collectionName).document(documentinput)
            
            docref.setData([
                    "title": title,
                    "maintext": maintext
                    ])
            
            self.title = "데이터 저장 중..."
            self.maintext = "아직 저장이 완료되지 않았습니다."
            
            docref.getDocument { (document, error) in
                guard error == nil else {
                    self.title = "저장 오류가 발생했습니다."
                    self.maintext = ":("
                    print("SaveError")
                    return
                }

                if let document = document, document.exists {
                    let data = document.data()
                    if let data = data {
                        print("data", data)
                        self.title = "저장 성공! 저장 데이터: " + (data["title"] as? String ?? "")
                        self.maintext = "저장 성공! 저장 데이터: " + (data["maintext"] as? String ?? "")
                    }
                }
            }
        }
    
    func AddMatchingCode(matchingCode: String) {
        let db = Firestore.firestore()
        let docref = db.collection("matchingcodeCollection").document(matchingCode)
        
        docref.setData([
            "matchingcode": matchingCode
                ])
    }
    
    func MatchingData(mynumber: String, matchingNumber: String){
        let db = Firestore.firestore()
        let docref = db.collection("matchingcodeCollection").document(matchingNumber)
        
        //self.status = "매칭 중..."
        
        docref.getDocument { (document, error) in
            guard error == nil else {
                self.title = "오류"
                return
            }
            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    self.title = data["matchingcode"] as? String ?? ""
                    self.dataDict["finalMatchingCode"] = String(Int(matchingNumber)! + Int(mynumber)!)
                    //self.status = "매칭 중... 매칭코드 : " + (self.dataDict["finalMatchingCode"] ?? "")
                    docref.setData([
                            "matchingcode" : self.dataDict["finalMatchingCode"] ?? "error"
                                ])
                    db.collection("matchingcodeCollection").document(self.dataDict["finalMatchingCode"] ?? "error").setData(["status": "매칭 완료!"])
                    return
                }
            }
            else{
                self.dataDict["finalMatchingCode"] = "상대 코드가 없습니다!"
            }
        }
        return
    }

    func afterMatchingFetch(matchingcode : String) {

        let db = Firestore.firestore()
        let docRef = db.collection("matchingcodeCollection").document(matchingcode)
        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("Error")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    print("data", data)
                    self.status = data["status"] as? String ?? ""
                }
            }
            else{
                self.status = "데이터를 찾지 못했습니다."
            }
        }
    }
    
    func liveListener(documentname: String, dataname: String){
        let db = Firestore.firestore()

        db.collection("matchingcodeCollection").document(documentname)
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
              print("Current data: \(data)")
              self.dataDict[dataname] = data[dataname] as? String ?? ""
              self.status = data["status"] as? String ?? "매칭 중..."
            }
    }
        
        func dataSend(inputstr: String){
            let db = Firestore.firestore()
            let docref = db.collection("matchingcodeCollection").document(self.dataDict["finalMatchingCode"] ?? "123")
            
            docref.setData([
                "moojeon" : inputstr
                    ])
        }
    
    init(){
        
    }
}
