using Readables, Test

# using the default settings

@test readable(0) == "0"
@test readable(0.0) == "0.0"

@test readable(0) == "0"
@test readable(12) == "12"
@test readable(123) == "123"
@test readable(1234) == "1,234"
@test readable(12345) == "12,345"
@test readable(123456) == "123,456"
@test readable(1234567) == "1,234,567"

@test readable(0.0) == "0.0"
@test readable(12.0) == "12.0"
@test readable(123.0) == "123.0"
@test readable(1234.0) == "1,234.0"
@test readable(12345.0) == "12,345.0"
@test readable(123456.0) == "123,456.0"
@test readable(1234567.0) == "1.23456_7e+6"

@test readable(0.12345) == "0.12345"
@test readable(12.12345) == "12.12345"
@test readable(123.12345) == "123.12345"
@test readable(1234.12345) == "1,234.12345"
@test readable(12345.12345) == "12,345.12345"
@test readable(123456.12345) == "123,456.12345"
@test readable(1234567.12345) == "1.23456_71234_5e+6"

@test readable(0.12345678) == "0.12345_678"
@test readable(12.12345678) == "12.12345_678"
@test readable(123.12345678) == "123.12345_678"
@test readable(1234.12345678) == "1,234.12345_678"
@test readable(12345.12345678) == "12,345.12345_678"
@test readable(123456.12345678) == "123,456.12345_678"

@test readable(1234567.12325675) == "1.23456_71232_5675e+6"
@test readable(BigFloat("1234567.12325675")) == "1.23456_71232_5675e+06"

