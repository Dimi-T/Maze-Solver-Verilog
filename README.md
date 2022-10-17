# Maze-Solver-Verilog

	In rezolvarea temei ma folosesc de 4 stari:
		- stare initiala,
		- stare pentru deplasare,
		- stare pentru primit input,
		- stare finala.

	Pentru deplasare, m-am folosit de orientarea dupa punctele cardinale. Modelul circular al acestui sistem permite cautarea directiei potrivite foarte usor si eficientizeaza rezolvarea:
		- pentru a cauta directia corecta, este suficient sa ciclez prin cele 4 orientari, incrementand sau decrementand cu 1 orientarea curenta.
			-> pentru a asigura corectitudinea algoritmului, cand ma aflu in orientarea 3 si doresc o decrementare, voi trece direct in orientarea 0.
		- datorita caracteristicii de simetrie din punct de vedere topologic a modelului punctelor cardinale, logica de deplasare trebuie elaborata doar pentru o directie oarecare:
			-> logicile pentru celelalte 3 directii nu reprezinta nimic altceva decat permutari ale aceleiasi logica initiala.

	Aleasa in mod arbitrar, orientarea initiala va fi cea catre NORD, iar codificarea celor 4 directii va fi:
		- NORTH = 0;
		- EAST  = 1;
		- SOUTH = 2;
		- WEST  = 3;

	Din acest punct, cand vor aparea indicatii despre directie (la stanga, in fata, etc), vor fi relative la orientare entitatii care parcurge labirintul (daca vreau sa ma refer la pozitia absoluta - fata de matrice, voi specifica)


	Indiferent de orientarea in care ma aflu, deplasarea se face la dreapta. Logica prin care schimb directia de mers are de-a face cu schimbarea directiei de orientare:
		- Ex: ma aflu in orientarea NORTH si vreau sa ma deplasez catre inainte. Programul stie sa se miste doar la dreapta, asa ca solutia este sa imi modific orientarea catre WEST.
			-> motivul fiind ca dreapta relativ pentru WEST este inainte ABSOLUT si totodata inainte pentru NORTH.

	Ideea de urmarire a peretelui drept este urmatoarea: ma misc tot timpul la dreapta si verific:
		- sunt in perete? Ma intorc de unde am venit si ma rotesc cu 90 de grade in sens trigonometric (decrementez orientarea cu 1).
			-> acest scenariu se poate intampla de mai multe ori consecutiv (ex o situatie de genul |_|, unde trebuie sa ma intorc). Functionarea nu este afectata, entitatea se va roti pana gaseste directia corecta.
		- sunt pe un culoar? Inseamna ca am facut dreapta si deci, pentru a putea ramane lipit de perete, trebuie sa imi schimb directia catre dreapta, adica 90 de grade in sens invers trigonometric (incrementez orientarea cu 1).
		- sunt pe un coridor in marginea labirintului? Inseamna ca am gasit iesirea.

	Este necesar sa ma deplasez la fiecare pas catre dreapta, pentru ca asta imi asigura ca urmaresc peretele drept. Numarul necesar de ciclii va fi urmatorul:
		- situatia 1, mers la dreapta: 2 ciclii -> unul pentru deplasat, unul pentru verificat;
		- situatia 2, mers inainte: 5 ciclii -> 2 de mai devreme, 1 pentru intors pe pozitia anterioara si inca 2 pentru deplasarea corecta catre inainte;
		- situatia 3, mers la stanga: 8 ciclii -> analog;
		- situatia 4, mers catre spate (intors din fundatura): 11 ciclii -> analog.

		=> Pentru cazul cel mai simplu sunt necesari 2 ciclii, la care se adauga succesiv cate 3 pentru fiecare rotirea efectuata.
