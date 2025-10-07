
# Quiz App Blueprint

## Overview

This document outlines the plan for creating a Flutter-based quiz application. The app will present users with multiple-choice questions on five different subjects: Python, Java, SQL, DSA, and HTML.

## Features

*   **User Name Input:** Users will enter their name before starting a quiz.
*   **Subject Selection:** Users can choose a quiz from a list of five subjects.
*   **Quiz Interface:** Each quiz will consist of 15 multiple-choice questions.
*   **Timer:** A timer will be displayed during the quiz, with a total time of 1 minute and 30 seconds.
*   **Results Screen:** After completing the quiz, the user's score will be displayed.
*   **Answer Review:** The results screen will also show all the questions, with the correct answers highlighted, especially for the questions the user answered incorrectly.

## Project Structure

*   **`lib/main.dart`**: The main entry point of the application.
*   **`assets/quiz.json`**: A JSON file containing the quiz questions and answers.
*   **`lib/quiz_screen.dart`**: The screen where the quiz is displayed.
*   **`lib/result_screen.dart`**: The screen where the results are displayed.
*   **`lib/home_screen.dart`**: The initial screen for name input and subject selection.

## Plan

1.  **Create the JSON data file (`assets/quiz.json`):** This file will store all the quiz questions, options, and correct answers for each subject.
2.  **Create the main application structure (`lib/main.dart`):** Set up the main app widget and navigation.
3.  **Create the home screen (`lib/home_screen.dart`):** Implement the UI for the user to enter their name and select a quiz subject.
4.  **Create the quiz screen (`lib/quiz_screen.dart`):** Build the UI to display the quiz questions, options, and the timer.
5.  **Create the result screen (`lib/result_screen.dart`):** Design the UI to show the user's score and a review of the questions and answers.
6.  **Implement the quiz logic:**
    *   Load the quiz data from the JSON file.
    *   Manage the quiz state, including the current question, user's answers, and the timer.
    *   Navigate between the home, quiz, and result screens.
