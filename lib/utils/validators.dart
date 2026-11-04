// Security Input Validation & Sanitization Controls

class Validators {
  /// Validates that an email format is correct and complies with standard RFC 5322 rules.
  /// When [strictEmail] is true, only valid email formats are accepted
  /// (no mock shortcuts like 'admin', 'counsellor', 'student').
  static String? validateEmail(String? value, {bool strictEmail = false}) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required.';
    }
    final trimmed = value.trim();

    // Allow standard mock shortcuts only for login (non-strict mode)
    if (!strictEmail && (trimmed == 'admin' || trimmed == 'counsellor' || trimmed == 'student')) {
      return null; // allow mock shortcuts
    }

    if (trimmed.length > 254) {
      return 'Email address cannot exceed 254 characters.';
    }

    if (trimmed.contains(' ')) {
      return 'Email address cannot contain spaces.';
    }

    final atIndex = trimmed.indexOf('@');
    final lastAtIndex = trimmed.lastIndexOf('@');
    if (atIndex == -1) {
      return 'Email address must contain an "@" symbol (e.g. user@domain.com).';
    }
    if (atIndex != lastAtIndex) {
      return 'Email address can only contain one "@" symbol.';
    }

    final localPart = trimmed.substring(0, atIndex);
    final domainPart = trimmed.substring(atIndex + 1);

    if (localPart.isEmpty) {
      return 'Email username before "@" cannot be empty.';
    }
    if (localPart.length > 64) {
      return 'Email username cannot exceed 64 characters.';
    }
    if (localPart.startsWith('.') || localPart.endsWith('.')) {
      return 'Email username cannot start or end with a dot.';
    }
    if (localPart.contains('..')) {
      return 'Email username cannot contain consecutive dots.';
    }

    if (domainPart.isEmpty) {
      return 'Email domain after "@" cannot be empty (e.g. domain.com).';
    }
    if (domainPart.startsWith('.') || domainPart.endsWith('.') || domainPart.startsWith('-') || domainPart.endsWith('-')) {
      return 'Email domain cannot start or end with a dot or hyphen.';
    }
    if (domainPart.contains('..')) {
      return 'Email domain cannot contain consecutive dots.';
    }
    if (!domainPart.contains('.')) {
      return 'Email domain must include a valid extension (e.g. .com, .edu, .org).';
    }

    final domainParts = domainPart.split('.');
    final tld = domainParts.last;
    if (tld.length < 2) {
      return 'Email domain extension must be at least 2 letters (e.g. .com, .edu).';
    }
    if (!RegExp(r'^[a-zA-Z]{2,24}$').hasMatch(tld)) {
      return 'Email domain extension can only contain letters (e.g. .com, .org).';
    }

    // Comprehensive RFC-compliant regex verification
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9]([a-zA-Z0-9._%+-]*[a-zA-Z0-9])?@[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid email format (e.g. user@domain.com).';
    }

    return null;
  }

  /// Validates password strength:
  /// - Min 8 characters
  /// - Min 1 uppercase letter
  /// - Min 1 lowercase letter
  /// - Min 1 number
  /// - Min 1 special character
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter.';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one digit.';
    }
    if (!RegExp(r'[!@#\$&*~%^()_\-+={[\]|:;"<,>.?\/]').hasMatch(value)) {
      return 'Password must contain at least one special character.';
    }
    return null;
  }

  /// Sanitizes text inputs by removing HTML tags and script contents to prevent XSS injection.
  static String sanitizeText(String text) {
    // Strip script blocks and their content entirely
    final scriptTagsExp = RegExp(r'<script\b[^>]*>([\s\S]*?)<\/script>', multiLine: true, caseSensitive: false);
    final noScripts = text.replaceAll(scriptTagsExp, '');

    // Strip remaining HTML tags
    final htmlTagsExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return noScripts.replaceAll(htmlTagsExp, '').trim();
  }

  /// Standard text field validation for general inputs
  static String? validateRequired(String? value, String fieldName, {int maxLen = 500}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    final sanitized = sanitizeText(value);
    if (sanitized.isEmpty) {
      return '$fieldName contains invalid characters.';
    }
    if (sanitized.length > maxLen) {
      return '$fieldName cannot exceed $maxLen characters.';
    }
    return null;
  }

  /// Validates URL formats for wellness resource uploads.
  /// Supports YouTube links with query parameters (e.g., ?v=xxx&t=123).
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Resource URL is required.';
    }
    final urlPattern = RegExp(
      r'^(https?:\/\/)?([a-zA-Z0-9]([a-zA-Z0-9\-]*[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}(\/[^\s]*)?$',
      caseSensitive: false,
    );
    if (!urlPattern.hasMatch(value.trim())) {
      return 'Please enter a valid URL (e.g., https://youtube.com/watch?v=xxx).';
    }
    return null;
  }

  /// Ensures a URL has an https:// prefix so it opens directly in the browser/app.
  static String ensureHttpsPrefix(String url) {
    final trimmed = url.trim();
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return 'https://$trimmed';
    }
    return trimmed;
  }
}
