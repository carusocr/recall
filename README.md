Recall
========

This todo list displays and tracks my tasks for a given day, changing colors to reflect their current state. Sinatra handles the HTTP requests/responses and tasks are stored in a SQLite database which resides in my Dropbox folder, which lets me access it from multiple machines.

My goal with this was to make a todo list that lets me remember those work ideas I think about in the morning that I'd otherwise forget about by the time I got to the office, and also compensates for my laziness by nagging appropriately and preventing me from simply deleting undone tasks at the end of the day.

White/LtGray: uncompleted task. Colors alternate for readability.

Red: uncompleted task, automatically carried over from previous day.

Green: Task is currently in progress. Todo will keep track of time spent performing task.

Aqua: completed task. A red task that is completed will vanish from the current day's display and show up in aqua on the day it was created.

Yellow: I didn't have the guts to finish this task and marked it 'slacked'. A slacked task cannot be deleted, as testament to my procrastination.

Example screenshot:

![todo_screen](https://cloud.githubusercontent.com/assets/1410310/11154374/ff2105d4-8a0c-11e5-847f-a0b4a9f22764.png)

The ⇜ ☸ ⇝ icons below the title will navigate to previous day, current day, and next day. The 'Jump to Date' box opens up a jQuery datepicker function, which brings you to whichever date you selected and allows you to set reminders for farther in the future or review what work you did in a past date.

The weird icons inside the task items:

↯   Start a task. This will mark the task as 'active' and begin tracking how much time I spend on this task. If I toggle this, it will stop timing and add those minutes to any additional ones if I click it to continue working on it. To be honest, I don't use this feature much now that I'm using Pomodoro.

↭   Mark task as procrastinated. This turns the task yellow and brings up a textbox for me to enter a reason why I didn't complete the task. This text gets displayed inside of the task section.

▣   Mark task as finished. This will turn the task aqua, add a text line showing how many minutes I spent working on it, and display a new ellipsis icon. Clicking this will bring up a text box that lets me enter any additional notes/thoughts about the task. This task will be displayed inside the completed task  section.

☢   Destroy task. This also deletes the task record in the SQLite database.

The 'Repeater' button simply recreates a particular task daily. Repeater tasks are shown in mint green. 

The 'Shopping List' button at the bottom links to the table output of my [Shopper](https://github.com/carusocr/shopper) application that uses Capybara to crawl the web and find the cheapest prices on my most commonly purchased grocery items.
