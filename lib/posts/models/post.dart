import 'package:equatable/equatable.dart';

class Post extends Equatable {
  int userId;
  int postId;
  String postTitle;
  String postBody;

  const Post({
    required this.userId,
    required this.postId,
    required this.postTitle,
    required this.postBody,
  });

  @override
  List<Object> get props => [userId, postId, postTitle, postBody];

}