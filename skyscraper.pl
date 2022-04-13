/*Verifications :
	-VerifN/1 : Verifie taille de la matrice carree fournie
	-VerifNA/2 : Verifie nombre d'elements de la matrice carree fournie.
	-verifNB/2 : Verifie la taille de la matrice, qu'on recoit une liste de tuple entier puis qu'il y'a le bon nombre d'elements.
	-verif/3 : execute l'ensemble des verifications precedentes
*/
verifN(T):- T =< 0, write("Taille inferieur ou egal a 0 !\n").
verifNA(T, A):- N is T**2, not(length(A, N)), write("Taille du skyscraper pas compatible avec la matrice fournie.\n").
verifB([]).
verifB([(A, B)|C]):- integer(A), integer(B), verifB(C).
verifNB(T, B):- T < 1, write("Taille de la matrice incoherente."); not(verifB(B)), write("Tuples de resolution non valide.\n"); N is T*2, not(length(B, N)), write("Nombre de tuple de resolution incoherent"). 
verif(T, A, B):- not(verifN(T)), not(verifNA(T, A)), not(verifNB(T, B)).
/*-----------LINE_solver-------------
	line_check : Verifie si une ligne est valide en fonction d'une valeur representant les immeubles visibles
	valid_line : Verifie s'il y a des duplicats dans la liste et verifie si la liste est valide dans les deux
		sens en utilisant linecheck et les valeurs a verifier
*/
line_check([], _, 0, 0).
line_check([A|B], CM, V, T):- T > 0, CM < A, V1 is V - 1, T1 is T - 1, line_check(B, A, V1, T1), !.
line_check([A|B], CM, V, T):- T > 0, CM >= A, T1 is T - 1, line_check(B, CM, V, T1).
valid_line(T, L, (VA, VB)):- is_set(L), line_check(L, 0, VA, T), reverse(L, L1), line_check(L1, 0, VB, T).
/*-----------LINES_SOLVER-----------
	- nmapline defini les elements de la liste (la ligne) a valider
	- valid_line verifie si la ligne fournie par nmapline est correcte
	- newCL fait avancer la liste d'une ligne et rappelle lines_solver

	- lines_solver appelle nmapline puis valid_line et fais avancer d'une ligne
	en appelant newCL(= new Current Line)*/
newCL(T, T, L, Vs):- lines_solver(T, L, Vs).
newCL(T, T1, [_|B], Vs):- T2 is T1 + 1, newCL(T, T2, B, Vs).

nmapline(_, 0, _, []).
nmapline(T, T1, [A|As], [A|Bs]):- T1 > 0, between(1, T, A), T2 is T1 - 1, nmapline(T, T2, As, Bs).

lines_solver(_, [], _).
lines_solver(T, L, [(VA, VB)|Vs]):- nmapline(T, T, L, L1), valid_line(T, L1, (VA, VB)),
				newCL(T, 0, L, Vs).
/*-----------COLS_SOLVER------------
	- nmapcol definie une ligne representant une colonne de la matrice
	- valid_line verifie si la ligne definie par nmapcol est correcte
	- cols_solver appelle valid_line avec la ligne definie par nmapcol puis passe
	a la colonne suivante

	- cols_ passe a la deuxième section de la liste de tuple de verification puis
	appelle cols_solver*/
nmapcol(T, T, _, _, []):- !.
nmapcol(T, T1, 0, [A|As], [A|Bs]):- T2 is T1 + 1, nmapcol(T, T2, 1, As, Bs).
nmapcol(T, T1, T2, [_|As], B):- T3 is T2 + 1, nmapcol(T, T1, T3, As, B).
nmapcol(T, T1, T, A, B):- nmapcol(T, T1, 0, A, B).

cols_solver(T, T, _, []).
cols_solver(T, T1, [A|B], [(VA,VB)|Vs]):- nmapcol(T, 0, 0, [A|B], A1),valid_line(T, A1, (VA,VB)),
				T2 is T1 + 1,  cols_solver(T, T2, B, Vs).

cols_(T, 0, A, B):- cols_solver(T, 0, A, B).
cols_(T, T1, A, [_|B]):- T1 > 0, T2 is T1 - 1, cols_(T, T2, A, B).
/*Display matrice*/
disp_matrice(T, T, 0, []).
disp_matrice(T, T1, T, A):- write("\n"), T2 is T1 + 1, disp_matrice(T, T2, 0, A). 
disp_matrice(T, T1, T2, [A|B]):- write(" "), write(A), T3 is T2 + 1, disp_matrice(T, T1, T3, B).
/*SKYSCRAPER*/
skyscraper_n(1, [1], (1,1)).
skyscraper_n(T, A, B):-	verif(T, A, B), lines_solver(T, A, B), cols_(T, T, A, B), writeln("Solution trouvee : "),
				disp_matrice(T, 0, 0, A), !.