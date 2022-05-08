import re
import tables

proc passwordValidator*(password: string): bool =
    echo password.len >= 8
    echo re"[^\w\s]" in password
    echo re"[A-Z]" in password
    result = (password.len >= 8 and re"[^\w\s]" in password and re"[A-Z]" in password)

proc checkLoggedIn*(cookies: Table[string, string]): bool =
    if not cookies.hasKey("username"):
        result = false
    else:
        result = cookies["username"] != ""
