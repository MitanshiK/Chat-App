import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class PhoneAuth2 extends StatefulWidget {
  const PhoneAuth2({super.key});

  @override
  State<PhoneAuth2> createState() => _PhoneAuth2State();
}

class _PhoneAuth2State extends State<PhoneAuth2> {

  TextEditingController phoneController =TextEditingController();
  TextEditingController otpController=TextEditingController();
  bool otpVisible=false;
  var phoneNo="";
  FirebaseAuth auth=FirebaseAuth.instance;
  var verificationCode;
 
 // sending otp on filled phone no
  void verifyPhoneNo(){
    auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
    verificationCompleted: (PhoneAuthCredential credential) async{ 
     await auth.signInWithCredential(credential).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("verification Successful"))
      );
     });
     },
     verificationFailed: (FirebaseAuthException error) { 
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$error"))
      );
      print(error);
      }, 
     codeSent: (String verificationId, int? forceResendingToken) { 
      verificationCode=verificationId;
       setState(() {
         otpVisible=true; // when the otp is sent , the otp textField will be visible
       });
      }, 
     codeAutoRetrievalTimeout: (String verificationId) {  });
  }

   // verifying otp sent 
    Future<void> verifyOtpSent() async{
    PhoneAuthCredential phoneAuthCredential=   PhoneAuthProvider.credential(
      verificationId: verificationCode,
       smsCode: otpController.text);

       await auth.signInWithCredential(phoneAuthCredential).then((value) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Successful")));
       });
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Phone Auth"),),
      body: Center(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // for Phone No
          TextFormField(
            controller: phoneController,
            style:  const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              label: Text("Phone no"),
              labelStyle: TextStyle(color: Colors.black)
            ),
          ),
          ElevatedButton(onPressed: ()async{
            setState(() {
              phoneNo="+91${phoneController.text}";
            });
           verifyPhoneNo();
          }, 
          child: const Text("Get Otp")),
        
        // for Otp
         Visibility(
          visible: otpVisible,
            child: Column(
              children: [
           TextFormField(
            controller: otpController,
            style:  const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              label: Text("OTP"),
              labelStyle: TextStyle(color: Colors.black)
            ),
          ),
          ElevatedButton(onPressed: (){
           verifyOtpSent();
          },
           child: const Text("Verify"))
          ],
          ))
        
        ],),
      ),),
    );
  }
}
