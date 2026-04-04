import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_threads/presentation/bloc/create_post/create_post_cubit.dart';
import 'package:smart_threads/presentation/bloc/create_post/create_post_state.dart';
import 'package:smart_threads/presentation/bloc/feed_cubit/feed_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePostCubit, CreatePostState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == CreatePostStatus.success) {
          context.read<FeedCubit>().loadFeed();
          Navigator.pop(context);
        }

        if (state.status == CreatePostStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Ошибка дефолт')),
          );
        }
      },
      builder: (context, state) {
        //     final isLoading = state.status == CreatePostStatus.loading;
        final cubit = context.read<CreatePostCubit>();

        return Scaffold(
          appBar: AppBar(
            title: Text('Новый пост'),
            actions: [
              TextButton(
                onPressed: state.canSubmit
                    ? () async {
                        cubit.submit();
                      }
                    : null,
                child: Text('Опубликовать'),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 20, child: Icon(Icons.person)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Что нового?',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          cubit.contentChanged(value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                if (state.imagePath != null) ...[
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(state.imagePath!),
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: cubit.removeImage,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    cubit.pickFromGallery();
                  },
                  child: Icon(
                    Icons.photo_outlined,
                    size: 22,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
