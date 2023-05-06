import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct StoreTestView: View {
    @StateObject var firestoreManager: FireStoreManager = FireStoreManager()
    @State var textSample : String = ""
         
        var body: some View {
            NavigationView{
                VStack {
                    Text("My Title: \(firestoreManager.title)")
                    Text("My Nickname: \(firestoreManager.maintext)")
                    Button(action:{
                        firestoreManager.fetchData(documentinput: textSample)}, label: {Text("Click")})
                    Button(action:{
                        firestoreManager.addData(title: "Apple", maintext: "Samsung", collectionName: "firstCollection", documentinput: "kA9U3ayhPRxgfeYmZAU6")}, label: {Text("SaveData")})
                    TextField("텍스트필드", text:$textSample)
                        .padding(.horizontal, 100.0)
                    NavigationLink(destination: MatchingView(), label:{ Text("매칭뷰로 가기")})
                }
            }
        }
}

struct StoreTestView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var firestoreManager = FireStoreManager()

        StoreTestView()
    }
}
