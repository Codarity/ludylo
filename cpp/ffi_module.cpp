#include <lua.hpp>

// native Funktion
extern "C" int add(int a, int b);


int sub(int a, int b) {
    return a - b;
}

int add(int a, int b) {
    return a + b;
}

// Lua-Wrapper für add()
int l_add(lua_State* L) {
    int a = luaL_checkinteger(L, 1);
    int b = luaL_checkinteger(L, 2);
    lua_pushinteger(L, add(a, b));
    return 1;
}

// Lua-Modul-Einstiegspunkt
extern "C" int luaopen_libffi_module(lua_State* L) {
    lua_newtable(L);

    lua_pushcfunction(L, l_add);
    lua_setfield(L, -2, "add");

    return 1;
}
