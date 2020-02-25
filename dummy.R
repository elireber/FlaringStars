args = commandArgs(trailingOnly=TRUE)
#filename is now in args[1] if it's the only input
#print(args[1])

#for now just give it a 50/50 chance of being a 1 or a 0
floor(runif(1, min=0, max=2))

