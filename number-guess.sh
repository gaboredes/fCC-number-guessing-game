#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo "Enter your username:"
read username
secret_number=$((RANDOM % 1000 + 1))
REGISTERED=$($PSQL "SELECT * FROM games WHERE username='$username';")
if [[ -z $REGISTERED ]]
then
echo "Welcome, $username! It looks like this is your first time here."
else
  games_played=$($PSQL "SELECT COUNT(*) FROM games WHERE username='$username';")
  best_game=$($PSQL "SELECT guesses FROM games WHERE username='$username' ORDER BY guesses ASC LIMIT 1;")
  echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi
number_of_guesses=0
echo -e "\nGuess the secret number between 1 and 1000:\n"
while read GUESS
do
let number_of_guesses=number_of_guesses+1
# Check if the guess is a valid number
if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
  echo "That is not an integer, guess again:"
elif (($GUESS == $secret_number)); then
  echo "You guessed it in $number_of_guesses tries. The secret number was $secret_number. Nice job!"
  SAVE_GAME=$($PSQL "INSERT INTO games(username, guesses) VALUES('$username', $number_of_guesses);")
  exit 0
elif (($GUESS < $secret_number)); then
  echo "It's higher than that, guess again:"
else
  echo "It's lower than that, guess again:"
fi
done