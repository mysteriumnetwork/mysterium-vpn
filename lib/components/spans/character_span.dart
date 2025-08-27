import 'package:flutter/widgets.dart';

class CharacterSpan extends TextSpan {
  const CharacterSpan._({required String character, super.style}) : super(text: character);

  factory CharacterSpan.space({TextStyle? style}) => CharacterSpan._(
        character: ' ',
        style: style,
      );

  factory CharacterSpan.newline({TextStyle? style}) => CharacterSpan._(
        character: '\n',
        style: style,
      );

  factory CharacterSpan.slash({TextStyle? style}) => CharacterSpan._(
        character: '/',
        style: style,
      );

  factory CharacterSpan.hyphen({TextStyle? style}) => CharacterSpan._(
        character: '-',
        style: style,
      );
  factory CharacterSpan.percent({TextStyle? style}) => CharacterSpan._(
        character: '%',
        style: style,
      );

  factory CharacterSpan.bullet({TextStyle? style}) => CharacterSpan._(
        character: '•',
        style: style,
      );
}
