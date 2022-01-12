import 'package:flutter/material.dart';
import 'package:infinite_list/posts/view/posts_page.dart';

// This widget is the root of your application.
class MyApp extends MaterialApp {
  const MyApp({Key? key}) : super(key: key, home: const PostsPage());
}