import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Xác thực số điện thoại
  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(PhoneAuthCredential) verificationCompleted,
    Function(FirebaseAuthException)? verificationFailed,
    Function(String, int?) codeSent,
    Function(String) codeAutoRetrievalTimeout,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: (FirebaseAuthException e) {
          if (verificationFailed != null) {
            verificationFailed((e.message ?? "Unknown error") as FirebaseAuthException);
          }
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      print("Error during phone number verification: $e");
    }
  }

  // Xác thực mã OTP
  Future<String?> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      return e.code.toString();
    }
  }

  // Lấy thông tin người dùng hiện tại
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
