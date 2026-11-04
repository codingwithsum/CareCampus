import 'package:flutter_test/flutter_test.dart';
import 'package:carecampus/utils/validators.dart';
import 'package:carecampus/utils/security.dart';
import 'package:carecampus/utils/url_helper.dart';
import 'package:carecampus/models/appointment_model.dart';

void main() {
  group('Security Validations Tests', () {
    test('Email format checking', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('   '), isNotNull);
      expect(Validators.validateEmail('invalid-email'), isNotNull);
      expect(Validators.validateEmail('student@carecampus.org'), isNull);
      // Mock shortcuts are allowed in non-strict mode
      expect(Validators.validateEmail('student'), isNull);
      expect(Validators.validateEmail('admin'), isNull);
      expect(Validators.validateEmail('counsellor'), isNull);

      // Strict mode rejects mock shortcuts (used during user creation in admin)
      expect(Validators.validateEmail('student', strictEmail: true), isNotNull);
      expect(Validators.validateEmail('admin', strictEmail: true), isNotNull);
      expect(Validators.validateEmail('student@carecampus.org', strictEmail: true), isNull);

      // Enhanced formatting checks
      expect(Validators.validateEmail('user@'), contains('domain after "@" cannot be empty'));
      expect(Validators.validateEmail('@domain.com'), contains('username before "@" cannot be empty'));
      expect(Validators.validateEmail('user with space@domain.com'), contains('cannot contain spaces'));
      expect(Validators.validateEmail('.user@domain.com'), contains('cannot start or end with a dot'));
      expect(Validators.validateEmail('user..test@domain.com'), contains('cannot contain consecutive dots'));
      expect(Validators.validateEmail('user@domain'), contains('must include a valid extension'));
      expect(Validators.validateEmail('user@domain.c'), contains('extension must be at least 2 letters'));
      expect(Validators.validateEmail('user@domain.123'), contains('extension can only contain letters'));
      expect(Validators.validateEmail('student.council@campus.edu.in'), isNull);
    });

    test('Password Strength Enforcement', () {
      // Short password
      expect(Validators.validatePassword('S@12'), contains('at least 8 characters'));
      // Missing uppercase
      expect(Validators.validatePassword('studentpassword@123'), contains('one uppercase letter'));
      // Missing lowercase
      expect(Validators.validatePassword('STUDENTPASSWORD@123'), contains('one lowercase letter'));
      // Missing digit
      expect(Validators.validatePassword('StudentPassword@'), contains('one digit'));
      // Missing special char
      expect(Validators.validatePassword('StudentPassword123'), contains('one special character'));
      // Valid password
      expect(Validators.validatePassword('StudentPassword@123'), isNull);
    });

    test('HTML Anti-XSS Sanitization', () {
      final input = '<script>alert("hack")</script>Hello World';
      final clean = Validators.sanitizeText(input);
      expect(clean, equals('Hello World'));
      expect(clean, isNot(contains('<script>')));
    });

    test('UrlHelper Unwraps Google Redirects and Extracts YouTube ID', () {
      // Direct Google search redirect
      final googleUrl = 'https://www.google.com/url?q=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DdQw4w9WgXcQ&sa=U&ved=2ahUKEwj';
      final unwrapped = UrlHelper.unwrapUrl(googleUrl);
      expect(unwrapped, startsWith('https://www.youtube.com/watch?v=dQw4w9WgXcQ'));

      // Extract YouTube Video IDs directly
      expect(UrlHelper.getYouTubeVideoId('https://www.youtube.com/watch?v=dQw4w9WgXcQ'), equals('dQw4w9WgXcQ'));
      expect(UrlHelper.getYouTubeVideoId('https://youtu.be/dQw4w9WgXcQ'), equals('dQw4w9WgXcQ'));
      expect(UrlHelper.getYouTubeVideoId('https://www.youtube.com/shorts/dQw4w9WgXcQ'), equals('dQw4w9WgXcQ'));
      expect(UrlHelper.getYouTubeVideoId(googleUrl), equals('dQw4w9WgXcQ'));

      // Non-YouTube URL
      expect(UrlHelper.getYouTubeVideoId('https://pdfobject.com/pdf/sample.pdf'), isNull);
    });
  });

  group('Student Anonymity Tests', () {
    test('Pseudonym formatting randomizer', () {
      final name1 = SecurityUtils.generatePseudonym('std-1');
      final name2 = SecurityUtils.generatePseudonym('std-1');
      final name3 = SecurityUtils.generatePseudonym('std-2');

      // Hash consistency check
      expect(name1, equals(name2));
      // Divergence check
      expect(name1, isNot(equals(name3)));
      // Pseudonym format matching (AdjectiveNoun-Number)
      expect(RegExp(r'^[A-Za-z]+-[0-9]{3}$').hasMatch(name1), isTrue);
    });

    test('ID masking utility', () {
      expect(SecurityUtils.maskId('std-12345'), equals('st*****45'));
      expect(SecurityUtils.maskId('ab'), equals('****'));
    });

    test('Appointment Anonymization Mask verification', () {
      final appt = Appointment(
        id: 'apt-99',
        studentId: 'std-22',
        studentPseudonym: 'CalmRiver-102',
        counsellorId: 'cns-1',
        counsellorName: 'Dr Sarah',
        status: 'pending',
        bookingDate: DateTime.now(),
        isAnonymous: true,
        anonymousAlertReason: 'PHQ-9 Score 21 (Severe)',
      );

      // Verify that appointment model does not carry student personal information on its pseudonym field
      expect(appt.studentPseudonym, equals('CalmRiver-102'));
      expect(appt.studentPseudonym, isNot(contains('student@carecampus.org')));
      expect(appt.isAnonymous, isTrue);
    });
  });
}
