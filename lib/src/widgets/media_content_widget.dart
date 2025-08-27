import 'package:flutter/material.dart';

/// A widget that renders media content including videos and GIFs
class MediaContentWidget extends StatelessWidget {
  final String content;
  final double? maxHeight;
  final double? maxWidth;
  final EdgeInsets? padding;
  final bool autoPlay;
  final bool showControls;

  const MediaContentWidget({
    Key? key,
    required this.content,
    this.maxHeight,
    this.maxWidth,
    this.padding,
    this.autoPlay = false,
    this.showControls = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: _buildMediaContent(context),
    );
  }

  Widget _buildMediaContent(BuildContext context) {
    List<Widget> widgets = [];
    String remainingContent = content;
    
    // Process video content
    while (remainingContent.contains(RegExp(r'\[video\](.+?)\[/video\]', caseSensitive: false))) {
      final videoMatch = RegExp(r'\[video\](.+?)\[/video\]', caseSensitive: false)
          .firstMatch(remainingContent);
      
      if (videoMatch == null) break;
      
      // Add text before video
      final beforeVideo = remainingContent.substring(0, videoMatch.start);
      if (beforeVideo.trim().isNotEmpty) {
        widgets.add(_buildTextContent(beforeVideo, context));
      }
      
      // Add video widget
      final videoUrl = videoMatch.group(1) ?? '';
      widgets.add(_buildVideoWidget(videoUrl));
      
      // Update remaining content
      remainingContent = remainingContent.substring(videoMatch.end);
    }
    
    // Process GIF content
    while (remainingContent.contains(RegExp(r'\[gif\](.+?)\[/gif\]', caseSensitive: false))) {
      final gifMatch = RegExp(r'\[gif\](.+?)\[/gif\]', caseSensitive: false)
          .firstMatch(remainingContent);
      
      if (gifMatch == null) break;
      
      // Add text before GIF
      final beforeGif = remainingContent.substring(0, gifMatch.start);
      if (beforeGif.trim().isNotEmpty) {
        widgets.add(_buildTextContent(beforeGif, context));
      }
      
      // Add GIF widget
      final gifUrl = gifMatch.group(1) ?? '';
      widgets.add(_buildGifWidget(gifUrl));
      
      // Update remaining content
      remainingContent = remainingContent.substring(gifMatch.end);
    }
    
    // Add any remaining text
    if (remainingContent.trim().isNotEmpty) {
      widgets.add(_buildTextContent(remainingContent, context));
    }
    
    // If no media content found, return original content as text
    if (widgets.isEmpty) {
      return _buildTextContent(content, context);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildTextContent(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildVideoWidget(String videoUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? 300,
        maxWidth: maxWidth ?? double.infinity,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: _VideoPlayerWidget(
          url: videoUrl,
          autoPlay: autoPlay,
          showControls: showControls,
        ),
      ),
    );
  }

  Widget _buildGifWidget(String gifUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? 200,
        maxWidth: maxWidth ?? double.infinity,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.network(
          gifUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.gif_box_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Failed to load GIF',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 150,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A simple video player widget placeholder
/// In a real implementation, you would use video_player package
class _VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool autoPlay;
  final bool showControls;

  const _VideoPlayerWidget({
    required this.url,
    this.autoPlay = false,
    this.showControls = true,
  });

  @override
  State<_VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<_VideoPlayerWidget> {
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    // Simulate video loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPlaying = widget.autoPlay;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_hasError) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey,
                size: 40,
              ),
              SizedBox(height: 8),
              Text(
                'Failed to load video',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        children: [
          // Video thumbnail/placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[800]!,
                  Colors.grey[900]!,
                ],
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: 60,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Video Player',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.url,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          
          // Play/Pause button
          if (widget.showControls)
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}