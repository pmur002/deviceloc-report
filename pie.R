
require(plotrix)


enhanced_pie <- function (x, labels = names(x), edges = 10000, radius = 1.0, clockwise = FALSE, shiftxby = 0,
                      line.length=1.1, factor=1.15, tail.threshold=0.1, label.offsets=NULL,
    init.angle = if (clockwise) 90 else 0, density = NULL, angle = 45, 
    col = NULL, border = NULL, lty = NULL, main = NULL, ...) 
{
    origx <- x
    ## setup label.offsets
    if (is.null(label.offsets)) {label.offsets = rep(0, length(labels))}
    if (!is.numeric(x) || any(is.na(x) | x < 0)) 
        stop("'x' values must be positive.")
    if (is.null(labels)) 
        labels <- as.character(seq_along(x))
    else labels <- as.graphicsAnnot(labels)
    x <- c(0, cumsum(x)/sum(x))
    dx <- diff(x)
    nx <- length(dx)
    plot.new()
    pin <- par("pin")
    xlim <- c(-1, 1) + shiftxby
    ylim <- c(-1, 1)

    if (!shiftxby){
      if (pin[1L] > pin[2L])
        xlim <- (pin[1L]/pin[2L]) * xlim
      else ylim <- (pin[2L]/pin[1L]) * ylim
    }

    dev.hold()
    on.exit(dev.flush())
    plot.window(xlim, ylim, "", asp = 1)
    if (is.null(col)) 
        col <- if (is.null(density)) 
            c("white", "lightblue", "mistyrose", "lightcyan", 
                "lavender", "cornsilk")
        else par("fg")
    if (!is.null(col)) 
        col <- rep_len(col, nx)
    if (!is.null(border)) 
        border <- rep_len(border, nx)
    if (!is.null(lty)) 
        lty <- rep_len(lty, nx)
    angle <- rep(angle, nx)
    if (!is.null(density)) 
        density <- rep_len(density, nx)
    twopi <- if (clockwise) 
        -2 * pi
    else 2 * pi
    t2xy <- function(t) {
        t2p <- twopi * t + init.angle * pi/180
        list(x = radius * cos(t2p), y = radius * sin(t2p))
    }

    ## GAK HACKS: (now command line args with defaults)
    ## line.length          # formerly hardwired 1.05
    ## factor <- 1.3        # formerly hardwired 1.1
    ## tail.threshold <- 0.1    # formerly did not exist (if < 0.1, then tail is drawn, else not)

    xind <- 0
    for (i in 1L:nx) {
    	xind <- xind + 1
        n <- max(2, floor(edges * dx[i]))
        P <- t2xy(seq.int(x[i], x[i + 1], length.out = n))
        polygon(c(P$x, 0), c(P$y, 0), density = density[i], angle = angle[i], 
            border = border[i], col = col[i], lty = lty[i])
        P <- t2xy(mean(x[i + 0:1]))
        lab <- as.character(labels[i])
        if (!is.na(lab) && nzchar(lab)) {
            
            ## GAK: make tail conditional upon tail.threshold
            ## lines(c(1, line.length) * P$x, c(1, line.length) * P$y)
	    if (origx[xind] < tail.threshold) {lines(c(1, line.length) * P$x, c(1, line.length) * P$y)}

            ## GAK: using soh / cah / toa, centering the labels, and computing offsets based on the angles of the pie wedges
            ##text(factor * P$x, factor * P$y, labels[i], xpd = TRUE, 
            ## adj = ifelse(P$x < 0, 1, 0), ...)
            ang <- atan2(P$y, P$x)
            r <- (P$x*P$x + P$y*P$y)^0.5
            ## adjust by any offset provided; offset is provided in degrees, so convert here
            ang <- ang + label.offsets[i] * pi / 180
            ## compute new Px and Py
            Py <- r * sin(ang)
            Px <- r * cos(ang)
            ## use that to compute text string offsets
            offy <- sin(ang) * strheight(labels[i]) * 0.5
            offx <- cos(ang) * strwidth(labels[i]) * 0.5
            text(factor * Px + offx, factor * Py + offy, labels[i], xpd = TRUE, col = 'black', adj = c(0.5, .5), ...)
            
        }
    }
    title(main = main, ...)

    draw.circle(0, 0, radius = radius, border = NA);

    
    invisible(NULL)
}
