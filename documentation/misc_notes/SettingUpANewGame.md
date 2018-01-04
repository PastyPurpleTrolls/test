# Setting Up A New Game

The process for adding a new game to the server is somewhat involved but
isn't too complicated if taken step by step. My understanding of the present
process is listed below. First is my suggestions for improving the 
user experience.

1.  Rename Referee to Game. While the term referee makes logical sense, people 
	will more quickly grasp the purpose with the name Game.

2.  The Referee/Game creation process needs to have a step by step wizard. The 
	current process is too involved and the steps are not well enough
	detailed or understood.

## The Current Process

### Setting up the Referee

Referees are sets of code used by the game server to create, 
manage and judge specific games.

1. Name the Referee: A short name describing what game the referee judges

2. Rules Url: this directs students to a website that should describe 
how to write an AI for this referee.

3. Round Limit: Defines how many rounds in a match the referee can handle.

4. Referee is capable of handling rounds: Can the referee start new 
rounds on its own, or does a new game have to be started for each round?

5. Players per game: How many players can participate in a match.

6. Time per game: How long in seconds the referee have to finish a match.

7. Upload referee: One file or a tar/zip of multiple files. 
If using multiple files, a Makefile must be included and it must 
support "make run". This is the code that is run in order to accomplish
each game.

8. Upload player include files: One file or a tar/zip of multiple files.
I don't understand this yet.

9. Upload Replay Plugin: A tar/zip containing a script.js and any assets
necessary in order to visually represent each match.

### Creating a Contest

Contests track the results of one or more tournaments and store AI's to be
run in those tournaments.

1. Name: The name of the contest
	
2. Description: Describe the contest

3. Deadline: A date and time. At this point, no new players are accepted.

### Creating a Tournament

Tournaments orchestrate a series of games involving a set of player 
AI's that have already been submitted to the Tournaments parent Contest.

1. Name: The name of the tournament

2. Start: A date and time at which point the matches will start being run.

3. Tournament Type: Various styles of eliminating players from the ongoing 
tournament	

4. Rounds per match: How many rounds for each match. At most the Referee's
Round Limit.

5. Select Players