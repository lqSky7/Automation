on findOrCreateList(listName)
    tell application "Reminders"
        if not (exists list listName) then
            make new list with properties {name:listName}
        end if
        return list listName
    end tell
end findOrCreateList

tell application "Reminders"
    set weekdaysListNames to {"Monday Tasks", "Tuesday Tasks", "Wednesday Tasks", "Thursday Tasks", "Friday Tasks"}
    
    repeat with aListName in weekdaysListNames
        my findOrCreateList(aListName)
    end repeat
    
    set targetList to my findOrCreateList("Today's Tasks")
    
    set currentDate to current date
    set weekdayName to weekday of currentDate as string
    
    set sourceListName to weekdayName & " Tasks"
    set sourceList to list sourceListName
    
    set sourceReminders to (reminders in sourceList whose completed is false)
    
    set existingNames to {}
    repeat with existingReminder in (reminders in targetList whose completed is false)
        set end of existingNames to name of existingReminder
    end repeat
    
    repeat with aReminder in sourceReminders
        if (name of aReminder) is not in existingNames then
            set newReminder to make new reminder at targetList
            set name of newReminder to name of aReminder
            
            try
                set reminderBody to body of aReminder
                if reminderBody is not missing value and reminderBody is not "" then
                    set body of newReminder to reminderBody
                end if
            end try
            
            try
                set reminderDueDate to due date of aReminder
                if reminderDueDate is not missing value then
                    set due date of newReminder to reminderDueDate
                end if
            end try
            
            try
                set reminderAlertDate to remind me date of aReminder
                if reminderAlertDate is not missing value then
                    set remind me date of newReminder to reminderAlertDate
                end if
            end try
            
            try
                set reminderPriority to priority of aReminder
                if reminderPriority is not missing value then
                    set priority of newReminder to reminderPriority
                end if
            end try
        end if
    end repeat
    
    display notification "Tasks updated for " & weekdayName with title "Daily Tasks Update"
end tell
