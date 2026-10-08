       >>SOURCE FORMAT FREE
identification division.
program-id. employee-data-management.
environment division.
input-output section.
file-control.
    select employee-file assign to "EMPLOYEERECORD.DAT"
        organization is line sequential
        file status is ws-file-status.
data division.
file section.
fd employee-file.
01 employee-record.
    05 emp-id             pic 9(6).
    05 emp-dept-code      pic 9(3).
    05 emp-last-name      pic x(20).
    05 emp-first-name     pic x(20).
    05 emp-age            pic 9(3).
    05 emp-service-years  pic 9(2).
working-storage section.
01 ws-file-status         pic xx.
01 ws-eof                 pic 9 value 0.
01 ws-choice              pic x.
01 ws-entry               pic x(80).
01 ws-value               pic 9(6).
01 ws-min                 pic 9(6).
01 ws-max                 pic 9(6).
01 ws-width               pic 99.
01 ws-label               pic x(32).
01 ws-valid               pic 9.
01 ws-i                   binary-long.
01 ws-digits-only         pic 9.
01 ws-name                 pic x(20).
01 ws-written              binary-long value 0.
01 ws-matches              binary-long value 0.
01 ws-display-age          pic zz9.
01 ws-display-years        pic z9.
procedure division.
main-control.
    display "EMPLOYEE DATA MANAGEMENT"
    perform until ws-choice = 'N'
        perform ask-continue
        if ws-choice = 'Y'
            perform accept-employee
            perform append-record
        end-if
    end-perform
    perform display-report
    display "Program completed."
    goback.

ask-continue.
    move space to ws-choice
    perform until ws-choice = 'Y' or 'N'
        display "Add an employee record? (Y/N): "
        accept ws-entry
        move function upper-case(function trim(ws-entry))
            to ws-choice
        if function length(function trim(ws-entry)) not = 1
            move space to ws-choice
        end-if
        if ws-choice not = 'Y' and ws-choice not = 'N'
            display "Please enter Y or N."
        end-if
    end-perform.

accept-employee.
    move "Employee ID (6 digits)" to ws-label
    move 0 to ws-min
    move 999999 to ws-max
    move 6 to ws-width
    perform get-number
    move ws-value to emp-id

    move "Department code (3 digits)" to ws-label
    move 0 to ws-min
    move 999 to ws-max
    move 3 to ws-width
    perform get-number
    move ws-value to emp-dept-code

    move "First name (1-20 characters)" to ws-label
    perform get-name
    move ws-name to emp-first-name
    move "Last name (1-20 characters)" to ws-label
    perform get-name
    move ws-name to emp-last-name

    move "Age (0-120)" to ws-label
    move 0 to ws-min
    move 120 to ws-max
    move 3 to ws-width
    perform get-number
    move ws-value to emp-age

    move "Years of service (0-99)" to ws-label
    move 0 to ws-min
    move 99 to ws-max
    move 2 to ws-width
    perform get-number
    move ws-value to emp-service-years.

get-number.
    move 0 to ws-valid
    perform until ws-valid = 1
        display function trim(ws-label) ": "
        accept ws-entry
        move 1 to ws-digits-only
        perform varying ws-i from 1 by 1 until
            ws-i > function length(function trim(ws-entry))
            if ws-entry(ws-i:1) < '0' or > '9'
                move 0 to ws-digits-only
            end-if
        end-perform
        evaluate true
            when function length(function trim(ws-entry)) = 0
                display "A number is required."
            when function length(function trim(ws-entry)) > ws-width
                display "Too many digits."
            when ws-digits-only = 0
                display "Digits only, please."
            when other
                compute ws-value = function numval(ws-entry)
                if ws-value >= ws-min and ws-value <= ws-max
                    move 1 to ws-valid
                else
                    display "Number is outside the allowed range."
                end-if
        end-evaluate
    end-perform.

get-name.
    move spaces to ws-name
    perform until ws-name not = spaces
        display function trim(ws-label) ": "
        accept ws-entry
        if function length(function trim(ws-entry)) > 20
            display "Maximum 20 characters."
        else
            move function trim(ws-entry) to ws-name
            if ws-name = spaces
                display "Name cannot be empty."
            end-if
        end-if
    end-perform.

append-record.
    open extend employee-file
    if ws-file-status not = '00'
        display "Cannot open employee file. Status: " ws-file-status
        goback
    end-if
    write employee-record
    if ws-file-status not = '00'
        display "Cannot write employee file. Status: " ws-file-status
        close employee-file
        goback
    end-if
    add 1 to ws-written
    close employee-file
    display "Record saved.".

display-report.
    open input employee-file
    evaluate ws-file-status
        when '35'
            display "No employee records available."
            exit paragraph
        when '00'
            continue
        when other
            display "Cannot read employee file. Status: " ws-file-status
            exit paragraph
    end-evaluate
    display "Employees with fewer than 5 years of service:"
    display "ID     Age  First Name           Last Name            Years"
    move 0 to ws-eof ws-matches
    perform until ws-eof = 1
        read employee-file
            at end move 1 to ws-eof
            not at end
                if emp-service-years < 5
                    move emp-age to ws-display-age
                    move emp-service-years to ws-display-years
                    display emp-id " " ws-display-age "  "
                        emp-first-name " " emp-last-name " "
                        ws-display-years
                    add 1 to ws-matches
                end-if
        end-read
        if ws-file-status not = '00' and '10'
            display "Read error. Status: " ws-file-status
            exit perform
        end-if
    end-perform
    close employee-file
    display "Matching employees: " ws-matches.
end program employee-data-management.
