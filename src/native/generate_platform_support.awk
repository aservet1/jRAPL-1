# .
# credit for how to generate a C data structure from a TSV text file
# goes to https://github.com/bontibon
#
# I copied one of his scripts as this one and modified it to fit
# my purposes.
# .

BEGIN {
    FS = "[ \t]+" # any amount of whitespace counts as one delimiter
    print "/* This file is automatically generated. DO NOT EDIT. */"
    print ""
    print "// credit to https://github.com/bontibon for a cool project that"
    print "// showcased this \"TSV file to C data structures via AWK\" idea"
    print ""
    print "#include <stdint.h>"
    print "#include \"platform_support.h\""
    print ""
    print "const power_domain_support_info_t PLATFORM_SUPPORT_TABLE[] = {"
    n = -1
} {
    #  $1 Platform ID
    #  $2 Platform name
    #  $3 DRAM Supported
    #  $4 PP0  Supported
    #  $5 PP1  Supported
    #  $6 PKG  Supported
    if (n != -1) # skip first line
        printf "\t[%s]\t{%s,\t\"%s\",\t%s,\t%s,\t%s,\t%s},\n", $1, $1, $2, $3, $4, $5, $6
    n = n + 1
    ids[n] = $1
} END {
    print "};"
    print ""
    print "const power_domain_support_info_t\n\tPLATFORM_NOT_SUPPORTED = {0x00, 0, false, false, false, false};"
    print ""
    print "const uint32_t KNOWN_PLATFORM_ID_SET[] = {"
    c = 0
    for (i = 1; i <= n; i++) {
        printf "\t%s, ", ids[i]
        c = ( c + 1 ) % 5
        if (c == 0)
            printf "\n"
    }
    if ( c != 0)
        printf "\n"
    print "};"
    print ""
    print "const int NUM_PLATFORMS_SUPPORTED = "n";"
    print ""
}
