grammar xapiantlr;

xapi
	: 'node' predicate+
	| 'way' predicate+
	| 'relation' predicate+
	| '*' predicate+
	;

predicate 
	: '[' predicate_internal ']'
	;

predicate_internal
	: child_element_predicate
	| user_tag_predicate
	| uid_tag_predicate
	| changeset_tag_predicate
	| tag_left_predicate
	| tag_right_predicate
	| bbox_predicate
	;
	
user_tag_predicate
	: '@user' '='! StringLiteral
	;
	
uid_tag_predicate
	: '@uid' '='! Digit+
	;

changeset_tag_predicate
	: '@changeset' '='! Digit+
	;

child_element_predicate
	: 'nd'
	| 'tag'
	| 'not(nd)'
	| 'not(tag)'
	| 'way'
	| 'not(way)'
	| 'relation'
	| 'not(relation)'
	;

tag_right_predicate
	: value_list '=' StringLiteral
	;

tag_left_predicate
	: StringLiteral '=' value_list
	| StringLiteral '=' '*'
	;
	
value_list
	: StringLiteral ('|' StringLiteral)*
	;

bbox_predicate
	: 'bbox' '='! (DecimalLiteral ','! DecimalLiteral ','! DecimalLiteral ','! DecimalLiteral)
	;

Letter
    :  '\u0024' | '\u005f'|
       '\u0041'..'\u005a' | '\u0061'..'\u007a' | 
       '\u00c0'..'\u00d6' | '\u00d8'..'\u00f6' | 
       '\u00f8'..'\u00ff' | '\u0100'..'\u1fff' | 
       '\u3040'..'\u318f' | '\u3300'..'\u337f' | 
       '\u3400'..'\u3d2d' | '\u4e00'..'\u9fff' | 
       '\uf900'..'\ufaff'
    ;

fragment Digit : '0'..'9';
DecimalLiteral
	: (Digit+ ('.' Digit*)?)
	| ('-' Digit+ ('.' Digit*)?)
	;

StringLiteral : Letter (Letter | Digit | '.' | '-' | '\\|')*;

WS: (' '|'\t'|'\u000C') {skip();};