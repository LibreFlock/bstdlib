local bstd = require("bstdduck")
local val = 3
for value in bstd.table.itval({1, 2, 3, 4})
do
	if value == val then print("hey") end
end
print("na")
