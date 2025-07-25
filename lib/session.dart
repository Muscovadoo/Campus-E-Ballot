// Session management for the app

Map<String, dynamic>? sessionUser;
Map<String, Map<String, dynamic>> tempUserStore = {};

// Use this to register a new user
void registerUser(Map<String, dynamic> user) {
  tempUserStore[user['gsuite']] = {...user, 'hasVoted': false, 'lastVRN': null};
}

// Use this to login
bool loginUser(String gsuite, String password) {
  // Check tempUserStore (registered users)
  if (tempUserStore.containsKey(gsuite) &&
      tempUserStore[gsuite]!['password'] == password) {
    sessionUser = Map<String, dynamic>.from(tempUserStore[gsuite]!);
    return true;
  }
  // Check predefined users
  final user = predefinedUsers.firstWhere(
    (u) => u['gsuite'] == gsuite && u['password'] == password,
    orElse: () => {},
  );
  if (user.isNotEmpty) {
    sessionUser = Map<String, dynamic>.from(user);
    return true;
  }
  return false;
}

// Use this to update the current user's data
void updateCurrentUserProfile(Map<String, dynamic> updatedFields) {
  if (sessionUser != null && sessionUser!['gsuite'] != null) {
    final gsuite = sessionUser!['gsuite'];
    // Update in tempUserStore if user is registered
    if (tempUserStore.containsKey(gsuite)) {
      tempUserStore[gsuite] = {...?tempUserStore[gsuite], ...updatedFields};
      sessionUser = Map<String, dynamic>.from(tempUserStore[gsuite]!);
    } else {
      // If predefined user, update sessionUser only (in-memory)
      sessionUser = {...sessionUser!, ...updatedFields};
    }
  }
}

List<Map<String, String>> predefinedUsers = [
  {
    'gsuite': 'demo',
    'password': 'demo',
    'fullName': 'Demo Account',
    'srCode': 'N/A',
    'age': '20',
    'contactNumber': '09123456789',
    'hasVoted': 'false',
    'lastVRN': '',
  },
  {
    'gsuite': 'test@example.com',
    'password': 'test',
    'fullName': 'Tester',
    'srCode': 'N/A',
    'hasVoted': 'false',
    'lastVRN': '',
  },
  {
    'gsuite': '22-61604@g.batstate-u.edu.ph',
    'password': 'jayjay022',
    'fullName': 'Jaymuel A. Penaredondo',
    'srCode': '22-61604',
    'hasVoted': 'false',
    'lastVRN': '',
  },
  {
    'gsuite': '22-60086@g.batstate-u.edu.ph',
    'password': 'andreipogi',
    'fullName': 'Francis Andrei M. Anciado',
    'srCode': '22-60086',
    'hasVoted': 'false',
    'lastVRN': '',
  },
  {
    'gsuite': '22-68623@g.batstate-u.edu.ph',
    'password': 'mjgalicio05',
    'fullName': 'Mark John Galicio',
    'srCode': '22-68623',
    'hasVoted': 'false',
    'lastVRN': '',
  },
];

// Use this to logout
void logoutUser() {
  sessionUser = null;
}

// Utility: Find user by gsuite and srCode (for forgot password, etc.)
Map<String, dynamic>? findUserByGsuiteAndSrCode(String gsuite, String srCode) {
  if (tempUserStore.containsKey(gsuite) &&
      tempUserStore[gsuite]!['srCode'] == srCode) {
    return tempUserStore[gsuite];
  }
  final user = predefinedUsers.firstWhere(
    (u) => u['gsuite'] == gsuite && u['srCode'] == srCode,
    orElse: () => {},
  );
  if (user.isNotEmpty) return user;
  return null;
}

// Utility: Update password for a user (for forgot password)
bool updateUserPassword(String gsuite, String srCode, String newPassword) {
  if (tempUserStore.containsKey(gsuite) &&
      tempUserStore[gsuite]!['srCode'] == srCode) {
    tempUserStore[gsuite]!['password'] = newPassword;
    return true;
  }
  for (var user in predefinedUsers) {
    if (user['gsuite'] == gsuite && user['srCode'] == srCode) {
      user['password'] = newPassword;
      return true;
    }
  }
  return false;
}

// Utility: Check if user has voted
bool hasUserVoted(String gsuite) {
  if (tempUserStore.containsKey(gsuite)) {
    return tempUserStore[gsuite]!['hasVoted'] == true ||
        tempUserStore[gsuite]!['hasVoted'] == 'true';
  }
  final user = predefinedUsers.firstWhere(
    (u) => u['gsuite'] == gsuite,
    orElse: () => {},
  );
  if (user.isNotEmpty) {
    return user['hasVoted'] == 'true' || user['hasVoted'] == true;
  }
  return false;
}

// Utility: Set user hasVoted and VRN (only if not already set)
void setUserVoted(String gsuite, String vrn) {
  if (tempUserStore.containsKey(gsuite)) {
    tempUserStore[gsuite]!['hasVoted'] = true;
    if (tempUserStore[gsuite]!['lastVRN'] == null ||
        tempUserStore[gsuite]!['lastVRN'] == '') {
      tempUserStore[gsuite]!['lastVRN'] = vrn;
    }
    if (sessionUser != null && sessionUser!['gsuite'] == gsuite) {
      sessionUser!['hasVoted'] = true;
      if (sessionUser!['lastVRN'] == null || sessionUser!['lastVRN'] == '') {
        sessionUser!['lastVRN'] = vrn;
      }
    }
    return;
  }
  for (var user in predefinedUsers) {
    if (user['gsuite'] == gsuite) {
      user['hasVoted'] = 'true';
      if (user['lastVRN'] == null || user['lastVRN'] == '') {
        user['lastVRN'] = vrn;
      }
      if (sessionUser != null && sessionUser!['gsuite'] == gsuite) {
        sessionUser!['hasVoted'] = 'true';
        if (sessionUser!['lastVRN'] == null || sessionUser!['lastVRN'] == '') {
          sessionUser!['lastVRN'] = vrn;
        }
      }
      return;
    }
  }
}

bool getUserHasVoted(String gsuite) {
  if (tempUserStore.containsKey(gsuite)) {
    final voted = tempUserStore[gsuite]?['hasVoted'];
    if (voted is bool) return voted;
    if (voted is String) return voted == 'true';
    return false;
  }
  final user = predefinedUsers.firstWhere(
    (u) => u['gsuite'] == gsuite,
    orElse: () => <String, String>{},
  );
  if (user.isNotEmpty) {
    final voted = user['hasVoted'];
    if (voted == true) return true;
    if (voted is String) return voted == 'true';
    return false;
  }
  return false;
}

String? getUserVRN(String gsuite) {
  if (tempUserStore.containsKey(gsuite)) {
    return tempUserStore[gsuite]?['lastVRN'];
  }
  final user = predefinedUsers.firstWhere(
    (u) => u['gsuite'] == gsuite,
    orElse: () => {},
  );
  return user.isNotEmpty ? user['lastVRN'] : null;
}
