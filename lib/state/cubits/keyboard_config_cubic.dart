import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_peer/state/models/keyboard_config.dart';

class KeyboardConfigCubic extends Cubit<KeyboardConfig> {
  KeyboardConfigCubic() : super(KeyboardConfig.forLang());

  void setConfig(KeyboardConfig config) => emit(config);
}
