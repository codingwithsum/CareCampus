import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/assessment_model.dart';
import '../../services/services.dart';
import '../../utils/theme.dart';
import '../../utils/app_alerts.dart';

class MentalHealthAnalytics extends StatefulWidget {
  const MentalHealthAnalytics({super.key});

  @override
  State<MentalHealthAnalytics> createState() => _MentalHealthAnalyticsState();
}

class _MentalHealthAnalyticsState extends State<MentalHealthAnalytics> {
  List<AssessmentReport> _reports = [];
  bool _isLoading = true;
  bool _isExporting = false;
  String? _exportPath;

  @override
  void initState() {
    super.initState();
    _loadAssessmentReports();
  }

  Future<void> _loadAssessmentReports() async {
    try {
      final list = await Services.db.getAssessmentReports();
      setState(() {
        _reports = list;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _exportAnonymizedReport(bool isHighRisk) async {
    final highRiskReports = _reports.where((r) => r.severity == 'Severe' || r.severity == 'Moderately Severe').toList();
    final targetReports = isHighRisk ? highRiskReports : _reports;

    if (isHighRisk && targetReports.isEmpty) {
      AppAlerts.info(context, 'No High-Risk records detected. All student distress scores are currently within safe thresholds.');
      return;
    }

    if (targetReports.isEmpty) {
      AppAlerts.warning(context, 'No assessment data available to generate report.');
      return;
    }

    setState(() {
      _isExporting = true;
      _exportPath = null;
    });

    try {
      // Build formatted CSV Data
      final buffer = StringBuffer();
      buffer.writeln('========================================================================');
      buffer.writeln('CARE CAMPUS - ${isHighRisk ? "HIGH-RISK CRISIS & ESCALATION ALERT REPORT" : "CAMPUS-WIDE CLINICAL ASSESSMENT REPORT"}');
      buffer.writeln('CONFIDENTIALITY: Strictly Confidential - Campus Health & Wellness Board');
      buffer.writeln('GENERATED_DATE: ${DateTime.now().toLocal().toString().split('.')[0]}');
      buffer.writeln('TOTAL_RECORDS: ${targetReports.length}');
      if (isHighRisk) {
        buffer.writeln('URGENT_INTERVENTION_REQUIRED: YES');
        buffer.writeln('CRITICAL_CASES_IDENTIFIED: ${targetReports.length}');
      }
      buffer.writeln('========================================================================');
      buffer.writeln('');
      buffer.writeln('Assessment_ID,Student_Pseudonym,Screening_Test,Score,Severity_Level,Date_Submitted,Recommended_Action');
      
      for (var r in targetReports) {
        final action = (r.severity == 'Severe')
            ? 'Immediate Crisis Intervention / Counsellor Alert'
            : (r.severity == 'Moderately Severe')
                ? 'High Priority Follow-up Counselling'
                : 'Routine Wellness Monitoring';
        final dateStr = '${r.createdAt.year}-${r.createdAt.month.toString().padLeft(2, '0')}-${r.createdAt.day.toString().padLeft(2, '0')}';
        buffer.writeln('${r.id},${r.studentPseudonym},${r.type},${r.score},${r.severity},$dateStr,"$action"');
      }

      final csvContent = buffer.toString();
      String savedPath = '';

      if (!kIsWeb) {
        Directory dir;
        try {
          dir = await getApplicationDocumentsDirectory();
        } catch (_) {
          dir = await getTemporaryDirectory();
        }
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filename = isHighRisk ? 'carecampus_high_risk_alert_$timestamp.csv' : 'carecampus_routine_report_$timestamp.csv';
        final file = File('${dir.path}${Platform.pathSeparator}$filename');
        await file.writeAsString(csvContent);
        savedPath = file.path;
      } else {
        savedPath = isHighRisk ? 'carecampus_high_risk_alert.csv' : 'carecampus_routine_report.csv';
      }

      setState(() {
        _exportPath = savedPath;
      });
      
      if (!mounted) return;

      // Show comprehensive, full report viewer dialog
      _showReportViewer(
        isHighRisk: isHighRisk,
        reports: targetReports,
        csvContent: csvContent,
        savedPath: savedPath,
      );
    } catch (e) {
      if (!mounted) return;
      AppAlerts.error(context, 'Export failed: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  void _showReportViewer({
    required bool isHighRisk,
    required List<AssessmentReport> reports,
    required String csvContent,
    required String savedPath,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        final screenWidth = MediaQuery.of(ctx).size.width;
        final isNarrow = screenWidth < 600;

        return Dialog(
          backgroundColor: AppTheme.cardBg(ctx),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isHighRisk ? AppTheme.alertSevere.withValues(alpha: 0.5) : AppTheme.borderColor(ctx),
              width: 1.5,
            ),
          ),
          child: Container(
            width: isNarrow ? double.infinity : 720,
            constraints: const BoxConstraints(maxHeight: 700),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isHighRisk ? AppTheme.alertSevere : AppTheme.tealPrimary).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: (isHighRisk ? AppTheme.alertSevere : AppTheme.tealPrimary).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        isHighRisk ? Icons.crisis_alert_rounded : Icons.assessment_rounded,
                        color: isHighRisk ? AppTheme.alertSevere : AppTheme.tealPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isHighRisk ? 'High-Risk Escalation Alert Report' : 'Clinical Assessment Analytics Report',
                            style: TextStyle(
                              color: AppTheme.textPrimary(ctx),
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isHighRisk
                                ? 'Targeted clinical escalation sheet for campus health intervention boards.'
                                : 'Routine population wellness screening summary.',
                            style: TextStyle(color: AppTheme.textSecondary(ctx), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: AppTheme.textSecondary(ctx)),
                      onPressed: () => Navigator.pop(ctx),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Summary Alert Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isHighRisk ? AppTheme.alertSevere.withValues(alpha: 0.1) : AppTheme.cardBgAlt(ctx),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isHighRisk ? AppTheme.alertSevere.withValues(alpha: 0.3) : AppTheme.borderColor(ctx),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isHighRisk ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
                        color: isHighRisk ? AppTheme.alertSevere : AppTheme.deepTeal,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isHighRisk
                              ? 'ATTENTION: ${reports.length} critical student case(s) require immediate counsellor follow-up.'
                              : 'Total of ${reports.length} assessment record(s) included in this export.',
                          style: TextStyle(
                            color: isHighRisk ? AppTheme.alertSevere : AppTheme.textPrimary(ctx),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Report Records Table / List
                Text(
                  'Identified Assessment Records:',
                  style: TextStyle(color: AppTheme.textPrimary(ctx), fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardBgAlt(ctx),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderColor(ctx)),
                    ),
                    child: reports.isEmpty
                        ? Center(
                            child: Text(
                              'No records found.',
                              style: TextStyle(color: AppTheme.textSecondary(ctx)),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(12),
                            itemCount: reports.length,
                            separatorBuilder: (_, i) => Divider(color: AppTheme.borderColor(ctx), height: 16),
                            itemBuilder: (context, index) {
                              final r = reports[index];
                              final isCritical = r.severity == 'Severe';
                              final isModSevere = r.severity == 'Moderately Severe';
                              final badgeColor = isCritical
                                  ? AppTheme.alertSevere
                                  : isModSevere
                                      ? AppTheme.alertWarning
                                      : r.severity == 'Moderate'
                                          ? AppTheme.alertWarning
                                          : AppTheme.alertSuccess;

                              final dateStr = '${r.createdAt.day}/${r.createdAt.month}/${r.createdAt.year}';

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Serial number
                                  Container(
                                    width: 28,
                                    height: 28,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppTheme.cardBg(ctx),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppTheme.borderColor(ctx)),
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(color: AppTheme.textPrimary(ctx), fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              r.studentPseudonym,
                                              style: TextStyle(
                                                color: AppTheme.textPrimary(ctx),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppTheme.cardBg(ctx),
                                                borderRadius: BorderRadius.circular(6),
                                                border: Border.all(color: AppTheme.borderColor(ctx)),
                                              ),
                                              child: Text(
                                                r.type,
                                                style: const TextStyle(color: AppTheme.deepTeal, fontSize: 11, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: badgeColor.withValues(alpha: 0.15),
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: badgeColor),
                                              ),
                                              child: Text(
                                                '${r.severity} (Score: ${r.score})',
                                                style: TextStyle(color: badgeColor, fontSize: 12, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today_rounded, size: 12, color: AppTheme.mutedText),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Submitted: $dateStr',
                                              style: const TextStyle(color: AppTheme.slateText, fontSize: 11),
                                            ),
                                            const SizedBox(width: 16),
                                            Icon(Icons.shield_outlined, size: 12, color: isCritical ? AppTheme.alertSevere : AppTheme.mutedText),
                                            const SizedBox(width: 4),
                                            Text(
                                              isCritical
                                                  ? 'Action: Immediate Intervention'
                                                  : isModSevere
                                                      ? 'Action: Priority Follow-up'
                                                      : 'Action: Wellness Monitoring',
                                              style: TextStyle(
                                                color: isCritical ? AppTheme.alertSevere : AppTheme.slateText,
                                                fontSize: 11,
                                                fontWeight: isCritical ? FontWeight.bold : FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Saved path box
                if (savedPath.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.cloudBlue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.iceBlue),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, color: AppTheme.alertSuccess, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('CSV File Exported Successfully To:', style: TextStyle(color: AppTheme.slateText, fontSize: 10, fontWeight: FontWeight.bold)),
                              SelectableText(
                                savedPath,
                                style: const TextStyle(color: AppTheme.deepTeal, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),

                // Action buttons footer
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.navyText,
                        side: const BorderSide(color: AppTheme.iceBlue),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text('Copy CSV Data'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: csvContent));
                        AppAlerts.success(context, 'Report CSV copied to clipboard!');
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.tealPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.tealPrimary)),
      );
    }

    final totalAssessments = _reports.length;
    final severeCount = _reports.where((r) => r.severity == 'Severe' || r.severity == 'Moderately Severe').length;
    final double severePercentage = totalAssessments > 0 ? (severeCount / totalAssessments) * 100 : 0.0;
    
    // Check for high-risk trend (e.g. > 30% are Severe/Moderately Severe)
    final bool isHighRiskTrend = severePercentage >= 30.0;

    // Test Type distribution
    final phqCount = _reports.where((r) => r.type == 'PHQ-9').length;
    final gadCount = _reports.where((r) => r.type == 'GAD-7').length;
    final ghqCount = _reports.where((r) => r.type == 'GHQ-12').length;

    // Severity distribution
    final minimal = _reports.where((r) => r.severity == 'Minimal').length;
    final mild = _reports.where((r) => r.severity == 'Mild').length;
    final moderate = _reports.where((r) => r.severity == 'Moderate').length;
    final severe = _reports.where((r) => r.severity == 'Severe' || r.severity == 'Moderately Severe').length;

    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Analytics'),
      ),
      body: Container(
        height: double.infinity,
        decoration: AppTheme.backgroundGradientOf(context),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clinical Assessment Analytics',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text(
                'Campus-wide psychological test analytics dashboard. Identifies population risk indices and clinical referral ratios.',
                style: TextStyle(color: AppTheme.textMedium),
              ),
              const SizedBox(height: 24),

              // High-Risk Alert Banner
              if (isHighRiskTrend) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.alertSevere.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.alertSevere.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.crisis_alert_rounded, color: AppTheme.alertSevere, size: 36),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HIGH-RISK TREND DETECTED!',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.alertSevere),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Over ${severePercentage.toStringAsFixed(1)}% of self-assessments indicate Moderately Severe or Severe distress. Immediate intervention programs are recommended.',
                              style: const TextStyle(color: AppTheme.textHigh, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Actions and Overview Cards
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildMetricsList(phqCount, gadCount, ghqCount, minimal, mild, moderate, severe, totalAssessments)),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: _buildExportCard(isHighRiskTrend, severeCount, totalAssessments)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildMetricsList(phqCount, gadCount, ghqCount, minimal, mild, moderate, severe, totalAssessments),
                        const SizedBox(height: 24),
                        _buildExportCard(isHighRiskTrend, severeCount, totalAssessments),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsList(
    int phq, int gad, int ghq, 
    int minimal, int mild, int moderate, int severe,
    int total,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Distribution of assessments
        Container(
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.glassCardDecorationOf(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assessment Types Distribution',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.mintAccent),
              ),
              const SizedBox(height: 20),
              _progressRow('PHQ-9 (Depression Screen)', phq, total, Colors.blue),
              const SizedBox(height: 16),
              _progressRow('GAD-7 (Anxiety Screen)', gad, total, Colors.amber),
              const SizedBox(height: 16),
              _progressRow('GHQ-12 (General Health)', ghq, total, Colors.teal),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Distribution of severities
        Container(
          padding: const EdgeInsets.all(24),
          decoration: AppTheme.glassCardDecorationOf(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clinical Severity Breakdown',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.lilacAccent),
              ),
              const SizedBox(height: 20),
              _progressRow('Minimal Distress', minimal, total, AppTheme.alertSuccess),
              const SizedBox(height: 16),
              _progressRow('Mild Distress', mild, total, Colors.lightBlue),
              const SizedBox(height: 16),
              _progressRow('Moderate Distress', moderate, total, AppTheme.alertWarning),
              const SizedBox(height: 16),
              _progressRow('Severe Distress', severe, total, AppTheme.alertSevere),
            ],
          ),
        ),
      ],
    );
  }

  Widget _progressRow(String label, int count, int total, Color color) {
    final double percent = total > 0 ? count / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text('$count (${(percent * 100).toStringAsFixed(1)}%)',
                style: const TextStyle(
                    color: AppTheme.textLow, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: Colors.white.withValues(alpha: 0.05),
          valueColor: AlwaysStoppedAnimation(color),
          borderRadius: BorderRadius.circular(4),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildExportCard(bool isHighRiskTrend, int severeCount, int totalAssessments) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.glassCardDecorationOf(context, isBorderAccent: isHighRiskTrend),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                severeCount > 0 ? Icons.crisis_alert_rounded : Icons.assessment_rounded,
                color: severeCount > 0 ? AppTheme.alertSevere : AppTheme.mintAccent,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'High-Risk Escalation & Reports',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            severeCount > 0
                ? '$severeCount student(s) currently flag critical or severe distress. Export the high-risk escalation report to review case details and initiate clinical intervention.'
                : 'Generate and export anonymized clinical assessment metrics sheets for school wellness monitoring boards.',
            style: const TextStyle(color: AppTheme.textMedium, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 20),

          // Primary Button: Export High-Risk Alert Report
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.alertSevere,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              elevation: 3,
            ),
            icon: const Icon(Icons.warning_amber_rounded),
            label: _isExporting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(severeCount > 0 ? 'Export High-Risk Alert Report ($severeCount)' : 'Export High-Risk Alert Report'),
            onPressed: _isExporting ? null : () => _exportAnonymizedReport(true),
          ),
          const SizedBox(height: 12),

          // Secondary Button: Routine Campus Report
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.mintAccent,
              side: const BorderSide(color: AppTheme.mintAccent),
              padding: const EdgeInsets.all(14),
            ),
            icon: const Icon(Icons.file_download_rounded),
            label: Text('Export Routine Report ($totalAssessments)'),
            onPressed: _isExporting || totalAssessments == 0 ? null : () => _exportAnonymizedReport(false),
          ),

          if (_exportPath != null) ...[
            const SizedBox(height: 16),
            Text(
              'Latest file saved: \n$_exportPath',
              style: const TextStyle(color: AppTheme.alertSuccess, fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
