part of 'authentication_bloc.dart';

enum AuthenticationStatus { authenticated, unauthicated, unknown }

class AuthenticationState extends Equatable {
  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user = User.empty,
  });

  const AuthenticationState.unknown() : this._();

  const AuthenticationState.authenticated(User user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthenticationState.unauthicated()
      : this._(status: AuthenticationStatus.authenticated);
  final AuthenticationStatus status;
  final User user;
  @override
  List<Object> get props => [status, user];
}
