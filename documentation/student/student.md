# Student Documentation

## Terminology

- **Player**: A file code submitted by a user to play in a specific contest
(which can contain many tournaments)
- **Tournament**: A competition between two or more players. The competition
consists of a series of matches between various players
- **Match**: The overarching result of rounds played between two or more
players. Matches contain at least one round, but can contain more depending
on what the instructor or challenger decides
- **Round**: One specific instance within a match. For example, a single game
of checkers, or a single game of risk. However many rounds are set by either
the instructor or the challenger determines how many rounds there are in a
match. Whoever has the majority of rounds won determines who wins the overall 
match
- **Referee**: A program submitted by an instructor that defines the rules of
matches played within contests and enforces those rules
- **Contest**: This is what ties the Game Contest Server together. A contest
is a container of tournaments and players. For example, an instructor may set
up a contest for a specific semester class. Within this contest, students
will upload their player files to it, which allows the instructor to then
set up tournaments to be played with the various players submitted. Also,
players can challenge other players from the same contest if they want to see
how they compare to another player specifically
- **Challenge Match**: A match between two or more players from the same
contest that a student can set up independently from an instructor to compare
their players with other players

## Terminology

#### Round -> Match/Challenge Match -> Tournament and Players -> Contest -> Referee

- **Referee**: Does not need anything!
- **Contest**: Needs a Referee
- **Tournament**: Needs a Contest
- **Player**: Needs a Contest
- **Match**: Needs a Tournament and multiples Players
- **Challenge Match**: Needs multiple Players
- **Round**: Needs a Match or a Challenge Match

## Student Capabilities

- Uploading Players to a specific Contest
- Challenging Players to a specific Contest
- Viewing all results from Tournaments and Challenge Matches