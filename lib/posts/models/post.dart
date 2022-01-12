import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int userId;
  final int postId;
  final String postTitle;
  final String postBody;

  const Post({
    required this.userId,
    required this.postId,
    required this.postTitle,
    required this.postBody,
  });

  @override
  List<Object> get props => [userId, postId, postTitle, postBody];

}