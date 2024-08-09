
import 'package:cubit_form/cubit_form.dart';

sealed class PhoneOrEmail{}
final class EmailSelected extends PhoneOrEmail{}
final class PhoneSelected extends PhoneOrEmail{}



// Observing change in state using onChange and onTransition method 

class InviteTypeBloc extends Bloc<PhoneOrEmail,String>{
  InviteTypeBloc():super("email"){          // initializing statye with 0

on<EmailSelected>((event,emit){
emit("email");
       });

       on<PhoneSelected>((event,emit){
emit("phone");
       });
 
 }
}