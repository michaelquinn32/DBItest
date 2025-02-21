#' spec_meta_get_statement
#' @usage NULL
#' @format NULL
#' @keywords internal
spec_meta_get_statement <- list(
  get_statement_formals = function() {
    # <establish formals of described functions>
    expect_equal(names(formals(dbGetStatement)), c("res", "..."))
  },

  #' @return
  #' `dbGetStatement()` returns a string, the query used in
  get_statement_query = function(con) {
    query <- trivial_query()
    with_result(
      #' either [dbSendQuery()]
      dbSendQuery(con, query),
      {
        s <- dbGetStatement(res)
        expect_type(s, "character")
        expect_identical(s, query)
      }
    )
  },
  #
  get_statement_statement = function(con, table_name) {
    query <- paste0("CREATE TABLE ", table_name, " (a integer)")
    with_result(
      #' or [dbSendStatement()].
      dbSendStatement(con, query),
      {
        s <- dbGetStatement(res)
        expect_type(s, "character")
        expect_identical(s, query)
      }
    )
  },
  #
  get_statement_error = function(con) {
    res <- dbSendQuery(con, trivial_query())
    dbClearResult(res)
    #' Attempting to query the statement for a result set cleared with
    #' [dbClearResult()] gives an error.
    expect_error(dbGetStatement(res))
  },
  #
  NULL
)
