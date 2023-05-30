comp : main.c comp.tab.c
	gcc main.c comp.tab.c -o comp -lm
comp.tab.c : comp.y lex.yy.c
	bison comp.y
lex.yy.c : comp.l
	flex comp.l
