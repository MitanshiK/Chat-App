import 'package:cubit_form/cubit_form.dart';

sealed class ShowHeart {}
final class HeartVis extends ShowHeart {}
final class HeartNotVis extends ShowHeart {}


class HeartVisBloc extends Bloc<ShowHeart, bool> {
  HeartVisBloc(bool initial) : super(initial) {
    on<HeartVis>((even, emit) {
      emit(true);

      // Future.delayed(const Duration(milliseconds: 100), () {
      //   emit(false);
      // });
    });

    on<HeartNotVis>((even, emit) {
      emit(false);
    });

////
    
  }
}
