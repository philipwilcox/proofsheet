/*
  People:
  plum
  mustard
  green
  white
  peacock
  scarlett

  Weapons:
  revolver
  lead_pipe
  knife
  rope
  candlestick
  wrench

  Rooms:
  kitchen
  ballroom
  conservatory
  billiard_room
  library
  study
  hall
  lounge
  dining_room
  */


% Two versions of this; the first ones are ones you'd hardcode for yourself at
% the start of a game after seeing your cards, and the second you could load
% dynamically like "assert(they_hold(joe, plum))." at the prolog shell as you
% learn some of other people's cards.
holds(Player, Card) :-
	Player=you, you_hold(Card).
holds(Player, Card) :-
	they_hold(Player, Card).

% TODO Sep 14, pmw: add restrictions on what possible suggestions can be made? e.g. to prevent
% ?- disproves(alice, mustard, rope, Y).   
% Y = green .
% but problably not necessary?

% This query can tell if someone can disprove something, and also allows for
% other disproves (when you don't know exactly why) to be specified, which will
% be taken into account when trying to come up with a solution.
disproves(Player, Person, _, _) :-
	holds(Player, Person).
disproves(Player, _, Weapon, _) :-
	holds(Player, Weapon).
disproves(Player, _, _, Room) :-
	holds(Player, Room).
disproves(Player, Person, Weapon, Room) :-
	they_disproved(Player, Person, Weapon, Room).

% Usage Note: you should also assert "undisproved" statements, with
% Person_Who_Made_It -- they will be used by the next set of rules.

% TODO Sep 14, pmw: any way to make these more generic tuples?
proven(Person) :-
	undisproved(X, Person, Weapon, Room),
	holds(X, Weapon),
	holds(X, Room).
proven(Weapon) :-
	undisproved(X, Person, Weapon, Room),
	holds(X, Person),
	holds(X, Room).
proven(Room) :-
	undisproved(X, Person, Weapon, Room),
	holds(X, Person),
	holds(X, Weapon).
% if the player who made the undisproved statement wasn't the same one who
% holds two of the cards, then it wouldn't have been undisproved!

% TODO Sep 14, pmw: or, you could prove two things in one undisproved statement!
% E.G. update that to be like "holds(X, Weapon) OR proven(Weapon)"

% So now, as long as we record the undisproved ones, once we get the additional
% knowledge about people's cards, we can automatically apply it!

% TODO Sep 14, pmw: would be nice to get some guidance on "I know this person
% has this or that" type stuff if someone else suggests something that someone
% else then disproves

% TODO Sep 14, pmw: come up with a set of moves for test_game.pl
