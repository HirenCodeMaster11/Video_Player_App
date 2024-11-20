import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:provider/provider.dart';

import '../../Provider/video provider.dart';

class VideoPage extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String channelName;
  final String des;

  const VideoPage({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.channelName,
    required this.des,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<VideoProvider>(context, listen: false)
          .initializePlayer(widget.videoUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    var providerTrue = Provider.of<VideoProvider>(context);
    var providerFalse = Provider.of<VideoProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff293239),
        body: Stack(
          children: [
            providerTrue.chewieController != null &&
                providerTrue.videoPlayerController.value.isInitialized
                ? Column(
              children: [
                AspectRatio(
                  aspectRatio: providerTrue
                      .videoPlayerController.value.aspectRatio,
                  child:
                  Chewie(controller: providerTrue.chewieController!),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.des,
                        maxLines: 4,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Icon(Icons.add_circle_outline,size: 30,color: Colors.white,),
                                SizedBox(height: 2,),
                                Text('Wishlist',style: TextStyle(color: Colors.white,),)
                              ],
                            ),
                            SizedBox(width: 10,),
                            Column(
                              children: [
                                Icon(Icons.share,size: 30,color: Colors.white,),
                                SizedBox(height: 2,),
                                Text('Share',style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: providerFalse.fetchApi(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 100,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        final videos = providerTrue
                            .videoModal!.categories.first.videos
                            .where((video) =>
                        video.sources.first != widget.videoUrl)
                            .toList();

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: videos.length,
                          itemBuilder: (context, index) {
                            final video = videos[index];
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => VideoPage(
                                      videoUrl: video.sources.first,
                                      title: video.title,
                                      channelName: video.subtitle.name,
                                      des: video.description,
                                    ),
                                  ),
                                );
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  video.thumb,
                                  height: 70,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                video.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                'Channel Name • ${index + 1}M views',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.more_vert,color: Colors.white,),
                                onPressed: () {},
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            )
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.black, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
