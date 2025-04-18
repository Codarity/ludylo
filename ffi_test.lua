local ludy = require("./lua/ludylo")

print(package.cpath)

local lib = ludy.load("libffi_module", "int add(int a, int b);", 1)

if lib then
    print("3 + 4 =", lib.add(3, 4))
end
