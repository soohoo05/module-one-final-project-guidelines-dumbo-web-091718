 ███╗  ███╗ ██████╗ ██╗    ██╗██╗███████╗   ██████╗ ██╗   ██╗ ██╗██████╗ ███████╗
 ████╗ ████║██╔══██╗██║    ██║██║██╔════╝  ██╔════╝ ██║   ██║ ██║██╔══██╗██╔════╝
 ██╔████╔██║██║  ██║██║    ██║██║█████╗    ██║  ███╗██║   ██║ ██║██║  ██║█████╗
 ██║╚██╔╝██║██║  ██║ ╚██╗ ██╔╝██║██╔══╝    ██║   ██║██║   ██║ ██║██║  ██║██╔══╝
 ██║ ╚═╝ ██╚██████╔╝  ╚████╔╝ ██║███████╗  ╚██████╔╝╚██████╔╝ ██║██████╔╝███████╗
 ╚═╝     ╚═╝╚═════╝    ╚═══╝  ╚═╝╚══════╝   ╚═════╝  ╚═════╝  ╚═╝╚═════╝ ╚══════╝
​
October 5th, 2018

A Flatiron School Access Labs Module One final project by Tyler Soo Hoo and Scott Waring
​
Our Movie Guide application allows the user to access an API to search for movies, save them to their personal lists,
edit their lists, edit the movies on their list, and view links to stream from free, subscription, and purchase source.
​
Movie Guide returns the title, director, release date, rating and description of the chosen movie.

The streaming sources information and the general movie information are saved to a text file on each iteration with our goal being to email that information to the user.

The email function works by instantiating a new text file on each iteration and and using a command line execution to send the user an email with that iteration of the text file from their own local computer. This was tested on a mac and may not have full functionality on a pc. 
​
Important notes:
​
-Our program runs on an API authorized key from "api.guidebox.com." if you are unable to access the API, the authorized key has either exhausted all of its provided uses or the key has expired. Please contact api.guidebox.com for a new key for use of the program and replace your new key on line 6 in the file "api_class.rb"
​
-Program is also dependent on a database that must be instantiated before use. You will need to call on "rake db:migrate" in order to create a fresh database.
​
Special thanks to Jeremy at Guidebox for granting us access to their API.
https://www.guidebox.com/
