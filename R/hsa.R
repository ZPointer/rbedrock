
##' @export
get_hsa <- function(db, keys=db$keys(), fancy=TRUE) {
    if (!is.character(keys)) {
        stop("'keys' must be a character vector.")
    }
    keys <- stringr::str_subset(keys, "^@[^:]+:[^:]+:[^:]+:57$")
    dat <- db$mget(keys, as_raw = TRUE)
    names(dat) <- keys;
    # prune keys that are missing
    if(!is.null(attr(dat,"missing"))) {
        dat[attr(dat,"missing")] <- NULL
    }
    out <- do.call("rbind", hsa)
    if(fancy == FALSE) {
        return(out)
    }
    hsa <- lapply(dat, .read_hsa)
    dimension <- as.integer(str_extract(names(hsa), "[^:]+(?=:57)"))
    n <- sapply(hsa, nrow)

    out <- as_tibble(out)
    out$tag <- factor(out$tag, levels=1:6,
        labels=c("NetherFortress",
                 "SwampHut",
                 "OceanMonument",
                 "4", # removed cat HSA
                 "PillagerOutpost",
                 "6"  # removed cat HSA
        ))
    out$dimension <- rep(dimension,n)
    out
}

##' @export
put_hsa <- function(db, x1, y1, z1, x2, y2, z2, tag, dimension) {
    # identify all chunks that this HSA overlaps
    x <- range(x1, x2)
    y <- range(y1, y2)
    z <- range(z1, z2)
    chunk_x1 <- x[1] %/% 16
    chunk_z1 <- z[1] %/% 16
    chunk_x2 <- x[2] %/% 16
    chunk_z2 <- z[2] %/% 16
    # create hsa for each chunk
    ret <- NULL
    for (chunk_x in seq.int(chunk_x1, chunk_x2)) {
        for (chunk_z in seq.int(chunk_z1, chunk_z2)) {
            hx1 <- max(x[1], chunk_x * 16)
            hx2 <- min(x[2], chunk_x * 16 + 15)
            hz1 <- max(z[1], chunk_z * 16)
            hz2 <- min(z[2], chunk_z * 16 + 15)
            hy1 <- y[1]
            hy2 <- y[2]
            hsa <- matrix(c(hx1, hy1, hz1, hx2, hy2, hz2, tag), 1, 7)
            ret <- rbind(ret, hsa)
            key <- create_chunk_key(chunk_x, chunk_z, dimension, 57)
            dat <- db$get(key, as_raw = TRUE)
            if (!is.null(dat)) {
                hsa <- rbind(.read_hsa(dat, fancy=FALSE)[, 1:7], hsa)
            }
            hsa <- .write_hsa(hsa)
            db$put(key, hsa)
        }
    }
    ret
}

.read_hsa <- function(rawval) {
    con <- rawConnection(rawval)
    on.exit(close(con))

    len <- readBin(con, integer(), n = 1, size = 4)
    out <- c()
    for (i in 1:len) {
        aabb <- readBin(con, integer(), n = 6, size = 4)
        tag <- readBin(con, integer(), n = 1, size = 1)
        out <- rbind(out, c(aabb, tag))
    }
    colnames(out) <- c("x1", "y1", "z1", "x2", "y2", "z2", "tag")
    out <- cbind(out, xspot = out[, "x1"] + (out[, "x2"] - out[, "x1"] + 1) %/% 2)
    out <- cbind(out, yspot = pmin.int(out[, "y1"], out[, "y2"]))
    out <- cbind(out, zspot = out[, "z1"] + (out[, "z2"] - out[, "z1"] + 1) %/% 2)
    rownames(out) <- NULL
    out
}

.write_hsa <- function(hsa) {
    len <- nrow(hsa)
    out <- writeBin(as.integer(len), raw(), size = 4, endian = "little")
    for (i in 1:len) {
        n <- as.integer(hsa[i, ])
        out <- c(out, writeBin(n[1:6], raw(), size = 4, endian = "little"))
        out <- c(out, writeBin(n[7], raw(), size = 1, endian = "little"))
    }
    out
}