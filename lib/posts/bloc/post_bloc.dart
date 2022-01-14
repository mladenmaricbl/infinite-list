
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_list/posts/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:stream_transform/stream_transform.dart';

part 'post_event.dart';
part 'post_state.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;

  PostBloc({required this.httpClient}) : super(const PostState()) {
    on<PostFetched>(
        _onFetchedPosts,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onFetchedPosts(PostFetched event, Emitter<PostState> emit) async {
    if(state.hasReachedMax){
      return;
    }
    try{
      if(state.status == PostStatus.initial){
        final posts = await _fetchPosts();
        return emit(state.copyWith(
          status: PostStatus.success,
          posts: posts,
          hasReachedMax: false,
        ));
      }
      final posts = await _fetchPosts(state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
          state.copyWith(
              status: PostStatus.success,
              posts: List.of(state.posts)..addAll(posts),
              hasReachedMax: false,
              )
          );
    }catch(_){
        emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    const String authority = 'jsonplaceholder.typicode.com';
    const String unencodedPath = '/posts';

    final Map<String,String> queryParameters = <String,String>{'_start': '$startIndex', '_limit': '$_postLimit'};
    final url = Uri.https(authority, unencodedPath, queryParameters);
    final response = await httpClient.get(url);

    if(response.statusCode == 200){
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        return Post(
            userId: json['userId'] as int,
            postId: json['id'] as int,
            postTitle: json['title'] as String,
            postBody: json['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
