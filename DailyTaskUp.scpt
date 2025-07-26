-- Handler to find or create a list
on findOrCreateList(listName)
	tell application "Reminders"
		if not (exists list listName) then
			make new list with properties {name:listName}
		end if
		return list listName
	end tell
end findOrCreateList

tell application "Reminders"
	-- List of all weekdays to ensure creation
	set weekdaysListNames to {"Monday Tasks", "Tuesday Tasks", "Wednesday Tasks", "Thursday Tasks", "Friday Tasks", "Saturday Tasks", "Sunday Tasks"}
	
	-- Create all weekday task lists
	repeat with aListName in weekdaysListNames
		my findOrCreateList(aListName)
	end repeat
	
	-- Also ensure "Today's Tasks" list exists
	set targetList to my findOrCreateList("Today's Tasks")
	
	-- Get the current weekday
	set currentDate to current date
	set weekdayName to weekday of currentDate as string -- e.g., "Monday"
	
	-- Compose source list name for today
	set sourceListName to weekdayName & " Tasks"
	set sourceList to list sourceListName
	
	-- Clear the target (today's) list
	set targetReminders to reminders in targetList
	repeat with aReminder in targetReminders
		delete aReminder
	end repeat
	
	-- Get incomplete reminders from today's source list
	set sourceReminders to (reminders in sourceList whose completed is false)
	
	-- Copy each reminder to the target list
	repeat with aReminder in sourceReminders
		set newReminder to make new reminder at targetList
		set name of newReminder to name of aReminder
		set body of newReminder to body of aReminder
		set due date of newReminder to due date of aReminder
		set remind me date of newReminder to remind me date of aReminder
	end repeat
	
	display notification "Tasks updated for " & weekdayName with title "Daily Tasks Update"
end tell

