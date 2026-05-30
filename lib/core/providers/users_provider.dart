import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../repositories/users_repository.dart';

class UsersNotifier extends Notifier<List<UserProfile>> {
  final _repo = UsersRepository();

  @override
  List<UserProfile> build() {
    _init();
    return const [];
  }

  Future<void> _init() async {
    try {
      final me = await _repo.getMe();
      state = [me];
    } catch (_) {}
  }

  Future<UserProfile?> fetchUser(String userId) async {
    try {
      final user = await _repo.getUser(userId);
      // Add or update in state
      final exists = state.any((u) => u.id == userId);
      if (exists) {
        state = [for (final u in state) u.id == userId ? user : u];
      } else {
        state = [...state, user];
      }
      return user;
    } catch (_) {
      return null;
    }
  }

  void toggleTuneIn(String userId) {
    state = [
      for (final u in state)
        if (u.id == userId)
          UserProfile(
            id: u.id,
            displayName: u.displayName,
            handle: u.handle,
            bio: u.bio,
            avatarUrl: u.avatarUrl,
            promptCount: u.promptCount,
            echoesReceived: u.echoesReceived,
            collectionsCount: u.collectionsCount,
            tunedInCount: u.tunedInCount + (u.isTunedIn ? -1 : 1),
            tuningInToCount: u.tuningInToCount,
            joinedAt: u.joinedAt,
            mood: u.mood,
            pinnedPromptIds: u.pinnedPromptIds,
            isTunedIn: !u.isTunedIn,
          )
        else
          u
    ];
    final isNowTunedIn = state.firstWhere((u) => u.id == userId).isTunedIn;
    _syncFollow(userId, isNowTunedIn);
  }

  Future<void> _syncFollow(String userId, bool follow) async {
    try {
      await _repo.toggleFollow(userId, follow);
    } catch (_) {
      // Revert
      state = [
        for (final u in state)
          if (u.id == userId)
            UserProfile(
              id: u.id,
              displayName: u.displayName,
              handle: u.handle,
              bio: u.bio,
              avatarUrl: u.avatarUrl,
              promptCount: u.promptCount,
              echoesReceived: u.echoesReceived,
              collectionsCount: u.collectionsCount,
              tunedInCount: u.tunedInCount + (u.isTunedIn ? -1 : 1),
              tuningInToCount: u.tuningInToCount,
              joinedAt: u.joinedAt,
              mood: u.mood,
              pinnedPromptIds: u.pinnedPromptIds,
              isTunedIn: !u.isTunedIn,
            )
          else
            u
      ];
    }
  }
}

final usersProvider =
    NotifierProvider<UsersNotifier, List<UserProfile>>(() {
  return UsersNotifier();
});
