import std/unittest
import nimterop/cimport

cDebug()

cDefine("FORCE")
cIncludeDir "$projpath/include"
cAddSearchDir "$projpath/include"
cCompile cSearchPath("test.c")
cImport cSearchPath "test.h"

check TEST_INT == 512
check TEST_FLOAT == 5.12
check TEST_HEX == 0x512

when defined(osx):
  check OSDEF == 10
elif defined(windows):
  check OSDEF == 20
else:
  check OSDEF == 30

block:
  # workaround for https://github.com/nim-lang/Nim/issues/10129
  const ok = OSDEF

var
  pt: PRIMTYPE
  ct: CUSTTYPE

  s: STRUCT1
  s2: STRUCT2
  s3: STRUCT3
  s4: STRUCT4
  s5: STRUCT5

  e: ENUM
  e2: ENUM2 = enum5
  e3: Enum_testh1 = enum7
  e4: ENUM4 = enum11

  vptr: VOIDPTR
  iptr: INTPTR

  u: UNION1
  u2: UNION2

  i: cint

pt = 3
ct = 4

s.field1 = 5
s2.field1 = 6
s3.field1 = 7
s4.field2[2] = 5
when defined(cpp):
  discard # TODO
else: # TODO: what's `defined(cpp)` for c ?
  s4.field3[3] = enum1

s5.tci = test_call_int
s5.tcp = test_call_param
s5.tcp8 = test_call_param8
check s5.tci() == 5

e = enum1
e2 = enum4

u2.field2 = 'c'

i = 5

check test_call_int() == 5
check test_call_param(5).field1 == 5
check test_call_param2(5, s2).field1 == 11
check test_call_param3(5, s).field1 == 10
# error: assigning to 'enum ENUM' from incompatible type 'NI' (aka 'long long')
when defined(cpp):
  discard # TODO
else:
  check test_call_param4(e) == e2
check test_call_param5(5.0).field2 == 5.0
check test_call_param6(u2) == 'c'
u.field1 = 4
check test_call_param7(u) == 4

when defined(cpp):
  # TODO
   # note: candidate function not viable: no known conversion from 'NI *' (aka 'long long *') to 'int *' for 1st argument
  # check test_call_param8(cast[ptr int](addr i)) == 25.0
  discard
else:
  check test_call_param8(addr i) == 25.0
  check i == 25

check e3 == enum7
check e4 == enum11

cAddStdDir()

## failing tests
when false:
  static: # Error: undeclared identifier: 'foobar1'
    doAssert foobar1(3) == OSDEF * 3
when false: # Error: undeclared identifier: 'foobar2'
    doAssert foobar2(3) == 3 + 1
