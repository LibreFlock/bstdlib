-- for testing macro.ts
--!define DUCKY
--!define DUCK


--!ifdef LOL
--!define FUNNY "both!!"
--!end

--!ifndef LOL
--!define FUNNY "none."
--!end
print("HELLO!")
--!ifdef DUCK
print("hey")
--!end

--!ifdef DUCK
--!ifdef DUCKY
print(FUNNY)
--!end
--!end