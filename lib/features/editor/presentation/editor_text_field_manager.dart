// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/features/editor/presentation/cubit/editor_cubit.dart';

class EditorTextFieldManager {
  List<EditorLine> lines = [];
  List<InlineSpan> spans = [];

  void generateSpans() {
    spans.clear();
    for (EditorLine line in lines) {
      final lineStyle =
          EditorFormatStyles.getLineFormatStyle(line.lineFormatType);
      for (EditorSpan span in line.spans) {
        if (span.span.style == null) {
          span.span = TextSpan(text: span.span.toPlainText(), style: lineStyle);
        } else {
          span.span = TextSpan(
            text: span.span.toPlainText(),
            style: span.span.style!.merge(lineStyle),
          );
        }
        spans.add(span.span);
      }
    }
  }
}

class EditorSpan extends Equatable {
  InlineSpan span;

  List<SpanFormatType> _spanFormatType = [];
  List<SpanFormatType> get spanFormatType => _spanFormatType;
  set spanFormatType(List<SpanFormatType> value) {
    _spanFormatType = value;
    for (SpanFormatType type in value) {
      TextStyle style = EditorFormatStyles.getSpanStyle(type);
      if (span.style != null) {
        span =
            TextSpan(text: span.toPlainText(), style: span.style!.merge(style));
      } else {
        span = TextSpan(text: span.toPlainText(), style: style);
      }
    }
  }

  int start;
  int end;
  EditorSpan({
    required this.span,
    required this.start,
    required this.end,
    List<SpanFormatType> spanFormatType = const [],
  }) {
    this.spanFormatType = spanFormatType;
  }

  EditorSpan copyWith({
    InlineSpan? span,
    int? start,
    int? end,
    List<SpanFormatType>? spanFormatType,
  }) {
    return EditorSpan(
      span: span ?? this.span,
      start: start ?? this.start,
      end: end ?? this.end,
      spanFormatType: spanFormatType ?? this.spanFormatType,
    );
  }

  @override
  List<Object?> get props => [span, start, end, spanFormatType];
}

class EditorLine extends Equatable {
  List<EditorSpan> spans = [];
  LineFormatType _lineFormatType = LineFormatType.body;

  LineFormatType get lineFormatType => _lineFormatType;

  set lineFormatType(LineFormatType value) {
    if (value == _lineFormatType) return;
    for (EditorSpan span in spans) {
      if (span.span.style != null) {
        span.span = TextSpan(
          text: span.span.toPlainText(),
          style: span.span.style!
              .merge(EditorFormatStyles.getLineFormatStyle(value)),
        );
      } else {
        span.span = TextSpan(
          text: span.span.toPlainText(),
          style: EditorFormatStyles.getLineFormatStyle(value),
        );
      }
    }
    _lineFormatType = value;
  }

  int start;
  int end;
  EditorLine({
    required this.start,
    required this.end,
    required this.spans,
    lineFormatType = LineFormatType.body,
  }) : _lineFormatType = lineFormatType;

  @override
  List<Object?> get props => [spans, start, end, lineFormatType];
}

enum SpanFormatType {
  bold,
  italic,
  underlined,
  strikethrough,
  superscript,
  subscript,
  tag,
  link
}

enum LineFormatType {
  heading,
  subheading,
  body,
  footnote,
  monostyled,
  bulleted_list,
  numbered_list,
  dashed_list,
  image,
  audio
}

class EditorFormatStyles {
  static TextStyle bold = const TextStyle(
    fontWeight: FontWeight.bold,
  );
  static TextStyle italic = const TextStyle(
    fontStyle: FontStyle.italic,
  );
  static TextStyle underlined = const TextStyle(
    decoration: TextDecoration.underline,
  );
  static TextStyle strikethrough = const TextStyle(
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle superscript = const TextStyle(
    fontSize: 10,
  );
  static TextStyle subscript = const TextStyle(
    fontSize: 10,
  );
  static TextStyle heading = const TextStyle(
    fontSize: 26,
  );
  static TextStyle subheading = const TextStyle(
    fontSize: 22,
  );
  static TextStyle body = const TextStyle(
    fontSize: 16,
  );
  static TextStyle footnote = const TextStyle(
    fontSize: 12,
  );
  static TextStyle monostyled = const TextStyle(
    fontSize: 16,
  );
  static TextStyle bulletedList = const TextStyle(
    fontSize: 16,
  );
  static TextStyle numberedList = const TextStyle(
    fontSize: 16,
  );
  static TextStyle dashedList = const TextStyle(
    fontSize: 16,
  );
  static TextStyle link = const TextStyle(
    decoration: TextDecoration.underline,
  );
  static TextStyle tag = const TextStyle(
    decoration: TextDecoration.underline,
  );

  static TextStyle getSpanStyle(SpanFormatType type) {
    switch (type) {
      case SpanFormatType.bold:
        return bold;
      case SpanFormatType.italic:
        return italic;
      case SpanFormatType.underlined:
        return underlined;
      case SpanFormatType.strikethrough:
        return strikethrough;
      case SpanFormatType.superscript:
        return superscript;
      case SpanFormatType.subscript:
        return subscript;
      case SpanFormatType.tag:
        return tag;
      case SpanFormatType.link:
        return link;
      default:
        return body;
    }
  }

  static TextStyle getLineFormatStyle(LineFormatType type) {
    switch (type) {
      case LineFormatType.heading:
        return heading;
      case LineFormatType.subheading:
        return subheading;
      case LineFormatType.body:
        return body;
      case LineFormatType.monostyled:
        return monostyled;
      case LineFormatType.bulleted_list:
        return bulletedList;
      case LineFormatType.numbered_list:
        return numberedList;
      case LineFormatType.dashed_list:
        return dashedList;
      default:
        return body;
    }
  }
}
