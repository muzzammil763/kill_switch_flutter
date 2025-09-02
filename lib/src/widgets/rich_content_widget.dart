import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that renders rich content including HTML, images, and links
class RichContentWidget extends StatelessWidget {
  final String content;
  final TextStyle? defaultTextStyle;
  final Color? linkColor;
  final double? imageMaxHeight;
  final double? imageMaxWidth;
  final EdgeInsets? padding;

  const RichContentWidget({
    super.key,
    required this.content,
    this.defaultTextStyle,
    this.linkColor,
    this.imageMaxHeight,
    this.imageMaxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Check if content contains HTML-like tags
    if (_isHtmlContent(content)) {
      return _buildHtmlContent(context);
    }

    // Check if content contains image URLs
    if (_containsImageUrl(content)) {
      return _buildImageContent(context);
    }

    // Check if content contains links
    if (_containsLinks(content)) {
      return _buildLinkContent(context);
    }

    // Default text content
    return Text(
      content,
      style: defaultTextStyle ?? Theme.of(context).textTheme.bodyMedium,
    );
  }

  bool _isHtmlContent(String text) {
    return text.contains(RegExp(r'<[^>]+>'));
  }

  bool _containsImageUrl(String text) {
    return text.contains(RegExp(r'\[img\](.+?)\[/img\]', caseSensitive: false));
  }

  bool _containsLinks(String text) {
    return text.contains(
            RegExp(r'\[link\](.+?)\[/link\]', caseSensitive: false)) ||
        text.contains(RegExp(r'https?://[^\s]+'));
  }

  Widget _buildHtmlContent(BuildContext context) {
    // Simple HTML parsing for basic tags
    String processedContent = content;
    List<InlineSpan> spans = [];

    // Process bold tags
    processedContent = processedContent.replaceAllMapped(
      RegExp(r'<b>(.*?)</b>', caseSensitive: false),
      (match) {
        spans.add(TextSpan(
          text: match.group(1) ?? '',
          style: (defaultTextStyle ?? TextStyle())
              .copyWith(fontWeight: FontWeight.bold),
        ));
        return '{{BOLD_${spans.length - 1}}}';
      },
    );

    // Process italic tags
    processedContent = processedContent.replaceAllMapped(
      RegExp(r'<i>(.*?)</i>', caseSensitive: false),
      (match) {
        spans.add(TextSpan(
          text: match.group(1) ?? '',
          style: (defaultTextStyle ?? TextStyle())
              .copyWith(fontStyle: FontStyle.italic),
        ));
        return '{{ITALIC_${spans.length - 1}}}';
      },
    );

    // Process link tags
    processedContent = processedContent.replaceAllMapped(
      RegExp(r'<a href="([^"]+)">(.*?)</a>', caseSensitive: false),
      (match) {
        final url = match.group(1) ?? '';
        final text = match.group(2) ?? '';
        spans.add(TextSpan(
          text: text,
          style: (defaultTextStyle ?? TextStyle()).copyWith(
            color: linkColor ?? Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(url),
        ));
        return '{{LINK_${spans.length - 1}}}';
      },
    );

    // Build the final rich text
    return _buildRichText(processedContent, spans, context);
  }

  Widget _buildImageContent(BuildContext context) {
    List<Widget> widgets = [];
    String remainingContent = content;

    while (remainingContent.isNotEmpty) {
      final imageMatch = RegExp(r'\[img\](.+?)\[/img\]', caseSensitive: false)
          .firstMatch(remainingContent);

      if (imageMatch == null) {
        // Add remaining text
        if (remainingContent.trim().isNotEmpty) {
          widgets.add(Text(
            remainingContent,
            style: defaultTextStyle ?? Theme.of(context).textTheme.bodyMedium,
          ));
        }
        break;
      }

      // Add text before image
      final beforeImage = remainingContent.substring(0, imageMatch.start);
      if (beforeImage.trim().isNotEmpty) {
        widgets.add(Text(
          beforeImage,
          style: defaultTextStyle ?? Theme.of(context).textTheme.bodyMedium,
        ));
      }

      // Add image
      final imageUrl = imageMatch.group(1) ?? '';
      widgets.add(_buildImage(imageUrl));

      // Update remaining content
      remainingContent = remainingContent.substring(imageMatch.end);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildLinkContent(BuildContext context) {
    List<InlineSpan> spans = [];
    String processedContent = content;

    // Process custom link format [link]url[/link]
    processedContent = processedContent.replaceAllMapped(
      RegExp(r'\[link\](.+?)\[/link\]', caseSensitive: false),
      (match) {
        final url = match.group(1) ?? '';
        spans.add(TextSpan(
          text: url,
          style: (defaultTextStyle ?? TextStyle()).copyWith(
            color: linkColor ?? Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(url),
        ));
        return '{{LINK_${spans.length - 1}}}';
      },
    );

    // Process direct URLs
    processedContent = processedContent.replaceAllMapped(
      RegExp(r'https?://[^\s]+'),
      (match) {
        final url = match.group(0) ?? '';
        spans.add(TextSpan(
          text: url,
          style: (defaultTextStyle ?? TextStyle()).copyWith(
            color: linkColor ?? Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()..onTap = () => _launchUrl(url),
        ));
        return '{{LINK_${spans.length - 1}}}';
      },
    );

    return _buildRichText(processedContent, spans, context);
  }

  Widget _buildRichText(
      String processedContent, List<InlineSpan> spans, BuildContext context) {
    List<InlineSpan> finalSpans = [];
    String remainingText = processedContent;

    // Replace placeholders with actual spans
    for (int i = 0; i < spans.length; i++) {
      final placeholder = RegExp('{{(BOLD|ITALIC|LINK)_$i}}');
      final match = placeholder.firstMatch(remainingText);

      if (match != null) {
        // Add text before placeholder
        final beforeText = remainingText.substring(0, match.start);
        if (beforeText.isNotEmpty) {
          finalSpans.add(TextSpan(
            text: beforeText,
            style: defaultTextStyle ?? Theme.of(context).textTheme.bodyMedium,
          ));
        }

        // Add the span
        finalSpans.add(spans[i]);

        // Update remaining text
        remainingText = remainingText.substring(match.end);
      }
    }

    // Add any remaining text
    if (remainingText.isNotEmpty) {
      finalSpans.add(TextSpan(
        text: remainingText,
        style: defaultTextStyle ?? Theme.of(context).textTheme.bodyMedium,
      ));
    }

    return RichText(
      text: TextSpan(children: finalSpans),
    );
  }

  Widget _buildImage(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      constraints: BoxConstraints(
        maxHeight: imageMaxHeight ?? 200,
        maxWidth: imageMaxWidth ?? double.infinity,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              height: 100,
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

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently or show a snackbar
      debugPrint('Error launching URL: $e');
    }
  }
}
