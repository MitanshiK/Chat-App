import 'package:cubit_form/cubit_form.dart';
// play video arrow in open_media.dart page

sealed class VideoState{}
final class VideoPlay extends VideoState{}
final class VideoPause extends VideoState{}


// Observing change in state using onChange and onTransition method 

class VideoStateBloc extends Bloc<VideoState,bool>{
  VideoStateBloc(bool initial):super(initial){          // initializing statye with 0
 on<VideoPlay>((even,emit){
  emit(!state);
    });

  on<VideoPause>((even,emit){
  emit(false);
    });
  }
}