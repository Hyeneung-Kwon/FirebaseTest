import SwiftUI
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseAuth

struct LoginView: View {
    
    @State var email = ""
       @State var pw = ""
       @ObservedObject var viewModel = AuthViewModel()
    
    var body: some View {
        VStack {
                    TextField("Email", text: $email)
                    SecureField("PW", text: $pw)
                    Button {
                        viewModel.registerUser()
                    } label: {
                        Text("등록")
                    }

                }
                .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

class AuthViewModel: ObservableObject {
    
    init() {
        
    }
    
    func registerUser() {
        Auth.auth().signInAnonymously() { result, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            
            print(user.uid)
        }
    }
}
