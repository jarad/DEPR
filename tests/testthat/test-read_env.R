env_file <- system.file("extdata", "071000090603_2.env", package="DEPR")

test_that("no error", {
    expect_error(read_env(env_file, start.year=2007), NA)
})
