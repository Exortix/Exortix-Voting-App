# Exortix Voting Web App
## Description
A voting web app powered by nim programming language and json database. This is a simple web app that allows users to create polls and vote on them. This is a demo learning project for me to learn nim and web development.
## Table of Contents
- [Technologies](#technologies)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
## Technologies
- [Nim](https://nim-lang.org/): Programming language
- [Nimble](https://github.com/nim-lang/nimble): Package manager to install dependencies
  - [Jester](https://github.com/dom96/jester): Web framework
  - [Mostachu](https://github.com/fenekku/moustachu): Template engine
- [Bootstrap](https://getbootstrap.com/): CSS framework
## Features
- [x] Register/Login System
- [x] User Restriction
- [x] Create Poll
- [x] Vote
- [x] View Poll
- [x] View Poll Results
- [ ] Possible Features to Add
  - [ ] Use an actual database (sqlite, postgresql, etc)
  - [ ] Edit/Delete Poll
  - [ ] Edit/Delete Vote
  - [ ] User Profile Page
  - [ ] Add more features
## Installation
1. Install nim
2. Clone this repository
3. Install dependencies using nimble (jester, moustachu)
4. Run `nim c app.nim` to compile the app
5. Run `./app` to start the app
## Usage
This is a general overview of how to use the web app. This is not a detailed guide.
1. Register an account
2. Login
3. Create a poll
4. Vote on a poll
5. View poll results
6. Logout