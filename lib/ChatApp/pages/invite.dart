import 'package:cubit_form/cubit_form.dart';
import 'package:flutter/material.dart';
import 'package:proj/ChatApp/models/Blocs/invite_type_bloc.dart';
import 'package:proj/ChatApp/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// class InviteFriends {
//   static void InviteDialog(BuildContext context) {
//     TextEditingController inviteController = TextEditingController();
//     String inviteType = "email";
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return BlocProvider<InviteTypeBloc>(
//           create: (_) => InviteTypeBloc(),
//           child: BlocBuilder<InviteTypeBloc, String>(
//             builder: (BuildContext context, state) {
//               return AlertDialog(
//                 title: ListTile(
//                   leading: Icon(Icons.group_add),
//                   title: Text("Invite Friends"),
//                 ),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(children: [
//                       TextButton(
//                           onPressed: () {
//                             inviteType = "phone";
//                             context.read<InviteTypeBloc>().add(PhoneSelected());
//                           },
//                           child: Text("Phone No")),
//                       SizedBox(
//                         width: 40,
//                       ),
//                       TextButton(
//                           onPressed: () {
//                             inviteType = "email";
//                             context.read<InviteTypeBloc>().add(EmailSelected());
//                           },
//                           child: Text("Email"))
//                     ]),
//                     Center(
//                       child: Column(
//                         children: [
//                           TextField(
//                             controller: inviteController,
//                             decoration: InputDecoration(
//                               labelStyle: TextStyle(color: Colors.grey),
//                               label: Text(
//                                   (context.watch<InviteTypeBloc>().state ==
//                                           "email")
//                                       ? "Email"
//                                       : "Phone"),
//                               hintText:
//                                   (context.watch<InviteTypeBloc>().state ==
//                                           "email")
//                                       ? "abc@gmail.com"
//                                       : "1234567898",
//                               hintStyle: TextStyle(color: Colors.grey),
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                       onPressed: () async {
//                         Provider.of<InviteTypeBloc>(context, listen: false);
//                         // email
//                         if (context.watch<InviteTypeBloc>().state == "email") {
//                           String body =
//                               "[name] is inviting you to join chat app and chat";
//                           var url = Uri(
//                             scheme: 'mailto',
//                             path: inviteController.text,
//                             queryParameters: {
//                               'subject': "Invitation",
//                               'body': body
//                             },
//                           ).toString().replaceAll("+",
//                               "%20"); // so that spaces in the body and subject do not get replaced with +
//
//                           if (await canLaunchUrl(Uri.parse(url))) {
//                             await launchUrl(Uri.parse(url));
//                           } else {
//                             print("could not launch the url[mail]");
//                           }
//                         }
//                         // phone
//                         else {
//                           var url = Uri(
//                             scheme: 'sms',
//                             path: inviteController.text,
//                             queryParameters: {
//                               'body':
//                                   "[name] is inviting you to join Chat App and chat"
//                             },
//                           ).toString().replaceAll("+", "%20");
//                           if (await canLaunchUrl(Uri.parse(url))) {
//                             await launchUrl(Uri.parse(url));
//                           } else {
//                             print("could not launch the url[phone]");
//                           }
//                         }
//
//                         Navigator.pop(context);
//                       },
//                       child: Text("Send Invite"))
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   static sendMailFun(String email) async {
//     // var url = Uri.parse("mailto:${emailController.text}"+"subject: Testing subject");
//     //OR
//     String body = "[name] is inviting you to join chat app and chat";
//     var url = Uri(
//       scheme: 'mailto',
//       path: email,
//       queryParameters: {'subject': "Invitation", 'body': body},
//     ).toString().replaceAll("+",
//         "%20"); // so that spaces in the body and subject do not get replaced with +
//
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     } else {
//       print("could not launch the url[mail]");
//     }
//   }
//
//   static sendSmsFun(String phone) async {
//     //  var url = Uri.parse("sms:${numController.text}");
//     //OR
//     var url = Uri(
//       scheme: 'sms',
//       path: phone,
//       queryParameters: {
//         'body': "[name] is inviting you to join Chat App and chat"
//       },
//     ).toString().replaceAll("+", "%20");
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     } else {
//       print("could not launch the url[phone]");
//     }
//   }
// }

class Invites extends StatefulWidget {
  const Invites({super.key ,required this.userModel});
  final UserModel userModel;

  @override
  State<Invites> createState() => _InvitesState();
}

class _InvitesState extends State<Invites> {
      TextEditingController inviteController = TextEditingController();
    String inviteType = "email";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // backgroundColor: Color.fromARGB(255, 253, 241, 207),
      // ),
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/chatBg.jpg"), fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                   Color.fromARGB(255, 253, 241, 207).withOpacity(0.2), BlendMode.screen),)),
        child: Center(
          child: SizedBox(
             height: MediaQuery.sizeOf(context).height/2.5,
        width: MediaQuery.sizeOf(context).width/1.5,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Color.fromARGB(255, 253, 241, 207) ,borderRadius: BorderRadius.circular(30)),
              child: Column(
                          children: [
                           ListTile(
                            leading: Icon(Icons.group_add),
                            title: Text("Invite Friends"),
                          ),
                         Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(children: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                         inviteType = "phone";
                                      });
                                     
                                    },
                                    child: Text("Phone No")),
                                SizedBox(
                                  width: 40,
                                ),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                          inviteType = "email";
                                      });
                                    
                                      // context.read<InviteTypeBloc>().add(EmailSelected());
                                    },
                                    child: Text("Email"))
                              ]),
                              Center(
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: inviteController,
                                      decoration: InputDecoration(
                                        labelStyle: TextStyle(color: Colors.grey),
                                        label: Text(
                                            (inviteType ==
                                                    "email")
                                                ? "Email"
                                                : "Phone"),
                                        hintText:
                                            (inviteType ==
                                                    "email")
                                                ? "abc@gmail.com"
                                                : "1234567898",
                                        hintStyle: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20,),
                            TextButton(
                                onPressed: () async {
                                  // Provider.of<InviteTypeBloc>(context, listen: false);
                                  // email
                                  if (inviteType == "email") {
                                    String body =
                                        "${widget.userModel.name} is inviting you to join chat app and chat";
                                    var url = Uri(
                                      scheme: 'mailto',
                                      path: inviteController.text,
                                      queryParameters: {
                                        'subject': "Invitation",
                                        'body': body
                                      },
                                    ).toString().replaceAll("+",
                                        "%20"); // so that spaces in the body and subject do not get replaced with +
              
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      print("could not launch the url[mail]");
                                    }
                                  }
                                  // phone
                                  else {
                                    var url = Uri(
                                      scheme: 'sms',
                                      path: inviteController.text,
                                      queryParameters: {
                                        'body':
                                            "[name] is inviting you to join Chat App and chat"
                                      },
                                    ).toString().replaceAll("+", "%20");
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(Uri.parse(url));
                                    } else {
                                      print("could not launch the url[phone]");
                                    }
                                  }
              
                                  // Navigator.pop(context);
                                },
                                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
                                child: Text("Send Invite" ,style: TextStyle(color: Colors.white),))
                          ],
                  
                        )
                    
            ),
          ),
        ),
      ),
    );
  }
}