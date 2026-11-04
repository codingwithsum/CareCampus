import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'app_alerts.dart';
import 'validators.dart';

class UrlHelper {
  static final RegExp _ytRegex = RegExp(
    r'(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?|shorts)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
    caseSensitive: false,
  );

  /// Strips away Google search and redirect wrappers (e.g. google.com/url?q=...)
  /// and returns the direct destination URL.
  static String unwrapUrl(String rawUrl) {
    var trimmed = rawUrl.trim();
    if (trimmed.isEmpty) return trimmed;

    try {
      final uri = Uri.tryParse(trimmed);
      if (uri != null && (uri.host.contains('google.') || uri.host == 'google.com')) {
        final target = uri.queryParameters['q'] ?? uri.queryParameters['url'];
        if (target != null && target.isNotEmpty) {
          trimmed = Uri.decodeFull(target);
        }
      }
    } catch (_) {}

    return trimmed;
  }

  /// Extracts the 11-character YouTube video ID if present in the URL.
  static String? getYouTubeVideoId(String url) {
    final clean = unwrapUrl(url);
    final match = _ytRegex.firstMatch(clean);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }

  /// Opens the resource URL directly, prioritizing the YouTube app without
  /// redirecting through Google search or the Google app.
  static Future<bool> openResourceUrl(BuildContext context, String rawUrl) async {
    String cleanUrl = unwrapUrl(rawUrl);
    cleanUrl = Validators.ensureHttpsPrefix(cleanUrl);

    final videoId = getYouTubeVideoId(cleanUrl);

    // 1. If it's a YouTube video, launch directly into the YouTube app
    if (videoId != null && videoId.isNotEmpty) {
      // Direct intent for native YouTube app (vnd.youtube:<id>)
      try {
        final appUri = Uri.parse('vnd.youtube:$videoId');
        final launched = await launcher.launchUrl(
          appUri,
          mode: launcher.LaunchMode.externalApplication,
        );
        if (launched) return true;
      } catch (_) {}

      // Second attempt: Direct HTTPS link with non-browser mode (prevents Google/browser intercept)
      try {
        final ytDirectUri = Uri.parse('https://www.youtube.com/watch?v=$videoId');
        final launched = await launcher.launchUrl(
          ytDirectUri,
          mode: launcher.LaunchMode.externalNonBrowserApplication,
        );
        if (launched) return true;
      } catch (_) {}
    }

    // 2. If it's any other YouTube URL (playlist, channel), try non-browser mode first
    final uri = Uri.tryParse(cleanUrl);
    if (uri != null) {
      if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
        try {
          final launched = await launcher.launchUrl(
            uri,
            mode: launcher.LaunchMode.externalNonBrowserApplication,
          );
          if (launched) return true;
        } catch (_) {}
      }

      // 3. General fallback for PDFs, audios, or other wellness links
      try {
        if (await launcher.canLaunchUrl(uri)) {
          final launched = await launcher.launchUrl(
            uri,
            mode: launcher.LaunchMode.externalApplication,
          );
          if (launched) return true;
        }
      } catch (_) {}
    }

    if (context.mounted) {
      AppAlerts.error(context, 'Failed to open link: $rawUrl');
    }
    return false;
  }
}
