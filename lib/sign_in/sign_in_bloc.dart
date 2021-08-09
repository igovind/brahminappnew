import 'dart:async';
import 'package:brahminapp/services/auth.dart';

class SignInBloc {
  SignInBloc({required this.auth});
  final AuthBase auth;

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<UserId?> _signIn(Future<UserId?> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<UserId?> signInAnonymously() async => await _signIn(auth.signInAnonymously);

  Future<UserId?> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);

}
