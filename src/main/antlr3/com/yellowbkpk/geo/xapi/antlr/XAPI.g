grammar XAPI;

options {
	backtrack=true;
	memoize=true;
	output=AST;
	language=Java;
}

tokens {
	REQUEST_KIND;
	BBOX_PREDICATE;
	TAG_PREDICATE;
	USER_PREDICATE;
	UID_PREDICATE;
	CHANGESET_PREDICATE;
	LEFT;
	RIGHT;
}

@header {
package com.yellowbkpk.geo.xapi.antlr;
}

@lexer::header {
package com.yellowbkpk.geo.xapi.antlr;
}

xapi
	: 'node' pred+=predicate+ -> ^(REQUEST_KIND 'node') $pred*
	| 'way' pred+=predicate+ -> ^(REQUEST_KIND 'way') $pred*
	| 'relation' pred+=predicate+ -> ^(REQUEST_KIND 'relation') $pred*
	| '*' pred+=predicate+ -> ^(REQUEST_KIND '*') $pred*
	| 'map?' pred1=bbox_predicate -> ^(REQUEST_KIND 'map?') $pred1
	;

predicate 
	: '[' predicate_internal ']' -> predicate_internal
	;

predicate_internal
	: child_element_predicate
	| user_tag_predicate
	| uid_tag_predicate
	| changeset_tag_predicate
	| tag_predicate
	| bbox_predicate
	;
	
user_tag_predicate
	: '@user' '=' r1=StringLiteral -> ^(USER_PREDICATE $r1)
	;
	
uid_tag_predicate
	: '@uid' '=' r1=(Digit+) -> ^(UID_PREDICATE $r1)
	;

changeset_tag_predicate
	: '@changeset' '=' r1=(Digit+) -> ^(CHANGESET_PREDICATE $r1)
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

tag_predicate
	: l1=StringLiteral '=' r1=value_list -> ^(TAG_PREDICATE ^(LEFT $l1) ^(RIGHT $r1))
	| l1=StringLiteral '=' r2='*' -> ^(TAG_PREDICATE ^(LEFT $l1) ^(RIGHT $r2))
	| l2=value_list '=' r2='*' -> ^(TAG_PREDICATE ^(LEFT $l2) ^(RIGHT $r2))
	| l2=value_list '=' r3=StringLiteral -> ^(TAG_PREDICATE ^(LEFT $l2) ^(RIGHT $r3))
	;
	
value_list
	: StringLiteral ('|'! StringLiteral)*
	;

bbox_predicate
	: 'bbox' '=' (l=DecimalLiteral ',' b=DecimalLiteral ',' r=DecimalLiteral ',' t=DecimalLiteral) -> ^(BBOX_PREDICATE $l $b $r $t)
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
fragment WS: (' '|'\t'|'\u000C');
DecimalLiteral
	: (Digit+ ('.' Digit*)?)
	| ('-' Digit+ ('.' Digit*)?)
	;

StringLiteral : (Letter | Digit | WS | '.' | '-' | '\\|')+;