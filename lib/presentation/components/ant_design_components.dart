import 'package:flutter/material.dart';

import '../theme/ant_design_theme.dart';

class AntCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final bool showBorder;
  final double? borderRadius;

  const AntCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.showBorder = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AntDesignTheme.surfaceColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: showBorder
            ? const Border.fromBorderSide(
                BorderSide(color: AntDesignTheme.borderColor, width: 1),
              )
            : null,
        boxShadow: AntDesignTheme.cardShadow,
      ),
      child: child,
    );
  }
}

class AntButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AntButtonType type;
  final AntButtonSize size;
  final IconData? icon;
  final bool loading;
  final bool block;

  const AntButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AntButtonType.primary,
    this.size = AntButtonSize.middle,
    this.icon,
    this.loading = false,
    this.block = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(type, size);
    final buttonChild = _buildButtonChild();

    Widget button = _buildButton(buttonStyle, buttonChild);

    if (block) {
      button = SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildButton(ButtonStyle style, Widget child) {
    switch (type) {
      case AntButtonType.primary:
        return ElevatedButton(
          onPressed: loading ? null : onPressed,
          style: style,
          child: child,
        );
      case AntButtonType.default_:
        return OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: style,
          child: child,
        );
      case AntButtonType.dashed:
        return OutlinedButton(
          onPressed: loading ? null : onPressed,
          style: style.copyWith(
            side: WidgetStateProperty.all(
              const BorderSide(color: AntDesignTheme.borderColor, width: 1, style: BorderStyle.solid),
            ),
          ),
          child: child,
        );
      case AntButtonType.text:
        return TextButton(
          onPressed: loading ? null : onPressed,
          style: style,
          child: child,
        );
      case AntButtonType.link:
        return TextButton(
          onPressed: loading ? null : onPressed,
          style: style.copyWith(
            foregroundColor: WidgetStateProperty.all(AntDesignTheme.primaryColor),
          ),
          child: child,
        );
    }
  }

  Widget _buildButtonChild() {
    if (loading) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          const SizedBox(width: 4),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  ButtonStyle _getButtonStyle(AntButtonType type, AntButtonSize size) {
    final padding = _getPadding(size);
    final textStyle = _getTextStyle(size);

    switch (type) {
      case AntButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AntDesignTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: padding,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        );
      case AntButtonType.default_:
        return OutlinedButton.styleFrom(
          foregroundColor: AntDesignTheme.textPrimary,
          side: const BorderSide(color: AntDesignTheme.borderColor),
          padding: padding,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        );
      case AntButtonType.dashed:
        return OutlinedButton.styleFrom(
          foregroundColor: AntDesignTheme.textPrimary,
          side: const BorderSide(color: AntDesignTheme.borderColor, style: BorderStyle.solid),
          padding: padding,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        );
      case AntButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: AntDesignTheme.textPrimary,
          padding: padding,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        );
      case AntButtonType.link:
        return TextButton.styleFrom(
          foregroundColor: AntDesignTheme.primaryColor,
          padding: padding,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        );
    }
  }

  EdgeInsetsGeometry _getPadding(AntButtonSize size) {
    switch (size) {
      case AntButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case AntButtonSize.middle:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case AntButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    }
  }

  TextStyle _getTextStyle(AntButtonSize size) {
    switch (size) {
      case AntButtonSize.small:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
      case AntButtonSize.middle:
        return const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
      case AntButtonSize.large:
        return const TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
    }
  }

  double _getIconSize() {
    switch (size) {
      case AntButtonSize.small:
        return 12;
      case AntButtonSize.middle:
        return 14;
      case AntButtonSize.large:
        return 16;
    }
  }
}

enum AntButtonType {
  primary,
  default_,
  dashed,
  text,
  link,
}

enum AntButtonSize {
  small,
  middle,
  large,
}

class AntProgress extends StatelessWidget {
  final double percent;
  final Color? strokeColor;
  final Color? trailColor;
  final double strokeWidth;
  final AntProgressType type;
  final String? format;

  const AntProgress({
    super.key,
    required this.percent,
    this.strokeColor,
    this.trailColor,
    this.strokeWidth = 8,
    this.type = AntProgressType.line,
    this.format,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AntProgressType.line:
        return _buildLineProgress();
      case AntProgressType.circle:
        return _buildCircleProgress();
    }
  }

  Widget _buildLineProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: percent / 100,
          backgroundColor: trailColor ?? AntDesignTheme.borderColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            strokeColor ?? AntDesignTheme.primaryColor,
          ),
          minHeight: strokeWidth,
        ),
        if (format != null) ...[
          const SizedBox(height: 8),
          Text(
            format!,
            style: const TextStyle(
              fontSize: 12,
              color: AntDesignTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCircleProgress() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: percent / 100,
            backgroundColor: trailColor ?? AntDesignTheme.borderColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              strokeColor ?? AntDesignTheme.primaryColor,
            ),
            strokeWidth: strokeWidth,
          ),
          Center(
            child: Text(
              format ?? '${percent.toInt()}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AntDesignTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum AntProgressType {
  line,
  circle,
}

class AntTag extends StatelessWidget {
  final String text;
  final AntTagColor color;
  final bool closable;
  final VoidCallback? onClose;

  const AntTag({
    super.key,
    required this.text,
    this.color = AntTagColor.default_,
    this.closable = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final tagColors = _getTagColors(color);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColors.backgroundColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: tagColors.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: tagColors.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (closable) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onClose,
              child: Icon(
                Icons.close,
                size: 12,
                color: tagColors.textColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  _TagColors _getTagColors(AntTagColor color) {
    switch (color) {
      case AntTagColor.default_:
        return _TagColors(
          backgroundColor: AntDesignTheme.backgroundColor,
          borderColor: AntDesignTheme.borderColor,
          textColor: AntDesignTheme.textPrimary,
        );
      case AntTagColor.success:
        return _TagColors(
          backgroundColor: AntDesignTheme.successColor.withOpacity(0.1),
          borderColor: AntDesignTheme.successColor.withOpacity(0.3),
          textColor: AntDesignTheme.successColor,
        );
      case AntTagColor.warning:
        return _TagColors(
          backgroundColor: AntDesignTheme.warningColor.withOpacity(0.1),
          borderColor: AntDesignTheme.warningColor.withOpacity(0.3),
          textColor: AntDesignTheme.warningColor,
        );
      case AntTagColor.error:
        return _TagColors(
          backgroundColor: AntDesignTheme.errorColor.withOpacity(0.1),
          borderColor: AntDesignTheme.errorColor.withOpacity(0.3),
          textColor: AntDesignTheme.errorColor,
        );
      case AntTagColor.info:
        return _TagColors(
          backgroundColor: AntDesignTheme.infoColor.withOpacity(0.1),
          borderColor: AntDesignTheme.infoColor.withOpacity(0.3),
          textColor: AntDesignTheme.infoColor,
        );
    }
  }
}

class _TagColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  _TagColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}

enum AntTagColor {
  default_,
  success,
  warning,
  error,
  info,
}

class AntStatistic extends StatelessWidget {
  final String title;
  final String value;
  final String? suffix;
  final String? prefix;
  final Color? valueColor;
  final TextStyle? valueStyle;
  final TextStyle? titleStyle;

  const AntStatistic({
    super.key,
    required this.title,
    required this.value,
    this.suffix,
    this.prefix,
    this.valueColor,
    this.valueStyle,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              titleStyle ??
              const TextStyle(
                fontSize: 14,
                color: AntDesignTheme.textSecondary,
                fontWeight: FontWeight.normal,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          '${prefix ?? ''}$value${suffix ?? ''}',
          style:
              valueStyle ??
              TextStyle(
                fontSize: 24,
                color: valueColor ?? AntDesignTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
