-- for testing macro.ts
--!define DUCKY
--!define DUCK
--!define FUNNY "both!!"
print("HELLO!")
--!ifdef DUCK
print("hey")
--!end

--!ifdef DUCK
--!ifdef DUCKY
print(FUNNY)
--!end
--!end