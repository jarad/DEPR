#' Runs the WEPP model
#'
#' An R interface to run the Water Erosion Prediction Project (WEPP) model.
#'
#' @param file A path to the file.
#'
#' @return A data frame containing the following elements:
#' \describe{
#'   \item{file}{character, file name}
#'   \item{file_type}{character, type of file eg. climate, environment,..}
#'   \item{type}{character, input/output}
#'   \item{md5sum}{character, hash of the file}
#'   \item{id}{character, conconated hash of hash of all the file names}
#' }
#' @export
#'
run_wepp <- function(file, copy_to_working = FALSE) {

    #check for correct file extension and Operating system
    stopifnot("Please pass a file with correct extension" =
                  tools::file_ext(file) == "run")
    stopifnot("Please run the function on Linux Operating System" =
                  WEPPR:::is_linux() == "TRUE")

    #checks for the WEPP executable file
    stopifnot("WEPP executable not found"= WEPPR:::is_wepp_available() == "TRUE")

    #read the files and seperates input and output files
    runfile <- read_dep_run(file)
    input_files <- runfile[c("man","slp","sol","cli")]
    output_files <- runfile[c("wb","env","yld")]

    #copies the input file and the run file to working directory (tempdir)
    current.folder <- getwd()
    working.folder <- tempdir()
    file.copy(c(input_files,file), working.folder)
    setwd(working.folder)

    #runs the binary files using the input files and
    #copies the output files to the original directory
    system(paste(command = 'wepp<',file,' > screen.txt'), wait = TRUE)

    if (copy_to_working) {
        file.copy(c(output_files,"screen.txt"), current.folder)
    }
    #set the original directory as working directory
    setwd(current.folder)
    files <- c(output_files, input_files)

    #create the columns for data frame to be returned
    file.name <- names(files)
    file.type <- ifelse(file.name %in% c("cli","man","slp","sol"),"input",
                        ifelse(file.name %in% c("env","yld","wb","txt"),
                               "output","unknown"))
    #table for deciding the type of file based on the name of the file
    lookup <-read.table(header = TRUE,
                        stringsAsFactors = FALSE,
                        text="name type
                            cli climate
                            env environment
                            man management
                            run run
                            slp slope
                            sol soil
                            wb  water_balance
                            yld yield")
    type <- with(lookup, type[match(file.name,name)])
    uniquehash <- as.vector(WEPPR:::hash(files))
    id <- digest::digest(paste(uniquehash, collapse = ''),algo= "md5")
    run.out <- data.frame("file_name" = as.vector(files),
                          "file_type" = type,
                          "type" = file.type,
                          "md5sum" = uniquehash)
    run.out$id <- id
    #returns the dataframe consisting file name,
    #file type, type, md5sum and unique id
    return(run.out)
}
