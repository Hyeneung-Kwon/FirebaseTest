import SwiftUI

func randnumPop() -> String{
    var temp: String = ""
    for _ in 0...5{
        temp += String(Int.random(in: 0...9))
    }
    return temp
}

struct MatchingView: View {
    @StateObject var firestoreManager: FireStoreManager = FireStoreManager()
    @State var randnums: String = ""
    @State var textSample: String = ""
    @State var moojeongi: String = ""
    
    var body: some View {
        VStack{
            Text("당신의 코드 : \(randnums)")
            
            Button(action: {
                randnums = randnumPop()
                firestoreManager.AddMatchingCode(matchingCode: randnums)},
                   label: {Text("랜덤 코드 제작")})
            
            TextField("상대방코드", text:$textSample)
                .padding(.horizontal, 100.0)
        
            Button(action: {
                firestoreManager.MatchingData(mynumber: randnums, matchingNumber: textSample)
                firestoreManager.liveListener(documentname: (firestoreManager.dataDict["finalMatchingCode"] ?? " "), dataname: "b")
            }, label: {Text("매칭하기")})
            
            Text(firestoreManager.status)
            
            TextField("무전기에 대고 할 말", text:$moojeongi)
                .padding(.horizontal, 100.0)
            
            VStack{
                Button(action: {
                    firestoreManager.dataSend(inputstr: moojeongi)
                }, label: {Text("무전 보내기")})
                
                Text(firestoreManager.dataDict["moojeon"] ?? "아직 받은 무전 데이터가 없습니다.")
            }
            
        }
    }
}

struct MatchingView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var firestoreManager = FireStoreManager()

        MatchingView()
    }
}
