import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum AttendanceStatus {
  present,
  halfDay,
  absent,
  unMarked,
}

extension AttendanceStatusX on AttendanceStatus {
  String get code {
    switch (this) {
      case AttendanceStatus.present:
        return 'P';
      case AttendanceStatus.halfDay:
        return 'H';
      case AttendanceStatus.absent:
        return 'A';
      case AttendanceStatus.unMarked:
        return '';
    }
  }

  String get label {
    switch (this) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.unMarked:
        return 'Not Marked';
    }
  }

  Color get textColor {
    switch (this) {
      case AttendanceStatus.present:
        return AppColors.stampPText;
      case AttendanceStatus.halfDay:
        return AppColors.stampHText;
      case AttendanceStatus.absent:
        return AppColors.stampAText;
      case AttendanceStatus.unMarked:
        return AppColors.textLight;
    }
  }

  Color get borderColor {
    switch (this) {
      case AttendanceStatus.present:
        return AppColors.stampPBorder;
      case AttendanceStatus.halfDay:
        return AppColors.stampHBorder;
      case AttendanceStatus.absent:
        return AppColors.stampABorder;
      case AttendanceStatus.unMarked:
        return const Color(0xFFC8BEAF);
    }
  }

  Color get bgColor {
    switch (this) {
      case AttendanceStatus.present:
        return AppColors.stampPBg;
      case AttendanceStatus.halfDay:
        return AppColors.stampHBg;
      case AttendanceStatus.absent:
        return AppColors.stampABg;
      case AttendanceStatus.unMarked:
        return Colors.transparent;
    }
  }
}
