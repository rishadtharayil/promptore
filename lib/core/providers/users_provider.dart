import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class UsersNotifier extends Notifier<List<UserProfile>> {
  @override
  List<UserProfile> build() {
    return List.from(MockData.users);
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
  }
}

final usersProvider =
    NotifierProvider<UsersNotifier, List<UserProfile>>(() {
  return UsersNotifier();
});
