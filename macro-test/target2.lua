--%include("./macro-test/test.lua")
--%define("hey", "duckkkkk")
--!define FUNNY "hello world!!"
print("test")
print(yo)
--!ifdef hey
print(FUNNY)
--!end