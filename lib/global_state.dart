class GlobalState {
  static final GlobalState _instance = GlobalState._internal();

  // Constructor privado para implementar el patrón singleton
  GlobalState._internal();

  // Acceso al único punto de instancia
  factory GlobalState() => _instance;

  // Variable para almacenar el uid
  String? currentUserUid;
}
