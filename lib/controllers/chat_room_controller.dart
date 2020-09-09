class ChatRoomController {
  ChatRoomController._();

  static String getChatRoomId(
      List<String> currentUserChatrooms, List<String> friendChatRooms) {
    currentUserChatrooms.removeWhere((item) => !friendChatRooms.contains(item));
    return currentUserChatrooms.first;
  }
}
