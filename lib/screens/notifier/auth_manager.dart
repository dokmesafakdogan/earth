class AuthManager {
  
  AuthManager._init();
  static final AuthManager _instance = AuthManager._init();
  static AuthManager get instance => _instance;

  String? userUuid;


  void setUserUuid(String userId){
    userUuid=userId;
  }









}