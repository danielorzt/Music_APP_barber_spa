import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../repositories/auth_repository.dart';
import '../../features/profile/models/user_model.dart';

// Events
abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object> get props => [];
}

class SessionStarted extends SessionEvent {}

class SessionLoggedIn extends SessionEvent {
  final User user;

  const SessionLoggedIn(this.user);

  @override
  List<Object> get props => [user];
}

class SessionLoggedOut extends SessionEvent {}

class SessionExpired extends SessionEvent {}

// States
abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionLoading extends SessionState {}

class SessionAuthenticated extends SessionState {
  final User user;

  const SessionAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class SessionUnauthenticated extends SessionState {}

// BLoC
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final AuthRepository _authRepository;

  SessionBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SessionLoading()) {
    on<SessionStarted>(_onSessionStarted);
    on<SessionLoggedIn>(_onSessionLoggedIn);
    on<SessionLoggedOut>(_onSessionLoggedOut);
    on<SessionExpired>(_onSessionExpired);
  }

  void _onSessionStarted(SessionStarted event, Emitter<SessionState> emit) async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(SessionAuthenticated(user));
      } else {
        emit(SessionUnauthenticated());
      }
    } catch (e) {
      emit(SessionUnauthenticated());
    }
  }

  void _onSessionLoggedIn(SessionLoggedIn event, Emitter<SessionState> emit) {
    emit(SessionAuthenticated(event.user));
  }

  void _onSessionLoggedOut(SessionLoggedOut event, Emitter<SessionState> emit) async {
    await _authRepository.logout();
    emit(SessionUnauthenticated());
  }

  void _onSessionExpired(SessionExpired event, Emitter<SessionState> emit) async {
    await _authRepository.logout();
    emit(SessionUnauthenticated());
  }
}